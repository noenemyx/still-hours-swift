# Benchmark Report — Collection / Curation / Memory Apps (Zero-base v2)

> Version 2.0 (OYL-독립) | 2026-05-20 | sunghun.ahn
>
> _**Ownlifelab / Own Your Life 가족과 무관**._ 이 문서는 _이 앱 자체_ 의 시장 위치만 평가한다.
> 페르소나·약속·가격·미감·플랫폼은 _열려있는 변수_ 이며, 시장 데이터로 도출한다.

---

## 0. Anchor (이 문서가 _가두지 않는_ 것 / _가두는_ 것)

### 0.1 _유일한_ anchor — 사용자 발화 (2026-05-20)

> "새로운 Service를 생각해 보고 있다. 이 app이나 Service는 이를테면 _Collection_ 이다.  
> 영구저장이나 영구 구매를 통한 것이 아닌, 요즘에는 컨텐츠를 구독제로 해서 이용하거나, 필요 시 구매를 하게 된다.  
> 물리적으로 보관하고 사용하는 것은 확실히 적다. (예를 들어 음악, 영화와 같은 것들)  
> 물리적으로 가지고 있지 않더라도, 아니면 물리적으로 가지고 있는 가치 있는 컨텐츠에 대해서 _관리와 공유_를 하는 앱을 생각하고 있다."

### 0.2 _분명한 것_ 4가지 (사용자 발화에서 직접 도출)

| # | 명제 | 근거 |
|---|----|----|
| A1 | _Collection_ 컨셉 | 발화 "Collection이다" |
| A2 | _구독시대의 모호한 소유_ 라는 시대 인식이 출발점 | "구독제로 이용 / 필요 시 구매 / 물리적 보관 적음" |
| A3 | _물리 + 디지털 통합_ | "물리적으로 가지고 있지 않더라도, 아니면 물리적으로 가지고 있는" |
| A4 | _관리_ + _공유_ 둘 다 first-class | "관리와 공유를 하는 앱" |

### 0.3 _열려있는 것_ 8가지 (시장 데이터로 도출 필요)

| # | 결정 | 옵션 |
|---|----|----|
| O1 | 페르소나 누구? | A: 일반 소비자 / B: 컬렉터 / C: 미적 큐레이터 / D: 가족 헤리티지 / E: 슬로우 웹 사상가 |
| O2 | 디자인 언어? | A: minimalist clean / B: warm tactile / C: 시각 위주 / D: classic library / E: 본인 그래픽 |
| O3 | 약속 시스템? | A: 일반 privacy policy / B: 강한 Forever 약속 / C: 자율 (없음) |
| O4 | 가격 모델? | A: Free / B: Freemium / C: Paid one-time / D: 구독 / E: hybrid |
| O5 | 플랫폼? | A: iOS only / B: iOS + macOS / C: + web / D: cross-platform |
| O6 | AI 사용? | A: 영구 X / B: 보조만 (OCR) / C: 적극 활용 (추천·분류) |
| O7 | 공유 모델? | A: public profile / B: 1-to-1 의도 / C: family / D: 안 함 |
| O8 | Item 모델? | A: 자산 only / B: 자산-as-memory anchor / C: 자유 block (Are.na) |

8개 변수 × 옵션 조합 = _다른 product_. 본 벤치마크의 _목적_ 은 _어떤 조합_이 _시장 빈 자리_ 인지 도출.

### 0.4 _배제하는_ 가정 (Ownlifelab 무관 명시)

- ✗ OYL 페르소나 자동 상속 — 새 페르소나는 0.3 O1 에서 도출
- ✗ OYL Forever Clause 차용 — 약속 시스템은 O3 에서 도출
- ✗ JOH 조수용 / 김호 철학 차용 — 디자인은 O2 에서 도출
- ✗ OYL pricing ladder ($4.99→$11.99) — 가격은 O4 에서 도출
- ✗ OYL design tokens / OYLLocalized / scripts — 코드 자산 상속 안 함
- ✗ "Own Your X" 명명 — 별도 brand
- ✗ OYL 사용자 acquisition path — 독립 acquisition

---

## 1. 시장 지도 — 9 카테고리 × 22 앱 (사실 데이터)

이전 조사 데이터 _재활용_ (사실 데이터는 OYL 무관). _차용 가능성_ 평가는 _완전 새로_.

### 1.1 카테고리 요약

| # | 카테고리 | 대표 앱 | 시장 성숙도 |
|---|---------|--------|----------|
| A | Cross-medium curation | **Listy**, Achriom, iCollect Everything, Libib, CLZ | ●●●●○ |
| B | Slow web / taste curation | **Are.na**, Cosmos.so, Sublime, Savee | ●●●●○ |
| C | AI second brain | MyMind, Capacities, Mem, Kosmik | ●●●○○ |
| D | Knowledge management (인접) | Notion, Craft, Bear, **Tot** | ●●●●● |
| E | Premium journal | **Day One**, Remember, Stoic | ●●●●○ |
| F | Single-medium 전용 | **Letterboxd**, **Discogs**, Goodreads, StoryGraph, Library Thing | ●●●●● |
| G | Physical inventory + lending | **Plumerie**, Sortly, Kolekto | ●●●○○ |
| H | Collector / 전문가 | iCollect Everything, WatchBox Game, Hodinkee | ●●●○○ |
| I | 한국 indie | **레포브 (Repov)**, 부키, 북모리, bookend | ●●○○○ |
| J | Memory archive (시간/공간) | 1 Second Everyday, Polarsteps | ●●●○○ |
| K | Gift utility | GiftLog, Who Gave Me What, Giftory | ●○○○○ |

### 1.2 22 앱 핵심 한 줄 (Quick Reference, OYL 무관 평가)

| 앱 | 한 줄 | 시장 시그널 |
|----|----|--------|
| **Are.na** | _Slow web 14년, anti-algorithm, $7/mo 구독, MAU 25K, MRR $117K_ | 니치 영속 검증 |
| **Listy** | _Cross-medium iOS 7년, 11 medium, freemium, privacy-first_ | 직접 동일 컨셉 검증 |
| **Day One** | _Premium journal 13년, $49.99~$74.99/yr, 2026 AI 도입_ | _entry-anchored_ 점령 |
| **Plumerie** | _책 + lending + family, €29.99/yr, web 우선_ | _lending niche_ 점령 |
| **MyMind** | _AI 자동 정리 시각 premium, $6.99/mo_ | _AI 시각 큐레이션_ 점령 |
| **Letterboxd** | _영화 lists + 디자인 14년, 14M+ users, freemium_ | _single-domain social_ 정점 |
| **Discogs** | _음반 work/release 25년, 6M+ users, marketplace_ | _데이터 모델_ gold |
| **Goodreads** | _Amazon 책, 100M+ users, 광고_ | anti-pattern |
| **StoryGraph** | _Modern Goodreads, 책만, 통계 기반_ | _modern 책_ niche |
| **Library Thing** | _책만 20년, $25 lifetime + free 200_ | _paid lifetime_ 검증 |
| **Tot** | _Apple-native paid one-time $20, 노트 7 슬롯_ | _premium paid one-time_ 검증 |
| **Sublime** | _Sari Azout knowledge garden, 2026 정식, 구독 + AI_ | _AI knowledge garden_ 신규 |
| **Cosmos.so** | _AI tag 시각, public default_ | _시각 큐레이션_ niche |
| **iCollect Everything** | _25+ 카테고리 양 위주, subscription_ | _카테고리 양_ 점령 |
| **CLZ** | _5개 별도 앱 × 5 구독 24년_ | dated |
| **Libib** | _무료 5000 item web, 5 medium_ | _free tier_ niche |
| **Achriom** | _AI librarian cross-medium 2024, $30/yr VIP_ | _AI cross-medium_ 신규 |
| **레포브 (Repov)** | _한국 indie 1.5년, 40+ category, 평생 ₩29,000 옵션, 4.8 / 2.5K reviews_ | **한국 시장 직접 경쟁** |
| **부키** | _한국 indie 책 AI 대화, Naver 연동_ | utility |
| **1 Second Everyday** | _매일 1초 비디오 10M+ users_ | _시간 archive_ niche |
| **Polarsteps** | _여행 GPS 자동 추적, 인쇄 책 €30+_ | _여행_ niche |
| **Hodinkee** | _시계 미디어 + 앱, free_ | _미디어 + 컬렉션_ 패턴 |

---

## 2. 각 앱의 독립적 차별점 (OYL 차용 가능성 _없음_, _이 앱 자체_ 평가)

### 2.1 데이터 모델 — _어디서 학습할 가치_

| 앱 | 차별 인사이트 |
|----|----------|
| Are.na | _Block + Channel + 재귀 nesting + 무한 connection_ — 가장 _flexible_ 데이터 모델 |
| Discogs | _Master/Release_ — 한 작품의 다중 매체 (work/manifestation) gold standard |
| Day One | _Entry + N attachments + edit history 보존_ — 시간 axis 데이터 모델 |
| Letterboxd | _Lists_ (의도된 큐레이션) + _Diary_ (시간 기록) 동시 |
| 1SE | _시간 axis 단일_ (date → 1 video) — 최단순 archive |

### 2.2 UX 흐름 — _어디서 학습할 가치_

| 앱 | 차별 인사이트 |
|----|----------|
| Letterboxd | _영화 본 직후 1-tap 기록_ — capture friction 0 |
| 레포브 | _5 view modes_ (별점·캘린더·갤러리·타임라인·지도) — view 다양성 |
| Day One | _On this day_ 회고 알림 |
| Polarsteps | _자동 GPS 추적_ — 메타데이터 자동 수집 |
| Apple Music | _라이브러리 import_ MPMediaQuery |
| Plumerie | _Lending overdue flag_ — 상태 추적 |
| Are.na | _Drag&Drop block_ |
| Cosmos.so | _AI 자동 태그_ (옵션) |

### 2.3 비즈니스 모델 — _어디서 학습할 가치_

| 앱 | 모델 인사이트 | 운영 기간 / 사용자 |
|----|---------|----|
| Are.na | _사용자 = 고객 순수성_, 구독 only, 14년 sustained niche | 14년 / 25K MAU |
| Library Thing | _$25 lifetime + free 200_, 책만 20년 sustained | 20년 / 추정 100K+ |
| Tot | _$20 paid one-time_, Apple-native premium | 5+ 년 |
| Day One | _$49.99~$74.99/yr_, premium positioning + Apple 통합 | 13년 / ~$10M+ ARR |
| Plumerie | _freemium (100 books) + €29.99/yr family_ | recent |
| 레포브 | _freemium + 평생 ₩29,000 lifetime + 월/연_ hybrid | 1.5년 / 4.8 평점 |
| Listy | _freemium privacy-first_ | 7년 / 100K-500K |

### 2.4 브랜드 / Editorial — _어디서 학습할 가치_

| 앱 | 인사이트 |
|----|----|
| Are.na | _Editorial team_ (Meg Miller) — 인터뷰·에세이 self-publish 가 _가입 이유_ |
| Hodinkee | _미디어가 본체_ + 앱은 부수 — content-first |
| Letterboxd | _연말 회고_ "Year in Review" — 사용자 retention 트리거 |
| Day One | _Apple Watch + Shortcuts + Health + Siri_ 깊은 ecosystem 통합 |

### 2.5 _학습 거부_ 항목 (anti-pattern)

| 앱 | 회피 이유 |
|----|---------|
| Goodreads | Amazon ad, 별점 강요, public 압박 |
| WatchBox Game | _컬렉션 게이미피케이션_ |
| Untappd | 뱃지/체크인/리더보드 |
| Day One Gold (2026 AI) | _LLM Daily Chat_ = AI judgment 침투 |
| 부키 | _책 AI 대화_ |
| iCollect Everything | _카테고리 양_ 위주, 디자인 generic |
| MyMind | _AI 자동 정리_ — 사용자 큐레이션 의식 약화 |
| Cosmos.so | _public-by-default_ |

---

## 3. _사용 목적_ Fit 평가 (페르소나 _무관_, 순수 사용 목적만)

사용 목적 = "구독 시대에 _가치 있는 컨텐츠 (물리·디지털 모두) 의 관리와 공유_"

3 차원 × 22 앱 점수:

| 차원 | 의미 |
|----|----|
| _관리_ fit | 인벤토리·조직·검색·정렬 적합도 |
| _공유_ fit | 의도된 공유·access control·1-to-1 적합도 |
| _물리·디지털 통합_ fit | 종이책 + Kindle, LP + Spotify 동시 표현 적합도 |

### 3.1 점수표 (0-10)

| 앱 | 관리 | 공유 | 물리+디지털 통합 | **합 / 30** |
|----|---|---|------|---|
| Are.na | 8 | 5 (public-default channel) | 4 (디지털만) | **17** |
| Listy | 9 | 3 (private only) | 5 (디지털 위주) | **17** |
| Day One | 6 | 3 (entry-share만) | 5 (텍스트 위주) | **14** |
| Plumerie | 7 | 7 (family + lending) | 3 (책만 + 위치) | **17** |
| MyMind | 8 | 2 (개인용) | 4 | **14** |
| Letterboxd | 7 | 8 (lists 공유) | 2 (영화만) | **17** |
| Discogs | 9 (음반 깊이) | 5 (marketplace 부수) | 4 (음반만, manifestation) | **18** |
| Goodreads | 7 | 7 (public) | 2 (책만) | **16** |
| Library Thing | 8 (책 깊이) | 5 (catalogue 공유) | 3 (책만) | **16** |
| Tot | 4 (노트만) | 3 | 2 | **9** |
| Sublime | 7 | 5 | 4 | **16** |
| Cosmos.so | 6 | 6 | 4 | **16** |
| iCollect Everything | 9 (25 cat) | 4 | 7 (다양) | **20** |
| CLZ | 8 | 4 | 5 (각각 별개 앱) | **17** |
| Libib | 7 | 5 | 5 | **17** |
| Achriom | 6 | 3 | 5 | **14** |
| **레포브 (Repov)** | 9 (40+ cat) | 8 (4단계 공개) | 5 (디지털 위주) | **22** |
| 부키 | 6 (책만) | 4 | 3 | **13** |
| 1 Second Everyday | 5 (시간 archive) | 6 (영상 공유) | 3 (비디오만) | **14** |
| Polarsteps | 8 (여행) | 7 (여행 공유) | 6 (장소+사진+텍스트) | **21** |
| Hodinkee | 5 | 4 | 5 (시계+미디어) | **14** |
| WatchBox Game | 5 | 3 | 4 | **12** |

### 3.2 상위 fit 5개 (사용 목적 점수만)

| 순위 | 앱 | 점수 | 핵심 강점 |
|----|----|----|----|
| 1 | **레포브 (Repov)** | **22** | 40+ generic 카테고리 + 4단계 공개 + 한국 시장 _이미_ 점령 |
| 2 | **Polarsteps** | **21** | 여행 자동 추적 + 인쇄 책자 + 공유, 단 _여행 only_ |
| 3 | **iCollect Everything** | **20** | 25 카테고리 양, 단 _디자인 generic_ |
| 4 | **Discogs** | **18** | 음반 데이터 모델 gold, 단 _음반 only_ |
| 5 | (4-way tie) Are.na · Listy · Letterboxd · Plumerie | **17** | 각각 _부분_ 점령 |

**해석**:
- _사용 목적 _가장_ 충족_은 **레포브 (한국 indie, 22점)**. 1.5년차에 이미 한국 시장에서 _작동_.
- _세상에 나온 앱 중_ 30/30 만족은 _없다_. 어떤 앱도 _관리 9+ × 공유 9+ × 물리·디지털 통합 9+_ 동시 만족 안 함.
- _상위 5개 모두 부분 점령_. 어디 _합쳐서 강화_ 할 자리가 있다.

### 3.3 _빈 자리_ — 사용 목적 차원에서

| 빈 자리 | 누구도 안 하는 것 |
|------|--------|
| 1 | _관리 9+ × 공유 9+ × 물리·디지털 통합 9+_ 동시 |
| 2 | _typed metadata_ × _다중 미디어_ — 레포브 40 generic vs Discogs 1 typed 의 _중간_ 없음 |
| 3 | _Item-anchored memory_ — Day One은 _entry-anchored_, 다른 모두 _자산만_. 자산을 _기억의 입구_로 두는 앱 _없음_ |
| 4 | _1-to-1 의도된 공유_ — 대부분 public profile (Letterboxd/Goodreads/Are.na) 또는 family (Plumerie) 또는 private only (Listy). _친구별 다른 컬렉션 다른 권한_ 없음 |
| 5 | _작품/매개체 분리_ × _다중 도메인_ — Discogs는 음반만, 다중 도메인에서 work/release 없음 |

→ 이 5개 _빈 자리_가 _이 앱 자체_의 _시장 가설_ 후보.

---

## 4. _이 앱_이 될 수 있는 5개 Product Hypothesis

OYL 가족 가정 _없이_, 사용자 발화 anchor + 시장 빈 자리만으로 _5개 가능한 product_ 시안. 각각 _다른_ 페르소나·약속·가격·미감·플랫폼.

> _이 5개 중 사용자가 _선택_ 또는 _수정_ 한 후 PRD 작성._

### Hypothesis 1 — **The Memory Archive** (자산이 기억의 입구)

| 차원 | 결정 |
|----|----|
| Core differentiator | _Item-as-memory-anchor_ 데이터 모델 — Day One 역방향 |
| Persona | 30-50대 _글로벌 출장자 / 디지털 노매드_ — _장소·시간·관계_ 다양성 |
| 사용 동기 | "_언제·어디서·누구로부터·왜_" 기억이 _자산을 봤을 때_ 떠오름 |
| 약속 | _Data sovereignty 강함_ (CloudKit Private only), AI 보조 OK (OCR / 자동 위치) |
| 가격 | Paid one-time $14.99~$19.99 (Tot 패턴), Pro 구독 옵션 없음 |
| 플랫폼 | iOS first (Apple-native), Mac v2.0 |
| 미감 | Minimalist Apple-native premium (Tot / Day One 사이) |
| 공유 | 1-to-1 의도, _public 없음_ |
| 가장 가까운 경쟁자 | Day One (entry-anchored vs item-anchored) |
| 시장 빈 자리 | 3 (Item-anchored memory) |
| 위험 | _Niche 깊지만 좁음_, Day One 사용자 acquisition |
| 시장 검증 잠재성 | _높음_ — Day One $10M+ ARR 가 검증 |

### Hypothesis 2 — **The Intimate Curator** (1-to-1 공유 우선)

| 차원 | 결정 |
|----|----|
| Core differentiator | _친구별 다른 컬렉션 다른 권한_ 공유 |
| Persona | 25-35세 _SNS 피로한 미적 사용자_ — Instagram 대안 찾는 사람 |
| 사용 동기 | "공개 프로필 없이 _절친_에게만 _내 취향_ 공유" |
| 약속 | _No public feed_, _no follow_, _no like count_ 명문 |
| 가격 | Free + 공유 _만료_ / _다중 recipient_ Premium $9.99/yr |
| 플랫폼 | iOS + iPad (모바일 우선), Mac v2.0 |
| 미감 | 시각 위주, _Pinterest 대안_ 톤, 이미지 grid 중심 |
| 공유 | _제일 핵심_ — recipient picker / scope / expiry first-class |
| 가장 가까운 경쟁자 | Are.na (public-default → 1-to-1 으로 뒤집기), Letterboxd lists |
| 시장 빈 자리 | 4 (1-to-1 의도된 공유) |
| 위험 | _공유 사용자 양면 시장_ — 받는 사람도 다운로드해야 함 |
| 시장 검증 잠재성 | _중간_ — 양면 시장의 chicken-and-egg |

### Hypothesis 3 — **The Cross-medium Catalogue** (Listy 직접 경쟁)

| 차원 | 결정 |
|----|----|
| Core differentiator | _Typed metadata × 다중 미디어_ — Listy의 _generic_과 Discogs의 _typed 단일_ 사이 |
| Persona | 30-50세 _컬렉터 + 디지털 소비자_ — 책 + 영화 + 음악 + LP + 만년필 모두 |
| 사용 동기 | "_consumption tracking_ + _인벤토리_ 한 곳에" |
| 약속 | privacy-first local + iCloud sync, _AI 보조_ 허용 |
| 가격 | Listy 직접 경쟁 _freemium_ (Pro $19/yr) 또는 _paid one-time $9.99_ |
| 플랫폼 | iOS + iPad + Apple Watch + Mac |
| 미감 | Modern minimal — Listy 보다 _typed metadata_ 가 시각적으로 살아나는 디자인 |
| 공유 | 일부만 (private-first + 선택적 link 공유) |
| 가장 가까운 경쟁자 | **Listy** (7년차 직접 경쟁), Libib, iCollect |
| 시장 빈 자리 | 2 (typed × 다중) |
| 위험 | _시장 점령됨_, Listy 7년 + Achriom + iCollect 동시 |
| 시장 검증 잠재성 | _낮음_ — 가장 위험. 직접 경쟁 |

### Hypothesis 4 — **The Heritage Library** (다음 세대로)

| 차원 | 결정 |
|----|----|
| Core differentiator | _자산 + 이야기_의 _세대 transfer_ — 자녀·가족에게 _남기는_ 컬렉션 |
| Persona | 35-55세 _가정 형성 후_, _물려줄 것_ 의식 |
| 사용 동기 | "_내 책장의 책 200권_에 _누가 받을 것인지_ 표시하고 _이야기_ 함께" |
| 약속 | _100년 보존_ — 데이터 영구 export, _세대 transfer_ 의 user education |
| 가격 | Paid one-time $14.99 + _Family Vault_ $24.99 (5명 sharing) |
| 플랫폼 | iOS + iPad (가족 공유), Mac native v1.0 |
| 미감 | Classic library 느낌 — _책장_ 메타포, _세리프 polished_, 시간 무게 |
| 공유 | _family + 세대 transfer_ first-class |
| 가장 가까운 경쟁자 | Plumerie (가족 + 책), 1SE (시간) |
| 시장 빈 자리 | 1 (관리 9+ × 공유 9+ × 통합 9+ 동시) |
| 위험 | _젊은 사용자 진입 장벽_ (heritage 메시지) |
| 시장 검증 잠재성 | _중간_ — Plumerie €29.99/yr family 가 부분 검증 |

### Hypothesis 5 — **The Anti-Algorithm Slow Curator** (Are.na 개인 자산 버전)

| 차원 | 결정 |
|----|----|
| Core differentiator | _Slow web 개인 자산_ — Are.na 정신을 _내가 가진 것_ 으로 |
| Persona | 25-40세 _slow web 사상가 / 디자이너 / 아티스트 / 연구자_ — anti-알고리즘 |
| 사용 동기 | "_광고도 알고리즘도 없는_, _느린_, _내 손으로_ 정리한 컬렉션" |
| 약속 | _영구 No algorithm / No public feed / No advertising / No AI judgment_ |
| 가격 | Paid one-time $19.99 또는 Are.na 패턴 $7/mo $70/yr |
| 플랫폼 | iOS + web (Are.na 패턴) — 또는 iOS only |
| 미감 | Minimal — Are.na 보다 더 _미감 polished_ (Are.na 모바일 약점 보완) |
| 공유 | _public 옵션 + 1-to-1 옵션_ 둘 다, default private |
| 가장 가까운 경쟁자 | **Are.na** (slow web 14년) — _개인 자산 자리_ 안 만짐 |
| 시장 빈 자리 | (Are.na와 인접 영역) |
| 위험 | _Are.na 사용자 분기_ 또는 _Are.na 정신적 형제 자리_ |
| 시장 검증 잠재성 | _높음_ — Are.na 14년 niche 영속 검증 |

---

## 5. 5개 Hypothesis 비교 매트릭스

| 차원 | H1 Memory | H2 Intimate | H3 Cross-medium | H4 Heritage | H5 Slow Curator |
|----|----|----|----|----|----|
| Core 차별 강도 | 강 | 강 | 약 | 강 | 중 |
| 시장 빈 자리 | _3_ | _4_ | _2_ | _1_ | (인접) |
| 직접 경쟁자 위협 | Day One (다른 axis) | (없음) | **Listy 직접** | Plumerie 부분 | Are.na 인접 |
| Persona 명확성 | ●●●● | ●●● | ●●● | ●●●● | ●●● |
| 시장 검증 잠재성 | ●●●● | ●●● | ●● | ●●● | ●●●● |
| 솔로 dev 적합 | ●●●● | ●● (양면시장) | ●●● | ●●● | ●●●● |
| 한국 시장 자리 | ●●●● | ●●● | ●●● (vs 레포브) | ●●● | ●●● |
| 글로벌 시장 자리 | ●●●● | ●●● | ●● | ●●● | ●●●● |
| 1년 ARR 잠재 | ●●● | ●●● | ●● | ●●● | ●●●● (Are.na 25K MAU 검증) |
| 10년 영속 가능성 | ●●●● | ●●● | ●● | ●●●●● | ●●●●● |
| 제작 effort 추정 | 중 | 중-대 | 중 | 대 (가족 모듈) | 중 |

### 5.1 추천 우선순위 (시장 데이터만 기반, 사용자 선호 _무관_)

| 순위 | Hypothesis | 추천 강도 | 근거 |
|----|----|----|----|
| 1 | **H1 Memory Archive** | ●●●●○ | 시장 빈 자리 #3 명확, Day One $10M+ ARR 검증, persona 명확, 솔로 dev 적합 |
| 2 | **H5 Slow Curator** | ●●●●○ | Are.na 14년 niche 영속 검증, 솔로 dev 적합, 10년 영속 |
| 3 | **H4 Heritage Library** | ●●●○○ | 시장 빈 자리 #1, persona 명확, 단 _가족 모듈_ 제작 효 |
| 4 | **H2 Intimate Curator** | ●●○○○ | 시장 빈 자리 #4, 단 _양면 시장_ chicken-egg |
| 5 | **H3 Cross-medium** | ●○○○○ | Listy 7년차 직접 경쟁, 가장 위험 |

### 5.2 _Hybrid_ 가능성

5개 hypothesis는 _상호 배타_ 아님. _2개 이상_ 합성 가능:

| Hybrid | 합성 | 위험 |
|------|----|----|
| **H1 + H5** | Memory archive _× Slow curator_ — 자산이 기억의 입구, anti-algorithm, paid one-time | Are.na와 _직접_ 인접, 정체성 모호 |
| **H1 + H4** | Memory archive _× Heritage_ — 자산이 기억의 입구, _세대 transfer_ | 페르소나 폭 좁아짐 (35-55) |
| **H2 + H4** | Intimate _× Heritage_ — _가족_ 공유 + _세대 transfer_ | Plumerie 인접 |
| **H1 + H2** | Memory _× Intimate_ — 자산+기억 _× 1-to-1 공유_ | 가장 복잡 |

→ _Hybrid 시도는 v1.0 _이후_의 진화_, v1.0 자체는 _단일 hypothesis 핵심 1개_가 안전.

---

## 6. 시장 정합 _가격_ 옵션 (각 hypothesis 별)

각 hypothesis 의 _시장 정합_ 가격 후보:

| Hypothesis | Launch | Mid-term | Mac v2.0 | 근거 |
|----|----|----|----|----|
| H1 Memory | $14.99 paid one-time | $19.99 | bundle $24.99 | Tot $20 / Day One Silver $49.99/yr 사이 |
| H2 Intimate | Free + Premium $9.99/yr | Premium $14.99/yr | bundle $19.99/yr | 양면 시장 = free 진입 필수 |
| H3 Cross-medium | Free + Pro $9.99/yr | Pro $14.99/yr | $19.99/yr | Listy freemium 직접 경쟁 |
| H4 Heritage | $14.99 paid + Family Vault $24.99 | $19.99 + $34.99 | bundle $39.99 | Plumerie €29.99/yr 가족 +α |
| H5 Slow Curator | $19.99 paid one-time _또는_ $7/mo | $24.99 _또는_ $9/mo | $39.99 _또는_ $12/mo | Are.na $7/mo 직접 비교 |

---

## 7. 권고 (시장 데이터 기반, 사용자 선호 _무관_)

### 7.1 최선의 default 선택 = **H1 + H5 hybrid**

근거 :
- _시장 빈 자리 #3 (Item-anchored memory)_ 명확 점령 (H1 강점)
- _10년 영속 가능성_ 둘 다 ●●●●● (H1·H5)
- _솔로 dev 적합도_ 둘 다 높음
- _Are.na와 정체성 분리_ — Are.na는 _자유 block 큐레이션_, OYC(가칭)는 _자산 + 기억_
- _Day One과 정체성 분리_ — Day One은 _entry-anchored_, OYC는 _item-anchored_
- _Slow web 정신_은 _브랜드 자산_, _데이터 모델_은 H1 _구체_

### 7.2 단 _사용자 결정 필요_

본 권고는 _시장 데이터_ 만 기반. _사용자 본인이 어디에 가장 마음이 가는지_가 _10년 도구 운영_의 _진짜 사용 가능성_ 결정. 본인 선호 없는 hypothesis는 _영속 안 함_.

### 7.3 다음 단계

1. 사용자가 5개 hypothesis 중 _선호_ 표시 (1개 또는 hybrid)
2. 또는 _다른 hypothesis 제안_ — 시장 데이터 _누락_ 또는 사용자 _고유 관점_
3. 선택된 hypothesis 기반 _zero-base PRD_ 작성
4. PRD 기반 Dev Plan

---

## 8. 본 문서의 의의

이 BENCHMARK v2는 _Ownlifelab/OYL 무관_ 으로 _이 앱 자체_의 시장 자리만 평가했다.

**확인된 사실**:
- _사용 목적 30/30 만족 앱 없음_ — 어떤 자리에든 _기회_ 있음
- _직접 경쟁자_ 는 hypothesis 별로 다름: H1=Day One / H2=(없음) / H3=Listy / H4=Plumerie / H5=Are.na
- _레포브 (한국 indie)_ 는 _사용 목적 22/30_ 최고지만 _typed 모델·기억 메타데이터·미감_ 부재
- _10년 영속_ 가능 hypothesis = H4 (heritage) + H5 (slow curator) ●●●●●
- _시장 검증 잠재성_ 최고 = H1 (Memory) + H5 (Slow Curator) ●●●●

**다음 결정 (사용자)**:
- 5개 hypothesis 중 _선호 1개 or hybrid_
- 또는 다른 product hypothesis 제시
- _그 후_ 단일 hypothesis 기반 PRD 작성

---

## Sources

본 문서는 _이전 작업의 사실 데이터_ 를 재활용하되 _OYL 차용 가정_ 을 _제거_ 한 평가다. 출처는 이전 `own-your-collection/docs/BENCHMARK.md` 의 Sources 섹션 참조.

핵심 1차 출처:
- Are.na · Day One · Listy · Letterboxd · Discogs · Plumerie · 레포브 — 각 앱 공식 / App Store / 인터뷰
- Charles Broskoski 인터뷰 (Kernel Magazine, Postlight Podcast)
- Apple Design Awards 2026 finalists (Apple Developer)
- Day One Gold AI 2026-04 (9to5Mac)
- Sublime 정식 출시 2026-03 (sublime.app)

---

_End of Benchmark v2._
_Note: Working title "Curio" was changed to "Curium" on 2026-05-20 due to App Store market collision. See PRD §19 / ADVISORY for details._
_Note: Naming "Curium → Still Hours" on 2026-05-20 after 25 candidate validation cycle._
