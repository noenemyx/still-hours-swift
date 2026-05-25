# PRD — H1+H5 Hybrid: Memory Archive × Slow Curator

> Version 1.0 (zero-base, OYL-독립) | 2026-05-20 / Build #9 amendment 2026-05-24 | sunghun.ahn
>
> _Ownlifelab / Own Your Life 가족과 무관._ 별도 brand · 별도 페르소나 · 별도 약속.
> 출발점: 사용자 발화 ("구독 시대 가치 있는 컨텐츠 관리·공유") + BENCHMARK §4 의 H1+H5 hybrid.

---

## §0.-1 Build #8 / #9 Amendment (2026-05-24) — Korea-first, Curation paradigm, 5 medium

본 PRD 의 _§1~§19_ 는 _Still Hours / 4 medium / 자산-입구_ 시대의 결정 history. 아래는 그 위에 _덮어 쓰는_ Build #8/#9 amendment. 충돌 시 본 §0.-1 이 우선.

### Rename: Still Hours → Own Your Curation

- 사용자 결정 2026-05-23. CFBundleDisplayName 변경 (Bundle ID `com.ownlifelab.stillhours` 유지 — 기술 키 변경 X).
- ASO Subtitle: `책·음반·영화·오브제·장소 큐레이션` → 신규 `취향을 기록하는 개인 아카이브` (C-2 research, 16자).
- 브랜드 패밀리: OYL / OYB / **OYC** (Own Your Curation).
- 기존 _Still Hours = 호기심의 진열장_ 메타포는 영구 폐기. 새 메타포 = _큐레이션_ (개인이 _고른_ 것의 기록).

### Market: Korea-first

- 6-panel 자문 (Strategist + Marketing + Financial + Competitive + UX + Cross-cultural, opus, 2026-05-23) 결정.
- v1.0 = ko 우선, en/ja sub-locale. JP fast-follow (3~6개월). US v1.x 이후 deferred.
- Paid one-time _보류_, ko 시장은 가격 민감 + 신뢰 부족 — _free for now_ (OYL pattern 차용) → traction 후 paid 복귀 검토.

### Medium 확장: 4 → 5 (장소 추가)

`Medium { book, music, movie, object, place }` — `Item.swift` 적용 완료.
`MemoryKind { …, visited }` — 방문 행위 추가.

5 medium fixed display order: 책 → 음반 → 영화 → 오브제 → 장소.

| Medium | Search source (Build #9b) | Mock (Build #9a) |
|---|---|---|
| book | 네이버 책 / 알라딘 / Open Library / Google Books | MockBookSearchProvider |
| music | iTunes Search / MusicBrainz / Discogs | MockMusicSearchProvider |
| movie | KOBIS (KR 전용) / TMDB / OMDb | MockFilmSearchProvider |
| object | _없음_ — 수동 입력 only (Vision 분류 보조 v1.x) | MockObjectSearchProvider |
| place | 네이버 지도 / Apple Maps (MapKit) | MockPlaceSearchProvider |

### Paradigm: 자산-입구 → 검색-입구 (Curation)

기존: 카메라/바코드/OCR로 _자산 등록_ → Memory 추가.
신규: **단일 검색 입력** → 결과 미리보기 → _채택_ → 자동 Item 생성 + Memory 작성 진입.

- "추가" 언어 _전면 폐기_. "**채택**" (adoption) 으로 통일.
- 4-mode picker (book/music/movie/object) 폐기 — `SearchFirstView.swift` 가 단일 입구.
- 매뉴얼 입력은 _empty state fallback_ 으로만 노출 (`onManualFallback`).
- Curation = _내가 고른 것의 기록_. 소유 사실이 아닌 _선택_ 의 기록.

### Build 진행 상황

- **Build #8** (rename + 5 medium) — DONE 2026-05-23. xcstrings/SemanticTokens/switch cascade 모두 적용.
- **Build #9a** (Mock search + SearchFirstView) — IN PROGRESS. UI + UnifiedSearchService 골격 완료, mock 5종 동작.
- **Build #9b** (실제 API 연동) — PENDING. 사용자 API key 발급 대기 (네이버 Client ID+Secret, KOBIS cert_key, TMDB v3/v4).
- **Build #10** (Korea ASO 적용) — PENDING. C-2 research 완료, ASC REST API 적용 대기.

### One-liner 갱신

기존 §0: _자산을 입구로, 기억을 본문으로._
**신규**: **_검색을 입구로, 채택을 본문으로._** — 큐레이션은 _고른 것_ 의 기록.

### 영구 무효화

본 amendment 적용 시점부터 아래 §은 _historical reference_ 로만 유지:
- §7.1 4 mode picker UI → SearchFirstView 단일 입구로 대체
- §10/§12 Still Hours naming/branding → Own Your Curation
- §18 4 medium accent (T2.3) → 5 medium typed (place 추가)
- BENCHMARK §3.3 등 4 medium 가정 → 5 medium 재계산은 v1.x

### 공유 카드 path — 1-to-1 의도된 공유 (사용자 결정 2026-05-24)

PRD §1.2 BENCHMARK #4 _"1-to-1 의도된 공유"_ 가 우리 차별 자리 4축 중 하나. UI 실현 path = _카드 형태로 한 명에게 보내고, 받은 사람이 자신의 아카이브에 채택_. 이로써 큐레이션의 _사회적 의미_ 완성.

#### Promise 정합 확인 (모두 통과)

| Promise | 위반 여부 | 근거 |
|---|---|---|
| No public feed | ✓ 정합 | 공유 = AirDrop/iMessage 등 _사용자 의도된 1-to-1 send_. 누구도 _브라우징_ 안 함 |
| No algorithm | ✓ 정합 | 카드 = 사용자가 _선택한_ Item, 알고리즘 추천 X |
| No advertising | ✓ 정합 | brand mark = 작은 footer footnote, 광고 X |
| No AI judgment | ✓ 정합 | 카드 내용 = 사용자 작성, AI 평가/요약 X |
| Data sovereignty | ✓ 정합 | 카드 = device-side render, 서버 송신 0 |

#### 4-phase 진화 path

| Phase | 의미 | 구현 | 작업량 |
|---|---|---|---|
| **A. v1.0 카드 이미지 export** | 단일 Item 을 _이미지 카드_로 render → ShareLink (native AirDrop/iMessage/Files). 받는 쪽 _이미지만_, 앱 불요 | SwiftUI `ImageRenderer` + `ShareLink` (iOS 16+) | **2~3h** (Build #9e) |
| **B. v1.x Universal Link 채택** | 카드에 숨겨진 deeplink → 받는 쪽 앱 있으면 _1탭으로 자신의 아카이브에 채택_. _함께 아카이빙_ 의미 실현 | Universal Link 설정 + receiver flow + externalID-기반 dedup | **6~8h** |
| **C. v2.0 Collection 공유** | "이번 가을 읽은 책 10권" 같은 _묶음_ 공유. 카드 grid preview | 기존 Collection 모델 (SchemaV1) 활용 + grid render + multi-item universal link | **10~12h** |
| **D. v3.0 CloudKit 협업 Collection** | 둘 이상이 _같은 Collection 편집_. 진정한 _함께_ 아카이빙 | CKShare API (OYL v3.0 OOL 합병 패턴 차용) | **20h+** |

#### v1.0 (Phase A) 카드 디자인 spec

**비율**: `3:4` (Instagram Story 친화, primary) — 세로형, 위 75% 이미지, 아래 25% 텍스트
**선택**: `1:1` (square, 채팅 thumbnail 친화) — v1.x

**Layout** (3:4):
```
┌─────────────────────────┐
│                         │
│      [Cover Image]      │  ← 75% — cover 또는 medium-typed SF Symbol placeholder
│                         │
├─────────────────────────┤
│ Norwegian Wood          │  ← title (semibold body, 1-2 line)
│ 무라카미 하루키          │  ← creator (regular secondary, 1 line)
│ 도쿄 츠타야 · 2024.08    │  ← 1-line memory (tertiary, optional)
│       큐레이션 by OYC   │  ← footer brand mark (caption2, tertiary)
└─────────────────────────┘
```

- 모서리 radius 12pt
- 내부 padding 16pt
- 색상: SemanticTokens (background, text, accent)
- brand mark _절대 prominent X_

#### v1.0 (Phase A) UI 통합 (변경 최소)

| 위치 | 변경 |
|---|---|
| ItemDetailView toolbar (top-right) | `ShareLink(item: cardImage)` 아이콘 |
| LibraryListView item context menu (long-press) | "카드로 공유" |
| AddMemoryView 저장 직후 success surface | 선택지 "친구에게 카드로 보내기" (low-key) |
| Settings → 데이터 (v1.x) | "공유 받은 카드 → 내 아카이브" history |

신규 view _0개_. 기존 3 view에 share entry 점 + 신규 `CardRenderView` 1개 (이미지 render 전용, 사용자 UI 노출 X).

#### 5 medium 카드 변주 예시 (디자이너 외주용)

| Medium | Title | Creator | 1-line memory |
|---|---|---|---|
| 책 | Norwegian Wood | 무라카미 하루키 | 도쿄 츠타야 · 2024.08 |
| 음반 | In Rainbows | Radiohead | LP 한정판, 첫 곡 15 Step |
| 영화 | Spirited Away | Hayao Miyazaki | 어머니와 마지막 본 영화 |
| 오브제 | Leica M6 | Leica Camera AG | 30년 된 카메라, 부친 유품 |
| 장소 | 도쿄 츠타야 | (없음) | 어머니와 함께, 2024-08 |

각 medium × 2 비율 = **10 mockup** 디자이너 외주 (`docs/design-brief/01-SHARE-CARD.md`).

#### 영구 결정

본 path 의 _v1.0 Phase A_ 는 _Curation paradigm 정체성 완성_ 으로 간주. 출시 첫 날부터 사용자가 _큐레이션을 친구에게 보낼 수_ 있어야 _개인 아카이브_ 가 _큐레이션_으로 의미 전환됨.

---

### 글로벌 확대 path — 구글 API 활용 (사용자 결정 2026-05-24)

KR source (네이버/KOBIS) 는 _한국 안에서만_ 가치. 글로벌 확대 시점에 _커버리지 0_. Google API 활용이 _필수_.

| Phase | Locale | Book 1차 | Movie 1차 | Place 1차 | Music 1차 |
|---|---|---|---|---|---|
| **v1.0** | ko-KR | 네이버 책 | KOBIS _only_ (TMDB skip) | 네이버 지도 | iTunes |
| **v1.x JP** | ja-JP | Rakuten Books (검토) | TMDB ja (commercial license 재검토) | Apple Maps ja | iTunes ja |
| **v2.0 Global** | en/de/fr/es/pt/zh | **Google Books** | TMDB commercial OR OMDb | **Google Places** | iTunes |

#### TMDB v1.0 skip 결정 (사용자 2026-05-26)

TMDB 약관: _Developer tier 무료_, _Commercial use는 enterprise license_. App Store 출시 앱 _commercial 해석 가능_ (회색 영역). 결정:

- **v1.0 = TMDB skip**. 한국 영화는 KOBIS 단일 source로 95%+ cover. Korea-first 시장 = 한국 영화 위주 collector.
- 해외 영화 채택은 _수동 입력 fallback_ (UnifiedSearchService movie medium에 KOBIS만 wire, mock 도 skip).
- TMDBSearchProvider 코드는 _유지_ (`Packages/InventoryCore/Sources/InventoryCore/Search/Providers/TMDBSearchProvider.swift`) — v1.x/2.0 시점 _commercial license_ 또는 _OMDb 대체_ 결정 시 즉시 활성화.
- env에 `TMDB_V4_BEARER` 없으면 `UnifiedSearchService.makeDefault` 가 TMDB 자동 skip (이미 conditional). 코드 변경 0.

#### Architecture 함의 (UnifiedSearchService)

`UnifiedSearchService.search(query:)` 가 locale-aware provider priority 적용:
- `Locale.current.region == .southKorea` → 네이버/KOBIS priority 100, Google priority 70
- `region == .japan` → Rakuten/TMDB-ja priority 100
- 그 외 → Google Books / Google Places priority 100, KR providers priority 0 (skip)

구현 시점: v2.0 (글로벌 출시 직전). v1.0 ~ v1.x 까지는 hardcoded KR + JP fallback 만으로 충분.

#### 비용 모델

- **Google Books**: 무료 (1,000 req/day quota)
- **Google Places**: $200/월 무료 credit + $0.017/req text search ≈ ~11,700 search/월 무료
- 글로벌 v2.0 시점 paid 전환 가정 (현 free for now 모델 끝) → quota 비용은 $4.99~$9.99 가격에 흡수 가능

#### v1.0 결정 = 변경 없음

본 글로벌 path 는 _v2.0 strategic intent_ 만 명시. v1.0 ASC 제출 = ko 우선 + 네이버/KOBIS/iTunes/TMDB. 구글 API key 발급 / 코드 구현 모두 _v2.0_ 시점.

---

## 0.0 Governance Principle (1원칙)

**모든 _Critical_ 결정은 사용자 (sunghun.ahn) 의 명시적 확인 후 진행한다.**

자문단 (advisory) 은 _권고_ 역할만. _자동 채택_, _권한 위임_ 영구 금지.

세부: 별도 `docs/GOVERNANCE.md` 참조 (Tier 1 critical 9 카테고리 / Tier 2 자동 진행 8 카테고리 / Decision flow 4-step / Dismissal 해석 / Trigger words / 위반 학습 history + **§10 병렬 작업 원칙 — sub-agent + parallel execution 강제 default**).

본 PRD 의 모든 _§ 결정_ 은 본 원칙 안에서 작성됨.

---

## 0. One-liner

**_자산을 입구로, 기억을 본문으로._**

자산은 _가졌다는 사실_이 아니라 _가지게 된 이야기_의 시작. 알고리즘 없이, 광고 없이, AI 판단 없이, 나의 손으로 기록하고 의도된 사람에게만 보여주는 _느린 컬렉션_.

---

## 1. Anchor

### 1.1 사용자 발화 (유일한 외부 anchor)

> "_Collection이다. 영구저장이나 영구 구매를 통한 것이 아닌, 요즘에는 컨텐츠를 구독제로 해서 이용하거나 필요 시 구매를 하게 된다. 물리적으로 보관하고 사용하는 것은 확실히 적다. 물리적으로 가지고 있지 않더라도, 아니면 물리적으로 가지고 있는 가치 있는 컨텐츠에 대해서 관리와 공유를 하는 앱._"

직접 도출 4명제:
- A1 _Collection_ 컨셉
- A2 _구독시대 모호한 소유_ 시대 인식
- A3 _물리 + 디지털_ 통합
- A4 _관리_ + _공유_ 둘 다 first-class

### 1.2 시장 데이터에서 도출한 _차별 자리_ (BENCHMARK §3.3)

5개 _빈 자리_ 중 본 hybrid가 점령하는 자리:
- ⭐ #3 _Item-anchored memory_ — Day One (entry-anchored) 의 _역방향_, 다른 모든 collection app은 _자산만_
- ⭐ #4 _1-to-1 의도된 공유_ — public profile · family · private only 사이의 _빈 자리_

### 1.3 H1+H5 합성 결과 (BENCHMARK §4.1 / §4.5)

| 차원 | H1 (Memory) | H5 (Slow Curator) | **Hybrid** |
|----|----|----|----|
| Core 차별 | Item-as-memory-anchor | Slow + anti-algorithm | **둘 다** |
| Persona | 글로벌 출장자·노매드 | Slow web 사상가·디자이너 | _교집합_ (아래 §3) |
| 약속 | Data sovereignty | No algorithm/feed/ad/AI | **5조항 합성** |
| 가격 | $14.99~$19.99 one-time | $19.99 one-time _or_ $7/mo | **$14.99 → $19.99 one-time _only_** |
| 미감 | Apple-native premium minimal | Slow web aesthetic | **Apple-native + slow web 톤** |
| AI | 보조 OK (OCR) | AI judgment X | **보조 OK, judgment X** |
| Item 모델 | Item + Memory 분리 | Are.na block 패턴 참고 | **Item + Memory + 옵션 재귀 Collection** |

---

## 2. The Niche — 시장에서 진짜 비어있는 자리

### 2.1 직접 경쟁자와의 _분명한_ 차별

| 경쟁자 | 우리와 _근본적_ 다른 점 |
|------|--------------------|
| **Day One** | _entry-anchored_ (날짜·entry) → 우리는 _item-anchored_ (자산이 입구). Day One 2026 Gold AI 도입 → 우리는 영구 No AI judgment. |
| **Are.na** | _Block + Channel 자유 큐레이션_ → 우리는 _typed Item + 기억 메타데이터_ first-class. Are.na public-default → 우리는 private-default. |
| **Listy** | _Cross-medium consumption tracking_ → 우리는 _Cross-medium 자산 + 기억_. Listy 메모리 없음. |
| **Plumerie** | _책 + family_ → 우리는 _다중 미디어 + 1-to-1_. Plumerie web 우선 → 우리 iOS native first. |
| **레포브 (한국)** | _40+ generic 카테고리_ → 우리는 _typed 4 미디어 깊이_. 레포브 _전체 공개_ 옵션 → 우리는 _공개 없음_. |
| **MyMind / Sublime** | _AI 자동 정리·추천_ → 우리는 _사용자 손으로_, AI judgment 영구 X. |

### 2.2 8축 매트릭스 (우리 vs 핵심 경쟁자)

| 축 | 우리 | Are.na | Day One | Listy | 레포브 |
|----|---|----|----|----|----|
| Apple-native iOS first | ◎ | △ | ◎ | ◎ | ◎ |
| 다중 미디어 (typed) | ◎ | ○ (generic block) | ✗ | ◎ (generic) | ◎ (generic) |
| Item-as-memory-anchor | ◎ | ✗ | ✗ entry-anchored | ✗ | ✗ |
| 기억 메타데이터 default | ◎ | ✗ | ○ entry-only | ✗ | △ |
| 1-to-1 의도된 공유 | ◎ | △ public-default | ✗ | ✗ private only | ○ 4단계 |
| Paid one-time only | ◎ | ✗ sub | ✗ sub | △ freemium | △ option |
| No AI judgment | ◎ | ◎ | ✗ Gold AI | ◎ | △ |
| Slow web 정신 (no algo/feed/ad) | ◎ | ◎ | ✗ | △ | ✗ |
| **8축 ◎** | **8** | 2 | 1 | 2 | 1 |

→ 8축 모두 ◎ 인 앱은 _우리_ 만. _차별의 진짜성_ 확인.

---

## 3. Target Persona

### 3.1 Primary — "Lina · 28-42세 다국 거주 큐레이터형 사용자"

- **나이**: 28-42세 (생애 1-2 도시 이주 경험)
- **거주**: 서울 / 도쿄 / 베를린 / 뉴욕 / 런던 / 코펜하겐 등 글로벌 도시
- **직업**: 디자이너 / 큐레이터 / 작가 / 브랜드 매니저 / 아트 디렉터 / 건축가 / 사진작가 / 슬로우 라이프 컨설턴트
- **연 수입**: $60K~$200K (USD 기준)
- **소유 패턴**:
  - 종이책 50-200권 + Kindle 100-500권
  - LP 20-100장 + Spotify 좋아하는 앨범 100-300개
  - 만년필 / 빈티지 카메라 / 향수 / 시계 / 도자기 _소수 + 진지_
  - 아트프린트·사진집·디자인 오브제 흩어져 있음
- **디지털 행동**:
  - SNS 피로 (Instagram 거의 안 보거나 비공개)
  - Netflix·Spotify·Apple Music 모두 사용, 단 _진짜 좋아하는 것_은 종이/LP로 따로 소유
  - News·알고리즘 피드 _의식적 회피_
  - Apple ecosystem 깊이 사용 (iPhone + iPad + Mac + Watch 가능)
- **가치**:
  - _미감 비양보_ + _느린 큐레이션_
  - _SNS 압박 없는_ 공유
  - _AI 판단 안 듣는_ 자율성
  - _내가 정리한 것_의 자기 표현

### 3.2 Secondary — "Joon · 32-50세 글로벌 출장자/노매드"

- 32-50세 남녀
- 잦은 출장·이주 — 도쿄·서울·뉴욕·LA·런던 이동
- _장소·시간·관계_가 자산에 _진하게_ 묻음
- _이 책은 도쿄 출장 마지막 날 츠타야_ 같은 기억이 _자산보다 중요_

### 3.3 _아닌_ 사용자

| 다른 사용자 | 다른 도구 권장 |
|----------|----------|
| 10,000+ 항목 power-collector | Discogs / CLZ / iCollect Everything |
| 공개 프로필로 영향력 원함 | Letterboxd / Goodreads / Instagram |
| 친구들과 경쟁/리더보드 원함 | Untappd / Goodreads star |
| AI 자동 정리 원함 | MyMind / Day One Gold / Sublime |
| 가족 inventory 위주 | Plumerie |
| 일기 위주 (entry-anchored) | Day One |
| 자유 block 영감 큐레이션 (이미지·링크 중심) | Are.na / Cosmos |

---

## 4. JTBD (Jobs To Be Done) — 12가지 맥락

> "어떤 _맥락_에서 _고용_하는가"

### 4.1 Capture (자산이 _기억의 입구_가 되는 순간)

1. **츠타야에서 책을 산 직후** → 영수증 받기 전 _3초_ 안에 _장소·날짜·왜_ 보존
2. **친구가 LP를 선물했을 때** → _누가·언제·왜_ 자산에 즉시 묶음
3. **이사 정리 중 오래된 만년필 발견** → _아버지가 1995년 입학 선물_ 이라는 기억 자산에 복원
4. **도쿄 출장 다이쇼만년필 가게 방문** → 사진 + 위치 + 가격 + 매장 직원 한 마디 보존

### 4.2 Curate (의미 단위 컬렉션)

5. **"내 인생을 바꾼 책 10권"** 형태의 의미 단위 묶음
6. **"결혼식에 쓴 음악"** 같은 _이벤트 단위_ 큐레이션
7. **"이번 가을 다시 읽고 싶은 책"** 같은 _시기 단위_

### 4.3 Share (의도된, 1-to-1)

8. **절친에게 _내가 추천하는 책 5권_ 보내기** — public 프로필 없이
9. **부모님께 _내가 모은 LP 컬렉션_ 보여드리기** — AirDrop / 링크
10. **파트너와 _둘만의 컬렉션_ 큐레이션** — 1년치 결혼생활 자산 기록

### 4.4 Time Travel (회고)

11. **5년 전 오늘의 책장** — anniversary view, _그때 적은 메모_까지 보존
12. **결혼 / 출산 / 이직 등 인생 전환점의 컬렉션 snapshot** — _시기별_ 자동 클러스터

---

## 5. The Promise — _영원히 하지 않는_ 5조항

이 앱의 _브랜드_ 는 _기능이 아니라 약속_. 약속이 _코드 lint_로 강제된다 (DEVPLAN §2.4).

### 5.1 The Five

1. **No algorithm** — 정렬·추천·자동 분류 _영구 X_. 사용자가 정한 순서만.
2. **No feed** — public feed / 무한 스크롤 / 활동 피드 _영구 X_.
3. **No advertising · No data sale** — 외부 트래커·픽셀·analytics broker _영구 X_. Apple Search Ads 등 외부 광고 채널 활용도 _영구 X_. 발견은 organic ASO + Editorial outreach + word-of-mouth 만.
4. **No AI judgment** — 자동 추천·요약·평가 _영구 X_. AI는 _메타데이터 보조_ (OCR / 이미지 인식) _만_.
5. **No subscription** — 일회성 paid app. 기존 구매자 _영구 무료_ 업그레이드.

### 5.2 Subtraction Clause

위 5조항 _중 어느 하나_를 약화시키는 방향의 기능 _영원히_ 추가 안 함.

### 5.3 Data Sovereignty Clause

- 모든 데이터는 _사용자의 iCloud Private DB_ 안에만 존재
- 외부 메타데이터 lookup 시에도 _사용자 식별 정보 송신 안 함_ (작품 ID만)
- _평문 JSON · CSV · PDF export 영구 보장_
- 앱이 사라져도 _데이터는 사용자의 것_

### 5.4 _어디서 영감 받았는가_ (출처 정직)

- _Are.na의 user-as-customer 순수성_ 정신 (Charles Broskoski 인터뷰)
- _Day One의 Apple ecosystem 깊이_ (단 entry-anchored 거부)
- _Discogs의 work/release 데이터 모델_
- _Library Thing의 paid lifetime 모델 20년 검증_
- _Tot의 Apple-native paid one-time premium_

이 5개 인용은 _브랜드 자산_. _숨기지 않고 명시_.

---

## 6. Hero Moments — 3가지 핵심 체험

App Store screenshot 3장 + 첫 화면 메시지 + 마케팅 카피 = _이 3개_ 만.

### Hero Moment 1 — _Story Capture_ (3초의 보존)

> 츠타야 다이칸야마, 저녁 7시. 책 한 권을 산다.
> 카운터에서 영수증을 받기 전, iPhone을 꺼낸다.
> 바코드 스캔 (1초) → 자동 메타데이터 (1초) → "어디서 · 왜" 음성 메모 한 줄 (10초).
> 영수증을 받을 때, 책은 _이미 컬렉션 + 기억_ 안에 있다.

핵심 UX:
- 한 화면, 두 손가락 작업
- 위치 자동 제안 (CoreLocation)
- 날짜 자동 (now)
- "왜?" 한 문장만 — 음성 또는 텍스트 quick capture
- 자산 등록 시 _자동 1 Memory 생성_

### Hero Moment 2 — _Memory Timeline_ (자산이 입구)

> 5년이 지났다.
> Library에서 그 책을 연다.
> 위에는 책 정보 (제목·저자·연도), 아래는 _그 책에 붙은 N개의 기억_.
> _2024-08 도쿄 츠타야_ 처음 산 날.
> _2024-12 친구 미진에게 추천_ 한 메모.
> _2025-03 다시 읽기 시작_ 한 음성.
> _2026-05 친구에게 빌려줌_ — 아직 안 돌아옴.
> 자산은 _가졌다는 사실_ 아니라 _이야기의 입구_.

핵심 UX:
- ItemDetail 위 1/3 = 자산 정보 (불변 metadata)
- 아래 2/3 = Memory timeline (시간 axis, 추가 자유)
- 새 Memory 추가 = _아무 시점에서나_ tap → quick add
- Memory 종류: 일반 / 읽음 / 들음 / 봤음 / 빌려줌 / 받음 / 선물함 / 주석

### Hero Moment 3 — _Intimate Share_ (1-to-1)

> 절친 미진에게 _이번 가을 읽을 책 5권_ 을 보낸다.
> Library에서 5권 선택 → "Share with…" → 미진의 이름.
> 미진이 받는 것: 5권의 책 + 내가 쓴 한 줄 메모. 
> _공개 프로필 없음. 별점 없음. follow 없음. like count 없음._
> 미진은 _계정 만들지 않고도_ 받는다. _만료 시각_도 선택 가능.
> SNS 가 아닌 _개인적 선물_.

핵심 UX:
- 컬렉션 → "Share" 메뉴는 _public_과 _1-to-1_ 이 별도
- Recipient picker = Contacts 연동 또는 free-text name
- Scope: viewItemsOnly / viewItemsAndPublicNotes / viewAll
- Expiry: 7d / 30d / 1y / 영구
- Share 받는 화면: 보낸 사람 이름 + 한 줄 메모 + 컬렉션 + (허용 시) 항목별 메모

---

## 7. User Stories — 45개

### 7.1 Capture (자산 등록) — 8개

1. 사용자로서, 종이책을 _ISBN 바코드 스캔 3초_ 안에 등록하고 싶다.
2. 사용자로서, 바코드 없는 외서를 _표지 사진 OCR_ 로 등록하고 싶다.
3. 사용자로서, _만년필·LP 슬리브·도자기_ 같은 물리 자산을 _직접 사진_으로 등록하고 싶다.
4. 사용자로서, Apple Music _좋아한 앨범_ 일괄 import 하고 싶다.
5. 사용자로서, _Kindle 라이브러리_ 를 수동/CSV/OCR 로 가져오고 싶다.
6. 사용자로서, _Goodreads / Letterboxd CSV_ 를 dedup 후 import 하고 싶다.
7. 사용자로서, _LP + Spotify + CD_ 를 _하나의 Item_ 의 _다른 manifestation_ 으로 묶고 싶다.
8. 사용자로서, 등록 즉시 _장소·날짜·왜_ 한 줄을 _음성 또는 텍스트_ 로 보존하고 싶다.

### 7.2 Memory (자산에 기억 붙이기) — 10개

9. 사용자로서, 항목마다 _N개의 Memory entry_ 를 추가하고 싶다.
10. 사용자로서, Memory 종류 _enum_ 으로 (acquired / read / listened / lent / received / annotated) 분류하고 싶다.
11. 사용자로서, 항목 detail 에서 _Memory timeline_ 을 시간 순으로 보고 싶다.
12. 사용자로서, _자유 메모_ 를 markdown 으로 적고 싶다.
13. 사용자로서, _복수 사진_ 을 첨부하고 싶다 (서명 페이지·책갈피·LP 슬리브 안쪽).
14. 사용자로서, _음성 메모_ 를 첨부하고 싶다 (on-device transcription).
15. 사용자로서, _메모 수정 history_ 가 보존되기를 원한다.
16. 사용자로서, Memory 에 _연결된 사람 (Contact)_ 을 link 할 수 있기를 원한다.
17. 사용자로서, Memory 에 _연결된 장소 (MapKit)_ 를 link 할 수 있기를 원한다.
18. 사용자로서, 항목 사이 _연결_ 을 link 할 수 있기를 원한다 (이 LP 는 그 책의 OST).

### 7.3 Curate (의미 단위 컬렉션) — 6개

19. 사용자로서, _의미 단위_ 컬렉션을 만들고 싶다.
20. 사용자로서, 한 항목이 _여러 컬렉션 동시_ 속할 수 있기를 원한다.
21. 사용자로서, 컬렉션 안 _수동 정렬_ 이 가능하기를 원한다.
22. 사용자로서, 컬렉션의 _커버_ 를 _항목 중 하나_ 로 지정하고 싶다.
23. 사용자로서, 컬렉션에 _짧은 description_ 을 붙이고 싶다 (왜 만들었는지).
24. 사용자로서, _스마트 컬렉션_ 도 원한다 (최근 30일 / 5년 전 오늘 / 특정 태그).

### 7.4 Share (의도된 1-to-1 공유) — 7개

25. 사용자로서, _특정 컬렉션_ 을 _특정 사람_ 에게만 _의도적으로_ 공유하고 싶다.
26. 사용자로서, 받는 사람이 _계정 만들지 않고_ 볼 수 있기를 원한다 (CloudKit URL / AirDrop / iMessage).
27. 사용자로서, _내 메모는 비공개_, 항목 자체만 공유할 옵션을 원한다.
28. 사용자로서, _만료 시각_ 을 설정할 수 있기를 원한다 (7일 / 30일 / 1년 / 영구).
29. 사용자로서, _공유 회수_ 가 _즉시_ 가능하기를 원한다.
30. 사용자로서, 공유받은 사람이 _코멘트나 좋아요를 남길 수 없기를_ 원한다.
31. 사용자로서, 공유 시 _보낸 사람 한 줄 메모_ 가 같이 가기를 원한다.

### 7.5 Slow Inventory (검색·필터, _알고리즘 없음_) — 4개

32. 사용자로서, 검색 결과가 _내가 정한 정렬 기준_ 으로만 나오기를 원한다 (relevance score X).
33. 사용자로서, 필터링은 _명시적 조건_ 만 (medium / tag / state / date range).
34. 사용자로서, _추천_ 받지 _않기_ 를 원한다 — 추천 surface 자체 없음.
35. 사용자로서, _스크롤 무한 피드_ 가 _없기_ 를 원한다.

### 7.6 Lending / Gift Flow — 4개

36. 사용자로서, _빌려준 책_ 을 _누구에게_ 기록하고 싶다.
37. 사용자로서, _받은 선물_ 을 _준 사람 + 맥락_ 과 함께 기록하고 싶다.
38. 사용자로서, _영구히 떠난 항목_ (선물·잃어버림·팔았음) 도 _archive_ 로 메모리에 남기를 원한다.
39. 사용자로서, 대출 만기 알림은 _default OFF_, 명시적 opt-in 만.

### 7.7 Time Travel (회고) — 3개

40. 사용자로서, _5년 전 오늘_ snapshot 을 보고 싶다.
41. 사용자로서, _특정 연도·계절·도시_ 에서 추가한 항목을 볼 수 있기를 원한다.
42. 사용자로서, _가장 오래 가진_ 항목을 보고 싶다.

### 7.8 Privacy / Data Sovereignty — 3개

43. 사용자로서, _계정 가입 不要_, Apple ID + iCloud 로 충분.
44. 사용자로서, _평문 JSON / CSV / PDF export_ 항상 가능.
45. 사용자로서, 외부 metadata lookup 시에도 _내 식별 정보가 송신되지 않기_ 를 원한다.

---

## 8. Data Model — 차별의 심장

> 데이터 모델이 _브랜드_. _Item과 Memory의 분리_ 가 _Day One 역방향_ 이라는 차별의 _구체_.

### 8.1 Core Entities

```
Item                            // 자산 — 기억의 입구
├─ id                           // UUID
├─ title                        // 작품명
├─ creator                      // 저자 / 아티스트 / 감독 / 장인
├─ year                         // 연도
├─ medium                       // enum: Book / Music / Movie / Object / (Place / Experience v2.0)
├─ mediumMetadata              // typed extension (Book→ISBN/pages, Music→artist/label/format, ...)
├─ manifestations              // [Manifestation] — 같은 작품의 다른 매체
├─ memories                     // [Memory] — _핵심 차별_, N개의 기억 entry
├─ tags                         // [String]
├─ state                        // owned / lent / gifted-out / lost / digital-only / archived
├─ cover                        // ImageRef
├─ attachments                  // [Attachment] — Item 자체 첨부 (사진·영수증 등)
├─ createdAt
└─ updatedAt

Manifestation                   // Discogs Work/Release 패턴
├─ id
├─ format                       // 종이책 / Kindle / LP / Spotify / Apple Music / DVD / Streaming
├─ source                       // String? ("Kyobo Bookstore", "Apple Music"...)
├─ externalIdentifiers          // [String: String] (ISBN: "...", musicBrainzID: "...")
└─ acquiredAt                   // Date?

Memory                          // _Day One 역방향_, 자산에 붙은 기억
├─ id
├─ itemID                       // belongs to Item
├─ kind                         // acquired / read / listened / watched / lent / received / gifted / annotated / general
├─ date                         // Date
├─ place                        // PlaceRef?
├─ withWhom                     // [ContactRef]
├─ note                         // String (markdown)
├─ voiceNote                    // URL?
├─ photos                       // [ImageRef]
├─ createdAt
└─ noteHistory                  // [HistoryEntry] — _Edit history 보존_, 10년 후에도 "그때 쓴 글" 보존

Collection                      // 의미 단위 묶음
├─ id
├─ title
├─ description                  // String?
├─ items                        // [ItemRef] (ordered, M:N)
├─ nestedCollections            // [CollectionRef]? — Are.na 패턴 (v2.0 검토)
├─ smartFilter                  // SmartFilterRule? — 명시적 조건만 (no algorithm)
├─ cover                        // ImageRef?
├─ pinnedToHome                 // Bool
├─ shares                       // [Share]
├─ createdAt
└─ updatedAt

Share                           // 의도된 1-to-1 공유 인스턴스
├─ id
├─ collectionID
├─ recipient                    // RecipientRef (이름 + 옵션 contact / 사진)
├─ scope                        // viewItemsOnly / viewItemsAndPublicNotes / viewAll
├─ message                      // String? — 보낸 사람 한 줄 메모
├─ shareURL                     // CloudKit CKShare URL
├─ expiry                       // Date?
├─ createdAt
└─ revokedAt                    // Date?

Loan                            // 대출 / 선물 흐름
├─ id
├─ itemID
├─ direction                    // lent-out / borrowed-from / gifted-out / received-as-gift
├─ counterparty                 // ContactRef? (또는 free-text)
├─ date
├─ dueDate                      // Date? (대출만)
├─ returnedDate                 // Date?
├─ note                         // String?
└─ markedAsPermanentlyGone      // Bool

Contact                         // 사람 (가족·친구·파트너·멘토)
├─ id
├─ displayName
├─ contactIdentifier            // Apple Contacts ID? (optional)
└─ photo                        // ImageRef?

Place                           // 장소
├─ id
├─ displayName                  // "츠타야 다이칸야마"
├─ coordinate                   // CLLocationCoordinate2D?
├─ mapKitID                     // MKMapItem identifier?
└─ photo                        // ImageRef?

Attachment
├─ id
├─ kind                         // photo / voice / receipt / document
├─ url
├─ thumbnailURL                 // 이미지
├─ caption                      // String?
└─ createdAt
```

### 8.2 핵심 디자인 결정 5가지

**D1 — Item과 Memory의 분리** (_차별의 핵심_)

다른 collection app은 _Item 자체에_ single timestamp만. 우리는 _Item에 N개의 Memory entry_가 붙는다. 같은 책에 대해 _읽은 날_ memory, _다시 읽은 날_ memory, _친구에게 빌려준 날_ memory 모두 보존. **이것이 _자산이 기억의 입구_ 의 구체.**

**D2 — Manifestation 분리** (Discogs work/release 패턴)

종이책 + Kindle = _같은 Item_, 다른 _Manifestation_. LP + Spotify = _같은 Item_. 중복 없이 _LP로도 가진다_는 사실 보존.

**D3 — Contact / Place 가 First-class entity**

"from": String 가 아니라 _Contact reference_. 그래서 _어머니가 준 모든 것_, _도쿄에서 산 모든 것_ 한 번에 조회 가능.

**D4 — Memory note edit history 보존**

`noteHistory` 가 _수정 시점마다_ snapshot. 5년 후 _그때 어떻게 적었나_ 볼 수 있음. _10년 도구_ 관점의 구체.

**D5 — Smart filter 는 _명시적 규칙_ 만**

algorithm score 기반 정렬 _없음_. 사용자가 정한 _date range / tag / medium / state_ 조건만. _No algorithm_ 약속의 데이터 모델 강제.

---

## 9. Deep Modules — 7개 테스트 가능 단위

### Module 1 — **InventoryCore** (Item · Manifestation · Memory · Collection)

- 외부 인터페이스: CRUD on Item · Memory · Collection. 검색·필터·정렬.
- 캡슐화: SwiftData persistence, manifestation grouping, smart filter evaluation (_명시적 규칙만_), full-text search (no scoring), dedup.
- TDD 적합도: ★★★ (순수 데이터 모델)
- **Implementation status (2026-05-21)**: ✓ implemented — 4 SwiftData entities (Item / Memory / Collection / Attachment) + 5 service actors (Library / Export / Capture / Timeline / ServiceError) + 71 SPM unit tests PASS (R4 `f15da22`)

### Module 2 — **MetadataResolver** (외부 메타데이터 lookup)

- 외부 인터페이스: `resolve(query, mediumHint) → ResolvedMetadata?`
- 캡슐화: Open Library / Google Books / MusicBrainz / TMDB / Wikipedia fallback chain, 로컬 캐싱, _사용자 식별 비송신_ 강제, rate limiting.
- TDD 적합도: ★★★ (mock URLSession)
- **Implementation status (2026-05-21)**: ✓ partially implemented — BookMetadataLookup actor (Open Library) + 9 serialized tests PASS (Sprint 1.2, R6 `fb21a15`). Music / Movie / Object resolvers deferred to v0.5.

### Module 3 — **CaptureFlow** (3-second capture)

- 외부 인터페이스: `startCapture() → CaptureSession`
- 캡슐화: AVFoundation 바코드, VisionKit OCR, 위치 자동 (CoreLocation), 날짜 now, 음성 메모 (Speech framework on-device).
- TDD 적합도: ★★ (integration)
- **Implementation status (2026-05-21)**: ✓ implemented — CaptureSheet + Manual mode + state machine (Sprint 1.1) + BarcodeCaptureView + AVCaptureSession (Sprint 1.3) + VoiceMemoCaptureView + SFSpeechRecognizer (Sprint 1.4) + AddMemoryView (Sprint 1.6). All three capture modes live (R6-R8).

### Module 4 — **IntimateShare** (1-to-1 의도된 공유)

- 외부 인터페이스: `share(collection, recipient, scope, expiry?) → ShareURL`, `revoke(shareID)`, `accept(URL)`
- 캡슐화: CKShare 생성, 권한 boundary 강제, 사적 메모 필터링, 만료 자동 회수.
- TDD 적합도: ★ integration
- **Implementation status (2026-05-21)**: ✗ deferred to v1.5 (post-launch) — iCloud auth gate wired in R10 (`1ab295d`); CKShare implementation pending CloudKit Container provisioning by user.

### Module 5 — **SlowInventoryQuery** (algorithm-free)

- 외부 인터페이스: `query(filter, sortBy)` — _filter / sort 모두 명시적 enum_, 자유 search ranking _없음_.
- 캡슐화: 명시적 필터 조합, 사용자 지정 정렬 키 (title / date / medium / recent memory).
- TDD 적합도: ★★★ (순수 query)
- **Implementation status (2026-05-21)**: ✓ implemented — search + sort + filter in LibraryListView (Sprint 1.5, R7 `8400374`); backed by InventoryService explicit query API (R4).

### Module 6 — **TimeTravel**

- 외부 인터페이스: `snapshot(at: Date)`, `addedIn(year/month/place)`, `anniversary(of: itemID)`
- 캡슐화: Memory history 기반 시점 재구성, anniversary 알림 (opt-in only).
- TDD 적합도: ★★★
- **Implementation status (2026-05-21)**: ✓ partially implemented — MemoryTimelineView with 1pt rail + year groups (Sprint 1.5, R7 `8400374`). Full anniversary / snapshot API deferred to v0.5.

### Module 7 — **ImportExport** (data sovereignty)

- 외부 인터페이스: `import(source) → ImportResult`, `export(format) → ExportResult`
- 캡슐화: Goodreads/Letterboxd/Discogs CSV, Apple Music (MPMediaQuery), Kindle (수동), JSON/CSV/PDF export, dedup, schema migration.
- TDD 적합도: ★★★
- **Implementation status (2026-05-21)**: ✓ partially implemented — ExportService actor in InventoryCore (R4 `f15da22`); Export UI in Settings (R7 `8400374`). Full CSV import (Goodreads/Letterboxd/Discogs) deferred to v0.5.

---

## 10. Pricing & Business Model

### 10.1 모델

- iOS / macOS App Store **paid one-time**
- _없음_: 인앱 결제 / 구독 / 광고 / pro tier / freemium
- _전 기능 unlock from purchase_

### 10.2 가격 ladder

| 시점 | 가격 | 트리거 |
|----|----|----|
| Launch (v1.0) | **$14.99** | _즉시 paid_, free tier 없음 |
| Launch + 6 months | $19.99 | NPS 50+ / refund < 2% / paid 500+ |
| v2.0 (Mac native) | $24.99 (또는 iOS+Mac bundle $29.99) | premium positioning |

### 10.3 _왜 $14.99_

- Tot $20 paid one-time (Apple-native premium) 검증
- Library Thing $25 lifetime (책만, 20년 운영) 검증
- 레포브 ₩29,000 lifetime (한국 1.5년차) 검증
- Day One Silver $49.99/yr → 5년 사용 시 $250 → 우리 $19.99 는 _10× 가치_ 명확
- Are.na $7/mo = $84/yr → 5년 $420 → 우리 _훨씬 비싸도_ premium 진입 정당

### 10.4 _기존 구매자 영구 무료 업그레이드_

가격 인상 시점에 _신규 구매자만_ 적용. _v1 구매자_ 는 v2 / v3 / ... 영구 무료 업그레이드. 가격 인상 _사전 공지 없음_ (자연스러운 전환).

### 10.5 환불 정책

App Store 표준 (Apple 자동). 별도 환불 채널 _없음_. _Forever Clause_ 약속이 환불 사유로 충돌하지 않도록 marketing 카피 _보수적_ 유지.

---

## 11. Out of Scope — 명시적 제외

### 11.1 영구 X (Promise 위반)

- Public profile / follow / like / comment / star ranking
- 알고리즘 추천 / 자동 분류 / 자동 요약 (AI 보조 = OCR / 이미지 인식만 OK)
- 인앱 결제 / 구독 / 광고 / 데이터 판매
- 마켓플레이스 / 구매·판매 / 가격 추적 / 자산 평가
- 자동 consumption tracking (Last.fm 식)
- 완성도 게이지 / 진척률 / 뱃지 / 어차치브먼트
- Android 버전
- Web 앱 (Apple-native first 유지)
- LLM Daily Chat (Day One Gold 패턴)

### 11.2 v1.0 에서 제외 (v2.0+ 이월)

- Mac native (v2.0)
- 위젯 (v1.x)
- Apple Watch (v2.0+)
- Vision Pro (v3.0+)
- Spotify OAuth (v2.0+, 식별 송신 disclosure 필요)
- Discogs lookup (v2.0+, marketplace 의존 X)
- Apple Music 깊은 통합 (v2.0)
- 알림 (대출 만기·anniversary) — default OFF 보장 후 (v1.x)
- _그룹_ 컬렉션 (3+ 명 공유) — v2.0+ 검토
- 재귀 Collection nesting (Are.na 패턴) — v2.0+ 검토
- 사용자 정의 medium (v1.x)

### 11.3 v1.0 medium 범위

**v1.0 포함 (typed)**:
- Book (종이 + Kindle + 오디오북)
- Music (LP + CD + Spotify + Apple Music)
- Movie (DVD + 스트리밍 + 영화관)
- Object (만년필 / 도자기 / 사진집 / 의류 / 향수 / 카메라 / 시계 / 와인 / 위스키 등 generic)

**v1.x 추가 검토**:
- Place (가본 곳·기억의 공간)
- Experience (콘서트·공연·여행·전시)

**v2.0+**:
- Wine / Whisky (전용 medium)
- Game (board + video)
- Comic / Manga
- Tea / Coffee

---

## 12. Open Questions — 사용자 결정 사항 (7개)

### 12.1 Naming

1. **정식 명칭**? 시장 데이터·persona·약속 정신 기반 후보 (zero-base):
   - **Vestige** (흔적·잔영) — slow + memory, 시적
   - **Atelier** (작업실) — 큐레이션 + premium 톤
   - **Still Hours** (호기심 + 진열장 이중 의미)
   - **Reliquary** (성물함) — heritage + memory, 약간 무거움
   - **Trace** — 기록·자취, 단순
   - **Lineage** — 계보, heritage 함의
   - **Memento** — 기념물
   - **Cabinet** — 진열장, 클래식
   - **Anchor** — 기억의 닻 (Item-as-anchor 정합)
   - **Tides** — 시간과 자산
   - **Cinder** — 흔적·잔재
   - **Archive** (대문자) — 정직, 가장 단순

### 12.2 Scope / Roadmap

2. **v1.0 시점**? 시장 진입 calendar 권고? 2026 Q4 / 2027 Q1 / 2027 Q2 ?
3. **v1.0 medium 범위 확정** — 4 typed (책·음악·영화·물리) vs 2 typed (책·음악) MVP 권고 (DEVPLAN §3 참고)

### 12.3 Brand surface

4. **Editorial layer 도입 시점** — v1.0 launch _즉시_ Manifesto 페이지 + 출시 글 vs v1.x 시점 ?
5. **Founder voice 노출 수준** — Are.na 패턴처럼 인터뷰 적극 노출 vs 단순 정적 페이지만 ?

### 12.4 Pricing

6. **Launch 가격 확정** — $14.99 vs $9.99 (lower entry) vs $19.99 (higher signal) ?

### 12.5 Risk

7. **사전 advisory 호출 여부** — Branding / Marketing / Strategy / UX 4-panel 사전 검토 ?

---

## 13. Success Criteria — 6개월 / 1년 / 3년

### 13.1 6개월 시점

**Healthy**:
- Paid downloads: 300+
- App Store rating: 4.5+
- Refund rate: < 2%
- 7-day retention: 60%+
- _자발적 외부 추천_ (Twitter / 블로그) 10+ 사례

**Quit**:
- Paid downloads: < 100 → 시장 가설 재검토

### 13.2 1년 시점

**Healthy**:
- Paid downloads: 2,000+
- 30-day retention: 40%+
- 사용자 컬렉션 평균 100+ items (실사용 증거)
- Editorial Manifesto / 인터뷰 1건 출간

**Quit**:
- 30-day retention: < 25% → 차별 부족 인정

### 13.3 3년 시점 (10년 도구 mid-checkpoint)

**Healthy**:
- Paid downloads: 10,000~30,000
- 5조항 + Subtraction Clause + Data Sovereignty Clause _모두 유지_
- v2.0 Mac native 출시 완료
- App Store features (Indie Spotlight 등) 1회 이상
- 사용자 자발적 추천 100+ 사례

**평가 시점**: 3년 retro. _계속 / 일몰 / 정체성 재정의_ 결정.

---

## 14. Brand Surface — _문구 시안_

PRD 의 _carrier_. 정확한 문구는 design 단계에서 다듬되 _톤_ 명시.

### 14.1 App Store 첫 줄 (subtitle 후보)

| Locale | 시안 |
|--------|----|
| 한국어 | "가진 것보다, 의미를 기록한다." |
| English | "Less about what you own. More about why it stayed." |
| 日本語 | "持っているもの、より、なぜそばに置いたか。" |
| 中文 | "拥有不是终点 —— 是记忆的开端。" |

### 14.2 Manifesto 페이지 첫 문단 (한국어 시안)

> 우리는 _가진 것의 양_을 자랑하지 않습니다.  
> 우리는 _가지게 된 이유_를 기억합니다.  
>  
> 알고리즘이 정렬하지 않습니다.  
> 광고가 끼어들지 않습니다.  
> AI 가 당신을 판단하지 않습니다.  
> 공개 피드는 없습니다.  
>  
> 당신의 손으로, 당신의 속도로, 당신이 정한 사람에게만.  
> _느린 컬렉션의 자리_.

### 14.3 Sober 톤 규칙

- 느낌표 _없음_
- 시적 동사 _절제_ (들었습니다 / 다듬다 X)
- 사실·행동 위주
- _Are.na 의 _take business personally_ 정신_ 차용

---

## 15. 다음 단계 (PRD → 실행)

1. **§12 Open Questions 7개 사용자 결정** (1-2시간)
2. **Naming 확정** + 신규 private repo 생성 + Apple Developer 신규 bundle ID
3. **DEVPLAN.md** 검토 + MVP 시작 시점 확정
4. **Standard 4-panel advisory** 호출 (Branding / Marketing / Strategy / UX) — Open Question #7 ✓ 인 경우
5. **본인의 Are.na / Day One / Listy / Letterboxd 1-2주 실사용** — felt-sense 수집
6. **v0.1 (MVP) scope freeze** → 코드 시작

본 PRD 는 _living document_. 1차 사용자 실사용 + Advisory 결과 후 v1.1 revision.

---

## 16. v1.5 Adjustments — User Decisions 2026-05-20 (Supersedes v1.0)

본 섹션은 _supersedes v1.0_. 사용자 4결정 반영. 위 §0~§15 의 _v1.0 baseline_ 은 history 보존 유지.

### 16.1 확정된 결정

| # | 항목 | v1.0 baseline | **v1.5 confirmed** |
|---|----|------------|---------------|
| 1 | Naming | TBD (11 후보) | **Still Hours** (호기심 + 진열장) |
| 2 | Launch 가격 | TBD ($14.99 권고) | **$14.99 paid one-time** (free tier 없음) |
| 3 | v1.0 MVP scope | TBD (2 vs 4 medium) | **4 medium MVP** (책+음악+영화+물리) |
| 4 | Promise 5조항 | lint 강제 | **모두 허용** (lint 강제 _제거_) |
| 5 | Editorial Manifesto | v1.0 즉시 surface | **만들지 않음** — _제품으로만 증명_ |

### 16.2 정체성 변화 — 8축 ◎ → **4축 ◎**

Promise 5조항 lint 강제 _제거_ + Manifesto _안 만듦_ 결정으로 차별 자리 _축소_:

**유지되는 4축** (이 4개는 _제품 데이터 모델_과 _구체 동작_으로 증명):
1. **Item-as-memory-anchor** (Day One 역방향 데이터 모델)
2. **다중 미디어 typed × work/manifestation** (Discogs 패턴 + 다중 도메인)
3. **1-to-1 의도된 공유** (CKShare 기반, public profile 없음 default)
4. **Apple-native iOS first** (Apple HIG 충실 + ecosystem 깊이)

**약화된 4축** (제품 _default_ 는 절제, _필요 시_ 사용 가능):
5. _No algorithm_ → _default 명시적 enum 정렬_. v1.x 사용자 신호 보고 _smart sort 옵션_ 검토 가능
6. _No feed_ → _default 없음_. v2.0+ 사용자 _opt-in feed_ 검토 가능
7. _No AI judgment_ → _default 안 함_. AI 보조 (OCR / 이미지 인식) _적극 활용_, _자동 판단_ 은 v1.x+ 사용자 명시 opt-in 옵션
8. _No subscription_ → _v1.0 paid one-time_. v1.x+ _Pro tier_ 검토 가능 (사용자 신호 + 운영비 분석 후)

### 16.3 §5 The Promise → The Approach (이름 + 정신 변경)

기존 _영원히 하지 않는 5조항_ → 새 _v1.0 default 원칙 + v1.x+ 옵션 가능_:

| 영역 | v1.0 default | v1.x+ 옵션 가능 |
|----|----------|--------------|
| 광고·트래커 | 외부 트래커·픽셀 _없음_ | (영구 유지 권고) |
| 데이터 판매 | _없음_ | (영구 유지) |
| 결제 | Paid one-time only | Pro tier 검토 가능 |
| 정렬 | 명시적 enum (title / date / medium / recent memory) | Smart sort 옵션 가능 |
| 추천 | _없음_ | _Suggested for you_ 옵션 가능 (opt-in) |
| AI 보조 | OCR / 이미지 인식 _적극_ | AI 자동 정리 / 요약 _opt-in_ 가능 |
| 공개 피드 | _없음_ default | _Public link_ 옵션 가능 |
| 데이터 주권 | CloudKit Private DB only | (영구 유지) |
| Export | JSON / CSV / PDF 영구 | (영구 유지) |

→ Forever 제약은 _개인정보 / 데이터 주권_ 둘만 _strict_. 나머지는 _v1.0 default_ + _evolution path_ 열림.

### 16.4 §11 Out of Scope 재정의

v1.0 _제외_, _영구 제외_ 분리:

| 영역 | 분류 | 비고 |
|----|----|----|
| 광고 / 외부 트래커 | 영구 X | 사용자 신뢰 핵심 |
| 데이터 판매 | 영구 X | 데이터 주권 |
| Public profile / follow | v1.0 X | v2.0+ _opt-in_ 검토 |
| 알고리즘 추천 / 자동 분류 | v1.0 X | v1.x+ _opt-in_ 옵션 |
| AI Daily Chat (Day One Gold 패턴) | v1.0 X | _재검토_ 가능 (사용자 신호 후) |
| 구독 | v1.0 X | v1.x+ Pro tier 검토 가능 |
| 마켓플레이스 | 영구 X | Forever Clause _최소 영역_ 만 |
| Android / Web | 영구 X | Apple-native first 유지 |

### 16.5 §12 Open Questions 축소

10개 → **6개** (4 결정 closed):

1. ~~Naming~~ → **Still Hours**
2. ~~Launch 가격~~ → **$14.99**
3. ~~v1.0 MVP medium~~ → **4 medium**
4. ~~Promise 5조항~~ → **모두 허용 (default 절제, 옵션 가능)**
5. ~~Manifesto~~ → **안 만듬, 제품으로 증명**

_남은_ 결정 (advisory 검토 후):
- v1.0 Editorial 대체 brand surface (Twitter / blog founder voice 만? 또는 더?)
- 4 medium MVP burnout mitigation 구체화 (DevPlan §4.3 강화 또는 scope 단계 분리?)
- v1.x+ Pro tier _구체 검토_ 시점
- Advisory 후 추가 사용자 결정 항목

### 16.6 §14 Brand Surface 수정

Manifesto 페이지 _제거_. 단 _제품 자체 카피_ 4 locale 시안은 _App Store metadata + UI 키 string_ 으로 _유지_:

| Locale | App Store Subtitle 시안 |
|--------|----------------------|
| 한국어 | "가진 것보다, 의미를 기록한다." |
| English | "Less about what you own. More about why it stayed." |
| 日本語 | "持っているもの、より、なぜそばに置いたか。" |
| 中文 | "拥有不是终点 —— 是记忆的开端。" |

→ _카피만_, _Manifesto 페이지 없음_. _제품 자체_ 가 _주장_.

### 16.7 차별 강도 재평가

| 시장 진입 차원 | v1.0 baseline | v1.5 confirmed |
|------------|------------|-------------|
| 차별 자리 명확성 | ●●●●● (8축 ◎) | ●●●○○ (4축 ◎) |
| Burnout risk | ●●●○○ (5조항 lint + Manifesto + 2 medium) | ●●●●○ (4 medium + 옵션 path 확장) |
| Marketing 메시지 sharp 강도 | ●●●●● (Forever Clause-strict) | ●●●○○ (제품 동작으로 증명) |
| 시장 evolution 유연성 | ●●○○○ (Forever lock) | ●●●●● (옵션 path 다 열림) |
| 사용자 신뢰 신호 | ●●●●● (명시적 약속) | ●●●○○ (default 절제만) |
| Solo dev 운영 부담 | ●●●○○ | ●●●●○ (4 medium = 1.5×) |

→ _제약 자체_가 _브랜드 자산_ 이었던 차원이 _약화_. _제품 동작 quality_ 가 _브랜드 자산_으로 _대체_되어야. 즉 _UI/UX/디자인 quality_ 가 _훨씬 더 critical_. (사용자 6-panel advisory 에 UI / Design 명시한 이유 정합)

---

_End of PRD v1.5._

---

## 17. v1.7 Adjustments — Apple-native 최신 디자인 원칙 적용 (2026-05-20)

본 섹션은 _supersedes v1.5_. 사용자 지시 (2026-05-20): _애플 전용 앱으로 만들 것이기에 Swift native 고려 및 Apple 디자인 원칙 적용 (현재 제일 최신의)_. 2026-05 시점 _진짜 최신_ Apple 디자인 원칙 (iOS 26 / Liquid Glass / SwiftUI 26 / SF Symbols 7) 채택 명시.

### 17.1 Apple 최신 OS 명명 (year-based, WWDC 2025 통일)

Apple 은 2025-06 WWDC 에서 _OS 명명 year-based 통일_:

| Platform | Version |
|----------|---------|
| iOS | **iOS 26** |
| iPadOS | **iPadOS 26** |
| macOS | **macOS Tahoe 26** |
| watchOS | **watchOS 26** |
| tvOS | **tvOS 26** |
| visionOS | **visionOS 26** |

→ Still Hours v1.0 deployment target 명명 _iOS 26_ (v1.5 의 "iOS 17+" 대체).

### 17.2 Liquid Glass design language 채택

Apple Liquid Glass (2025-06 WWDC 발표, iOS 26 / iPadOS 26 / macOS Tahoe 26 / watchOS 26 / tvOS 26 / visionOS 26 통합) 채택. 핵심 특징:

- **Translucent / refractive** — 유리의 광학적 품질 (굴절·반사)
- **Specular highlights** — 시각적 깊이감
- **Dynamic response** — motion / content / inputs 에 반응
- **Layered app icon system** — visionOS / tvOS 패턴 차용
- **Glass shimmer** — device motion 반응

Curium 의 _Curio cabinet (호기심의 진열장)_ metaphor 와 Liquid Glass _translucent depth_ 는 _개념 정합도 ●●●●●_. _진열장 안의 자산_ 이 _글래스 표면 너머_ 로 보이는 시각 metaphor 자연.

### 17.3 SwiftUI 26 features 적극 활용

WWDC 2025 발표 SwiftUI 26 new APIs:

| API | 활용 위치 |
|----|------|
| **@IncrementalState** | Library Grid 1000+ items 의 fine-grained state tracking — Engineer R6 권고 (1000-item 60fps) 의 _native 해결_ |
| **ToolbarSpacer** | Capture / Library / ItemDetail toolbar의 _Apple HIG 정합_ 그룹화 |
| **Native WebView** | (v2.0+ 검토) Memory note 의 markdown preview, 외부 link preview |
| **향상된 TextEditor** | Memory note markdown 입력 — _swift-markdown SPM dependency 불필요_ 가능 |
| **Chart3D** | (검토) Time Travel 시각화의 시간 × medium × count 3D 표현 — _데이터 시각화 차별_ 가능 |

→ SwiftUI 26 features _v1.0 부터_ 활용. _SwiftPM external dependency 최소화_ 정책 정합.

### 17.4 App Icon = Liquid Glass Layered System

UI advisor 권고 (Wunderkammer cabinet metaphor, burnt sienna `#B85C38` 배경 + 백색 선묘) 와 _Liquid Glass layered_ 합성:

| Layer | 내용 |
|-------|----|
| Background layer | Burnt sienna `#B85C38` glass material |
| Middle layer | 백색 선묘 cabinet 문틀 (refractive edge) |
| Foreground layer | 4개 미세 오브제 실루엣 (Book / Music / Movie / Object), specular highlight |
| Motion response | device tilt 시 cabinet 안 오브제 _수평 shift_ — _cabinet 안을 들여다보는_ 효과 |

→ App icon _자체_ 가 _Still Hours = 호기심의 진열장_ 컨셉의 _Liquid Glass_ 표현. App Store 첫 인상 + Home Screen 모든 상태에서 작동.

### 17.5 SF Symbols 7 활용

iOS 26 동시 출시 _SF Symbols 7_ (6,900+ symbols, Liquid Glass 정합).

- **Memory kind 7가지 icon**: UI advisor R2 권고 (book.closed / headphones / film / person.badge / gift / arrow.uturn / pencil.line) 모두 SF Symbols 7 검증 가능
- **Medium typed badge**: Book / Music / Movie / Object 4 medium 의 SF Symbol mapping
- **Tab bar / Navigation**: 전부 SF Symbols 7 (custom icon 0 시작점)

→ SF Symbols 7 _v1.0 baseline_, custom icon 도입은 _10× 가치 통과 시만_.

### 17.6 Apple Design Resources 26 Figma/Sketch 활용

Apple 공식 _iOS 26 / iPadOS 26 / macOS Tahoe 26 design kit_ (Figma/Sketch, 2026-04-03 업데이트) 다운로드 + _Still Hours design tokens 1차_ 의 _baseline_ 으로 활용.

Pre-flight Week 1 task 추가:
- Apple Design Resources iOS 26 Figma 파일 download
- SF Symbols 7 macOS 앱 install
- Liquid Glass Material reference 학습

### 17.7 Apple Intelligence / Visual Intelligence 결정

iOS 26 _Visual Intelligence_ 가 _baked-in_ — 스크린샷으로 시각 검색.

Still Hours 정합도 평가:
- _Visual Intelligence_ = _Apple OS 레벨_ 서비스, 우리 앱이 _호출_ 하는 게 아님 → Promise §5.4 (No AI judgment) _위반 아님_
- _옵션_ : Visual Intelligence 결과 → Still Hours Item 후보 _import path_ 검토 가능 (v1.x)
- v1.0 default _안 함_

### 17.8 deployment target 결정 사항 (사용자 결정 필요)

iOS minimum 선택:

| 옵션 | 장점 | 단점 |
|----|----|----|
| **iOS 26 only** | Liquid Glass full / SwiftUI 26 features 전부 / 개발 단순 | 2026-05 채택률 추정 60-80%, iOS 25 이하 사용자 진입 불가 |
| **iOS 25/26 dual** | 더 많은 사용자 진입 가능 | UI 분기 가능, 일부 SwiftUI 26 features (@IncrementalState 등) 제한 |
| **iOS 17.5+ (v1.5 baseline)** | 가장 많은 사용자 진입 | _최신 디자인 적용_ 사용자 지시와 _부분 충돌_ |

**v1.7 권고 (사용자 지시 _최신 적용_ 정합)**: **iOS 26 only**. _Premium positioning + 최신 디자인 channel_ 한 번에 신호. 2027 Q1 launch 시점이면 iOS 26 채택률 75-85% 추정.

### 17.9 Tech Stack 업데이트 (DEVPLAN §1.1 supersede)

| 선택 | v1.5 | **v1.7** |
|----|------|------|
| iOS minimum | iOS 17.5+ | **iOS 26 (사용자 결정 권고)** |
| Xcode | Xcode 17+ | **Xcode 26+ (Liquid Glass auto)** |
| SwiftUI | SwiftUI iOS 17 baseline | **SwiftUI 26 + new APIs** |
| SF Symbols | SF Symbols 5+ | **SF Symbols 7 baseline** |
| Design Resources | OYL 차용 X (독립) | **Apple Design Resources 26 + Still Hours 독립 tokens** |

### 17.10 PRD §14 Brand Surface 시안 _Liquid Glass 정합 추가_

기존 4 locale App Store subtitle 시안 유지. 단 _Liquid Glass 표현_ 추가 가능:

| Surface | Liquid Glass 표현 |
|--------|---------------|
| App icon | Layered glass cabinet (§17.4) |
| Library Grid 카드 | Item card 의 _refractive edge_ (Apple Liquid Glass 자동 적용) |
| Memory timeline | timeline connector 의 _specular line_ |
| Settings → "Still Hours is" | _semi-translucent material_ (Apple default 활용) |

---

_End of PRD v1.7._

---

## 18. v2.0 Final — 32 결정 통합 (2026-05-20)

본 섹션은 _supersedes v1.7_. Tier 1 Round 1+2 (8) + Tier 2 (6) + Tier 3 (5) + Tier 4 (4) + Tier 5 (9) = **32 결정** 통합 최종 확정.

사용자 결정 방식: Tier 1 = AskUserQuestion 2 round 직접 결정, Tier 2-5 = _"가장 정공법"_ 일관 답변 = Advisory 권고 default + 가장 적극적/철저한 옵션 자동 채택.

### 18.1 Tier 1 (Round 1+2) — 직접 결정 8개

| # | 항목 | 결정 |
|---|----|----|
| T1.1 | MVP scope | **Tracer Bullet 순서**: Book full (v0.1) → Music full (v0.1.5) → Movie basic (v0.2) → Object basic (v0.3) |
| T1.2 | Quit criteria | **자체 없음 + monthly advisory 검토** |
| T1.3 | 8 locale launch | **3-stage soft launch**: Wave 1 ko/en/ja → Wave 2 zh/de → Wave 3 fr/es/pt |
| T1.4 | Promise lint 추가 | **No subscription IAP** 코드 강제 (StoreKit Subscription/recurring keyword 차단) |
| T1.5 | Pre-flight 범위 | **36h** (Foundation tokens + App icon 시안 + typography + palette + iOS 26 학습 + SF Symbols 7 + Liquid Glass material + Memory timeline design pass) |
| T1.6 | Trademark 점검 | **Pre-flight Week 1 즉시** (KIPRIS + USPTO Class 9 + EUIPO + App Store 동명 앱 전수 조사) |
| T1.7 | iPad 지원 | **iPadOS 26 native v1.0 default** (Universal app, SwiftUI multiplatform single target) |
| T1.8 | iOS minimum | **iOS 26 only** (Liquid Glass full + SwiftUI 26 API + 단순 stack) |

### 18.2 Tier 2 (Pre-flight 안) — 자동 결정 6개

| # | 항목 | 결정 (UI/Design 권고 default) |
|---|----|----|
| T2.1 | Typography | **System-only (SF Pro + New York)** — Apple system serif (New York iOS 17+ 지원), 외부 폰트 도입 안 함. CJK locale 시스템 폰트 자동 (Apple SD Gothic Neo / Hiragino / PingFang) |
| T2.2 | Color palette | **Still Hours 6색 + Dark mode 4색** (UI 권고). Light: background `#F5F0E8` warm parchment / surface `#FAFAF5` / text-primary `#1A1812` / text-secondary `#7A7060` / accent `#B85C38` burnt sienna / accent-muted `#D4A574`. Dark: background `#141210` / surface `#1E1B17` / text-primary `#F0EBE1` / accent `#D4734A` |
| T2.3 | 4 medium accent | **Single-accent baseline** (burnt sienna), medium-별 다름은 v0.5 Pre-flight 비교 시안 후 결정 (Design Q2 권고) |
| T2.4 | Item Card 종횡비 | **3:4 portrait fixed** — Book cover 표준, Music/Movie/Object 는 center-crop + letterbox (medium-color accent strip 활용) |
| T2.5 | Memory kind 시각 | **Icon + medium-shared accent line** (UI R2 권고). SF Symbols 7: acquired (`book.closed`) / read (`text.book.closed`) / listened (`headphones`) / watched (`film`) / lent (`arrow.uturn.left`) / received (`arrow.down.left.square`) / gifted (`gift`) / annotated (`pencil.line`). 색은 _kind별_이 아니라 _medium별_ |
| T2.6 | App icon | **Wunderkammer cabinet + Liquid Glass layered** (UI R7 + 17.4 권고). Background layer: burnt sienna `#B85C38` glass material. Middle: 백색 선묘 cabinet 문틀. Foreground: 4 미세 오브제 (책/음표/필름/점). Motion: device tilt 시 오브제 horizontal shift |

### 18.3 Tier 3 (v0.1 시작 전) — 자동 결정 5개

| # | 항목 | 결정 (Engineer 권고 default) |
|---|----|----|
| T3.1 | SwiftData @Model v0.1 minimum | **4 entity** (Item + Memory + Collection + Attachment). Manifestation / Loan / Contact / Place / Share = v0.5 도입 |
| T3.2 | VersionedSchema | **첫 schema 부터 적용**. `Schema(versionedSchema: SchemaV1.self)` + `SchemaMigrationPlan`. v0.5 시점 의미 없는 schema bump 1회 시뮬레이션 검증 |
| T3.3 | iOS minimum (T1.8과 정합) | **iOS 26 only** (이미 결정) |
| T3.4 | MetadataResolver MVP matrix | **Book = Open Library only / Music = 수동 입력 only / Movie = TMDB only / Object = 수동 only** (v0.1). 4 medium × 5 source 풀 통합은 v0.5+ |
| T3.5 | Memory timeline design pass | **별도 8-12h 분리** (Design A2 권고). ItemDetailView 10h 작업과 _독립_ design pass. App Store screenshot 1번 슬롯 |

### 18.4 Tier 4 (v0.9 전) — 자동 결정 4개

| # | 항목 | 결정 (Engineer / UX 권고 default) |
|---|----|----|
| T4.1 | CKShare test environment | **별도 iCloud account 확보**. v0.9 단계 _intentional 2 different Apple ID_ 시뮬레이터 + 실 device 검증 필수. _못 확보 시 IntimateShare v1.0 이월_, v1.0 = share 없는 베타 (Engineer Q1 권고) |
| T4.2 | Onboarding 3-step | **4축 시각화 순서** (UX R5 권고). Screen 1: Item-as-memory anim (빈 Item card에 Memory 붙는 애니메이션, 단 1개). Screen 2: 4 medium typed (Book/Music/Movie/Object 4 card 나란히). Screen 3: 1-to-1 share (Share sheet "공개 프로필 없음, 한 사람에게만" 카피) |
| T4.3 | Empty Library state | **v0.1 scope 명시** (UI W3 권고). 텍스트 단독 + 단일 라인 서브 카피. "처음 자산을 추가하면 기억의 입구가 열립니다" (브랜드 정합 톤). 일러스트 없음 |
| T4.4 | Settings → "Still Hours is" surface | **brand-loaded 의도 설계** (Design R6 권고). 3 섹션: (a) "Still Hours is" — 약속 3줄 (알고리즘 없음 / 공개 피드 없음 / 광고 없음), (b) Data Sovereignty — Export JSON/CSV/PDF + "당신의 데이터는 당신의 iCloud에만", (c) "Made by" — founder 이름 + 한 줄 bio + blog link |

### 18.5 Tier 5 (Open Question) — 자동 결정 9개

| # | 항목 | 결정 (Advisory 권고 default) |
|---|----|----|
| T5.1 | App Store description 톤 | **동작 묘사 위주** (Marketing Q1 권고). _철학 선언_ 회피. "자산이 기억의 입구입니다 → 3초 캡처 → 1-to-1 공유" 구체적 사용 시나리오 한 단락씩 |
| T5.2 | 한국 시장 위치 | **검증 시장** (Marketing Q3 권고). 첫 목표 시장은 _글로벌 영어 + 일본_ (Lina/Joon 페르소나 정합). 한국은 _레포브 4.8 평점 검증 환경_에서 차별 메시지 ROI 측정 |
| T5.3 | Brand drift 방어 mechanism | **monthly advisory 의무화** (T1.2 정합) + **lessons-learned doc 분기별 review** + **Promise 5조항 자가 검열 ritual** (3개월·6개월·1년 시점) |
| T5.4 | Day One item-anchored contingency | **12개월 안 30% 확률 가정**. _추가 차별 사전 준비_: (a) _스토리텔링 강도_ (Memory voice note + photo 첨부 friction 0), (b) _데이터 모델 깊이_ (Manifestation 다중 매체 통합, Day One 부재), (c) _Slow inventory 정신_ (Promise 약속) |
| T5.5 | Memory entry 시간 축 | **두 가지 모두 지원**. `Memory.date` (사용자 지정, _일어난 날_) vs `Memory.createdAt` (시스템, _추가한 날_). Timeline 정렬 = `date` 기준. _소급 추가_ entry는 timeline _과거 위치_에 삽입 (UX Q2 권고) |
| T5.6 | CKShare Android/non-Apple fallback | **v1.0 "Apple ecosystem only" 명시 제한** (UX Q1 권고). 받는 사람도 iOS/iPadOS/macOS Apple ID 필요. v1.x+ 정적 read-only 웹 페이지 (CloudKit Public DB 경유) 검토 |
| T5.7 | 베타 5-10명 모집 path | **3-channel 조합** (Marketing 권고): (a) personal network 2-3명 (가장 trusted), (b) Threads 한국 indie 디자이너 커뮤니티 2-3명, (c) 일본 indie 앱 매체 + Substack newsletter 필자 1-2명 |
| T5.8 | Apple editorial outreach | **v1.0 launch week 체크리스트 포함**. Apple "App of the Day" + "Indie Spotlight" + 한국 App Store team direct outreach + 일본 App Store team. 자동 form 외에 _personal email_ 시도 |
| T5.9 | Data loss event protocol | **4-step protocol**: (1) 자동 in-app notification + email, (2) Restore guide (iCloud Time Machine + Still Hours JSON export backup), (3) 사과 + 1년치 무료 업그레이드 보장 (v1 구매자 영구 무료 정책 강화), (4) lessons-learned doc 영구 entry + 자동 lint 추가 (재발 방지) |

### 18.6 32 결정 종합 영향

| 차원 | v1.7 baseline | **v2.0 final** |
|----|------|------|
| Pre-flight | 12h | **36h** |
| v0.1 MVP medium | 4 typed 동시 | **Tracer Bullet (Book full only)** |
| v0.1 effort | 150-200h | **명목 200-260h, 현실 280-380h** |
| iPad 지원 | v1.x | **v1.0 Universal app** |
| iOS minimum | 17.5+ | **iOS 26 only** |
| 8 locale launch | 동시 | **3-stage soft launch** |
| Quit criteria | 시장별 분리 | **자체 없음 + monthly advisory** |
| Promise lint | 2개 | **3개 (No subscription IAP 추가)** |
| Typography | TBD | **System-only (SF Pro + New York)** |
| Palette | TBD | **Still Hours 6색 + Dark 4색 확정** |
| Item Card 종횡비 | TBD | **3:4 portrait fixed** |
| Memory kind 시각 | TBD | **Icon + medium-shared accent line** |
| App icon 방향 | TBD | **Wunderkammer + Liquid Glass layered** |
| SwiftData entity v0.1 | 9개 가능성 | **4 entity (Item+Memory+Collection+Attachment)** |
| MetadataResolver MVP | 5 source 풀 | **Book Open Library / Movie TMDB만, 나머지 수동** |
| 8 locale launch wave 1 | 동시 | **ko/en/ja Wave 1 만 v1.0** |
| 한국 시장 | 첫 시장 가능 | **검증 시장** (Wave 1 모니터링 후 결정) |

### 18.7 v2.0 final timeline 추정

총 v0.1 → v1.0 launch:
- Pre-flight: 3주 (36h × 22h/week = 1.6주 × 1.5 buffer)
- v0.1 Tracer Bullet Book full: 4-5주 (Engineer 추정 + 1.3× learning curve)
- v0.5 Music full + CloudKit Sync + Metadata Movie TMDB: 5-6주
- v0.9 Object basic + IntimateShare + 8 locale Wave 1 (ko/en/ja): 5-6주
- v1.0 ASC submit: 2-3주

**총 19-23 weeks ≈ 4.5-5.5 months** (Pre-flight 36h + Tracer Bullet + Universal app 효율). v1.5 추정 4.5-6.5개월 + Tracer Bullet 약간 단축 + Universal 효율.

### 18.8 한 줄 요약 (v2.0 final)

> **Still Hours**, iOS 26 only + iPadOS 26 Universal + Liquid Glass + SwiftUI 26 + SF Symbols 7. **$14.99 paid one-time**. **Tracer Bullet** (Book → Music → Movie → Object). **3-stage soft launch** ko/en/ja → zh/de → fr/es/pt. **No subscription IAP 코드 강제**, 나머지 Promise 4조항은 default 절제 + 옵션 evolution path. **Manifesto 없음** — 제품 동작과 Settings "Still Hours is" surface로 증명. **Wunderkammer cabinet + Liquid Glass layered** app icon. **Burnt sienna** `#B85C38` 단일 accent + **warm parchment** `#F5F0E8` background. **Item-Memory 분리 데이터 모델 + 1-to-1 의도된 공유**가 4축 정체성. **Pre-flight 36h + v0.1 Tracer Bullet 4-5w + 총 4.5-5.5개월 v1.0 launch**. **Monthly advisory + Promise 자가 검열 ritual** = brand drift 방어. **22h/week 상한 엄격** = burnout 보호.

---

## 19. v2.1 Naming Change — Curio → Curium (2026-05-20)

Naming history:
- 2026-05-20 초기 가칭 _Curio_ 결정 (Tier 2 §18.2.6 자동 결정)
- 2026-05-20 Marketing P1 trademark 사전 점검 결과 _Curio_ App Store 다수 동명 앱 (Curio for Serious Collectors, Curio Save Things Worth Keeping, Curio Antique Identifier 등) 확인 → 시장 충돌
- 2026-05-20 4-panel Naming Advisory (Phase 1) + 사용자 brief _Collection + Curiosity + Universe 결합 어감_ → 3 후보 (Still Hours / Constella / Vaulta)
- 2026-05-20 4-panel Phase 2 토론 + Web verification → **Vaulta = EOS Network 2025-03 rebrand 직접 충돌 확정 폐기** + **Constella = AbbVie 의약품 trademark SEO 충돌** + **Still Hours 가장 안전**
- 2026-05-20 전문가 그룹 최종 결정 = **Still Hours** (평균 1.75위, Branding 1위 + 다른 3 panel 모두 2위)
- 2026-05-20 사용자 확인 _"Still Hours 으로 진행"_

Still Hours 어원 + 정체성:
- 화학원소 96번 (1944년 발견, Marie Curie 헌정)
- Curiosity 어원 (라틴어 curiositas → 호기심 → 큐레이션 → Curium)
- Wunderkammer / Curio cabinet metaphor 보존 (curiosity 의 원래 cabinet 의미 그대로 활용)
- 4 medium typed 컬렉션 = _과학자가 표본 수집_ 메타포

본 § 이후 PRD 전반의 _Curio_ 는 _Curium_ 으로 일괄 변경됨.

---

## 20. ASO Optimization (지속 과제)

> 사용자 instruction: "ASO는 우리의 지속 과제. 개발 단계부터 철저히 고려."

3-panel advisory (Marketing / Strategy / Design) 종합 결과.

### 20.1 전략 원칙

- ASO = _시작의 가속기, 지속 엔진 아님_. 북극성 지표 = 자발 추천 비율.
- Year 1-2: 자발 30% / ASO 70% → Year 5+: 자발 70% / ASO 30% 점진 전환.
- Still Hours 키워드 포지셔닝: "slow curation" 자기 카테고리 점유. Day One/journal 정면 충돌 회피.

### 20.2 App Store Metadata — Wave 1 (ko/en/ja) 시안

#### Subtitle (30자 이내)

| Locale | Subtitle | 자수 |
|--------|----------|------|
| en | A curator's personal archive | 28자 |
| ko | 책·음악·영화, 기억으로 정박 | 14자 |
| ja | 本·音楽·映画、記憶に刻む | 13자 |

#### Description 첫 단락 (3줄, 펼치기 전 표시)

| Locale | 첫 3줄 |
|--------|--------|
| en | Your books, records, films, and objects — with the story of how you found them. One purchase. No algorithm. No subscription — ever. |
| ko | 책, 음악, 영화, 오브제 — 그것을 만난 기억과 함께. 한 번 구입. 알고리즘 없음. 구독 없음 — 영원히. |
| ja | 本、レコード、映画、オブジェ — 出会いの記憶とともに。一度の購入。アルゴリズムなし。サブスクなし — 永遠に。 |

#### Keywords 시안

| Locale | Primary | Secondary | Long-tail |
|--------|---------|-----------|-----------|
| en | curator, collection, memory keeper | archive, library, slow curation | personal archive, memory journal, commonplace book |
| ko | 책 기록, 음악 라이브러리, 영화 수집 | 컬렉션, 기억, 아카이브 | 큐레이터 앱, 느린 컬렉션, 기억 보관 |
| ja | コレクション管理, 蒐集, スローキュレーション | アーカイブ, 記憶, ライブラリ | 個人アーカイブ, 記憶ノート, 収集管理 |

Still Hours (화학원소 96/radioactive/periodic table/chemistry) 검색 간섭 방지를 위한 organic keyword 선택 시 해당 용어 회피.

#### Promotional Text (170자, 심사 없이 update 가능)

> "No algorithm. No subscription. No AI judgment — ever. One purchase, owned for life. Your collection, your memory, your data."

#### Description 구조 (4000자 중 800-1200 사용)

1. 첫 단락 3줄 (펼치기 전 표시)
2. 중단선 `——` + Promise 5조항 dash list
3. 이모지 금지, HTML 불가 — 절제 자체가 차별화

### 20.3 Privacy Nutrition Label

"Data Not Collected" = ASO asset. 경쟁 앱 대비 명시적 차별화 요소. 라벨 유지가 Promise §5 이행의 증거.

### 20.4 Custom Product Pages (CPP) 3개

| Page | 타겟 | 핵심 장면 |
|------|------|----------|
| A — Lina (큐레이터) | 취향 중심 사용자 | Library Grid + Memory Timeline 감정 훅 |
| B — Joon (출장자) | 도시 탐방 사용자 | Tsutaya 도쿄 장면 + Capture 3초 flow |
| C — Book-only | Goodreads 이탈자 | Book medium 특화 + Promise 비교 |

CPP 3개 (Lina/Joon/Book-only) → Organic ASO 타겟별 메타데이터 최적화. Search Ads X.

### 20.5 Screenshot 8장 순서

| # | 장면 | 목적 |
|---|------|------|
| 1 | Memory Timeline | 감정 훅 |
| 2 | Story Capture 3초 | 핵심 UX 증명 |
| 3 | Library 4-tab | 전체 구조 |
| 4 | Promise 5조항 manifesto | 신뢰 구축 |
| 5 | Tsutaya 도쿄 장면 | 감성 맥락 |
| 6 | Collection 의미 묶음 | M:N 연결 |
| 7 | Intimate Share | 1-to-1 공유 |
| 8 | Data Sovereignty | 차별화 마무리 |

시각 일관성: 배경 `#F5F0E8` 단색 / 기기 frame iPhone 16 Pro 실버 / accent `#B85C38` 1요소만 / 상하 여백 20-24pt.

Wave 1: ko/en/ja × 8 = 24장 수동. Wave 2/3: xcodebuild test + simctl screenshot 자동화 (fastlane 미사용).

### 20.6 Preview Video 30초 (en 1개 Wave 1)

| 구간 | 내용 |
|------|------|
| 0-8s | Capture — 바코드 스캔 → 자동 메타 |
| 8-20s | Memory Timeline — 과거 기억 회고 |
| 20-30s | Promise 3조항 fade — No algorithm / No subscription / Data Sovereignty |

제작 도구: Rotato + QuickTime + iMovie (Wave 1, 6-8h).

### 20.7 Discovery 채널 (User Decision 2026-05-20: No advertisement — Apple Search Ads 포함 영구 X)

Apple Search Ads 포함 _모든 외부 광고 채널 영구 X_. 발견 채널 3가지만:

1. **Organic ASO** — Keyword / Subtitle / Description / Promotional Text / CPP 3개
2. **Editorial outreach** — App of the Day / Indie Spotlight / 한·일 press (콘텐츠 추천, ads 아님)
3. **Word-of-mouth** — 자발 추천 = 북극성 지표. Year 1-2 자발50% / Organic ASO50% → Year 5+ 자발80% / Organic ASO20%

### 20.8 ASO × Promise 충돌 해결 매트릭스

| Promise 조항 | ASO 행위 | 판정 |
|-------------|---------|------|
| No advertising | 앱 내부 광고 | 금지 |
| No advertising | Apple Search Ads | **영구 금지** (Promise §5.3 확장, 2026-05-20) |
| No AI judgment | Apple ML ranking | 허용 (외부 인프라, 앱 내 AI 아님) |
| Description | 4000자 중 800-1200 사용 | 허용 (절제) |
| Sober tone | PR outreach | 허용 (sober 톤 유지 시) |

### 20.9 Quit Signal 정량 기준 (6개월 시점)

다음 4개 중 3개 이상 동시 충족 시 제품 자체 재검토:
- (a) 3-month rating < 4.0
- (b) 누적 paid < 100
- (c) 30-day refund rate > 8%
- (d) DAU/MAU < 15%

ASO ritual (매월 1일 1시간) 과 advisory ritual 은 _분리_ 운영.

### 20.10 경쟁자 ASO 분석

| 경쟁자 | ASO 강도 | 대응 |
|--------|---------|------|
| Day One | journal/diary 강 점유 | 우회 — curator/collection 포지셔닝 |
| Are.na | 의도적 ASO 약함 | slow curation 카테고리 선점 |
| Listy | consumption tracking | framing 분리 |
| 레포브(ko) | ₩19,000 | 가격 비교 모니터링 권고 |

_User Decision 2026-05-20: No advertisement (Apple Search Ads 포함). Ads는 절대 옵션 아님._

---

## 21. v2.6 Naming Change — Curium → Still Hours (2026-05-20)

### 21.1 최종 채택

**Still Hours** — 영어 _Still + Hours_ 조합 (고요+지속 이중 의미 + 작은 시간 단위)

### 21.2 21+ 후보 누적 학습 (영구 보존)

다음 후보 모두 _점령/충돌_ 발견하여 폐기. 학습 영구 보존:

| # | 후보 | 폐기 trigger |
|---|----|----|
| 1 | Curio | App Store 시장 충돌 (Curio for Serious Collectors 등) |
| 2 | Vaulta | EOS Network 2025-03 rebrand 직접 충돌 |
| 3 | Constella | AbbVie 의약품 CONSTELLA® Class 5 |
| 4 | Curium | Curium Pharma 글로벌 핵의학 + SEO noise |
| 5 | Luminae | Celebrity Cruises 레스토랑 + App Store 동명 2개 |
| 6 | Aevum | Aevum Therapeutics + AEVUM 토큰 + Aevum Aerospace + JSTOR |
| 7 | Kuria | Kuria Therapeutics + kuria.app 선점 |
| 8 | Reliqua | LOBASA LTD. RELIQUA USPTO Class 5 |
| 9 | Own Collection | SEO 보통명사 포화 + Own- OYL 영향 |
| 10 | Own Your Collection | OYL family 직접 차용 (사용자 결정 충돌) |
| 11 | Ownbox | 5+ 실제 서비스 점령 (ownbox.webflow/.co.uk/GitHub/Amazon) |
| 12 | Otium | Otium Capital VC + App Store 7개 + 럭셔리 호텔 다수 |
| 13 | Own Gem | Own- 접두사 + Gem 일반어 SEO |
| 14 | Your Magnet | Mac App Store Magnet 1위 검색 혼선 |
| 15 | Heartlink | HeartLINK+ App Store + Heartlink Medical + HeartLink India 데이팅 |
| 16 | Your Journey | Journey® 등록 + App Store 6+ + yourjourney.com 캐나다 여행사 |
| 17 | Tidemark | US App Store Tidemark Productivity 앱 + 4 법인 분산 |
| 18 | Cairn | USPTO Class 9 등록 (FitClimb, 2014) + Steam 게임 + App Store 현역 |
| 19 | Reliquary | App Store Reliquary MTG 카드 앱 + USPTO Reliquary Project/Souls EAM |
| 20 | Sumi | Sumi Interactive Grid Diary 동일 카테고리 + 일본 문화 점령 |
| 21 | Mura | Mura SaaS $6M 시드 + Mura CMS + Lean 용어 SEO |
| 22 | Lumo | USPTO LUMO Class 42 등록 (2019) + Proton AG Lumo AI |
| 23 | Slow Shelf | Stellar Works 가구 brand Google 1-3위 점령 |
| 24 | Still Yours | Kid LAROI 1500만 스트림 + Bryson Tiller + 영화 + ornamental |
| 25 | Still Times | Still Time 밴드 + Karen Matheson 앨범 + Netflix 영화 + 일본 タイムズ 주차장 |

### 21.3 Naming Change 학습 패턴 (영구 명시)

- _라틴어·짧은 단어_ → pharma 회사 선호 (4/4 pharma 충돌)
- _보통명사 조합_ → SEO 포화 + USPTO descriptive 거절
- _복합어 신조어_ → -box / Own- 영역 이미 점령
- _Own / Your X_ → OYL family 차용 충돌
- _일본어 어원_ → 일본 문화·SaaS 점령
- _romance/관계 phrase_ → 음악·영화 점령 (Still Yours)
- _Times / Hours_ 시간 단위 → USPTO descriptive risk

### 21.4 Still Hours 최종 채택 근거

| 항목 | 결과 |
|----|----|
| 4 jurisdiction trademark | 등록 없음 |
| App Store 정확 명칭 | 없음 |
| 음악·영화·시 점령 | 없음 (Still Times·Still Yours와 차별) |
| Pharma/Crypto/Fintech | 없음 |
| USPTO descriptive | 50/50 — 변리사 의견서 ($300-500) 대비 |
| 이중 의미 | _고요 (stillness)_ + _여전히 (continuing)_ |
| 자문단 권고 | Branding 1위 (Still + X 계열 brainstorm Top 권고) |
| 사용자 brief 정합 | Collection ★★ / Curiosity ★★ / Universe ★★ / Life Journey ★★★★★ |

### 21.5 다음 step

- 변리사 의견서 의뢰 (USPTO descriptive 사전 평가) v1.0 launch 제출 주단 이월
- Bundle ID: `com.ownlifelab.stillhours`
- Repo: `noenemyx/still-hours-swift`
- 모든 master + repo 문서 _Curium → Still Hours_ 일괄 변경 완료

_End of PRD v2.6._

