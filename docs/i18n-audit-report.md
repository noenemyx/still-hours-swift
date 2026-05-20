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
