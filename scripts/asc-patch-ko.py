#!/usr/bin/env python3
"""
asc-patch-ko.py — Apply Korean ASO metadata to App Store Connect.

Source of truth: docs/ASO-Metadata-OwnYourCuration.md §2.5
Bundle: com.ownlifelab.stillhours (Own Your Curation)

Credentials read from environment only (caller's responsibility):
    ASC_KEY_ID         e.g. "ABCD1234XY"
    ASC_ISSUER_ID      e.g. "12345678-aaaa-bbbb-cccc-1234567890ab"
    ASC_KEY_PATH       absolute path to AuthKey_XXXXX.p8

This script does NOT read .env files, does NOT log credentials,
does NOT write Key IDs anywhere on disk. Uses openssl CLI for ES256
signing (no pip deps required).

Usage:
    # Probe (read-only): discover app/version/localization IDs + current values
    python3 scripts/asc-patch-ko.py --probe

    # Apply: PATCH ko subtitle (appInfoLocalization) + keywords + description
    python3 scripts/asc-patch-ko.py --apply
"""
import argparse, base64, json, os, subprocess, sys, time
import urllib.request, urllib.error

BUNDLE_ID = "com.ownlifelab.stillhours"
ASC_BASE = "https://api.appstoreconnect.apple.com"
LOCALE = "ko"

# === Source of truth: docs/ASO-Metadata-OwnYourCuration.md §2.5 ===
NEW_SUBTITLE = "취향을 기록하는 개인 아카이브"
NEW_KEYWORDS = "큐레이션,아카이브,취향,소장품,수집,오브제,장소,책방,음반,LP,영화,갤러리,다이어리,메모,저널,여행,노트,일회구매"
NEW_DESCRIPTION = """당신이 좋아하는 것들을 한 곳에.

읽은 책, 들은 음반, 본 영화, 모은 오브제, 다녀온 장소.
알고리즘 없는 개인 아카이브에서 취향의 흐름을 봅니다.

Own Your Curation 은 가진 것의 목록이 아닙니다. 고른 것의 기록입니다.

——

다섯 가지 큐레이션

책 — 제목이나 ISBN 으로 검색, 표지와 메타데이터 자동 채택. 읽은 날, 출판사, 번역가, 메모.

음반 — 앨범 검색, 형태 자동 채택 (LP, CD, 스트리밍). 트랙리스트, 발매년, 청취 노트.

영화 — 제목 검색, 감독·출연·개봉 정보 자동 채택. 본 날, 감상평.

오브제 — 만년필, 빈티지 카메라, 도자기, 작품집. 자유 입력, 사진과 함께 보관.

장소 — 카페, 책방, 갤러리, 여행지. 머문 시간, 함께한 사람, 기억하고 싶은 한 줄.

——

Own Your Curation 의 약속

알고리즘 없음. 큐레이션은 당신이 정한 순서로만 정렬됩니다.
공개 피드 없음. 누구도 당신의 컬렉션을 볼 수 없습니다.
광고 없음. 영구히.
구독 없음. 일회 구매. 모든 기능. 모든 향후 업데이트 포함.
AI 판단 없음. 무엇을 큐레이션할지는 오직 당신의 결정입니다.

——

데이터 주권

모든 데이터는 당신의 iCloud 개인 데이터베이스에만 저장됩니다.
서버로 전송되지 않습니다. 언제든 JSON 또는 CSV 로 내보낼 수 있습니다.

——

큐레이션은 잊지 않는 것이 아닙니다. 가까이 두는 것입니다.

만든 사람 sunghun.ahn — 1인 도구."""

EDITABLE_STATES = {
    "PREPARE_FOR_SUBMISSION",
    "DEVELOPER_REJECTED",
    "REJECTED",
    "METADATA_REJECTED",
    "INVALID_BINARY",
    "WAITING_FOR_REVIEW",
    "DEVELOPER_REMOVED_FROM_SALE",
    "PENDING_DEVELOPER_RELEASE",
    "READY_FOR_REVIEW",
}


def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")


def make_jwt(key_id: str, issuer_id: str, key_path: str) -> str:
    now = int(time.time())
    header = {"alg": "ES256", "kid": key_id, "typ": "JWT"}
    payload = {"iss": issuer_id, "iat": now, "exp": now + 1200, "aud": "appstoreconnect-v1"}
    signing_input = (
        b64url(json.dumps(header, separators=(",", ":")).encode())
        + "."
        + b64url(json.dumps(payload, separators=(",", ":")).encode())
    )
    proc = subprocess.run(
        ["openssl", "dgst", "-sha256", "-sign", key_path],
        input=signing_input.encode(),
        capture_output=True,
        check=True,
    )
    der = proc.stdout
    # DER ECDSA → JOSE: SEQUENCE { INTEGER r, INTEGER s } → r||s (32+32)
    assert der[0] == 0x30, "expected DER SEQUENCE"
    i = 2 if der[1] < 0x80 else 3  # short or long length form
    assert der[i] == 0x02
    r_len = der[i + 1]
    r = der[i + 2 : i + 2 + r_len]
    i = i + 2 + r_len
    assert der[i] == 0x02
    s_len = der[i + 1]
    s = der[i + 2 : i + 2 + s_len]
    r = r.lstrip(b"\x00").rjust(32, b"\x00")
    s = s.lstrip(b"\x00").rjust(32, b"\x00")
    return signing_input + "." + b64url(r + s)


def api(token: str, method: str, path: str, body: dict = None) -> dict:
    url = ASC_BASE + path if path.startswith("/") else path
    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {token}")
    if body is not None:
        req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            raw = resp.read()
            return json.loads(raw) if raw else {}
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code} {method} {path}", file=sys.stderr)
        print(e.read().decode(errors="replace"), file=sys.stderr)
        raise


def find_first(seq, pred, label):
    for x in seq:
        if pred(x):
            return x
    raise SystemExit(f"ERROR: no {label} found")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--probe", action="store_true")
    p.add_argument("--apply", action="store_true")
    args = p.parse_args()
    if not (args.probe or args.apply):
        p.error("specify --probe or --apply")

    for v in ("ASC_KEY_ID", "ASC_ISSUER_ID", "ASC_KEY_PATH"):
        if not os.environ.get(v):
            print(f"ERROR: {v} env var not set", file=sys.stderr)
            sys.exit(2)
    key_path = os.environ["ASC_KEY_PATH"]
    if not os.path.exists(key_path):
        print(f"ERROR: ASC_KEY_PATH={key_path} not found", file=sys.stderr)
        sys.exit(2)

    token = make_jwt(os.environ["ASC_KEY_ID"], os.environ["ASC_ISSUER_ID"], key_path)

    # 1. App
    apps = api(token, "GET", f"/v1/apps?filter%5BbundleId%5D={BUNDLE_ID}")
    if not apps.get("data"):
        print(f"ERROR: no app with bundleId={BUNDLE_ID} in this team", file=sys.stderr)
        print("(check that the OYL ASC API key's team owns com.ownlifelab.stillhours)", file=sys.stderr)
        sys.exit(3)
    app = apps["data"][0]
    app_id = app["id"]
    print(f"App: {app['attributes'].get('name', '?')} (id={app_id}, bundleId={BUNDLE_ID})")

    # 2. AppInfo (for subtitle) — pick first editable
    appinfos = api(token, "GET", f"/v1/apps/{app_id}/appInfos?limit=10")
    print(f"\nAppInfos found: {len(appinfos.get('data', []))}")
    for ai in appinfos.get("data", []):
        print(f"  - id={ai['id']} state={ai['attributes'].get('appStoreState')!r} version={ai['attributes'].get('appStoreAgeRating')!r}")
    editable_ai = None
    for ai in appinfos.get("data", []):
        if ai["attributes"].get("appStoreState") in EDITABLE_STATES:
            editable_ai = ai
            break
    if not editable_ai:
        editable_ai = appinfos["data"][0] if appinfos.get("data") else None
    if not editable_ai:
        print("ERROR: no appInfo on app", file=sys.stderr)
        sys.exit(4)
    appinfo_id = editable_ai["id"]
    print(f"→ using appInfo id={appinfo_id} (state={editable_ai['attributes'].get('appStoreState')})")

    # 3. AppInfoLocalization ko
    ai_locs = api(token, "GET", f"/v1/appInfos/{appinfo_id}/appInfoLocalizations?limit=50")
    ko_ailoc = None
    for l in ai_locs.get("data", []):
        if l["attributes"].get("locale") == LOCALE:
            ko_ailoc = l
            break
    if not ko_ailoc:
        print(f"ERROR: no {LOCALE} appInfoLocalization", file=sys.stderr)
        sys.exit(5)
    ailoc_id = ko_ailoc["id"]
    cur_subtitle = ko_ailoc["attributes"].get("subtitle")
    cur_name = ko_ailoc["attributes"].get("name")
    print(f"\nko AppInfoLocalization id={ailoc_id}")
    print(f"  current name:     {cur_name!r}")
    print(f"  current subtitle: {cur_subtitle!r}")
    print(f"  new     subtitle: {NEW_SUBTITLE!r} ({len(NEW_SUBTITLE)} chars)")

    # 4. AppStoreVersion (for keywords + description) — pick first editable
    versions = api(token, "GET", f"/v1/apps/{app_id}/appStoreVersions?limit=10")
    print(f"\nAppStoreVersions found: {len(versions.get('data', []))}")
    for v in versions.get("data", []):
        print(f"  - id={v['id']} version={v['attributes'].get('versionString')!r} state={v['attributes'].get('appStoreState')!r}")
    editable_v = None
    for v in versions.get("data", []):
        if v["attributes"].get("appStoreState") in EDITABLE_STATES:
            editable_v = v
            break
    if not editable_v:
        print("ERROR: no editable appStoreVersion (only READY_FOR_SALE or similar)", file=sys.stderr)
        print("       → create a new version in ASC first (e.g. 1.0.1), then re-run", file=sys.stderr)
        sys.exit(6)
    version_id = editable_v["id"]
    print(f"→ using appStoreVersion id={version_id} (v{editable_v['attributes'].get('versionString')}, state={editable_v['attributes'].get('appStoreState')})")

    # 5. AppStoreVersionLocalization ko
    v_locs = api(token, "GET", f"/v1/appStoreVersions/{version_id}/appStoreVersionLocalizations?limit=50")
    ko_vloc = None
    for l in v_locs.get("data", []):
        if l["attributes"].get("locale") == LOCALE:
            ko_vloc = l
            break
    if not ko_vloc:
        print(f"ERROR: no {LOCALE} appStoreVersionLocalization", file=sys.stderr)
        sys.exit(7)
    vloc_id = ko_vloc["id"]
    cur_keywords = ko_vloc["attributes"].get("keywords")
    cur_description = ko_vloc["attributes"].get("description") or ""
    print(f"\nko AppStoreVersionLocalization id={vloc_id}")
    print(f"  current keywords ({len(cur_keywords or '')} chars): {cur_keywords!r}")
    print(f"  new     keywords ({len(NEW_KEYWORDS)} chars): {NEW_KEYWORDS!r}")
    print(f"  current description ({len(cur_description)} chars), first 100: {cur_description[:100]!r}...")
    print(f"  new     description ({len(NEW_DESCRIPTION)} chars), first 100: {NEW_DESCRIPTION[:100]!r}...")

    if args.probe:
        print("\n[probe complete — no changes made. re-run with --apply to PATCH.]")
        return

    # 6. PATCH appInfoLocalization (subtitle)
    print("\nPATCH /v1/appInfoLocalizations/{id}  (subtitle)...")
    api(
        token,
        "PATCH",
        f"/v1/appInfoLocalizations/{ailoc_id}",
        {
            "data": {
                "type": "appInfoLocalizations",
                "id": ailoc_id,
                "attributes": {"subtitle": NEW_SUBTITLE},
            }
        },
    )
    print("  ✓ subtitle updated")

    # 7. PATCH appStoreVersionLocalization (keywords + description)
    print("PATCH /v1/appStoreVersionLocalizations/{id}  (keywords + description)...")
    api(
        token,
        "PATCH",
        f"/v1/appStoreVersionLocalizations/{vloc_id}",
        {
            "data": {
                "type": "appStoreVersionLocalizations",
                "id": vloc_id,
                "attributes": {
                    "keywords": NEW_KEYWORDS,
                    "description": NEW_DESCRIPTION,
                },
            }
        },
    )
    print("  ✓ keywords + description updated")

    print("\nDone. Verify in ASC web console; ko snippet propagates ~24h after Save.")


if __name__ == "__main__":
    main()
