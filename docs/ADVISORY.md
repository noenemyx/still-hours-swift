# 6-Panel Advisory — Still Hours (Synthesis)

> 2026-05-20 | sunghun.ahn
>
> Marketing / Strategy / UX / UI / Design / Engineer 6명 independent advisory _병렬_ 결과.
> 각 panel은 _다른 5 panel 의견 모르고_ PRD + DEVPLAN + BENCHMARK 직접 검토.
> 본 문서는 _agreement / divergence / blind spots / actionable decisions_ 종합.

---

## 1. Panel 별 핵심 요약

### Marketing
- _Curium 이중 의미_ + _$14.99 진지한 사용자 신호_ + _Item-as-memory-anchor 한 줄 카피_ 강점
- _Manifesto 없음 → App Store description 부담_, _이름 충돌_, _한국 vs 레포브 차별 메시지 약함_ 약점
- Risk A: free tier 없는 $14.99 발견 funnel 차단 / B: Still Hours trademark 충돌 / C: 8 locale 번역 quality
- **즉시 P1**: trademark 사전 점검 (KIPRIS + USPTO), App Store subtitle 8 locale _문화적 재작성_

### Strategy
- _데이터 모델이 차별 carrier_ + _solo dev × niche × paid one-time 정합성_ 강점
- _4축 축소 시장 가독성_ + _Manifesto+Promise lint 제거 복합 효과 과소평가_ + _4 medium × burnout 충돌_ 약점
- Risk A: **Brand Drift via 1000 small decisions** (5년 horizon, 9/10×7/10) / B: Item-as-memory 인지 비용 / C: solo × 4 × 8 quality bar 미달 (highest)
- **P0**: Quit criteria AND → OR + 시간, **Promise lint 최소 1개 추가 (No subscription IAP)**, 4 medium Tracer Bullet 순서, Day One contingency plan

### UX
- _Item-as-memory 데이터 모델 UX 정합_ + _Contact/Place first-class_ + _Memory edit history_ 강점
- _CaptureFlow 3초 happy path 전제_ + _Memory kind 7가지 시각 구분 부재_ + _Intimate Share scope 내부 enum 노출_ 약점
- Risk A: 첫 사용 마이크/위치 권한 2번 연속 → 의심 / B: edit history 사용자 오해 / C: CKShare Apple ID 없는 수신자
- **Critical R1**: 권한 요청 _앱 첫 실행 시점_ 분리, **R2**: capture _offline-first 아키텍처_, R4: scope를 _사용자 언어_로 재정의

### Engineering
- _Apple-native pipeline 검증_ + _Item/Manifestation/Memory 3-entity 분리 옳음_ + _SwiftData+CloudKit v1.0 안정성_ 강점
- _SwiftData 9 @Model v0.1 과적 (실제 20h+)_ + _CKShare iOS 17→18 차이 대비책 없음_ + _MetadataResolver 정규화 schema 미명세 (40-50h actual)_ 약점
- 명목 effort 310-460h vs 현실 **500-700h actual** (Apple-native learning curve)
- Risk C (highest 60/125): **4 medium MVP scope creep × API rate limit cascading**
- **R1**: SwiftData 9 → v0.1 minimum 4 entity, R2: VersionedSchema 첫 schema부터, R3: CKShare 2 iCloud account 실 device test 필수

### UI (Visual Design)
- _Item-as-memory 화면 분할 시각 결정_ + _느린 컬렉션 dense UI 거부 정당_ 강점
- _4 medium Card 종횡비 충돌_ + _Memory kind 7가지 시각 구분 미정_ + _Library empty state 부재_ + _App Store screenshot 64장 시각 연속성 계획 부재_ 약점
- Risk A: **App icon 브랜드 전부 대표 방향 부재** (변경 불가) / B: 경쟁 palette 회피 의도 없으면 default 수렴 / C: 8 locale CJK 타이포그래피 충돌
- **권고 palette** (경쟁 회피): background `#F5F0E8` warm parchment, accent `#B85C38` burnt sienna (도서관 가죽 제본색), Dark `#141210`
- **Typography**: System-only (SF Pro + New York), v1.0 non-system font 도입 안 함
- **Item Card 3:4 portrait fixed**, **Memory kind = icon + medium-shared accent line (not color)**

### Design System
- _데이터 모델 design 출발점_ + _Apple HIG solo dev 운영 비용 절감_ + _App Store subtitle brand voice anchor_ 강점
- _Foundation layer 어디에도 정의 없음_ + _4 medium 시각 통합 전략 미결_ + _Memory timeline visual signature 미설계_ + _Onboarding 3-step brand surface 역할 미정의_ 약점
- Risk A: **Brand identity drift** (Manifesto + design tokens 부재 _동시_) / B: Memory timeline generic list = core differentiation 시각 불증 / C: 8 locale CJK 불균형 첫인상 훼손
- **R1**: Pre-flight 12h → 3 deliverable (Foundation/Semantic/Component token), **R2**: Memory timeline 독립 design pass 8-12h, **R6**: Settings를 brand-loaded surface 의도 설계

---

## 2. Agreement (4+ panel 합의)

### A1. _4 medium MVP는 risk이고 mitigation 필요_ (Strategy + Engineer + UI + Design)
- Strategy: 4 medium × 8 locale quality bar _곱셈적_, 최선 6.5개월 도달 어려움
- Engineer: 9 @Model entity v0.1 _과적_, 현실 500-700h
- UI: 4 medium 종횡비 충돌, Card container 전략 미결
- Design: 4 medium 시각 통합 전략 부재

→ **수렴 권고**: **Tracer Bullet 순서** — Book full (v0.1) → Music full (v0.1.5) → Movie basic (v0.2) → Object basic (v0.3). 4 medium _동시 launch_가 아닌 _4 medium 동시 존재_만 v1.0 시점에 보장.

### A2. _Memory timeline 시각 설계 부재 — 차별의 핵심이 generic 위험_ (UX + UI + Design)
- UX: 7 Memory kind 시각 구분 부재 (R3)
- UI: Memory kind = icon + accent line (not color) 권고
- Design: Memory timeline _Still Hours 의 visual brand_, App Store screenshot 1번 슬롯이어야

→ **수렴 권고**: 별도 _8-12h design pass_ 분리. SF Symbols icon 7개 + medium-shared accent line + timeline connector + photo thumbnail 처리.

### A3. _8 locale 동시 launch는 quality bar 위험_ (Marketing + Strategy + UI + Design)
- Marketing: 8 locale 번역 quality 브랜드 신뢰 깎음
- Strategy: 8 locale × 4 medium quality bar _곱셈적_
- UI: CJK 타이포그래피 충돌
- Design: CJK typeface fallback stack 없음

→ **수렴 권고**: **3-stage soft launch** — Wave 1: ko + en + ja (4-6w monitoring) → Wave 2: zh + de → Wave 3: fr + es + pt. 한국·일본 시장 _조기 신호_가 글로벌 expansion 데이터 제공.

### A4. _Manifesto 없음 + Promise lint 제거 복합 효과 위험_ (Strategy + Marketing + Design)
- Strategy: **Brand Drift via 1000 small decisions** (5년 horizon, 가장 심각)
- Marketing: $14.99 구매 전 _납득 비용 증가_
- Design: Brand identity drift (Manifesto + design tokens 부재 _동시_)

→ **수렴 권고**: 
- **Promise lint 최소 1개 추가** — _No subscription IAP_ 코드 lint (Strategy P0)
- **Settings를 brand-loaded surface 의도 설계** — "Still Hours is" 섹션 (약속 3줄) + Data Sovereignty + "Made by"
- **App Store description = _동작 묘사_** 위주 (철학 선언 회피)

### A5. _Pre-flight 12h 결과물 명시 필요_ (UX + UI + Design)
- UX: 5 visual 결정 사전 권고
- UI: palette / typography / spacing / icon / column 모두 Pre-flight 권고
- Design: Pre-flight 3 deliverable (Foundation/Semantic/Component)

→ **수렴 권고**: **Pre-flight 12h → 24h** 확대. 3 deliverable + design language exploration + typography 결정 + App icon 1차 시안.

---

## 3. Divergence (의견 충돌, 수렴 방향)

### D1. CKShare Apple ID 없는 수신자 처리
- UX Q1: cold-start friction, Apple ID 없는 fallback 어떻게?
- Engineer Q1: 별도 iCloud account 확보 시 v0.9 필수, _확보 못하면 IntimateShare v1.0 이월_

→ **수렴**: 우선 _확보 후 진행_. 시 _못 확보_ 시 → _v1.0 = share 없는 베타_ 결정 (Engineer 권고 채택). UX 우려는 _확보_시 해소.

### D2. Typography
- UI: System-only (SF Pro + New York) 권고
- Design: 3 typeface 후보 비교 후 결정

→ **수렴**: _Pre-flight 안 결정_. 두 panel 모두 동의. _System-only 가 baseline_, _후보 비교가 있다면 Pre-flight 24h 안_.

### D3. 4 medium accent color
- UI: medium-별 다른 accent 시안 (Book amber/Music teal/Movie rose/Object sage) 가능성
- Design: Q2 다름 vs 같음 결정 필요

→ **수렴**: _시각 시안 2개 비교_ — single-accent vs medium-accent. Pre-flight 시점 결정.

---

## 4. Blind Spots (6 panel 모두 안 다룬 영역)

### B1. iPad 지원 시점
- PRD §11.2: 위젯 v1.x, Apple Watch v2.0+, Vision Pro v3.0+
- iPad 명시 _없음_. iOS Universal 인지 iPhone only 인지 _불명_
- UI Q3: iPad column 수 언급, 단 _scope 확인 필요_

→ **결정 필요**: iPad 지원이 v1.0 default 인가?

### B2. Accessibility (VoiceOver / Dynamic Type 깊이)
- DEVPLAN §3.1 _Apple HIG basics_ 만 명시
- UI W4: 8 locale × Dynamic Type × Dark mode 교집합 미검증
- _VoiceOver Memory timeline_ 어떻게? 모든 panel 침묵

→ **결정 필요**: Accessibility full audit + VoiceOver _Memory kind icon_ label 명시. Apple Design Award 후보가 되려면 critical.

### B3. Migration path (기존 도구 → Still Hours)
- PRD §7.1: Apple Music import / Goodreads/Letterboxd/Discogs CSV
- 단 _가장 중요한 acquisition lever_ 일 수 있음 (Marketing R)
- 누구도 _migration friction_ 평가 안 함

→ **결정 필요**: v0.5 _가장 _쉬운_ migration_ 어디? Goodreads CSV / Day One export / Listy export / 레포브 export?

### B4. Crash / Data loss 사용자 communication
- Engineer Risk B: SwiftData iOS migration user data loss
- _10년 도구_ 약속 = 데이터 영구 보존인데 _복구 protocol_ 미명시
- Marketing / UX panel 모두 침묵

→ **결정 필요**: Data loss event 발생 시 protocol (notification + restore + 사과 + 보상)?

### B5. Apple App Store editorial pickup
- Marketing: 8 locale launch press 가치 언급
- Strategy: Apple Design Award 3년 시점 권고
- _Apple "App of the Day" / "Indie Spotlight" direct outreach_ 명시 부재

→ **결정 필요**: Apple editorial team _direct outreach_ 절차 v1.0 launch week 체크리스트?

### B6. v0.5 베타 5-10명 모집 path
- DEVPLAN §5.3 "베타 5-10명 모집 + 채널 셋업 4h"
- 구체 _누구_, _어디서_ 모집 path 부재
- OYL 사용자는 _OYL 무관 결정_과 충돌

→ **결정 필요**: 베타 5-10명 _누구_ — personal network / Twitter recruit / 한국 indie 앱 커뮤니티 / Threads?

---

## 5. 사용자 결정 항목 — 5 Tier 우선순위

### Tier 1 — 즉시 결정 (Pre-flight 시작 _전_) ⭐

1. **MVP scope 재조정** — 4 medium 동시 vs **Tracer Bullet 권고** (Book→Music→Movie→Object)
2. **Quit criteria 재설계** — AND → **OR + 시간** (한국 paid < 30 _OR_ 3개월 review < 20 _OR_ 1-week retention < 40% trigger)
3. **8 locale launch 단계화** — **3-stage soft launch** (Wave 1: ko/en/ja → Wave 2: zh/de → Wave 3: fr/es/pt)
4. **Pre-flight 12h → 24h scope 확대** — Foundation/Semantic/Component design tokens 3 deliverable + design language exploration
5. **Promise lint 최소 1개 추가** — **No subscription IAP** 코드 lint 강제
6. **Trademark 사전 점검** — Still Hours in **KIPRIS + USPTO + App Store**
7. **iPad 지원** — v1.0 default vs v1.x 이월

### Tier 2 — Pre-flight 안 결정 (24h scope 內)

8. **Typography** — System-only (SF Pro + New York) 권고 vs 3 후보 비교
9. **Color palette** — UI 권고 시안 (`#F5F0E8` parchment + `#B85C38` burnt sienna accent) vs 검토
10. **4 medium accent** — medium-별 다름 vs 단일 accent
11. **Item Card 종횡비** — 3:4 portrait fixed 권고
12. **Memory kind 시각 구분** — Icon + medium-shared accent line (color 아님)
13. **App icon 방향** — Wunderkammer cabinet metaphor (burnt sienna 배경 + 백색 선묘) 시안 검토

### Tier 3 — v0.1 시작 전 결정

14. **SwiftData @Model v0.1 minimum** — 9 → **4 entity** (Item + Memory + Collection + Attachment) 권고
15. **VersionedSchema 첫 schema 적용** 확정
16. **iOS minimum** — 17.0 vs **17.5+ 권고**
17. **MetadataResolver MVP integration matrix** — 4 medium × 5 source 전체 vs 단순화 (Book = Open Library only / Music = 수동 only / Movie = TMDB only / Object = 수동 only) 권고
18. **Memory timeline 독립 design pass 8-12h 분리**

### Tier 4 — v0.9 전 결정

19. **CKShare 2 iCloud account 실 device 테스트 환경 확보** — 가능? 못 하면 **IntimateShare v1.0 이월** 결정
20. **Onboarding 3-step 4축 시각화 순서** 설계 (Screen 1 = Item-as-memory anim, Screen 2 = 4 medium typed, Screen 3 = 1-to-1 share)
21. **Empty Library state** 카피 + 시각 처리 (v0.1 scope에 _명시적_ 포함)
22. **Settings → "Still Hours is" surface** 의도 설계 (Manifesto 대체)

### Tier 5 — Open Question (founder 답변 필요)

23. **App Store description 톤** — 철학 선언 vs **동작 묘사** (Marketing 권고)
24. **한국 시장 = 첫 시장 vs 검증 시장**
25. **5년 시점 brand drift 방어 mechanism** — 자가 검열 / advisory 강제 / 약속 회의록
26. **Day One item-anchored 추가 시 contingency plan**
27. **Memory entry 시간 축** — _추가한 날_ vs _일어난 날_
28. **CKShare Android/non-Apple 수신자 fallback** — 정적 read-only 웹 vs "iOS only" 명시 제한
29. **베타 5-10명 모집 path** — personal network / Twitter / 한국 indie 커뮤니티 / Threads
30. **Apple editorial team direct outreach** — v1.0 launch week 체크리스트 포함?
31. **Crash / data loss event 사용자 communication protocol**

---

## 6. 한 줄 종합 결론

> 6-panel advisory **공통 결론**: _차별의 진정성_ 은 명확 (data model + slow + Apple-native). 단 _scope 확대 (4 medium) + 제약 완화 (Promise 옵션 + Manifesto 없음)_ 의 _복합 효과_가 _solo dev 의 quality bar 달성 가능성_ 을 _과소평가_ 됨. 
> 
> 가장 critical action 3개:
> 1. **4 medium → Tracer Bullet 순서** (Strategy + Engineer + UI + Design 합의)
> 2. **Promise lint 1개 추가** (No subscription IAP) — Brand drift 방어
> 3. **Pre-flight 12h → 24h** — Foundation token + Memory timeline visual signature + App icon 시안

이 3개 _Tier 1_ 결정 후 _Tier 2-3_ 결정 + _Tier 4 Open Question_ 답변 → Pre-flight 시작 가능.

---

_End of Advisory Synthesis._
_Note: Naming "Curio → Curium" on 2026-05-20 per 4-panel advisory + Web verification. See PRD §19._
_Note: Naming "Curium → Still Hours" on 2026-05-20 after 25 candidate validation cycle._
