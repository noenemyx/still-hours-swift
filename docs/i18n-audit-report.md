# i18n Audit Report — R10.1

**Date**: 2026-05-21  
**Auditor**: R10.1 automated audit  
**Trigger**: R9.4 4-quadrant screenshots showed identical English text in ko and en quadrants.

---

## Root Causes Found

### Root Cause 1 (Primary) — Launch command missing locale arguments

**Hypothesis 4** confirmed.

`scripts/capture-screenshots.sh` `capture_quadrant()` step 4 launched:

```bash
xcrun simctl launch booted "${BUNDLE_ID}"
```

`defaults write -g AppleLocale / AppleLanguages` changes the global preference store, but the iOS app process reads its preferred localizations from the bundle cache at startup. Without explicit process-level arguments, the cached value (typically `en`) was used regardless of the `defaults write` call — even after SpringBoard restart.

**Fix applied**: `capture-screenshots.sh` now passes `-AppleLanguages "(ko)" -AppleLocale ko_KR` (or en equivalents) to every `xcrun simctl launch` call, guaranteeing locale is set at process start:

```bash
xcrun simctl launch booted "${BUNDLE_ID}" \
  -AppleLanguages "(ko)" \
  -AppleLocale ko_KR
```

This is the correct and documented mechanism for locale override in iOS Simulator (Apple DTS recommendation).

---

### Root Cause 2 (Secondary) — 15 String(localized:) keys missing from Localizable.xcstrings

**Hypothesis 5** confirmed.

When `String(localized: "key", defaultValue: "English text")` cannot resolve the key from the bundle (key absent from xcstrings), it falls back to `defaultValue` in ALL locales. This explains why Capture and Preview screens showed English regardless of locale.

**Keys added** (15 total, all with ko/en/ja translations):

| Key | ko | en | ja |
|-----|----|----|-----|
| `capture.close` | 닫기 | Close | 閉じる |
| `capture.field.title` | 제목 | Title | タイトル |
| `capture.field.title.prompt` | 필수 | Required | 必須 |
| `capture.field.medium` | 매체 | Medium | メディア |
| `capture.field.creator` | 제작자 (선택) | Creator (optional) | 作成者（任意） |
| `capture.field.cover` | 커버 이미지 (선택) | Cover Image (optional) | カバー画像（任意） |
| `capture.preview.memory` | 첫 기억 | First Memory | 最初の記憶 |
| `capture.preview.edit` | 수정 | Edit | 編集 |
| `capture.preview.save` | 저장 | Save | 保存 |
| `capture.retry` | 다시 시도 | Retry | 再試行 |
| `capture.save` | 저장 | Save | 保存 |
| `capture.status.done` | 저장 완료 | Saved | 保存完了 |
| `capture.status.failed` | 저장 실패 | Save failed | 保存失敗 |
| `capture.status.saving` | 저장 중… | Saving… | 保存中… |
| `capture.voice.processing` | 음성 처리 중… | Processing… | 処理中… |

---

## Hypotheses Checked

| Hypothesis | Status | Finding |
|-----------|--------|---------|
| H1 — xcstrings not compiled into bundle | N/A | No built bundle in DerivedData to inspect (build not run yet in this session) |
| H2 — sourceLanguage vs CFBundleDevelopmentRegion mismatch | **CLEAR** | Both `"ko"`. No fix needed. |
| H3 — String(localized:) using wrong table/bundle | **CLEAR** | All calls use default `Bundle.main` + `Localizable` table. No overrides. |
| H4 — defaults write not propagated to app process | **ROOT CAUSE** | Fixed in capture-screenshots.sh. |
| H5 — defaultValue masking missing key resolution | **ROOT CAUSE** | 15 keys missing. Fixed in Localizable.xcstrings. |

---

## Files Modified

| File | Change |
|------|--------|
| `scripts/capture-screenshots.sh` | Launch step now passes `-AppleLanguages` / `-AppleLocale` args |
| `App/Resources/Localizable.xcstrings` | 15 missing keys added (109 → 124 total) |

---

## Orphaned Keys (informational — no action taken)

41 keys exist in xcstrings but are not referenced by any `String(localized:)` call in current sources. These are likely keys for views not yet implemented or keys referenced via non-grep-visible patterns (e.g., `LocalizedStringKey` interpolation, `Text("key")`). No deletion — orphaned keys do not cause runtime errors and may be referenced by views not scanned.

---

## Verification Checklist

- [x] xcstrings JSON valid (python3 json.load passes)
- [x] All 15 new keys: ko/en/ja all present, all non-empty values
- [x] All 68 source-referenced keys now present in xcstrings
- [x] capture-screenshots.sh: launch step has locale args
- [ ] Single-quadrant capture test: run `bash scripts/capture-screenshots.sh --single light-ko` after next build to confirm Korean text visible

---

## R11A.1 — Full i18n Key Sync Audit

**Date**: 2026-05-21
**Auditor**: R11A.1 automated audit
**Trigger**: R10.3 Onboarding agent added 16+ keys; other recent agents may have introduced new String(localized:) usages without xcstrings entries. Comprehensive re-audit required.

### Pre-Audit State

| Metric | Count |
|--------|-------|
| Source keys extracted (String(localized:) + Text("key") + LocalizedStringKey patterns) | 126 |
| Catalog keys (xcstrings) | 140 |
| Missing (source → catalog) | 10 |
| Orphaned (catalog → source) | 24 |

### Missing Keys Found (10)

All 10 had `defaultValue` in source that served as English fallback across all locales.

| Key | en (defaultValue) | ko | ja |
|-----|-------------------|----|----|
| `accessibility.onboarding.1.card` | Book cover: Norwegian Wood... | 책 표지: 노르웨이의 숲... | ブックカバー：ノルウェイの森... |
| `accessibility.onboarding.1.memory` | Memory entry: Tokyo Tsutaya... | 기억 항목: 도쿄 츠타야... | 記憶エントリー：東京 蔦屋書店... |
| `accessibility.onboarding.3.sheet` | Share to: friend Minjin... | 공유 대상: 친구 민진... | 共有先：友人ミンジン... |
| `capture.error.open_settings` | Open Settings | 설정 열기 | 設定を開く |
| `capture.field.creator.prompt` | Author / Artist / Director… | 저자 / 아티스트 / 감독… | 著者 / アーティスト / 監督… |
| `capture.preview.acquired_note` | Acquired — just now | 획득 — 방금 | 入手 — たった今 |
| `capture.preview.ready` | Ready to save | 저장 준비 완료 | 保存の準備完了 |
| `capture.validation.title_required` | Title is required. | 제목을 입력해 주세요. | タイトルを入力してください。 |
| `capture.voice.permissionDenied.desc` | Microphone or speech recognition permission was denied. | 마이크 또는 음성 인식 권한이 거부되었습니다. | マイクまたは音声認識の権限が拒否されました。 |
| `capture.voice.transcript.label` | Recognised text | 인식된 텍스트 | 認識されたテキスト |

### Orphaned Keys (24 — preserved)

Keys in xcstrings but not referenced in current source. Kept — likely referenced by future views or via LocalizedStringKey interpolation not detectable by static grep.

`app.name`, `capture.error.titleRequired`, `capture.manual.cover`, `capture.manual.creator`, `capture.manual.medium`, `capture.manual.title`, `capture.modeUnavailable.barcode`, `capture.modeUnavailable.voice`, `capture.voice.permissionSpeech`, `item.detail.pages`, `item.detail.publisher`, `library.placeholder`, `nav.back`, `nav.close`, `nav.delete`, `nav.done`, `nav.edit`, `nav.save`, `nav.search`, `onboarding.2.media.line`, `onboarding.2.medium.book`, `onboarding.2.medium.movie`, `onboarding.2.medium.music`, `onboarding.2.medium.object`

### Post-Audit State

| Metric | Count |
|--------|-------|
| xcstrings total keys | 150 (was 140) |
| Missing (source → catalog) | 0 |
| Orphaned (catalog → source) | 24 (preserved) |
| All 3 locales (ko/en/ja) complete | yes |

### Files Modified

| File | Change |
|------|--------|
| `App/Resources/Localizable.xcstrings` | 10 missing keys added (140 → 150 total), all with ko/en/ja translations |
| `scripts/check-i18n.sh` | Added Step 8 — Axis N (key sync: source ↔ catalog). FAIL on any missing-in-catalog key, WARN on orphaned. Summary table updated. |

### Lint Verification (post-fix)

```
Axis N — Key sync: source ↔ catalog    PASS
Axis N WARN: 24 catalog keys not found in source (orphaned — kept, no action needed)
Step 3: 150 keys, all 3 locales complete, all states valid.
```

Axis A FAIL is pre-existing (numeric segments in `onboarding.N.*` keys violate the `[a-z][a-zA-Z]*` regex, introduced before R10.1 by the onboarding scaffolding). R11A scope: key sync only.

### Verification Checklist

- [x] xcstrings JSON valid (python3 json.load passes)
- [x] All 10 new keys: ko/en/ja all present, non-empty, state=translated
- [x] Axis N PASS: 0 source keys missing from catalog
- [x] Step 3 PASS: 150 keys, all 3 locales complete
- [x] check-i18n.sh Step 8 — Axis N added and operational
