# Still Hours

> iOS 26 + iPadOS 26 native collection app. _Item-as-memory-anchor × multi-medium typed (Book/Music/Movie/Object) × intimate 1-to-1 share × Slow curator_. Paid one-time **$14.99**.
>
> 자산을 입구로, 기억을 본문으로.

---

## What is this

Still Hours is a collection management app where each item (book, album, film, object) becomes the entry point for the memories attached to it. Day One organizes by date entries; Still Hours organizes by items and lets memories accumulate underneath each one.

**Naming history**: 25 candidates were validated before adopting Still Hours (2026-05-20). Rejected (in order): Curio (App Store collision), Vaulta (EOS Network rebrand), Constella (AbbVie pharma), Curium (Curium Pharma SEO), Luminae, Aevum, Kuria, Reliqua, Own Collection, Own Your Collection, Ownbox, Otium, Own Gem, Your Magnet, Heartlink, Your Journey, Tidemark, Cairn, Reliquary, Sumi, Mura, Lumo, Slow Shelf, Still Yours, Still Times. See `docs/PRD.md §19 + §21` for the full naming history and 25-candidate validation table.

**Still Hours** — dual meaning: _stillness (고요)_ + _still continuing (여전히)_, anchored to the smallest time unit that belongs to you.

---

## Status

- **Pre-flight stage** (2026-05-20)
- Repo: `noenemyx/still-hours-swift` (private)
- Bundle ID: `com.ownlifelab.stillhours` (TBD by user — Apple Developer Console)
- Launch target: iOS 26 + iPadOS 26 only (Liquid Glass full, SwiftUI 26 APIs)
- Mac native: v2.0 (post-launch month 7-12)

---

## Identity (4 axes)

1. **Item-as-memory-anchor** — items are the entry, memories are the body (Day One inverse)
2. **Multi-medium typed × work/manifestation** — books, music, films, physical objects in one data model (Discogs work/release pattern, multi-domain)
3. **1-to-1 intimate share** — CloudKit CKShare, no public profile
4. **Apple-native iOS 26 first** — Liquid Glass design language, SwiftUI 26 APIs

---

## Promise (default reserve)

1. No algorithm — sort by explicit user choice only
2. No feed — no public stream
3. No advertising / no data sale — including no Apple Search Ads, no external ad channels
4. No AI judgment — AI assist only for OCR/image recognition
5. **No subscription IAP** — code-enforced via lint (the one Promise made non-negotiable in code)

Plus Data Sovereignty: CloudKit Private DB only, plaintext JSON/CSV/PDF export always available.

---

## Documents (`docs/`)

| File | Lines | Description |
|------|-------|-------------|
| `PRD.md` | ~1280 | Product Requirements — niche, persona, JTBD, hero moments, user stories, data model, modules, pricing, naming history (§19 Curio→Curium, §21 Curium→Still Hours + 25-candidate table) |
| `GOVERNANCE.md` | ~95 | Decision authority — advisory vs user role + Critical Tier 1/2 + Decision flow + violation history |
| `DEVPLAN.md` | ~1360 | Development Plan — tech stack, architecture, MVP definition (Tracer Bullet), milestones, risk register, release strategy, burnout protection, ASO Implementation (§16), naming change history (§17) |
| `BENCHMARK.md` | ~440 | Market benchmark — 22 apps × 9 categories, 5 product hypotheses, niche definition |
| `ADVISORY.md` | ~235 | 6-panel advisory synthesis (Marketing / Strategy / UX / UI / Design / Engineer) |
| `Design.md` | ~970 | Design system living document — Sunsama + Things 3 + benchmark + Claude Design collaboration + ASO Visual Strategy |

---

## ASO Optimization (continuous practice)

ASO is treated as a _continuous practice from development stage_, not a launch-only activity. See `PRD.md §20` / `DEVPLAN.md §16` / `Design.md §16` for full strategy.

Monthly ASO ritual = 매월 1일 1시간 (advisory ritual과 분리):
- Keyword ranking 30분 + Competitor scan 20분 + Review analysis 10분

ASO Quit signal (6개월 시점):
- 3-month rolling rating < 4.0 _AND_ paid downloads < 100 _AND_ 30-day refund > 8% _AND_ DAU/MAU < 15% — 4개 중 3개 이상 동시 충족 시 제품 재검토

---

## Pre-flight Week 1-3 (36h checklist)

Tracer Bullet sequence (`Book full → Music full → Movie basic → Object basic`) starts after Pre-flight gate clears all items.

**Status as of 2026-05-20** — through Pre-flight Round 4 / commit `f15da22`:

### Agent-doable (auto-completable) — all done ✓

- [x] Liquid Glass material reference study (WWDC 2025) → `docs/LiquidGlass-Notes.md`
- [x] Foundation tokens v1.0 (Color 10 + Type 8 + Space 6 + Radius 4 + Shadow 2 + Motion 4) → R1 `4ee9652`
- [x] Semantic tokens v1.0 → R2 `04919f9`
- [x] Component tokens v1.0 (ItemCard / MemoryRow / CollectionCover / MediumBadge) → R2 `04919f9`
- [x] Memory Timeline visual signature design pass → `docs/MemoryTimeline-Design.md` (R1)
- [x] WCAG AA contrast verification chart → `docs/WCAG-Contrast-Verification.md` (R3: Light 0 Fail / Dark 0 Fail)
- [x] Settings → "Still Hours is" surface copy (ko/en draft) → `docs/Settings-Surface-Copy.md` (R1)
- [x] App Store metadata 8-locale 1차 draft (Wave 1 ko/en/ja 우선) → `docs/ASO-Metadata-Wave1.md` (R4 — 665 lines, 15 deliverables verified)
- [x] Promise lint scripts (Privacy + Data Sovereignty + No subscription IAP — 3 lint baseline) → `scripts/check-*.sh`, all 3 PASS (R3/R4)
- [x] SwiftData v1 schema — Item / Memory / Collection / Attachment + VersionedSchema → R3 `8344a9c`
- [x] InventoryCore services (Library / Export / Capture / Timeline / ServiceError) → R4 `f15da22`
- [x] InventoryCore unit tests (Swift Testing, 71 @Test functions, all PASS) → R4 `f15da22`
- [x] CaptureFlow UI design spec → `docs/CaptureFlow-Design.md` (R4 — 719 lines)
- [x] Onboarding 3-step design spec → `docs/Onboarding-3step-Design.md` (R3)
- [x] xcodegen project.yml + iOS 26.0 deployment target → R3 `8344a9c`
- [x] `xcodebuild iOS 26.4 simulator` clean build verified → R4 `f15da22`

### Deferred pending user input

- [ ] App icon v1.0 draft (Wunderkammer cabinet + Liquid Glass layered) — _Deferred_ by user 2026-05-20 pending Apple Design Resources Figma study. Two concept directions drafted in `docs/AppIcon-v1-Concept.md` (Wunderkammer vs Light on Paper). Advisor recommendation: B (Light on Paper) — final decision after Figma.

### User-direct actions (no agent path)

- [x] Trademark search (KIPRIS + USPTO Class 9 + EUIPO + App Store dupes) for "Still Hours" — 7-axis pre-check done (no critical collision; descriptive-risk 50/50 mitigated by Liquid Glass app-icon + UI distinctiveness). Final formal 변리사 opinion: **사용자 결정으로 진행하지 않음 (2026-05-21)**. Risk accepted: USPTO refusal possible at registration; pivot to common-law / state TM if needed.
- [ ] Apple Design Resources iOS 26 Figma download + study — see docs/Pre-flight-User-Actions.md
- [ ] SF Symbols 7 macOS app install — see docs/Pre-flight-User-Actions.md
- [x] Bundle ID `com.ownlifelab.stillhours` — **등록 완료 2026-05-21** via ASC API. Resource ID `GFG86L5VY4`, iCloud/CloudKit capability 활성화. Team ID `89J24XNYL3` (Configs/Debug.xcconfig + Release.xcconfig에 주입됨).
- [ ] CloudKit Container `iCloud.com.ownlifelab.stillhours` — Apple Developer Console에서 수동 생성 (ASC API는 container 생성을 expose 하지 않음)

---

## Build

```bash
xcodegen generate                    # Generate StillHours.xcodeproj from project.yml
swift test --package-path Packages/InventoryCore  # SPM unit tests (71 PASS)
bash scripts/test.sh                 # All 3 lints + SPM tests + xcodebuild (single entry)
bash scripts/test.sh --lint-only     # 3 Promise lints only (~1s)
bash scripts/test.sh --build-only    # SPM test + xcodebuild only

xcodebuild -project StillHours.xcodeproj -scheme StillHours \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug build         # Direct xcodebuild
```

**Toolchain pinned** (verified 2026-05-20): Xcode 26.4 / Swift 6.3 / xcodegen 2.45.4 / iOS 26.4 simulator runtime.

---

## License

Proprietary. © sunghun.ahn 2026-.
