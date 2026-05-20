# Development Plan — H1+H5 Hybrid: Memory Archive × Slow Curator

> Version 1.0 (zero-base, OYL-독립) | 2026-05-20 | sunghun.ahn
>
> _PRD.md 와 함께 읽을 것._ PRD 가 _무엇을 / 왜_, 본 문서가 _어떻게 / 언제 / 얼마나_.
> _Ownlifelab / OYL 코드 자산 차용 X._ 본 프로젝트는 _독립_ codebase.

---

## 0. Engineering Charter

본 프로젝트는 _독립_ codebase 이지만, 사용자가 _경험을 통해 검증한_ 작업 원칙은 _개인 자산_으로 적용. _OYL 의존 X_ 라는 의미는 _코드 차용 X_, _브랜드 차용 X_ 일 뿐 _개인 엔지니어링 원칙_ 까지 reset 의미 아님.

### 0.1 1원칙 — 사용자 oriented

모든 결정은 _10년 후 Lina (페르소나) 가 더 나은 삶을 살게 하는가?_ 라는 한 질문으로 회귀.

### 0.2 정공법

- Apple-native first. fastlane / Ruby / Bundler 도입 _금지_.
- xcodebuild / xcrun / Python + ASC REST API.
- 3rd-party 의존성당 _10× 가치_ bar.
- 우회보다 근본 원인.

### 0.3 Boring tech default

- SwiftData over Realm/Core Data.
- CloudKit Private DB over Firebase/Supabase.
- SwiftUI over UIKit.
- 의존성 _0_ 을 시작점으로.

### 0.4 Karpathy guidelines

- Think before code, simplicity first, surgical changes, goal-driven execution.
- Code review separate pass.
- 200줄 → 50줄 가능하면 다시 쓰기.

### 0.5 Sub-agent parallel + 위임

- ≥2 file 변경 = sub-agent fanout (≤4 동시).
- Long-running = `run_in_background: true`.
- Strategic decisions = main session.

### 0.6 Lessons Learned consult

- 작성 _전_ `~/.claude/lessons-learned-global.md` 확인 (cross-project, OYL 무관 entries).
- 하드 버그 발생 시 신규 entry + 자동 lint 추가.

---

## 1. Tech Stack — _왜 이걸 선택했는가_

### 1.1 Language / Framework

| 선택 | 대안 | 선택 이유 |
|------|------|---------|
| **Swift 6 (strict concurrency)** | Swift 5, Kotlin, Flutter, RN | Apple-native first. _Sendable 강제_로 race condition 사전 차단. |
| **SwiftUI** | UIKit, Catalyst | iOS 17+ 안정. 10년 도구 시점 (2030~) UIKit-only legacy 의 maintenance cost 가 SwiftUI _이상_ 으로 추정. |
| **SwiftData** | Core Data, Realm, SQLite | Apple-bundled. iOS 17+ 안정성 검증. SwiftUI 직접 연동. CloudKit Sharing 직접 지원. |
| **CloudKit Private DB + Sharing** | Firebase, Supabase, custom backend | _데이터 주권_. 외부 서버 0. Apple ID 자동 인증. CKShare 로 _계정 없는 공유_. 서버 운영비 $0. |
| **MapKit + CoreLocation** | Mapbox, Google Maps SDK | Place entity의 _장소 등록_. _개인정보 외부 송신 0_. |
| **AVFoundation + VisionKit** | 3rd-party OCR | 바코드 / OCR. Apple-bundled, 외부 송신 0. |
| **Speech framework** | Whisper, third-party | 음성 메모. _on-device_ 옵션, 외부 송신 X. |
| **Combine + async/await** | RxSwift | Apple 표준. 새 dependency 0. |

### 1.2 External APIs (외부 메타데이터 lookup)

| 용도 | 선택 | 무료/유료 | 사용자 식별 송신 |
|------|------|--------|--------------|
| Book ISBN | Open Library (1차), Google Books (fallback) | 무료 | _0_ (ISBN만) |
| Music | MusicBrainz (1차), Apple Music search (보조) | 무료 (Apple Music = Apple Dev) | _0_ |
| Movie | TMDB | 무료 (API key 필요) | _0_ |
| Generic | Wikipedia (fallback) | 무료 | _0_ |
| Place | MapKit | 무료 | Apple 내부, 외부 _0_ |
| 표지 이미지 | 위 source의 cover URL | 무료 | _0_ |

**v1.0 의도적 제외**: Spotify (OAuth + 식별 송신) / Discogs / Audible / Amazon.

### 1.3 Build / Release Pipeline (Apple-native)

| 단계 | 도구 |
|------|-----|
| Project generation | XcodeGen (`project.yml`) |
| Build / Test | `xcodebuild`, `xcrun simctl` |
| Code signing | `xcrun altool` + Apple ID + ASC API key |
| Screenshots | `xcodebuild test` (UI test target) |
| Metadata push | Python + ASC REST API (PyJWT ES256) |
| Localization | Apple xcstrings |
| Pre-commit hooks | _OYL scripts 차용 X_, _독립_ scripts 작성 |

**금지**: fastlane / Bundler / Ruby gem / npm-based release tools.

### 1.4 SPM Dependencies

**v1.0 허용 후보** (10× 가치 통과한 것만):
- _없음을 시작점으로_. Apple-bundled framework 만으로 v1.0 목표.
- 필요 시 검토:
  - `swift-markdown` (Apple) — Memory note markdown
  - `swift-collections` (Apple) — OrderedDictionary
  - 그 외 _모두 reject default_.

**금지** (10년 도구 위반):
- Realm, Couchbase, Firebase
- Alamofire / Moya (URLSession 충분)
- RxSwift / Combine 외 third-party reactive
- LLM SDK (OpenAI / Anthropic / Gemini) — Promise §5 #4 위반

### 1.5 코드 자산 — _OYL 차용 X_, 독립 작성

OYL `Packages/OYLCore/` 의 design tokens / Locale helper / 검증된 lint scripts 는 _개인 경험_으로 _패턴_ 차용 가능. 단 _코드 자체 copy-paste 금지_:

| OYL 자산 | 본 프로젝트 | 처리 |
|---------|--------|----|
| Design tokens | _독립 작성_ | 새 brand identity (§3.3 참고) |
| `OYLLocalized()` 패턴 | _독립 작성_ | 새 namespace 함수 |
| `AppLocale` resolver 패턴 | _독립 작성_ | 코드 새로, 패턴만 참고 |
| 10-axis i18n lint scripts | _독립 작성_ | 새 scripts, 본 프로젝트 namespace |
| SwiftData predicate lint | _독립 작성_ | 새 script |
| Pre-commit hook installer | _독립 작성_ | 새 script |
| ASC REST API release Python | _패턴 참고만_ | 새 API key, 새 bundle ID |

→ _코드 자산_ 은 _개인 경험_ 으로 _패턴_ 만 차용. _브랜드 차용 0_.

---

## 2. Architecture

### 2.1 Layer

```
┌─────────────────────────────────────────────────────────┐
│ App (SwiftUI Views, View Models)                        │
│   - CaptureFlow / Library / ItemDetail / MemoryEditor  │
│   - Share / TimeTravel / Settings / Manifesto           │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│ Domain (Use Cases / Services — @MainActor or sendable)  │
│   - InventoryCore / MetadataResolver / ShareService     │
│   - TimeTravelService / ImportExportService             │
│   - SlowInventoryQuery (algorithm-free)                 │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│ Persistence (SwiftData @Model / CloudKit CKShare)       │
│   - Item / Manifestation / Memory / Collection / Share  │
│   - Loan / Contact / Place / Attachment                 │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│ External (Apple frameworks only in v1.0)                │
│   - AVFoundation / VisionKit / MapKit / Speech / CloudKit│
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│ Metadata APIs (HTTPS read-only, _no user identity_)     │
│   - Open Library / Google Books / MusicBrainz / TMDB    │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Module 경계 (PRD §9 매핑)

| Module | Layer | Test |
|--------|------|------|
| InventoryCore | Persistence + Domain | TDD unit (SwiftData in-memory) |
| MetadataResolver | Domain | TDD unit (URLSession mock) |
| CaptureFlow | App + Domain | XCTest UI + integration |
| IntimateShare | Domain + Persistence | Integration (2 simulator) |
| SlowInventoryQuery | Domain | TDD unit (query fixture) |
| TimeTravel | Domain | TDD unit (history fixture) |
| ImportExport | Domain | TDD unit (CSV fixture) |

### 2.3 Package 구조 (SPM)

> _OYL `own-your-collection/` 디렉토리 무관._ 독립 디렉토리.

```
<naming-final>/                  # 사용자 결정 후 확정
├─ App/
│  ├─ Sources/
│  │  ├─ Capture/
│  │  ├─ Library/
│  │  ├─ Memory/
│  │  ├─ Share/
│  │  ├─ TimeTravel/
│  │  ├─ Settings/                # Settings + Manifesto
│  │  └─ App/
│  ├─ Resources/
│  │  ├─ Localizable.xcstrings
│  │  └─ Assets.xcassets
│  └─ UITests/
├─ Packages/
│  └─ InventoryCore/              # SPM package: domain + persistence + design tokens
│     ├─ Sources/InventoryCore/
│     │  ├─ Models/
│     │  ├─ Services/
│     │  ├─ DesignTokens/         # 독립 작성
│     │  └─ Localization/
│     └─ Tests/InventoryCoreTests/
├─ scripts/                       # 독립 작성, OYL 차용 X
│  ├─ test.sh
│  ├─ build.sh
│  ├─ check-i18n.sh
│  ├─ check-promise.sh             # _Promise 5조항 강제_, OYL Forever lint 와 다름
│  ├─ check-swiftdata-predicates.sh
│  └─ install-hooks.sh
├─ docs/
│  ├─ PRD.md
│  ├─ DEVPLAN.md
│  ├─ BENCHMARK.md
│  ├─ ARCHITECTURE.md
│  ├─ MANIFESTO.md                 # 사용자 대상 Manifesto 원본
│  ├─ lessons-learned.md
│  └─ release-flow.md
├─ project.yml                     # XcodeGen
└─ README.md
```

### 2.4 Promise 5조항을 _코드로_ 강제 (lint)

| 약속 | 코드 가드 |
|------|--------|
| No algorithm | _Sort by_ enum 만 (title / date / medium / recent memory). 알고리즘 score 기반 함수 부재 lint. |
| No feed | Public API endpoint 부재. `PublicFeed` namespace 부재 lint. |
| No advertising / data sale | 3rd-party analytics / ad SDK 의존성 0. 외부 host 화이트리스트 강제 lint. |
| No AI judgment | LLM SDK 부재 (`OpenAI`/`Anthropic`/`Gemini` 키워드 import 차단 lint). _On-device CoreML for OCR / barcode only_. |
| No subscription | StoreKit IAP 부재. 단일 paid app product ID. `Sk*Subscription` / `recurring` 키워드 차단. |

→ Promise 5조항 = _코드 검증_. _주장 아닌 lint pass/fail_.

---

## 3. MVP Definition — v0.1 _최소_ 무엇이 있어야 _쓸 만한가_

### 3.1 v0.1 Scope (TestFlight 비공개 베타, _2 미디어 시작 권고_)

**포함** (다음 5개 _하나라도 빠지면_ MVP 아님):

1. **CaptureFlow**: 바코드 스캔 + 수동 입력 + 한 줄 음성/텍스트 메모 (Memory 1개 auto-create)
2. **LibraryView**: Grid / List 2 모드, 검색·필터·정렬 (모두 _명시적 enum_)
3. **ItemDetail**: 모든 필드 + Memory timeline + 사진 첨부 + 자유 메모
4. **CollectionView**: 생성/수정/삭제, 항목 add/remove/reorder, 커버 지정
5. **ImportExport**: JSON export + Goodreads CSV import

**Medium v0.1 범위**: **Book + Music** (2 typed)
- Book typed metadata: ISBN, author, year, pages, publisher
- Music typed metadata: artist, year, label, format (LP/CD/digital)
- Movie / Object 는 model stub만, _v0.5 도달_

**제외** (v0.1 엔 없어도 됨):
- CloudKit Sync (v0.5)
- 외부 metadata lookup (v0.5)
- Time Travel 회고 (v0.5)
- Loan tracking (v0.5)
- IntimateShare (v0.9)
- Multi-language (v0.5 — v0.1 은 ko/en)
- Mac 지원 (v2.0)

**Quality bar**:
- iPhone 12+ 60fps
- iOS 17+ 지원
- Apple HIG basics (Dynamic Type, VoiceOver, Dark Mode)
- Promise 5조항 lint 모두 통과
- i18n axis 통과 (ko / en)

### 3.2 v0.5 (private beta 5-10명)

추가:
- CloudKit Sync (Private DB 만; sharing 은 v0.9)
- MetadataResolver (Open Library + Google Books + MusicBrainz + TMDB)
- Movie typed (TMDB 통합)
- Object typed (사진 + 획득 metadata)
- Time Travel basic (anniversary + addedIn)
- Loan tracking (default OFF alarm)
- i18n 4 locale: ko / en / ja / zh
- Manifesto 페이지 ko 1차 작성

### 3.3 v0.9 (closed beta 30-50명)

추가:
- **IntimateShare** (CloudKit CKShare) — _핵심 차별의 마지막 조각_
- Share UI (recipient picker / scope / expiry)
- Share accept flow
- 베타 피드백 top 10 fix
- i18n 추가: fr / es / pt / de (8 locale 도달)
- Manifesto 8 locale 번역 (manifesto-grade)
- Performance pass (1000-item 60fps)

### 3.4 v1.0 (App Store paid launch)

추가:
- App icon 최종 + alternate icons
- 스크린샷 자동 캡처 (xcodebuild test + simctl), 8 locale × 8 장
- App Store metadata 8 locale (이름·서브타이틀·설명·키워드)
- Privacy policy 페이지 (정적 사이트)
- Settings → Manifesto / Forever surface 정교화
- Onboarding 3-step

### 3.5 v1.x (post-launch 안정화)

- 사용자 피드백 top 10 fix
- 위젯 (Lock Screen + Home)
- 알림 (default OFF, opt-in)
- 가격 ladder 1단계 ($14.99 → $19.99) — 사용자 검증 후
- Editorial: 첫 사용자 인터뷰 발행 (1년 시점 검토)

### 3.6 v2.0 (Mac native + Music depth)

- SwiftUI multiplatform target
- 큰 화면 view modes (Mosaic / Shelf / Editorial board)
- Drag & drop capture (URL → Item, image → Attachment)
- Apple Music library 깊은 통합 (MPMediaQuery 확장)
- Apple Watch (회고 알림 + 빠른 메모리 추가)
- 가격: $19.99 → $24.99 (또는 iOS+Mac bundle $29.99)

### 3.7 v3.0+ (장기, _필수 아닌 가능_)

- Vision Pro 검토
- Place / Experience medium full
- 그룹 컬렉션 (3+ 명) 신중 검토 (Promise 위반 가능성)
- Editorial 동영상 / podcast 검토

---

## 4. Milestones & Timeline (Solo Dev Calendar)

### 4.1 가정

- _Ownlifelab / OYL 프로젝트와 무관 추진_. OYL 운영 부담은 _별도_.
- 단 사용자 _solo dev_ 이므로 _시간 자원 공유_. 주당 _15~25시간_ 본 프로젝트 가능 (다른 일·OYL 운영 외 시간).
- OYL 코드 차용 X = 1.5~2× 가속 _없음_. _처음부터_.

### 4.2 Timeline 추정

| Phase | Calendar 기간 | Effort | 출구 조건 | Status (2026-05-21) |
|-------|------------|--------|--------|---------------------|
| **Pre-flight** | 2-3 weeks | 40~60h | naming, repo, design language proto, lint scripts | ✓ DONE (R1-R5, `d0bd2f5`) |
| **Tracer Bullet sprints 1.1-1.8** | _actual: ~5 days_ | _faster than planned_ | Book full-stack running, 84 tests PASS | ✓ DONE (R6-R10, `1ab295d`) |
| **R11 Cool Blue palette** | current | design | Claude Design deliverable | Pending (brief ready) |
| **R12+ Music / Movie / Object content rollout** | next | content | 3 remaining media types using shared code path | Not started |
| **v0.5 Private beta** | 3-4 weeks | 60~100h | CloudKit Sync, Metadata, 4 medium, 5-10명 베타 | Not started |
| **v0.9 Closed beta** | 3-4 weeks | 60~100h | IntimateShare, 8 locale, 30-50명 베타 | Not started |
| **v1.0 App Store** | 2-3 weeks | 40~60h | ASC submit, 스크린샷, 메타데이터 | Not started |
| **v1.0 post-launch wait** | 4-8 weeks | 모니터링 | 첫 1000 다운로드 + 100 user feedback | Not started |
| **v1.x Stabilize** | 2-3 months | 100~150h | top 10 fix, 위젯, 가격 transition | Not started |
| **v2.0 Mac + Music** | 2-3 months | 150~200h | Mac native + Music depth | Not started |

**Positive surprise**: Pre-flight + Tracer Bullet 1.1-1.8 completed in roughly 5 days of dev time, well ahead of the 3-week pre-flight + 5-7-week MVP estimate. The single-round-per-day cadence held. Do not extrapolate to later phases — v0.5 CloudKit sync and IntimateShare carry higher integration risk.

**총 v0.1 → v1.0 launch**: 약 **15~21 calendar weeks ≈ 4~5 months** (estimate unchanged; buffer consumed by solid tracer bullet foundation).

**총 시작 → v2.0**: 약 **10~13 months**.

### 4.3 Burnout 보호 규칙

1. **주당 본 프로젝트 상한 25h**.
2. **MVP Time-box** — v0.1 5-7 weeks 안 도달 _못하면_ scope 추가 축소 (1 medium = 책만).
3. **출시 후 2주 강제 휴식** — v1.0 launch 후 _낙담/흥분_ 2주 거리 두고 평가.
4. **6 months gate 자가 진단 의무화** — paid downloads 외 _수면 / 운동 / 인간관계_ 정량 체크.
5. **Advisory 최소 3회 보장** — v0.5 (전략), v1.0 launch 직전 (검증), 6개월 (지속 vs 보류).
6. _다른 프로젝트와 동시 출시 금지_ — OYL major release / OYB 출시 시기 회피.

---

## 5. Per-milestone 작업 분해

### 5.1 Pre-flight (week 1-3) — ✓ DONE

| Task | Effort | Dependency | Status |
|------|--------|----------|--------|
| Naming 확정 | 2h | 사용자 결정 | ✓ "Still Hours" confirmed `efff02c` |
| Apple Developer 신규 bundle ID 생성 | 1h | naming | ✓ `com.ownlifelab.stillhours` `271e356` |
| 신규 private GitHub repo 생성 | 1h | naming | ✓ `noenemyx/still-hours-swift` |
| Repo skeleton (XcodeGen + Package.swift + scripts/) | 6h | repo | ✓ R3 `8344a9c` |
| _Design language_ exploration — 색·폰트·spacing 1차 시안 | 12h | repo | ✓ R1-R2 `4ee9652` `04919f9` |
| Design tokens 1차 작성 (독립) | 6h | design | ✓ Foundation + Semantic + Component R1-R2 |
| Promise 5조항 lint 작성 | 6h | repo | ✓ 3 scripts PASS R3/R4 |
| i18n 10-axis lint 작성 (독립) | 6h | repo | ✓ `d0bd2f5` |
| SwiftData predicate lint 작성 (독립) | 3h | repo | ✓ `d0bd2f5` |
| Pre-commit hook installer 작성 | 2h | scripts | ✓ `d0bd2f5` |
| `docs/lessons-learned.md` skeleton | 1h | repo | ✓ 13 axes (A-M) through R10 |
| Manifesto 1차 (한국어 draft) | 4h | brand | ✓ Settings surface copy `d0bd2f5` |
| 첫 commit + Promise lint 첫 검증 | 2h | all | ✓ `8344a9c` |

**Exit gate**: ✓ CLEARED — `bash scripts/test.sh` 0 exit, 5 lints PASS, 84 tests PASS, BUILD SUCCEEDED.

### 5.2 v0.1 MVP — Tracer Bullet sprints 1.1-1.8 — ✓ DONE (R6-R10)

_Tracer Bullet strategy: Book medium first, full-stack, then extend to Music/Movie/Object using shared code path. This replaced the original week-by-week decomposition below._

| Sprint | Task | Commit | Status |
|--------|------|--------|--------|
| 1.1 | CaptureSheet + Manual mode + state machine | R6 `fb21a15` | ✓ DONE |
| 1.2 | BookMetadataLookup actor + 9 serialized tests | R6 `fb21a15` | ✓ DONE |
| 1.3 | BarcodeCaptureView + AVCaptureSession | R7 `8400374` | ✓ DONE |
| 1.4 | VoiceMemoCaptureView + SFSpeechRecognizer | R7 `8400374` | ✓ DONE |
| 1.5 | LibraryListView + ItemDetailView + MemoryTimelineView | R7 `8400374` | ✓ DONE |
| 1.6 | AddMemoryView + 22 i18n keys | R8 `11ab06b` | ✓ DONE |
| 1.7 | DemoSeeder + 8 curated demo items | R8 `11ab06b` | ✓ DONE |
| 1.8 | UI smoke tests + SF Symbol audit | R8 `11ab06b` | ✓ DONE |
| — | Brand tone fix + AccentColor wiring + screenshot automation | R9 `eb9ee24` | ✓ DONE |
| — | i18n locale resolution + iCloud auth gate + Onboarding 3-step | R10 `1ab295d` | ✓ DONE |

**Additional R7 work**: ContentView + Settings/Export/About scaffolding

**Exit gate (Tracer Bullet)**: ✓ CLEARED — 84 SPM tests PASS / 5 lints PASS / BUILD SUCCEEDED / Onboarding 3-step live / i18n 124+ keys × ko/en/ja

**Next sprint**: R11 Cool Blue palette (Claude Design deliverable pending) → R12+ Music/Movie/Object content rollout

---

_Original week-by-week decomposition below preserved for reference — actual execution followed Tracer Bullet path above._

**Week 4-5 — Foundation**

| Task | Effort |
|------|--------|
| SwiftData @Model 정의 (Item / Manifestation / Memory / Collection / Contact / Place / Attachment / Loan / Share) | 10h |
| InventoryCore SPM package 분리 | 2h |
| Unit test: SwiftData round-trip per model | 8h |
| InventoryService (CRUD + 명시적 query) | 8h |
| Unit test: InventoryService | 6h |

**Week 6 — CaptureFlow**

| Task | Effort |
|------|--------|
| ItemEntryView (수동) | 6h |
| 바코드 스캔 (AVFoundation) | 6h |
| 음성 메모 (Speech) | 4h |
| Memory auto-creation on Item creation | 2h |
| 3-second capture flow UX 반복 검증 | 4h |

**Week 7 — Library**

| Task | Effort |
|------|--------|
| LibraryView Grid 모드 | 6h |
| LibraryView List 모드 | 3h |
| 검색 / 필터 / 정렬 UI (_명시적 enum_) | 6h |
| ItemDetailView (모든 필드 + Memory timeline) | 10h |
| 사진 첨부 UI (PhotosUI multi-select) | 4h |

**Week 8 — Collection + ImportExport**

| Task | Effort |
|------|--------|
| CollectionListView + Detail | 6h |
| 항목 add/remove/reorder | 4h |
| 커버 이미지 지정 | 2h |
| JSON export | 4h |
| Goodreads CSV import + dedup | 6h |
| Apple Music library import (MPMediaQuery) | 6h |

**Week 9 — Polish + Manifesto**

| Task | Effort |
|------|--------|
| Onboarding 3-step | 4h |
| Settings + Manifesto 1차 surface | 6h |
| i18n ko/en (10-axis lint 통과) | 8h |
| App icon proto | 4h |

**Week 10 — Gate**

| Task | Effort |
|------|--------|
| `bash scripts/test.sh` 0 exit + 모든 lint 통과 | 6h |
| TestFlight internal upload | 4h |
| 자기·신뢰 1-2명 3일 사용 검증 | 모니터링 |

**Exit gate (v0.1)**: 5 core flow 동작, 2 medium typed, Promise 5 + i18n 10 axis 통과, TestFlight 비공개 베타 시작.

### 5.3 v0.5 (week 11-14)

| Task | Effort |
|------|--------|
| CloudKit Private DB schema | 8h |
| SwiftData ↔ CloudKit 양방향 sync | 16h |
| Conflict resolution (last-write-wins) | 6h |
| MetadataResolver module | 12h |
| Fallback chain (Open Library / Google Books / MusicBrainz / TMDB) | 10h |
| 사용자 식별 비송신 검증 (lint + integration) | 4h |
| Movie typed + TMDB | 8h |
| Object typed + 사진 / 획득 metadata | 8h |
| TimeTravel basic (anniversary + addedIn) | 8h |
| Loan tracking UI | 8h |
| i18n: ja + zh 추가 (4 locale) | 8h |
| Manifesto ko/en 정교화 | 4h |
| 베타 5-10명 모집 + 채널 셋업 | 4h |

### 5.4 v0.9 (week 15-18)

| Task | Effort |
|------|--------|
| 베타 top 10 fix | 30h |
| IntimateShare 모듈 (CKShare) | 20h |
| Share UI (recipient / scope / expiry) | 12h |
| Share accept flow | 8h |
| i18n fr/es/pt/de 추가 (8 locale) | 12h |
| Manifesto 8 locale 번역 (manifesto-grade) | 16h |
| Performance pass (1000-item 60fps) | 8h |
| 베타 30-50명 외부 모집 | 4h |
| Lessons-learned doc 1차 업데이트 | 4h |

### 5.5 v1.0 (week 19-21)

| Task | Effort |
|------|--------|
| App icon 최종 + alternate icons | 6h |
| 스크린샷 자동 캡처 (xcodebuild test + simctl) | 8h |
| 64장 자동 생성 (8 locale × 8 장) | 6h |
| App Store metadata 8 locale | 12h |
| Privacy policy 정적 사이트 | 4h |
| Settings → Manifesto surface 정교화 | 4h |
| ASC API key + Python push 스크립트 | 4h |
| Submit for Review | 4h |
| 출시 공지 준비 (Twitter / Threads / blog) | 4h |
| 모니터링 셋업 (review alert / crash alert) | 2h |

**Exit gate (v1.0)**: ASC review 통과, 24h crash rate < 0.5%.

### 5.6 v1.0 post-launch wait (week 22-29)

활동:
- 일일 ASC analytics + review 모니터링
- User reply (이메일 / Twitter)
- 데이터: paid downloads, retention, crash, refunds
- 1 week / 1 month checkpoint

**Gate at month 1**: paid downloads < 50 → 시장 신호 검토 + advisory 호출.

**Gate at month 3**: paid downloads < 300 → 큰 기능 추가 보류 + 기존 사용자 집중.

### 5.7 v1.x (month 4-6 post-launch)

- 사용자 피드백 top 10
- 위젯 (Lock Screen + Home)
- 알림 (default OFF)
- 가격 transition $14.99 → $19.99 (사용자 만족 검증 후)
- Editorial 1: 사용자 인터뷰 1건 (검토)

### 5.8 v2.0 (month 7-12 post-launch)

- SwiftUI multiplatform Mac
- 큰 화면 view modes
- Mac-only: drag & drop, Spotlight integration
- Apple Music library 깊은 통합
- Apple Watch (회고 알림)
- 가격: $19.99 → $24.99 (Mac bundle $29.99 옵션)

---

## 6. Risk Register (12개 + 완화)

### Risk 1 — 솔로 dev burnout (시간 자원 충돌)

**확률**: 높음 · **영향**: 치명적

**완화**: 주당 25h 상한 / MVP time-box / 출시 후 2주 휴식 / 6개월 자가 진단 / advisory 3회.

### Risk 2 — Day One 직접 비교 압박

**확률**: 중간 · **영향**: 큼

Day One 13년차 $10M+ ARR. _journal_ 카테고리 정점.

**완화**: 명시적 차별 메시지 — _entry-anchored vs item-anchored_. Day One 자체는 _좋은 앱_, 우리는 _다른 use case_. 직접 비교 회피, _옆 카테고리_ 포지션.

### Risk 3 — Are.na 정신적 차용 압박

**확률**: 중간 · **영향**: 중간

Are.na 정신을 차용했다고 명시 — _베끼기로 인식_ 위험.

**완화**: Are.na 영감 _공개적 명시_ (Manifesto에 출처 정직). _개인 자산 + typed metadata_ 가 _Are.na 의 빈 자리_ 라는 차별 명확.

### Risk 4 — CloudKit Sharing 복잡도 (CKShare 버그)

**확률**: 중간 · **영향**: 큼

**완화**: v0.1엔 없음. v0.5 sync만. v0.9 sharing. 단계적. WWDC video / Apple Developer Forums 사전 학습. Integration test 2 시뮬레이터. Fallback: v1.0 _Share 미완성_ 시 v1.1 이월.

### Risk 5 — Metadata API rate limit / 변경

**확률**: 중간 · **영향**: 중간

**완화**: Fallback chain 4 source. 로컬 캐싱 strict. Rate limit hit 시 사용자 명시 메시지. _수동 metadata 입력 path_ 항상 유지.

### Risk 6 — iOS 18 → 19 SwiftData migration

**확률**: 중간 · **영향**: 큼

**완화**: v0.1부터 명시적 schema version. `VersionedSchema` + `SchemaMigrationPlan`. iOS major 출시 _전_ 2개월 베타.

### Risk 7 — App Store rejection (privacy / sharing / IAP)

**확률**: 낮음~중간 · **영향**: 큼

**완화**: Privacy nutrition label _수집 0_ 명시. CKShare Apple-native. IAP 부재. v1.0 submission 전 ASC reviewer 가이드 문서화.

### Risk 8 — 시장 신호 부재 (paid < 100 in 6 months)

**확률**: 중간 · **영향**: 전략적

**완화**: 6 months gate. 신호 부재 시 _기능 추가 중단_, _기존 사용자 집중_, _가격 인하 1단계 검토_.

### Risk 9 — Promise 5조항 압박 ("구독 추가" / "AI 추가" / "feed 만들자")

**확률**: 높음 · **영향**: 브랜드 치명적

**완화**: Promise 5조항 _코드 lint_ 강제. Advisory 호출 시 "Promise 는 하드 제약" 명시. 본인 약해질 때 _Manifesto 다시 읽기_.

### Risk 10 — Editorial 방치 (Manifesto / 인터뷰)

**확률**: 높음 · **영향**: 브랜드 중간

**완화**: Manifesto는 _v1.0 launch에 이미 작성됨_. 인터뷰는 _1년에 1회_만. 솔로 dev 부담 적정화.

### Risk 11 — i18n leak

**확률**: 중간 · **영향**: 작음~중간

**완화**: 10-axis i18n lint 독립 작성, pre-commit + Xcode build phase 둘 다. 새 string 추가 시 _최소 ko + en_ 강제.

### Risk 12 — Naming · Brand identity confusion (zero-base 단점)

**확률**: 중간 · **영향**: 중간

새 brand 0년차 — 인지 기반 0.

**완화**: Naming 결정에 _2주_ 시간. Founder voice _Twitter / blog_ 1-2회/월 publish. Manifesto 4 locale _v1.0 launch 즉시_ surface. 자발적 외부 추천 신호 추적.

---

## 7. Release Strategy

### 7.1 Channel

| 단계 | Channel | 노출 |
|------|--------|----|
| v0.1 MVP | TestFlight Internal (본인 + 1-2명) | _없음_ |
| v0.5 Private beta | TestFlight External (5-10명) | _없음_ |
| v0.9 Closed beta | TestFlight External (30-50명) | _없음_ |
| v1.0 launch | App Store Public | Twitter / Threads / blog / Hacker News Show HN |
| v1.1+ | App Store + Indie Spotlight 신청 | Apple ASO + Indie 매체 |

### 7.2 Launch 공지 (v1.0)

**8 locale 동시 launch.**

공지 surfaces (sober 톤):
- Twitter / Threads — _3 post_ (출시 / Manifesto / Hero Moment 1개)
- Blog / Substack newsletter — _1 post_ (founder voice)
- App Store 자체 노출
- (선택) Hacker News Show HN — _1 post_, _Manifesto 핵심_ 강조

피해야 할 것:
- "Revolutionary" 등 marketing 어휘
- 느낌표
- 시적 과장

### 7.3 Pricing Transition

| 시점 | 가격 | 트리거 |
|------|-----|------|
| Launch (v1.0) | $14.99 | _즉시 paid_, free tier 없음 |
| Launch + 6 months | $19.99 | NPS 50+ / refund < 2% / paid 500+ 충족 시 _자동 transition_ |
| v2.0 (Mac native) | $24.99 | premium positioning |
| Mac bundle (v2.0 시점) | iOS + Mac bundle $29.99 | App Store Connect bundle 옵션 |

_v1 구매자 영구 무료 업그레이드_. _가격 인상 사전 공지 없음_.

---

## 8. Editorial Surface Plan

브랜드 = _목소리_. 솔로 dev 부담 적정화 _저빈도 high-impact_.

### 8.1 v1.0 시점 (launch 즉시)

- **Manifesto 페이지** — Settings → Manifesto + 정적 사이트. 5조항 + Subtraction + Data Sovereignty 전문. 8 locale.
- **About 페이지** — _왜 만들었나_ 한 문단. 8 locale.
- **Privacy 페이지** — nutrition label 평문 설명.
- **Founder blog 첫 글** — _왜 paid one-time / no AI / no algorithm_.

### 8.2 v1.x 시점 (출시 6-12개월)

- **첫 사용자 인터뷰** — 1명, 신뢰 사용자. _사용자 컬렉션이 무엇인가_ 토픽. 1회.

### 8.3 v1.x 시점 (출시 1년)

- **1주년 Letter** — 1년 회고 + 다음 1년 방향. 8 locale, manifesto-grade 톤.

### 8.4 v2.0 시점

- **Mac + Music depth 출시 공지**.
- **두 번째 사용자 인터뷰**.

---

## 9. Tech Debt Limits

### 9.1 절대 안 하는 것

- `// TODO: refactor later` 코멘트 남기지 않음.
- 임시 데이터 모델 (큰 schema 변경은 _migration plan 있을 때만_).
- 의존성 업그레이드 보류 — Apple SDK 는 _주요 출시 후 2달 안_ migrate.

### 9.2 허용되는 debt

- TestFlight 내부 빌드 1주 안 fix 가능 bug → 다음 빌드까지 보류.
- 8 locale 중 _하나_ 미세 번역 어색함 → v1.x fix.
- Apple Watch / 위젯 부재 (v1.x 이월).

### 9.3 매월 dependency / debt 점검

매월 첫째 주 toolchain / Xcode / Swift / iOS minimum 점검. Pre-commit hook 통과율 점검. Lessons-learned doc 1회 review.

---

## 10. Success Metrics & Quit Criteria

### 10.1 6개월 시점

**Healthy**:
- Paid downloads: 300+ (글로벌)
- Rating: 4.5+
- Refund rate: < 2%
- Top crashes < 3
- 자발적 외부 추천 10+ 사례

**Yellow**:
- Paid downloads: 100-300 → 마케팅 surface 검토
- Rating: 4.0-4.5 → 사용자 피드백 top 10 fix

**Quit**:
- Paid downloads: < 100 _and_ rating < 4.0 → 시장 가설 재검토 advisory 호출

### 10.2 1년 시점

**Healthy**:
- Paid downloads: 2,000+
- 30-day retention: 40%+
- 1주년 Letter v1 출간
- v1.x 안정화 + v2.0 시작 가능

**Quit**:
- 30-day retention: < 25% → 차별 부족 인정, 자원 회수 검토

### 10.3 3년 시점 (10년 도구 mid-checkpoint)

**Healthy**:
- Paid downloads: 10,000~30,000
- Promise 5조항 _모두 유지_
- v2.0 Mac native 출시 완료
- Apple Design Award nomination 1회 이상 (선호)
- 자발적 외부 추천 100+ 사례

**평가 시점**: 3년 retro. _계속 / 일몰 / 정체성 재정의_ 결정.

### 10.4 시장별 분리 평가

| 6개월 시점 | Healthy | Yellow | Quit |
|---------|---------|--------|------|
| **글로벌 paid** | 300+ | 100-300 | <100 |
| **한국 paid** | 100+ | 30-100 | <30 |
| **일본 paid** | 50+ | 10-50 | <10 |
| **App Store rating** | 4.5+ | 4.0-4.5 | <4.0 |

**Quit trigger**: 위 4 시장 _모두 Quit 조건_ 동시 충족 → 시장 가설 재검토.

---

## 11. 시작 직전 사용자 확인 사항 (10개 gate)

다음 _전부_ 결정되어야 Pre-flight 시작:

1. ✓/✗ **Naming 확정** (PRD §12 후보 또는 사용자 신규)
2. ✓/✗ **Promise 5조항 + Subtraction Clause + Data Sovereignty Clause _재확인_**
3. ✓/✗ **v1.0 medium 범위** — MVP 2 medium (책·음악) → v0.5 4 medium (영화·물리 추가) OK?
4. ✓/✗ **Launch 가격** — $14.99 (권고) vs $9.99 vs $19.99 ?
5. ✓/✗ **v1.0 Editorial Manifesto 즉시 surface** OK?
6. ✓/✗ **다른 프로젝트 (OYL major release 등) 와 동시 출시 회피 동의**
7. ✓/✗ **Pre-flight 시작 calendar week** 확정
8. ✓/✗ **Standard 4-panel advisory 사전 검토 수행** (Branding / Marketing / Strategy / UX)
9. ✓/✗ **본인 _Are.na / Day One / Listy / Letterboxd_ 1-2주 실사용 수행** (felt-sense 수집)
10. ✓/✗ **Apple Developer 신규 bundle ID 준비**

→ 10개 모두 ✓ 이후 `bash scripts/setup-new-repo.sh <naming>` 실행.

---

## 12. 한 줄 요약

> **4-5개월** 만에 v1.0 launch. **10-13개월** 만에 Mac. 6개월 paid < 100 & rating < 4.0 동시 → quit criteria. **Promise 5조항은 코드 lint로 강제**. 솔로 dev 25h/week 상한 + 다른 프로젝트와 동시 출시 회피. _Day One 의 entry-anchored 가 아닌 item-anchored, Are.na 의 자유 block 이 아닌 typed Item + Memory_ 가 정체성 핵심.

---

## 13. v1.5 Adjustments — User Decisions 2026-05-20 (Supersedes v1.0)

본 섹션은 _supersedes v1.0_. 사용자 4결정 + scope 확대 반영. 위 §0~§12 v1.0 baseline 보존.

### 13.1 사용자 결정 (PRD §16.1 참조)

1. **Naming = Still Hours** — repo 이름 `still-hours-swift` 권고
2. **$14.99 paid one-time** 확정
3. **4 medium MVP** (책+음악+영화+물리) — v1.0 baseline DevPlan §3.1 의 _2 medium MVP_ 권고 _기각_
4. **Promise 5조항 모두 허용** (lint 강제 _제거_)
5. **Manifesto 안 만듬** — _제품으로 증명_

### 13.2 §1.4 SPM Dependencies 정책 변경

| 항목 | v1.0 baseline | v1.5 confirmed |
|----|----------|-----------|
| LLM SDK (OpenAI / Anthropic / Gemini) | _금지_ | _v1.0 default 없음, v1.x+ 도입 시 사용자 명시 disclosure_ |
| 외부 analytics SDK | _금지_ | _v1.0 default 없음, v1.x+ opt-in 검토_ |
| Subscription IAP | _금지_ | _v1.0 없음, v1.x+ Pro tier 검토_ |

→ _금지 절대_ 가 아닌 _v1.0 default + evolution path_ 로 _완화_. 단 _개인정보 / 데이터 주권_ 관련 dependency 는 _영구 금지_.

### 13.3 §2.4 Promise lint 정책 변경

기존 6개 _Promise lint_ → 2개 _Privacy lint_ 만 유지:

| lint | v1.0 baseline | v1.5 |
|----|----------|------|
| External host whitelist (사용자 식별 비송신) | 강제 | **강제 유지** |
| Data export path 항상 가능 | 강제 | **강제 유지** |
| StoreKit Subscription 키워드 | 강제 차단 | _제거_ (v1.0 default _없음_ 유지하나 lint X) |
| `PublicFeed` namespace | 강제 부재 | _제거_ |
| Algorithm score 함수 | 강제 부재 | _제거_ |
| LLM SDK 키워드 | 강제 차단 | _제거_ |

→ _Privacy + Data Sovereignty_ 만 _lint_ 강제. 다른 _Promise_ 는 _코드 review + 사용자 의지_ 로 유지.

### 13.4 §3 MVP scope 확대 — 4 medium MVP

| 단계 | v1.0 baseline | v1.5 confirmed |
|----|----------|-----------|
| v0.1 MVP medium | 2 typed (책+음악) | **4 typed (책+음악+영화+물리)** |
| v0.1 effort | 100-140h | **150-200h** (+40%) |
| v0.1 calendar | 5-7 weeks | **6-9 weeks** |
| v0.5 medium 추가 | 영화+물리 추가 | _이미 v0.1 포함_, v0.5 = CloudKit Sync + Metadata만 |
| 총 v0.1 → v1.0 launch | 15-21 weeks | **18-26 weeks ≈ 4.5-6.5 months** |

### 13.5 §4.3 Burnout 보호 _강화 필수_

scope 확대 + Promise lint 완화 + Manifesto 제거 = _저절제 약화_ 측면이 있음. _Burnout 보호 강화_ 필수:

| 규칙 | v1.0 baseline | v1.5 강화 |
|----|----------|-------|
| 주당 상한 | 25h | **22h** (-3h) |
| MVP time-box | v0.1 5-7w 안 도달 못하면 scope 축소 | **v0.1 6w 안 도달 못하면 _즉시_ scope 축소 → 3 medium 으로** |
| 출시 후 휴식 | 2주 | 2주 _+ 강제 OYL/OYB 작업만 1주_ |
| 자가 진단 | 6개월 시점 1회 | **3개월 + 6개월** 2회 |
| Advisory | 최소 3회 | **최소 4회** (PRD 검토 / v0.5 전략 / v1.0 launch 직전 / 6개월 시점) |
| 다른 프로젝트 동시 출시 회피 | 동의 | **강제 — OYL major release 시 즉시 보류** |

### 13.6 §6 Risk Register 추가/제거

**제거** (Promise 완화로 risk 약화):
- ~~Risk 9 Promise 5조항 압박~~ → _없음_, Promise _옵션_으로 evolution path 열림
- ~~Risk 10 Editorial Manifesto 방치~~ → _Manifesto 안 만듦_, risk 부재

**추가** (4 medium MVP + scope 확대 + Manifesto 부재로 새 risk):

#### Risk 13 — 4 medium MVP scope creep

**확률**: 높음 · **영향**: 큼

v0.1 = 4 typed metadata × 외부 API integration × UI 4종 = _scope 1.5×_. _완벽 추구_ 시 v0.1 도달 _8-10 weeks_ 까지 늘어남.

**완화**:
- MVP time-box 강화 (§13.5)
- v0.1 medium 별 _quality bar_ 명시 — 책·음악 은 _full typed metadata_, 영화·물리 는 _기본 typed_ 만 (v0.5 정교화)
- Movie typed = TMDB 통합만, Object typed = 사진 + acquired metadata 만
- 각 주 끝 _scope 점검 ritual_

#### Risk 14 — Brand identity confusion (Manifesto 없음)

**확률**: 중간 · **영향**: 중간

Manifesto 페이지 부재 = _제품 사용 전_ 사용자 _이유_ 파악 어려움. App Store description / Twitter / blog 만으로 _차별 메시지_ 전달.

**완화**:
- _App Store subtitle 4 locale_ 시안 (PRD §16.6) 정교 작성 + 8 locale 확장 v0.9 단계
- _Founder Twitter / blog_ founder voice publish (월 1-2회) — PRD §15 명시
- 인터뷰 1건 (1년 시점) — Editorial 활동 유지
- _제품 onboarding 3-step_ 에 _차별 동작 강조_ (Item-as-memory-anchor 시각화)

#### Risk 15 — Promise lint 부재로 _느린 brand drift_

**확률**: 중간 · **영향**: 큼 (5+ 년 시점)

코드 lint 강제 _없음_ = 1-2년 후 _작은 결정_ 으로 _AI 추가_, _구독 추가_, _feed 추가_ 가능성. _장기 brand identity_ 보호 약화.

**완화**:
- _3개월 자가 진단_에 _"오늘 결정한 것 중 Promise 약화한 것 있나?"_ 항목 포함
- _Advisory 4회 보장_ 의 _v0.5 + 6개월 + 1년_ 시점 모두 _Promise drift_ 점검
- _v1.x+ Pro tier 도입 시_ 자문 + 1주일 숙고 + 사용자 자필 결정

### 13.7 §11 시작 직전 gate 10 → 6 항목

| # | gate | v1.5 상태 |
|---|----|-------|
| 1 | Naming | ✓ **Still Hours** |
| 2 | Promise 재확인 | ✓ **모두 허용 (옵션)** |
| 3 | v1.0 medium | ✓ **4 medium MVP** |
| 4 | Launch 가격 | ✓ **$14.99** |
| 5 | Editorial Manifesto | ✓ **만들지 않음** |
| 6 | 동시 출시 회피 | _묵시적 ✓_ (다른 프로젝트 무관 명시) |
| 7 | Pre-flight 시작 timing | ✓ **즉시 (이번 주 / 다음 주)** |
| 8 | Advisory 호출 | ✓ **6-panel 즉시 + 필요 시** |
| 9 | Are.na / Day One / Listy 실사용 | _Pre-flight Week 2-3_ 자연스럽게 포함 |
| 10 | Apple Developer bundle ID | _Pre-flight Week 1_ task |

→ _모두 결정됨_. _Advisory 결과_ + _Apple Developer bundle ID 확인_ 후 _Pre-flight 시작 가능_.

### 13.8 한 줄 요약 (v1.5)

> **4.5-6.5개월** v1.0 launch (4 medium MVP). **Still Hours 이름**. **$14.99 paid one-time**. **Promise 옵션 / Manifesto 없음** — _제품 동작으로 증명_. _Item-as-memory-anchor + 다중 미디어 typed + 1-to-1 공유 + Apple-native_ 4축 정체성. 6-panel advisory _즉시_ 호출 후 Pre-flight 이번 주 / 다음 주.

---

_End of Development Plan v1.5._

---

## 14. v1.7 Adjustments — Apple-native 최신 디자인 원칙 적용 (2026-05-20)

본 섹션은 _supersedes v1.5_. 사용자 지시 _애플 전용 + 현재 제일 최신_ 적용. PRD §17 과 함께 읽을 것.

### 14.1 Tech Stack v1.7 (DEVPLAN §1.1 supersede)

| 항목 | v1.5 | **v1.7** |
|----|------|------|
| iOS deployment target | iOS 17.5+ | **iOS 26 only (사용자 결정 권고)** |
| iPadOS deployment | iPadOS 17.5+ (v1.1 검토) | **iPadOS 26 (v1.0 default 검토)** |
| macOS (v2.0) | macOS 14+ | **macOS Tahoe 26+** |
| Xcode | Xcode 17+ | **Xcode 26+** (recompile 만으로 Liquid Glass 자동) |
| SwiftUI | SwiftUI iOS 17 | **SwiftUI 26 + new APIs** |
| SwiftData | SwiftData iOS 17 | **SwiftData iOS 26 (안정성 +18 개월)** |
| CloudKit Sharing | iOS 17 | **iOS 26 (CKShare 안정성 향상)** |
| SF Symbols | 5+ | **SF Symbols 7** (6,900+ symbols) |
| Design Resources | 독립 작성 | **Apple Design Resources iOS 26 Figma/Sketch baseline + Still Hours 독립 tokens** |

### 14.2 SwiftUI 26 신규 API 활용 (Engineer R6 / Performance 해결)

| API | 활용 module | 효과 |
|----|----|----|
| `@IncrementalState` | LibraryCore / SlowInventoryQuery | 1000+ items 의 fine-grained state — Engineer R6 _1000-item 60fps_ 의 _native 해결_ |
| `ToolbarSpacer` | CaptureFlow / Library / ItemDetail | Apple HIG 정합 toolbar 그룹화 |
| Native `WebView` | (v2.0+ 검토) Memory note markdown preview | _swift-markdown SPM dependency 불필요_ 가능 |
| 향상된 `TextEditor` | MemoryEditor | Memory note markdown 입력 native |
| `Chart3D` | (검토 v1.x) TimeTravel 3D 시각화 | _데이터 시각화 차별_ 가능 |

→ SwiftUI 26 features _v1.0 부터_ 활용. _3rd-party SPM dependency 0 시작점_ 정책 _강화 가능_.

### 14.3 Liquid Glass 자동 적용 + App icon Layered

- **Xcode 26 recompile 만으로 _기본 Liquid Glass 자동 적용_** — 별도 코드 없음
- **App icon Layered Glass** — Apple Design Resources Figma 의 _Layered icon_ 템플릿 활용. PRD §17.4 의 cabinet metaphor + Liquid Glass 합성.

### 14.4 Pre-flight Week 1 추가 task (v1.5 §5.1 update)

| Task | Effort | Note |
|----|----|----|
| Apple Design Resources iOS 26 Figma 다운로드 + 학습 | 4h | _독립 design tokens 의 baseline_ 으로 활용 |
| SF Symbols 7 macOS 앱 install + 핵심 Memory kind / medium symbol selection | 3h | UI R2 권고 (icon + accent line) 의 _구체_ |
| Liquid Glass Material reference 학습 (WWDC 2025 "Meet Liquid Glass" + "Hello, Liquid Glass") | 4h | _Apple 표준 적용_ 학습 |
| Xcode 26 + iOS 26 simulator + 실 device test 환경 | 2h | _최신 toolchain 검증_ |
| iOS 26 vs iOS 18/26 dual support 결정 (사용자 결정) | _decision_ | §17.8 권고 = _iOS 26 only_ |

→ Pre-flight 12h → **24h** 권고 (Advisory §5 A5 합의). 위 13h + design language exploration 12h - 1h 중복 = 24h.

### 14.5 SwiftData / CloudKit Sharing iOS 26 안정성

Engineer Risk A (CKShare participant first-access edge) 와 Risk B (SwiftData migration data loss) 는 **iOS 26 deployment target 채택 시 _완화_** :

- iOS 26 CloudKit Sharing 의 _participant ENOENT_ 알려진 버그 일부 해소
- SwiftData iOS 26 의 `Schema(versionedSchema:)` 안정성 향상 (2024-2025 issue 다수 해소)
- _v1.0 launch 시점 iOS 26 출시 8-12개월차_ = production-ready 검증된 시점

→ Engineer Risk A composite 32/125 → **추정 24/125 감소**, Risk B 30/125 → **추정 20/125 감소**.

### 14.6 Apple Intelligence / Visual Intelligence 정책

iOS 26 _Visual Intelligence_ baked-in. Still Hours 정책:

- **v1.0 활용 안 함** — Promise §5.4 (No AI judgment) default 절제
- **v1.x+ 검토**: _Visual Intelligence 결과_ → Still Hours Item _후보 import path_ 옵션. 사용자 명시 trigger only (자동 호출 X)
- Apple Intelligence 다른 features (Genmoji / Image Playground / Writing Tools) _v1.0 활용 안 함_

### 14.7 SwiftPM Dependencies _최신 정책 update_

| dependency | v1.5 | v1.7 |
|----|----|----|
| swift-markdown (Apple) | 검토 후보 | **불필요 가능** (SwiftUI 26 향상된 TextEditor markdown native) |
| swift-collections (Apple) | 검토 후보 | _필요 시만_ |
| 외부 모든 3rd-party | reject default | **reject default + iOS 26 SwiftUI native API 우선** |

→ SwiftUI 26 native API 가 v1.5 의 일부 SPM 후보 _대체_. 의존성 0 시작점 _강화_.

### 14.8 Quality Bar 업데이트

| Quality 항목 | v1.5 | v1.7 |
|----|------|------|
| Performance | iPhone 12+ 60fps | **iPhone 12+ 120fps (ProMotion) + iPhone SE 60fps** (`@IncrementalState` 활용) |
| Liquid Glass | 명시 안 됨 | **Xcode 26 recompile 자동 + custom Liquid Glass material 활용 검토** |
| Dynamic Type | Apple HIG basics | **iOS 26 Dynamic Type 최신 (Apple SD Gothic Neo 8 locale 충실)** |
| Dark mode | Apple HIG basics | **Liquid Glass dark variant** |
| Accessibility | Apple HIG basics | **VoiceOver Memory timeline 명시 라벨 + Reduced Motion fallback** |
| SF Symbols | 명시 안 됨 | **SF Symbols 7 baseline, custom icon 0 시작** |

### 14.9 한 줄 종합 (v1.7)

> **iOS 26 only** deployment target (사용자 권고). **Liquid Glass 자동** + **SwiftUI 26 신규 API** 적극 활용. App icon **Layered Glass cabinet metaphor**. SF Symbols 7. Apple Design Resources 26 Figma baseline + Still Hours 독립 tokens. Engineer Risk A/B 일부 _자동 완화_. Pre-flight **24h** (Apple 최신 리소스 학습 13h + design language exploration 11h).

---

_End of Development Plan v1.7._

---

## 15. v2.0 Final — Implementation Roadmap (2026-05-20)

본 섹션은 _supersedes v1.7_. PRD v2.0 §18 (32 결정) 의 _구현 측면 반영_.

### 15.1 v2.0 Tech Stack Final

| 항목 | v2.0 |
|----|-----|
| Language | Swift 6 strict concurrency |
| UI | SwiftUI 26 (iOS 26 + iPadOS 26 + macOS Tahoe 26 v2.0) |
| Persistence | SwiftData (iOS 26) + `VersionedSchema` + `SchemaMigrationPlan` (T3.2) |
| Sync | CloudKit Private DB + CKShare (v0.9) |
| Design Resources | Apple Design Resources iOS 26 Figma + Still Hours 독립 tokens |
| Symbols | SF Symbols 7 (T2.5 Memory kind + medium icons) |
| Color tokens | Still Hours 6색 light + 4색 dark (T2.2) |
| Typography | System-only (SF Pro + New York, T2.1) |
| App icon | Layered Liquid Glass cabinet (T2.6) |
| Build | Xcode 26 (Liquid Glass auto) + xcodebuild + xcrun + Python ASC REST API |
| Dependencies | 0 시작 (SwiftUI 26 native APIs 우선 활용) |

### 15.2 Pre-flight Week 1-3 (36h) — 7 deliverable

T1.5 가장 정공법 36h 확장. _3 weeks calendar_ 추정 (22h/week 상한 안).

| Deliverable | Effort | Notes |
|----|----|----|
| Trademark 사전 조사 (KIPRIS + USPTO Class 9 + EUIPO + App Store 전수, T1.6) | 4h | _충돌 시 대안 naming 즉시 재결정 gate_ |
| Apple Design Resources iOS 26 Figma 다운로드 + 학습 | 4h | Foundation token baseline |
| SF Symbols 7 macOS 앱 install + Memory kind 7 + medium 4 symbol selection (T2.5) | 3h | UI 권고 SF Symbol list 검증 |
| Liquid Glass material reference 학습 (WWDC 2025 "Meet/Hello Liquid Glass") | 4h | Apple 표준 적용 학습 |
| Xcode 26 + iOS 26 simulator + 실 device 환경 셋업 | 2h | 최신 toolchain |
| **Foundation tokens 1차 작성** (Color 6+4 / Type / Space 4-32 grid / Radius 8/12/16/24) | 6h | T2.2 결정 직접 코드화 |
| **Semantic tokens 1차** (colorSurfacePrimary / colorAccentBook/Music/Movie/Object / textPrimary/Secondary/Tertiary) | 4h | Design R1 |
| **Component tokens 1차** (Card 3:4 portrait fixed / MemoryRow / MediumBadge / PrimaryButton) | 4h | T2.4 결정 직접 코드화 |
| **App icon 1차 시안 작성** (Wunderkammer cabinet + Liquid Glass layered) | 6h | T2.6 결정 - 사용자 검토 - 확정 |
| **Memory timeline visual signature design pass** (T3.5) | 8h | 별도 design pass, ItemDetailView _독립_ |
| Naming + Apple Developer 신규 bundle ID + 신규 repo + scaffold | 3h | T1.6 trademark 통과 후 |
| `docs/MANIFESTO.md` 작성 안 함 (Manifesto 없음 결정) | 0h | 대신 Settings "Still Hours is" surface 카피 작성 |
| _Settings "Still Hours is" surface 카피 1차_ (T4.4) | 2h | 3 섹션 카피 ko/en draft |

**Total 50h** — 명목 36h 초과. _22h/week × 2.5w = 55h_ 안. _Pre-flight 3 weeks_ 가능.

### 15.3 v0.1 Tracer Bullet (Book full, 4-5w)

T1.1 결정. _Book full typed_ 만 v0.1.

| Week | Tasks | Effort |
|----|----|----|
| Week 4 (Foundation) | SwiftData @Model 4 entity (Item + Memory + Collection + Attachment, T3.1) + `SchemaV1` namespace + `SchemaMigrationPlan` skeleton (T3.2) + InventoryCore SPM package | 22h |
| Week 5 (CaptureFlow Book) | Book typed metadata UI + ISBN 바코드 (AVFoundation) + 위치 자동 (CoreLocation) + 음성 메모 (Speech) + Memory auto-create + _권한 요청 onboarding 분리_ (UX R1) | 22h |
| Week 6 (Library Book) | LibraryView Grid (3:4 portrait fixed, T2.4) + ItemDetailView (위 1/3 자산 + 아래 2/3 Memory timeline, T3.5 적용) + 검색·필터·정렬 (명시적 enum, SlowInventoryQuery) | 22h |
| Week 7 (Collection + Onboarding + Empty) | CollectionView + JSON export + Onboarding 3-step (T4.2) + Empty Library state (T4.3) + i18n ko/en | 22h |
| Week 8 (Polish + Gate) | Apple HIG accessibility (VoiceOver Memory timeline 명시 라벨, T2.5) + Settings → "Still Hours is" surface 1차 (T4.4) + TestFlight internal | 16h |

**Total ~104h, 4-5w calendar.** v0.1 Exit gate: Book full typed 동작, 모든 lint 통과 (Privacy + Data Sovereignty + **No subscription IAP**), TestFlight 비공개.

### 15.4 v0.1.5 Music full (2-3w)

T1.1 Tracer Bullet. v0.1 안정 후 Music full 점진 추가.

| Task | Effort |
|----|----|
| Music typed metadata (artist/year/label/format) | 8h |
| MusicBrainz API 통합 + Apple Music search 보조 | 12h |
| MPMediaQuery Apple Music library import | 10h |
| Manifestation 모델 도입 (Music = LP+Spotify+CD 묶음 검증) | 8h |
| Music UI Item card / detail | 6h |

**Total ~44h, 2-3w calendar.**

### 15.5 v0.5 CloudKit Sync + Movie basic (5-6w)

| Task | Effort |
|----|----|
| CloudKit Private DB schema 매핑 | 8h |
| SwiftData ↔ CloudKit 양방향 sync | 18h |
| Conflict resolution (last-write-wins) | 6h |
| Movie typed (TMDB API only, T3.4) | 12h |
| Contact / Place entity 도입 (Memory 연동) | 10h |
| Loan tracking UI (대출·선물 흐름) | 8h |
| i18n: 시점에 따라 _Wave 1_ ko/en/ja 만 진행 (T1.3 3-stage soft launch) | 8h |
| Schema migration 1회 시뮬레이션 검증 (T3.2) | 4h |

**Total ~74h, 5-6w calendar.**

### 15.6 v0.9 IntimateShare + Object basic (5-6w)

| Task | Effort |
|----|----|
| **별도 iCloud account 확보 + 2-device test 환경** (T4.1) | 4h |
| IntimateShare 모듈 (CKShare) | 22h |
| Retry-on-ENOENT 3x backoff (Engineer R3) | 4h |
| Share UI (recipient picker / scope 사용자 언어 / expiry, UX R4) | 12h |
| Share accept flow (Apple ecosystem only 명시, T5.6) | 8h |
| Object typed (수동 입력 + 사진, T3.4) | 10h |
| 베타 top 10 fix (5-10명 베타 모집 - personal network + Threads + Substack, T5.7) | 30h |
| Performance pass (1000-item 60fps + `@IncrementalState`) | 12h |

**Total ~102h, 5-6w calendar.**

### 15.7 v1.0 App Store launch Wave 1 (3-4w)

T1.3 3-stage soft launch. **Wave 1 = ko/en/ja 만**.

| Task | Effort |
|----|----|
| App icon 최종 (Wunderkammer + Liquid Glass, T2.6) + alternate icons | 8h |
| 스크린샷 자동 캡처 (xcodebuild test + simctl) | 8h |
| 24장 자동 생성 (3 locale × 8 장) — Wave 1 만 | 4h |
| App Store metadata 3 locale ko/en/ja (subtitle + description 동작 묘사 톤, T5.1) | 12h |
| Privacy policy 정적 사이트 | 4h |
| Settings → "Still Hours is" surface 정교화 (T4.4) | 6h |
| ASC API key + Python push 스크립트 | 4h |
| Submit for Review | 4h |
| Wave 1 launch 공지 (Twitter / Threads / blog / Hacker News Show HN) | 6h |
| Apple editorial outreach (T5.8) — "App of the Day" / "Indie Spotlight" / 한국 + 일본 App Store team | 6h |
| 모니터링 셋업 (review alert / crash alert) | 2h |

**Total ~64h, 3-4w calendar.**

### 15.8 v1.0 Wave 2-3 (post-launch 6-12 months)

| Wave | locale | 시점 | 조건 |
|------|------|----|----|
| Wave 1 | ko + en + ja | v1.0 launch | _기본_ |
| Wave 2 | zh + de | Wave 1 + 4-6w monitoring 후 | Wave 1 rating 4.5+ / refund < 2% |
| Wave 3 | fr + es + pt | Wave 2 + 4-6w monitoring 후 | Wave 2 ASO 검증 + 번역 quality 충분 |

각 wave 사이 _번역 quality 문화적 재작성_ + screenshot 추가 + ASC metadata.

### 15.9 v1.x Stabilize (post-launch month 4-6)

- 사용자 피드백 top 10 fix
- 위젯 (Lock Screen + Home)
- 알림 (default OFF, opt-in)
- 가격 transition $14.99 → $19.99 (NPS 50+ + paid 500+ 검증 후)
- **monthly advisory** ritual 시작 (T1.2 / T5.3 정합)

### 15.10 v2.0 Mac Native (post-launch month 7-12)

- macOS Tahoe 26 native (SwiftUI multiplatform, T1.7 정합)
- 큰 화면 view modes (Mosaic / Shelf)
- Mac-only: drag & drop / Spotlight integration
- Apple Music library 깊은 통합
- Apple Watch (회고 알림 + 빠른 메모리 추가)
- 가격: $19.99 → $24.99 (또는 iOS+Mac bundle $29.99)

### 15.11 Total timeline (v2.0 final)

| Phase | Calendar | Effort |
|----|----|----|
| Pre-flight | 3w | 50h |
| v0.1 Book full | 4-5w | 104h |
| v0.1.5 Music full | 2-3w | 44h |
| v0.5 CloudKit + Movie | 5-6w | 74h |
| v0.9 IntimateShare + Object | 5-6w | 102h |
| v1.0 ASC launch Wave 1 | 3-4w | 64h |
| **Total v0.1 → v1.0 launch** | **22-27w ≈ 5-6 months** | **~438h** |
| v1.0 → v2.0 Mac (post-launch) | 7-12 months | 200-300h |

22h/week × 27w = 594h _가능 시간_, 438h _필요 시간_ → 156h _버퍼_. 안전.

### 15.12 v2.0 Risk Register Final (15개)

기존 13 + 2 추가:

| # | Risk | 완화 |
|---|------|----|
| R1-13 | (v1.5 기존) | (기존 완화 + v1.7/v2.0 update 적용) |
| R14 | **iPad Universal app 의 UI 분기 복잡도** (T1.7 추가 결정) | iPadOS 26 Sidebar / Split View / Touch optimized — Apple HIG Universal app 패턴 충실. SwiftUI _자동 분기_ 활용 |
| R15 | **iOS 26 only deployment** 의 사용자 진입 ceiling | 2027 Q1 launch 시점 iOS 26 채택률 75-85% 추정. Wave 1 일본 시장이 _가장 높은 채택률_ (Apple ecosystem 충성도). 진입 ceiling은 _진지한 premium niche_와 정합 |

### 15.13 Burnout 보호 v2.0 강화

T1.5 36h Pre-flight + T1.7 Universal app + T1.8 iOS 26 only + T1.1 Tracer Bullet + T1.2 monthly advisory 의 _복합 효과_:

| 보호 | v1.7 baseline | **v2.0 강화** |
|----|------|------|
| 주당 상한 | 22h | **22h 엄격 (monthly advisory ritual 도입)** |
| MVP time-box | v0.1 6w | **v0.1 Book full 5w** (Tracer Bullet 덕분에 ambiguity 감소) |
| 출시 후 휴식 | 2w + OYL/OYB | **2w + 다른 일** (사용자 결정 시점에 결정) |
| 자가 진단 | 6개월 시점 | **3개월 + 6개월 + monthly advisory** |
| Advisory | 최소 4회 | **monthly advisory ritual 영구** (T1.2 정합) |
| 동시 출시 회피 | 동의 | **강제** |

### 15.14 한 줄 종합 (v2.0 final implementation)

> **Still Hours v1.0 launch 5-6 months** (Pre-flight 3w + v0.1-0.9 Tracer Bullet 16-20w + ASC submit 3-4w). Wave 1 ko/en/ja → Wave 2 zh/de → Wave 3 fr/es/pt. **iOS 26 + iPadOS 26 Universal + Liquid Glass + SwiftUI 26 + SF Symbols 7**. **438h 필요 / 594h 가능 = 156h 버퍼**. **monthly advisory ritual** + **22h/week 엄격** = brand drift + burnout 단일 mitigation.

---

_End of Development Plan v2.0 Final._

---

## Naming Change — Curio → Curium (2026-05-20)

Naming history:
- 2026-05-20 초기 가칭 _Curio_ 결정 (Tier 2 §18.2.6 자동 결정)
- 2026-05-20 Marketing P1 trademark 사전 점검 결과 _Curio_ App Store 다수 동명 앱 확인 → 시장 충돌
- 2026-05-20 4-panel Naming Advisory (Phase 1) + Phase 2 Web verification → **Still Hours 채택**
- 2026-05-20 사용자 확인 _"Still Hours 으로 진행"_

Repo 이름: `still-hours-swift`
Bundle ID: `com.ownlifelab.stillhours` (사용자 결정 사항)

본 § 이후 DEVPLAN 전반의 _Curio_ 는 _Curium_ 으로 일괄 변경됨. See PRD §19 for full naming rationale.

---

## §16 ASO Implementation (지속 운영)

> 사용자 instruction: "ASO는 우리의 지속 과제. 개발 단계부터 철저히 고려."

3-panel advisory (Marketing / Strategy / Design) 종합 결과.

### 16.1 Pre-flight Week 1-3 ASO Deliverable

| 주차 | 항목 |
|-----|------|
| Week 1 | App Store metadata 초안 (ko/en/ja Subtitle + Keywords 1차) |
| Week 2 | Description 1차 draft (en 800자 + ko/ja 대응) / Promotional Text 170자 확정 |
| Week 3 | 8 locale Subtitle 확정 / CPP 3개 (Lina/Joon/Book-only) 기획 초안 |

### 16.2 Wave Launch ASO 실행 단계

| Wave | Trigger | ASO 행위 |
|------|---------|---------|
| Wave 1 | v1.0 launch | ko/en/ja 동시 출시. 8장 screenshot × 3 locale = 24장 (수동 Keynote + 시뮬레이터 capture). Preview Video 30초 en 1개. Editorial outreach + Organic ASO 시작. |
| Wave 2 | ko/en/ja 합산 monthly 200+ OR 비현지화 territory 10+ install/월 | zh-Hans/de 출시. 24장 자동화 전환 (xcodebuild UI Test + simctl screenshot). |
| Wave 3 | Wave 2 3개월 안정 | fr/es/pt 출시. 자동화 파이프라인 완전 운영. |

fastlane 미사용. xcodebuild + simctl 만 활용.

### 16.3 Discovery 채널 (User Decision 2026-05-20: No advertisement — Apple Search Ads 영구 X)

Apple Search Ads 포함 모든 외부 광고 채널 _영구 X_ (Promise §5.3 확장).
- Organic ASO — Keyword / Subtitle / Description / Promotional Text / CPP 3개
- Editorial outreach — App of the Day / Indie Spotlight / 한·일 press
- Word-of-mouth — 자발 추천 = 북극성 지표
- CPP 3개 (Lina/Joon/Book-only) → Organic ASO 타겟 메타데이터 최적화에 활용

### 16.4 ASO 자동화 (Wave 2 이후)

```bash
# simctl screenshot (fastlane 미사용)
xcrun simctl io booted screenshot screenshot_01.png
# UI Test 기반 자동 캡처
xcodebuild test -scheme StillHoursUITests -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

Wave 2 trigger 도달 시 `scripts/capture-screenshots.sh` 작성. locale별 시뮬레이터 언어 전환 자동화.

### 16.5 Monthly ASO Ritual (매월 1일 1시간)

Advisory ritual 과 _분리_ 운영 (같은 날 하지 않음).

| Layer | 시간 | 내용 |
|-------|------|------|
| Keyword ranking | 30분 | 주요 키워드 순위 추적 (AppFollow 또는 수동) |
| Competitor 스캔 | 20분 | Day One / Are.na / Listy 변화 점검 |
| Review 분석 | 10분 | 1-3성 리뷰 패턴 분류 |

### 16.6 ASO KPI Dashboard

Notion 또는 Numbers template. 매월 1일 업데이트.

| KPI | 목표 | 경고 |
|-----|------|------|
| Organic impressions | +5% WoW | -10% WoW 2주 연속 |
| Product Page View CVR | 3% 이상 (paid 기준) | <2% |
| Top keyword ranking | top-50 | top-100 이탈 |
| Organic impressions WoW | +5% | -10% 2주 연속 |
| Rating | 4.3+ | <4.0 3개월 지속 |

### 16.7 Quit Signal 6개월 정량 기준

다음 4개 중 3개 이상 동시 충족 시 제품 자체 재검토 (ASO 조정이 아닌 제품 재검토):
- (a) 3-month rating < 4.0
- (b) 누적 paid < 100
- (c) 30-day refund rate > 8%
- (d) DAU/MAU < 15%

### 16.8 iOS 27 Liquid Glass v2 대비 자동 재캡처

- WWDC 발표 당일: 시뮬레이터 점검 (시각 깨짐 여부)
- 발표 2주 안: screenshot 재캡처 + ASC 재제출
- Beta 2 이후에만 ASC 제출 (Beta 1 UI 불안정)
- `scripts/capture-screenshots.sh` 를 annual OS cycle 기준으로 유지

### 16.9 ADA Nomination 시점

- App of the Day outreach: 출시 후 6-8주 (v1.0 안정화 후)
- ADA nomination: v2.0 macOS parity 완료 후 (시점 = iOS 출시 후 약 2년)
- 한국·일본 개인 이메일 outreach: v1.2 안정화 후 (paid 500+ + rating 4.5+)

### 16.10 ASO × Promise 충돌 해결

| Promise 조항 | ASO 행위 | 판정 |
|-------------|---------|------|
| No advertising | 앱 내 광고 | 금지 (lint 강제) |
| No advertising | Apple Search Ads | **영구 금지** (User Decision 2026-05-20, Promise §5.3) |
| No AI judgment | Apple ML ranking | 허용 (외부 인프라) |
| No subscription | Description 카피 | "one-time purchase" 명시 의무 |
| Data Sovereignty | Privacy label | "Data Not Collected" 유지 의무 |

---

## §17 v2.4 Naming Change — Curium → Still Hours (2026-05-20)

사용자 최종 결정 (2026-05-20): **Still Hours** 채택. 25 후보 검증 사이클 완료.

| 항목 | 변경 |
|----|----|
| 앱 이름 | Curium → **Still Hours** |
| Bundle ID | `com.ownlifelab.curium` → `com.ownlifelab.stillhours` |
| Repo | `noenemyx/curium-swift` → `noenemyx/still-hours-swift` |
| Test scheme | `CuriumUITests` → `StillHoursUITests` |

### 17.1 폐기 후보 25개 (학습 영구 보존)

Curio (App Store 충돌) → Vaulta (EOS Network) → Constella (AbbVie pharma) → Curium (Curium Pharma SEO) → Luminae (Celebrity Cruises) → Aevum (Therapeutics/token) → Kuria (pharma) → Reliqua (USPTO Class 5) → Own Collection (SEO) → Own Your Collection (OYL 충돌) → Ownbox (5+ 서비스) → Otium (VC+App Store) → Own Gem (SEO) → Your Magnet (Mac Magnet) → Heartlink (Medical+데이팅) → Your Journey (Journey® 등록) → Tidemark (US App Store) → Cairn (USPTO 2014) → Reliquary (MTG 앱) → Sumi (Grid Diary 동일 카테고리) → Mura (SaaS $6M) → Lumo (USPTO Class 42) → Slow Shelf (Stellar Works 가구) → Still Yours (Kid LAROI 음악) → Still Times (밴드+영화)

PRD §21 에 전체 표 + 학습 패턴 + 채택 근거 영구 보존. 본 섹션은 Dev 관점 요약.

### 17.2 Code 변경 사항

- Test target 이름: `CuriumUITests` → `StillHoursUITests`
- 토큰 namespace: `StillHoursTypeface` (Design.MD §3.2 정합)
- `com.ownlifelab.stillhours` bundle ID 는 Apple Developer Console 에서 사용자 직접 등록

_End of Development Plan v2.4._

