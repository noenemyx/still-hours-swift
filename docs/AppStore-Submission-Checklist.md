# App Store Submission Checklist — Still Hours v1.0

> **App**: Still Hours  
> **Bundle ID**: com.ownlifelab.stillhours  
> **Minimum Deployment**: iOS 26  
> **Pricing**: $14.99 one-time paid (Tier 21)  
> **Locales**: ko · en · ja · zh-Hans · zh-Hant · fr · es · pt (8 locales; Wave 1 = ko/en/ja)  
> **CloudKit**: disabled in v1.0 (iCloud sync deferred to v1.1)  
> **IAP / Subscription / Ads**: none  
> **Data collection**: zero  
> Last updated: 2026-05-22

---

## 1. Pre-Submission Build Gates

### 1.1 Code Quality

- [x] `bash scripts/test.sh` exits 0 (84 SPM unit tests PASS as of R10 `1ab295d`)
- [x] Promise 5-clause lint scripts all PASS (`check-promise.sh`, R3/R4 `d0bd2f5`)
- [x] i18n 10-axis lint PASS (`check-i18n.sh`, R6)
- [x] SwiftData predicate lint PASS (R3 `d0bd2f5`)
- [x] SF Symbols lint PASS (`check-sfsymbols.sh`, R8 `11ab06b`)
- [x] Axis A module-shadow lint PASS (R11A `check-axis-a.sh`)
- [x] Axis F quote-escape lint PASS (R11A)
- [ ] Pre-commit hook runs clean on a fresh `git commit` (verify after final code changes)
- [ ] `xcodebuild build -scheme StillHours -destination 'generic/platform=iOS'` exits 0 with no warnings
- [ ] Archive build succeeds: `xcodebuild archive -scheme StillHours -archivePath StillHours.xcarchive`
- [ ] Export IPA: `xcodebuild -exportArchive -archivePath StillHours.xcarchive -exportPath ./export -exportOptionsPlist ExportOptions.plist`
- [ ] No `DEBUG`-only code paths reachable in release build (`#if DEBUG` guards verified)
- [ ] No `TODO` / `HACK` / `FIXME` comments in production source files

### 1.2 Privacy Manifest (`PrivacyInfo.xcprivacy`)

- [x] `PrivacyInfo.xcprivacy` file present in app target (R5 scaffold)
- [ ] `NSPrivacyTracking` = `false`
- [ ] `NSPrivacyTrackingDomains` = `[]` (empty)
- [ ] `NSPrivacyCollectedDataTypes` = `[]` (zero collection)
- [ ] `NSPrivacyAccessedAPITypes` — verify each Required Reason API used:
  - [ ] File timestamp APIs (if used): reason code included
  - [ ] UserDefaults (if used): reason code `CA92.1` or equivalent
  - [ ] No other Required Reason APIs accessed without declared reason
- [ ] Run `xcrun stapler` on archive to verify notarization compatibility (macOS only; skip for iOS-only submit)
- [ ] Apple's privacy manifest validator shows no warnings: [Required Reason API docs](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api)

### 1.3 Entitlements

- [ ] `StillHours.entitlements` contains only entitlements actually used
- [ ] `com.apple.developer.icloud-container-identifiers` — **omit or set to empty** (CloudKit deferred to v1.1; do not request CloudKit entitlement in v1.0 unless the capability is wired end-to-end)
- [ ] `com.apple.developer.icloud-services` — **omit** in v1.0
- [ ] No Push Notifications entitlement (v1.0 has no push)
- [ ] No Associated Domains entitlement unless Universal Links are active
- [ ] Provisioning profile matches bundle ID `com.ownlifelab.stillhours` exactly
- [ ] Provisioning profile includes all test devices (internal TestFlight)
- [ ] Distribution certificate valid and not expiring within 30 days

### 1.4 TestFlight Internal Beta

- [ ] Internal TestFlight build uploaded and accepted by App Review automation
- [ ] At least 1 internal tester has installed and smoke-tested the build
- [ ] Crash-free rate > 99% over minimum 24h internal test window
- [ ] No `ITMS-9000x` warnings in the App Store Connect upload log

---

## 2. ASC Metadata (8 Locales)

Reference: `docs/ASO-Metadata-Wave1.md` for ko/en/ja copy (verified, character-counted).  
zh-Hans · zh-Hant · fr · es · pt = Wave 2 content (draft before submit if targeting simultaneous 8-locale launch).

### 2.1 App Name (30 chars max)

- [x] **ko** · **en** · **ja**: `Still Hours` (11/30) — locked in ASO-Metadata-Wave1 §2/3/4
- [ ] **zh-Hans**: `Still Hours` (confirm or provide localized name)
- [ ] **zh-Hant**: `Still Hours` (confirm or provide localized name)
- [ ] **fr**: `Still Hours`
- [ ] **es**: `Still Hours`
- [ ] **pt**: `Still Hours`

### 2.2 Subtitle (30 chars max)

- [x] **ko**: `책·음악·영화·오브제의 기억 아카이브` (ASO-Metadata-Wave1 §2, verified ≤30)
- [x] **en**: `Archive. Four mediums. Slow things.` (ASO-Metadata-Wave1 §3, verify char count)
- [x] **ja**: `本·音楽·映画·モノの記憶アーカイブ` (ASO-Metadata-Wave1 §4, verified ≤30)
- [ ] **zh-Hans**: draft subtitle (≤30 chars)
- [ ] **zh-Hant**: draft subtitle (≤30 chars)
- [ ] **fr**: draft subtitle (≤30 chars)
- [ ] **es**: draft subtitle (≤30 chars)
- [ ] **pt**: draft subtitle (≤30 chars)

### 2.3 Promotional Text (170 chars max — updatable without review)

- [ ] **ko**: draft (170 chars max)
- [ ] **en**: draft (170 chars max)
- [ ] **ja**: draft (170 chars max)
- [ ] zh-Hans / zh-Hant / fr / es / pt: draft or copy from English

### 2.4 Description (4000 chars max)

- [x] **ko**: full description in ASO-Metadata-Wave1 §2 (structure verified: hook → 4 mediums → promises → price)
- [x] **en**: full description in ASO-Metadata-Wave1 §3
- [x] **ja**: full description in ASO-Metadata-Wave1 §4
- [ ] **zh-Hans**: draft description (4000 chars max)
- [ ] **zh-Hant**: draft description (4000 chars max)
- [ ] **fr**: draft description (4000 chars max)
- [ ] **es**: draft description (4000 chars max)
- [ ] **pt**: draft description (4000 chars max)
- [ ] All descriptions include explicit price statement (`$14.99 one-time` or locale equivalent) — critical for setting expectation before price page
- [ ] No emoji in any description (brand rule)
- [ ] No superlatives (`best`, `#1`, `most`) — App Review guideline 2.3.7

### 2.5 Keywords (100 chars max per locale — updatable without review)

- [x] **ko**: `컬렉션,아카이브,독서기록,음악수집,영화기록,큐레이션,기억,일회구매,기록앱` (ASO-Metadata-Wave1 §2, ≤100)
- [x] **en**: `collection,archive,library,books,music,films,memory,curator,vinyl` (ASO-Metadata-Wave1 §3, ≤100)
- [x] **ja**: `コレクション,アーカイブ,蔵書,映画記録,読書記録,買い切り,キュレーション,音盤,日記` (ASO-Metadata-Wave1 §4, ≤100)
- [ ] **zh-Hans**: keyword string (≤100 chars, no spaces in multi-word terms)
- [ ] **zh-Hant**: keyword string (≤100 chars)
- [ ] **fr**: keyword string (≤100 chars)
- [ ] **es**: keyword string (≤100 chars)
- [ ] **pt**: keyword string (≤100 chars)
- [ ] No keyword already in App Name or Subtitle (Apple ignores duplicates; wasted slots)
- [ ] No competitor app names in keywords (policy violation)

### 2.6 Category

- [ ] **Primary category**: Lifestyle  
  _(Rationale: 4-medium personal curation / memory archive; "Lifestyle" is the standard App Store category for this niche. "Entertainment" is incorrect — Still Hours is a creation/archiving tool, not passive media consumption.)_
- [ ] **Secondary category**: Productivity  
  _(Captures users searching for organizational tools; complements Lifestyle primary.)_

### 2.7 Support URL and Marketing URL

- [ ] **Support URL**: privacy policy / support page live and reachable (HTTPS required)  
  Candidate: `https://ownlifelab.com/stillhours/support` or equivalent static page
- [ ] **Marketing URL** (optional): product landing page URL if available
- [ ] Privacy Policy URL entered in ASC (required for all paid apps): direct link to `PrivacyPolicy-en.md` hosted as HTML page  
  Note: `docs/legal/PrivacyPolicy-en.md` exists — must be deployed to a public URL before submission

---

## 3. Screenshots

Apple requires screenshots for specific device sizes. Missing a required size blocks submission.  
Reference: [App Store screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/)

### Required Device Frames

| Frame | Resolution | Required? | Status |
|-------|-----------|-----------|--------|
| 6.7" iPhone (iPhone 15 Pro Max, 16 Pro Max) | 1290 × 2796 px | **Yes** | Verify R12 captures match |
| 6.5" iPhone (iPhone 14 Plus, 15 Plus) | 1242 × 2688 px | Yes (if not using 6.7" to cover) | Check if 6.7" covers |
| 5.5" iPhone (iPhone 8 Plus) | 1242 × 2208 px | Yes (legacy required size) | Not yet captured |
| 12.9" iPad Pro | 2048 × 2732 px | Yes (if iPad supported) | R13 verified layout |

> **Apple policy (2024+)**: If you submit screenshots for 6.7" only, Apple will use those for all iPhone sizes. However, 5.5" is still a _separate required slot_ if you want to explicitly cover older devices. Confirm current ASC requirement at submission time — Apple occasionally removes legacy slots.

### Screenshot Count and Content

- [x] iPhone light/dark × ko/en × portrait captured in R12 (4-quadrant automation, R9 `eb9ee24`)
- [x] iPad layout verified in R13 (split-view, `iPad Pro 13"` simulator)
- [ ] iPad 12.9" screenshots captured in portrait (required for iPad-supported builds)
- [ ] **6.7" iPhone screenshots** — confirm R12 captures are exactly 1290 × 2796 px (verify with `sips -g pixelWidth -g pixelHeight screenshot.png`)
- [ ] **5.5" iPhone screenshots** — capture separately on iPhone 8 Plus simulator or resize with Keynote framing
- [ ] Minimum 1 screenshot per locale per device size (App Review minimum)
- [ ] Maximum 10 screenshots per locale per device size
- [ ] No landscape screenshots for iPhone (portrait-only app — confirm in `Info.plist` supported orientations)
- [ ] No placeholder text, lorem ipsum, or DEBUG watermarks visible in any screenshot
- [ ] No competitor app logos visible in screenshots (policy)
- [ ] All screenshots show iOS 26 / Liquid Glass UI (matches submitted build)

### Screenshot Localization

Wave 1 (required at launch):
- [ ] **ko**: screenshots with Korean locale active (R12 ✓ — verify filenames)
- [ ] **en**: screenshots with English locale active (R12 ✓ — verify filenames)
- [ ] **ja**: screenshots with Japanese locale active (not yet captured — R12 captured ko/en only)

Wave 2 locales (can use English screenshots as fallback initially):
- [ ] zh-Hans / zh-Hant / fr / es / pt: either locale-specific captures or English fallback

### App Preview Video (Optional)

- [ ] 30-second preview video (en) — DEVPLAN §16.4 Wave 1 mentions 1 preview video; create if capacity allows
- [ ] H.264 or HEVC, 30fps max, no letterboxing

---

## 4. App Review Information

### 4.1 Contact Information

- [ ] **First name / Last name**: enter reviewer contact (your name or a support alias)
- [ ] **Email**: sunghun.ahn@gmail.com (or a dedicated support address)
- [ ] **Phone**: required field — enter a reachable number with country code

### 4.2 Demo Account

- [ ] **Demo account required?**: No — Still Hours has no sign-in, no account system. Select "No sign-in required."

### 4.3 Notes for App Review

Prepare a clear note covering the following (paste into the Notes field in ASC):

```
Still Hours is a paid personal media archive app. No account, no login, no server.

Four media types: book (ISBN scan), music (manual + MusicBrainz), movie (manual + TMDB), physical object (manual).

No in-app purchase, no subscription, no advertising SDK, no analytics SDK, no third-party data collection. Privacy nutrition label: nothing collected.

iCloud sync is intentionally absent in v1.0 (deferred to v1.1). The CloudKit entitlement is not requested.

The app requires camera permission (barcode scan), microphone permission (voice memo capture), and speech recognition permission (voice-to-text). Each permission is requested only when the user initiates the relevant capture mode.

DemoSeeder (DEBUG-only test data) is compiled out in release builds via #if DEBUG guards.
```

- [ ] Notes text entered in ASC "Notes" field (App Review Information section)
- [ ] Attachment: optional — attach a brief screen-recording of the capture flow if App Review may be confused by the barcode / voice capture UX

---

## 5. Pricing and Availability

- [ ] **Price**: $14.99 USD (Tier 21) — confirm in ASC Pricing and Availability tab
- [ ] **Pricing schedule**: no introductory pricing, no limited-time sale at launch
- [ ] **Availability**: all territories (or choose specific if you want to gate by locale wave)
- [ ] **Distribution**: App Store only (no Custom Apps, no Business)
- [ ] **Pre-orders**: not enabled (straight to sale)
- [ ] **Educational pricing**: not applicable (no institution license)
- [ ] Confirm price displays correctly in target storefronts: KRW (Korea), JPY (Japan), USD (US), EUR (France), etc.

---

## 6. Privacy Nutrition Label

Still Hours collects zero data. The label should be the simplest possible.

- [ ] In ASC, navigate to App Privacy → Data Types
- [ ] **Answer "No" to every data collection question** — no data is collected, linked, or used for tracking
- [ ] Specifically confirm **not** collected:
  - Contact info (name, email, phone, address)
  - Health & fitness
  - Financial info
  - Location
  - Sensitive info
  - Contacts
  - User content (the user's items/memories stay on-device only)
  - Browsing / search history
  - Identifiers (device ID, user ID)
  - Usage data (no analytics SDK)
  - Diagnostics (no crash reporting SDK — confirm; if using `MetricKit` for crash logs, declare it)
- [ ] `NSPrivacyTracking` = `false` in `PrivacyInfo.xcprivacy` (cross-check with §1.2)
- [ ] Privacy Policy URL is live and entered in ASC (required even for zero-collection apps — App Review will reject without it)
- [ ] Confirm legal docs are deployed:  
  - `docs/legal/PrivacyPolicy-en.md` → public HTTPS URL
  - `docs/legal/PrivacyPolicy-ko.md` → same or separate URL
  - `docs/legal/PrivacyPolicy-ja.md` → same or separate URL
- [ ] Terms of Service URL entered if applicable (`docs/legal/TermsOfService-en.md` exists — decide if ToS link is displayed)

---

## 7. Export Compliance

- [ ] In ASC, answer the export compliance questionnaire:
  - **Does your app use encryption beyond what Apple provides?** → **No**  
    _(Still Hours uses only HTTPS via URLSession and ATS — Apple OS-provided encryption. No custom encryption, no third-party crypto libraries, no VPN.)_
  - **Is your app a mass-market encryption product?** → N/A (answered No above)
- [ ] Select "No — this app does not use encryption, or only uses exempt encryption" — this allows App Store distribution without ERN (Export Regulations Number)
- [ ] If `NSAllowsArbitraryLoads` is set to true in `Info.plist`, remove it — ATS exceptions require justification and may trigger export compliance questions

---

## 8. Age Rating Questionnaire

Answer in ASC → App Information → Age Rating:

- [ ] **Cartoon or fantasy violence**: None
- [ ] **Realistic violence**: None
- [ ] **Sexual content or nudity**: None
- [ ] **Profanity or crude humor**: None
- [ ] **Mature / suggestive themes**: None
- [ ] **Horror / fear themes**: None
- [ ] **Medical / treatment information**: None
- [ ] **Alcohol, tobacco, or drug use**: None
- [ ] **Gambling**: None
- [ ] **Contests**: None
- [ ] **Unrestricted web access**: None (no WebKit full-browser; any WKWebView is sandboxed to specific URLs)
- [ ] **User-generated content visible to others**: None (no sharing in v1.0; IntimateShare deferred)
- [ ] **Expected rating**: **4+** (all clean; confirmed by questionnaire above)
- [ ] Enter expected rating in ASC and confirm Apple's calculated rating matches 4+

---

## 9. Version and Release Notes (What's New)

### 9.1 Version Number

- [ ] **Version**: `1.0.0` (CFBundleShortVersionString in `Info.plist`)
- [ ] **Build number**: increment from last TestFlight build (CFBundleVersion, e.g., `100`)
- [ ] Confirm version and build in `project.yml` (XcodeGen source of truth) match the archive

### 9.2 What's New Text (4000 chars max — required for v1.0)

For v1.0, "What's New" is the first-launch message. Keep it short and brand-consistent.

- [ ] **ko** (required at Wave 1 launch):
  ```
  Still Hours 첫 번째 버전입니다.
  책, 음악, 영화, 오브제 — 네 가지 미디어의 기억을 하나에 기록합니다.
  $14.99 일회 구매. 구독 없음. 광고 없음. 데이터 수집 없음.
  ```
- [ ] **en** (required at Wave 1 launch):
  ```
  Still Hours 1.0 — the first release.
  Archive books, music, films, and objects. One place for the things that stay with you.
  $14.99 one-time. No subscription. No ads. Nothing collected.
  ```
- [ ] **ja** (required at Wave 1 launch):
  ```
  Still Hours 初回リリースです。
  本・音楽・映画・モノ — 4つのメディアの記憶を一か所に。
  $14.99 買い切り。サブスクなし。広告なし。データ収集なし。
  ```
- [ ] zh-Hans / zh-Hant / fr / es / pt: draft or use English fallback for Wave 1
- [ ] No emoji in release notes (brand rule)

---

## 10. Final Submit Checklist

Run through this list immediately before clicking "Submit for Review" in ASC.

### 10.1 Build Verification (Day-of-Submit)

- [ ] Fresh archive build on clean checkout (`git stash` → `xcodebuild clean` → archive)
- [ ] Archive uploaded via `xcrun altool --upload-app` or Xcode Organizer
- [ ] Upload succeeded with no `ITMS-9000x` errors
- [ ] Build appears in ASC → TestFlight → Builds within 30 minutes

### 10.2 ASC Completeness Check

- [ ] All required fields in App Information are filled (no yellow warning banners in ASC)
- [ ] Screenshots submitted for all required device sizes (6.7" iPhone minimum; iPad 12.9" if iPad capability is declared)
- [ ] At least 1 screenshot per active locale
- [ ] Privacy Nutrition Label completed and saved (not just drafted)
- [ ] Export Compliance answered
- [ ] Age Rating questionnaire complete
- [ ] App Review Notes entered
- [ ] Support URL is live and returns HTTP 200
- [ ] Privacy Policy URL is live and returns HTTP 200
- [ ] Pricing set to $14.99 and availability configured
- [ ] Version and build selected in "Version Information" section

### 10.3 Pre-Submit Smoke Test (Device)

- [ ] Install the exact IPA from the archive on a physical iPhone running iOS 26
- [ ] Complete the 3-step Onboarding without error
- [ ] Add one Book item via barcode scan
- [ ] Add one Book item via manual entry
- [ ] Add one Memory to the item
- [ ] Verify MemoryTimelineView shows the item
- [ ] Export JSON from Settings → Export
- [ ] Verify exported JSON is valid (open in Files app or share to Notes)
- [ ] Launch in Japanese locale (Settings → General → Language): confirm UI is fully translated
- [ ] No crash on any of the above steps

### 10.4 Post-Submit

- [ ] Click "Submit for Review" — confirm submission ID recorded
- [ ] Monitor ASC for "In Review" status (typically within 24–48 hours for new apps)
- [ ] Prepare App Store connect phased release if desired (5% → 10% → 20% → 50% → 100% over 7 days) — optional but recommended for first launch
- [ ] Have a v1.0.1 hotfix plan ready: identify the 1–2 most likely launch-day issues based on TestFlight feedback

---

## Appendix A — Legal Docs Deployment Status

| Document | File | Status |
|----------|------|--------|
| Privacy Policy (en) | `docs/legal/PrivacyPolicy-en.md` | Exists — needs public URL |
| Privacy Policy (ko) | `docs/legal/PrivacyPolicy-ko.md` | Exists — needs public URL |
| Privacy Policy (ja) | `docs/legal/PrivacyPolicy-ja.md` | Exists — needs public URL |
| Terms of Service (en) | `docs/legal/TermsOfService-en.md` | Exists — needs public URL |
| Terms of Service (ko) | `docs/legal/TermsOfService-ko.md` | Exists — needs public URL |
| Terms of Service (ja) | `docs/legal/TermsOfService-ja.md` | Exists — needs public URL |

All six documents must be deployed to HTTPS URLs before submission. A simple GitHub Pages deployment (`docs/legal/` folder as a static site root) suffices.

---

## Appendix B — Screenshot Capture Commands

```bash
# Capture screenshot from running simulator
xcrun simctl io booted screenshot screenshot_01.png

# Run UI tests that trigger screenshot capture
xcodebuild test \
  -scheme StillHoursUITests \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro Max,OS=26.0' \
  -resultBundlePath TestResults.xcresult

# Verify screenshot dimensions
sips -g pixelWidth -g pixelHeight screenshot_01.png

# Change simulator locale (requires reboot)
xcrun simctl spawn booted defaults write NSGlobalDomain AppleLocale ja_JP
xcrun simctl spawn booted defaults write NSGlobalDomain AppleLanguages "(ja)"
xcrun simctl shutdown booted && xcrun simctl boot <UDID>
```

Wave 2 screenshot automation: `scripts/capture-screenshots.sh` (to be written per DEVPLAN §16.4 Wave 2 trigger).

---

## Appendix C — Key Apple Documentation Links

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/screenshot-specifications/)
- [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files)
- [Required Reason APIs](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api)
- [App privacy details](https://developer.apple.com/app-store/app-privacy-details/)
- [Export compliance overview](https://developer.apple.com/help/app-store-connect/reference/export-compliance-overview)
- [Human Interface Guidelines — App icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Human Interface Guidelines — Screenshots](https://developer.apple.com/design/human-interface-guidelines/in-app-purchase#App-Store-product-pages)
- [App Store Connect Help](https://developer.apple.com/help/app-store-connect/)
