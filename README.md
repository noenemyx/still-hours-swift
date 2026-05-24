# Own Your Curation

> iOS 26 + iPadOS 26 native curation app. _Search-first × 5-medium typed (Book/Music/Movie/Object/**Place**) × 1-to-1 share-card × Slow curator_.
>
> Korea-first launch (v1.0 free-for-now, paid post-traction). JP fast-follow. Global v2.0.
>
> **검색을 입구로, 채택을 본문으로.**

---

## What is this

Own Your Curation is a 5-medium personal archive where you **search → adopt → curate**. Not _what you own_ — _what you've chosen to keep close_.

Search a book by title or ISBN, an album by artist, a film, a cafe; adopt the result; attach a memory (date, who you were with, a line worth remembering). Share a single item as a 3:4 card to one friend (no public feed, ever). Receive a card from a friend → adopt into your own archive.

Five mediums: **책 / 음반 / 영화 / 오브제 / 장소**.

**Naming history**: 25 candidates validated before Still Hours (2026-05-20). Renamed to **Own Your Curation** (2026-05-23) as the paradigm shifted from _asset entry_ to _curation_. Bundle ID `com.ownlifelab.stillhours` preserved (technical key unchanged; display name only). Trademark 4-panel verdict 2026-05-23: SAFE to use. See `docs/PRD.md §0.-1` for full Build #8/#9 amendment + naming history.

---

## Status (2026-05-24)

- **Pre-launch** — Apple Developer 가입 승인 대기
- Repo: `noenemyx/curium-swift` (private). Display name: Own Your Curation. Bundle ID: `com.ownlifelab.stillhours`. Team ID: `89J24XNYL3`
- Launch target: iOS 26 + iPadOS 26 (Liquid Glass full, SwiftUI 26 APIs)
- Market: Korea-first v1.0. JP fast-follow (3~6m). Global v2.0.
- Build #9 cycle: paradigm shift complete. Search-first UI live. 5 medium model. SchemaV2 lightweight migration. Mock providers + iTunesSearchProvider live; Naver/KOBIS/TMDB providers pending user-provided API keys.

---

## Identity (Curation paradigm)

1. **Search-first single entry** — typing > tap chains. SearchFirstView is the root of tab 1
2. **Adopt, not add** — "채택" replaces "추가". Source-attributed Items (externalID + source) dedup across re-curations
3. **5 medium typed × work/manifestation** — books / music / films / objects / places in one data model
4. **1-to-1 intimate share-card** — ShareLink + 3:4 rendered image. v1.x adds Universal Link receive → adopt into receiver archive
5. **Apple-native iOS 26 first** — Liquid Glass, SwiftUI 26, SF Symbols 7, no fastlane

---

## Promise (5조항, 영구)

1. **No algorithm** — sort by explicit user choice only
2. **No public feed** — share is 1-to-1 (AirDrop/iMessage/Files), never browsable
3. **No advertising / no data sale** — including no Apple Search Ads
4. **No AI judgment** — AI only for OCR / image classification, never evaluation
5. **No subscription IAP** — lint-enforced in code

Data sovereignty: CloudKit Private DB only (opt-in v1.1); export anytime as JSON / CSV / PDF.

---

## Architecture

```
TabView root (3 tabs)
├── Tab 1 — 큐레이션  → CurationRootView → SearchFirstView (search → adopt)
├── Tab 2 — 내 컬렉션 → LibraryListView → ItemDetailView (curated items)
└── Tab 3 — 설정      → SettingsRootView
```

**Search aggregation** (`InventoryCore/Search/`):
- `UnifiedSearchService` actor — parallel TaskGroup over registered `SearchProvider`s, per-medium dedupe + rank
- Build #9a: 5 mock providers + Build #9b: iTunesSearchProvider (live, no key)
- Pending: NaverBookSearchProvider, NaverPlaceSearchProvider, KOBISSearchProvider, TMDBSearchProvider (Build #9b)

**Adoption** (`InventoryCore/Curation/CurationAdoptionService.swift`):
- `SearchResult` → `Item` with externalID-based dedup (predicate-scoped fetch, fetchLimit 1)
- Fallback dedup on `(medium, title, creator)` for results without externalID

**Share card** (`App/Views/Sharing/CardRenderView.swift`):
- SwiftUI `ImageRenderer` → 3:4 PNG (300×400pt @ 3x)
- ShareLink at 3 entry points: ItemDetailView toolbar, LibraryListView context menu, AddMemoryView post-save CTA

**Data**:
- SchemaV2 (`Models/SchemaV2.swift`) — added `externalID: String?`, `source: String?`, `publisher: String?` to Item
- Lightweight migration from SchemaV1 (additive optional fields, lossless)
- SwiftData + CloudKit Private DB (release) / in-memory (DEBUG)

---

## Documents (`docs/`)

| File | Purpose |
|------|---------|
| `PRD.md` | Product Requirements. **§0.-1 Build #8/#9 amendment** = current source of truth (rename, 5 medium, search-first, share-card path, global Google API path). Original §1~§19 = historical Still Hours decisions |
| `DEVPLAN.md` | Development Plan. **§0.-1** = Build #8 DONE / #9a-#9e DONE / #9f in progress / #9b pending KR keys / #10 ASO / #11+ Google API |
| `ASO-Metadata-OwnYourCuration.md` | App Store metadata 3 locale. **§2.5** = C-2 Korea ASO research revision (paste-ready) |
| `design-brief/` | Claude Design 외주 brief (5 파일: context / share-card / app-icon / medium-icons / brand-summary) |
| `lessons-learned.md` | Project-local lessons (axis A-R). Axis Q (SwiftData lightweight migration) + R (cross-project credential boundary) added Build #9 |
| `BENCHMARK.md` / `GOVERNANCE.md` / `Design.MD` | Original strategy + governance + design system |

---

## Build

```bash
xcodegen generate
swift test --package-path Packages/InventoryCore
bash scripts/test.sh                 # lints + SPM + xcodebuild

xcodebuild -project StillHours.xcodeproj -scheme StillHours \
  -configuration Debug -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

**Toolchain pinned** (2026-05-24): Xcode 26.4 / Swift 6.3 / xcodegen 2.45.4 / iOS 26.4 simulator.

---

## Current Status (Build #9 cycle, 2026-05-24)

**Tests / Lints**: `swift test` all PASS · `xcodebuild` BUILD SUCCEEDED (iPhone 17 Pro + iPad Pro 11) · 5 lints + i18n check PASS · 127+ Localizable.xcstrings keys × 3 locales (ko/en/ja)

**Build #9 milestones**:
- ✓ Build #8 — display name → Own Your Curation, Medium.place 5번째 + switch cascade 12 view
- ✓ Build #9a — UnifiedSearchService + 5 mock providers + SearchFirstView UI + CurationAdoptionService
- ✓ Build #9b (partial) — iTunesSearchProvider live (no key). Naver/KOBIS/TMDB pending API keys
- ✓ Build #9c — Onboarding 4파일 폐기, TabView 3 tabs, SearchFirstView at root
- ✓ Build #9d — sub-label 제거, auto-focus off, place demo data (도쿄 츠타야)
- ✓ Build #9e — Share Card v1.0 (3:4 ImageRenderer + 3 ShareLink entry points)
- ⏳ Build #9f — HIGH/MED 8건 fix (actor lift / predicate fetch / i18n / UI test cleanup)
- ⏳ SchemaV2 tests — CurationAdoptionService + UnifiedSearchService coverage

**Pending user actions**:
- Apple Developer 가입 승인 (Apple 처리)
- KR API keys: 네이버 검색 + KOBIS + TMDB (Build #9b unblock)
- Own Your Curation 전용 ASC API key 발급 (메타데이터 PATCH 자동화)
- 도메인 등록 (`ownyourcuration.com` / `.app`)
- SNS 핸들 잠금 (Instagram / X / Threads)
- App icon v3 finalize (design-brief 외주 결과 대기)

**Privacy policy URLs (live, HTTP 200 verified 2026-05-24)**:
- ko: https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-ko.html
- en: https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-en.html
- ja: https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-ja.html

---

## License

Proprietary. © sunghun.ahn 2026-.
