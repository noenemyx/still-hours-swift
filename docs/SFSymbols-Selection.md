# SFSymbols-Selection.md — Still Hours

> Version 1.0 | 2026-05-20 | Design.MD §6.2/6.3 정합
> Memory Kind 8 + Medium 4 = 12 SF Symbols 확정 선택.

---

## 1. Memory Kind 8 — SF Symbol Selection

> 모두 SF Symbols 7 (Xcode 16+ / iOS 17+ 기준). Memory Timeline Icon 16pt, `accent.default` monochrome tint.

### 1.1 acquired — 자산 획득

| 항목 | 값 |
|------|-----|
| **Selected** | `shippingbox` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 3.0+ 도입, 7에서 유지 |
| Accessibility label | `"Acquired"` |
| Rationale | 택배 상자 = _구입해서 받는다_ 는 물리적 행위의 자연스러운 metaphor. book/music/movie/object 매체 종류를 초월한 _보편 획득_ 아이콘. `archivebox` 보다 가벼운 느낌. |

| Alternative | 이유 |
|-------------|------|
| `cart` | 구매 흐름 전반 — _구입 완료_보다 _구입 중_ 뉘앙스 |
| `bag` | 쇼핑백 — retail 맥락 강함, 도서관 톤과 불일치 |
| `archivebox` | 보관/아카이브 뉘앙스 강함 — _신규 획득_보다 _보관_에 가까움 |

---

### 1.2 read — 읽음

| 항목 | 값 |
|------|-----|
| **Selected** | `text.book.closed` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 4.0+ 도입 |
| Accessibility label | `"Read"` |
| Rationale | 닫힌 책 + 텍스트 라인 = _읽기 완료_ 상태의 명확한 표현. `book.closed` 와 달리 텍스트 라인이 _읽기 행위_ 직접 지시. Music/Movie medium 에서도 `listened`/`watched` 와 구분 명확. |

| Alternative | 이유 |
|-------------|------|
| `book.closed` | text 라인 없음 — _보유_ 와 구분 어려움 |
| `book.pages` | 펼쳐진 느낌 — _읽는 중_에 가까움 |
| `character.book.closed` | SF Symbols 7 only (사용 가능) 하지만 medium badge `book.closed` 와 혼동 위험 |

---

### 1.3 listened — 들음

| 항목 | 값 |
|------|-----|
| **Selected** | `headphones` |
| Variant | regular (no fill) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Listened"` |
| Rationale | 헤드폰 = 음악 듣기 행위의 보편 metaphor. Medium badge `music.note` (보유/분류) 와 의미 계층 분리: `headphones` = _경험 행위_, `music.note` = _매체 종류_. |

| Alternative | 이유 |
|-------------|------|
| `music.note` | Medium badge 와 동일 — Medium/Kind 구분 불명확 |
| `ear` | 청각 행위 직접적이나 의료/접근성 아이콘 느낌 |
| `waveform` | 소리 시각화 — _듣기_ 행위보다 _녹음/오디오_ 뉘앙스 |

---

### 1.4 watched — 봄

| 항목 | 값 |
|------|-----|
| **Selected** | `film` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Watched"` |
| Rationale | 필름 릴 = 영화/영상 시청의 표준 metaphor. Medium badge `film` (movie 분류) 와 동일 아이콘 사용 — context 에 따라 (Timeline = watched 행위 / Library tab = movie medium 분류) 의미 분화 적용. Things 3 패턴과 동일한 방식. |

| Alternative | 이유 |
|-------------|------|
| `play.rectangle` | 재생 UI 느낌 — _시청 완료_ 기록 아이콘으로 약함 |
| `eye` | 시각적이나 Generic — 감시/검토 뉘앙스 혼재 |
| `tv` | TV 매체에 한정된 인상 |

---

### 1.5 lent — 빌려줌

| 항목 | 값 |
|------|-----|
| **Selected** | `arrow.uturn.left` |
| Variant | regular (no fill) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Lent"` |
| Rationale | U턴 화살표 왼쪽 = _나갔다가 돌아올_ 흐름. `lent` = 내 것이 타인에게 임시 이동 → 되돌아오는 흐름. `arrow.down.left.square`(`received`)와 방향 대비 명확. |

| Alternative | 이유 |
|-------------|------|
| `arrow.right.square` | 일방향 — 대출 _반납 기대_ 표현 약함 |
| `person.badge.plus` | 사람 + 추가 — 친구 추가 뉘앙스 강함 |
| `hand.raised` | STOP 제스처 — 대출과 무관 |

---

### 1.6 received — 받음

| 항목 | 값 |
|------|-----|
| **Selected** | `arrow.down.left.square` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 2.0+ 도입 |
| Accessibility label | `"Received"` |
| Rationale | 아래+왼쪽 화살표 = _외부에서 내 쪽으로 들어오는_ 방향성. `lent`(uturn left)와 방향 계열 통일하면서 의미 대립. `acquired`(상자)와 구분: acquired = _구입_, received = _선물/증정으로 받음_. |

| Alternative | 이유 |
|-------------|------|
| `tray.and.arrow.down` | 트레이 수신 — 이메일/다운로드 맥락 강함 |
| `gift` | `gifted` 와 중복 혼동 위험 |
| `arrow.down.circle` | 방향 표현 있으나 square frame 없어 `lent`와 시각 계열 불일치 |

---

### 1.7 gifted — 선물함

| 항목 | 값 |
|------|-----|
| **Selected** | `gift` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Gifted"` |
| Rationale | 리본 달린 선물 상자 = _선물_ 의 전 문화권 공통 metaphor. `received`(받음)와 의미 대립 명확: gifted = _내가 줌_, received = _내가 받음_. |

| Alternative | 이유 |
|-------------|------|
| `heart` | 감정 표현 — _선물 행위_ 보다 _좋아함_ 뉘앙스 |
| `paperplane` | 보내기 — DM/메시지 맥락 강함 |
| `ribbon` | 리본만 단독 — 선물 상자 context 약함 |

---

### 1.8 annotated — 주석 달기

| 항목 | 값 |
|------|-----|
| **Selected** | `pencil.line` |
| Variant | regular (no fill) |
| SF Symbols 7 가용 | Yes — SF Symbols 3.0+ 도입 |
| Accessibility label | `"Annotated"` |
| Rationale | 연필 + 선 = 책/악보/대본에 _손글씨 주석_ 을 다는 행위. `pencil` 단독보다 _쓰는 흐름_ 표현. 헌책방에서 이전 독자 메모, 악보 연주 표시 = Still Hours 핵심 감성과 정합. |

| Alternative | 이유 |
|-------------|------|
| `pencil` | 주석보다 _편집_ 모드 아이콘 느낌 (UX 관례) |
| `highlighter` | SF Symbols 7에 `highlighter` 존재 (4.0+) — 형광펜 = 강조지 주석 아님 |
| `note.text` | 메모 전반 — _해당 자산에 특정된 주석_ 맥락 약함 |

---

## 2. Medium 4 — SF Symbol Selection

> Library tab, ItemCard badge, Filter UI, TabBar 모두 동일 icon 사용.

### 2.1 book — 책

| 항목 | 값 |
|------|-----|
| **Selected** | `book.closed` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Book"` |
| Rationale | 닫힌 책 = _보유한 책_ 의 표준 metaphor. `text.book.closed`(kind=read)와 구분: 텍스트 라인 _없음_ = 행위가 아닌 _매체 분류_. |
| Context | Library filter / TabBar / ItemCard badge |

---

### 2.2 music — 음악

| 항목 | 값 |
|------|-----|
| **Selected** | `music.note` |
| Variant | regular |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Music"` |
| Rationale | 음표 = 음악 매체 분류의 표준. `headphones`(kind=listened)와 의미 계층 분리: `music.note` = _보유 LP/CD/스트리밍 앨범_ (매체), `headphones` = _들었다는 행위_ (kind). |
| Context | Library filter / TabBar / ItemCard badge |

---

### 2.3 movie — 영화

| 항목 | 값 |
|------|-----|
| **Selected** | `film` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Movie"` |
| Rationale | 필름 릴 = 영화 매체 표준. `film`(kind=watched)와 동일 symbol — context 분화 적용: Library filter/badge = movie medium, Memory Timeline = watched kind. Things 3 패턴 (Task 아이콘과 Project 아이콘 동일 but context 다름) 정합. |
| Context | Library filter / TabBar / ItemCard badge |

---

### 2.4 object — 오브제/실물

| 항목 | 값 |
|------|-----|
| **Selected** | `cube` |
| Variant | `.fill` (filled) |
| SF Symbols 7 가용 | Yes — SF Symbols 1.0+ 도입 |
| Accessibility label | `"Object"` |
| Rationale | 정육면체 = 물리 오브제(도자기/문구/가구/잡화)의 _제네릭 3D solid_ 표현. `shippingbox`(kind=acquired)와 형태 유사하나 cube = _오브제 자체_, shippingbox = _배달 과정_ 구분. |

| Alternative | 이유 |
|-------------|------|
| `archivebox.fill` | 상자 컨테이너 — _보관_ 뉘앙스. `acquired` 와 혼동 위험 |
| `circle.hexagongrid` | 추상적 — _물리 오브제_ 연상 어려움 |
| `star.square` | 특별/즐겨찾기 뉘앙스 강함 |

> **v1.x 검토**: `cube.transparent` (SF Symbols 4.0+) — 투명 큐브, 유리/도자기 오브제 표현 더 강함. v1.0 은 `cube.fill` 안정성 우선.

---

## 3. MediumBadge / Library Filter 사용 패턴

### 3.1 동일 Icon — Context 분화

| 위치 | Symbol | Color | Size |
|------|--------|-------|------|
| TabBar (medium filter tab) | Medium별 above | `accent.default` | 22pt |
| Library filter chip | Medium별 above | `accent.default` | 16pt |
| ItemCard medium badge | Medium별 above | `accent.default` | 12pt |
| Memory Timeline kind icon | Kind별 §1 above | `accent.default` | 16pt |

### 3.2 MediumBadge 컴포넌트

```
[ ■  Book ]  pill shape, radius.sm 8pt
```

| 항목 | 값 |
|------|-----|
| Icon | SF Symbol 12pt |
| Label | `font.subhead` SF Pro Medium 15pt |
| Icon ↔ label gap | 4pt (`space.xs`) |
| Pill padding | 4pt vertical / 8pt horizontal |
| Background | `surface.elevated` (선택 해제) / `accent.default` (선택) |
| Label color | `text.primary` (선택 해제) / white (선택) |
| Min-width | 64pt |

---

## 4. Custom Icon 도입 검토

### 4.1 v1.0 — 없음

App Icon (Wunderkammer cabinet) _만_ custom SVG. 나머지 12 symbols 모두 SF Symbols 7.

기준 (Design.MD §6.1): _10× 가치 통과 시만_ custom icon 도입.

### 4.2 v1.x 검토 후보

| 후보 | 이유 | 기준 충족 여부 |
|------|------|----------------|
| `object` medium custom icon | SF `cube.fill` 이 너무 geometric → 도자기/공예품 느낌 부족 | 사용자 테스트 후 판단 |
| `annotated` kind custom icon | `pencil.line` 이 편집 모드와 혼동 가능 | UX 리서치 후 판단 |
| Wunderkammer micro icon | Settings / 1주년 Letter 헤더용 | v1.x 때 검토 |

### 4.3 Custom Icon 도입 프로세스 (조건부)

1. SF Symbols 7 에서 5+ 대안 탐색 → 모두 부적합 확인
2. Custom SVG 제작 (Figma, SF Symbols export spec 준수)
3. SF Symbols `.custom()` 등록 → Dynamic Type 자동 대응
4. Accessibility label 명시 (SF Symbol 자동 label 없음)
5. Design.MD §6 + SFSymbols-Selection.md §4 업데이트

---

## 5. Verification Checklist

| Symbol | SF Symbols 7 가용 | 16pt 가독성 | filled/regular 결정 | accessibility label |
|--------|------------------|------------|---------------------|---------------------|
| `shippingbox` (acquired) | Yes | Good | `.fill` | "Acquired" |
| `text.book.closed` (read) | Yes | Good | `.fill` | "Read" |
| `headphones` (listened) | Yes | Good | regular | "Listened" |
| `film` (watched) | Yes | Good | `.fill` | "Watched" |
| `arrow.uturn.left` (lent) | Yes | Good | regular | "Lent" |
| `arrow.down.left.square` (received) | Yes | Good | `.fill` | "Received" |
| `gift` (gifted) | Yes | Good | `.fill` | "Gifted" |
| `pencil.line` (annotated) | Yes | Good | regular | "Annotated" |
| `book.closed` (book medium) | Yes | Good | `.fill` | "Book" |
| `music.note` (music medium) | Yes | Good | regular | "Music" |
| `film` (movie medium) | Yes | Good | `.fill` | "Movie" |
| `cube` (object medium) | Yes | Good | `.fill` | "Object" |

**16pt 가독성 검증 기준**: SF Symbols 앱 (macOS) 에서 16pt preview 확인. 복잡한 내부 detail 이 뭉치지 않을 것.

**filled vs regular 원칙**:
- _명사(보유/매체)_ = `.fill` — 상태의 고정성
- _동사(이동/흐름/쓰기)_ = regular — 행위의 가벼움
- 예외: `gift.fill` — 선물 상자 filled 가 의미 명확도 높음

---

_End of SFSymbols-Selection.md v1.0_

| Date | Change |
|------|--------|
| 2026-05-20 | v1.0 initial — Memory Kind 8 + Medium 4 = 12 symbols 확정, alternatives 각 3개, accessibility labels 전수 명시 |
| 2026-05-21 | R8 — Audit report section added; check-sfsymbols.sh lint integrated into test.sh |

---

## Audit Report — 2026-05-21 (Round 8)

_Auto-generated by `scripts/check-sfsymbols.sh`. Manual updates above
this divider; everything below is regenerated each audit._

### Symbols currently used in source

Symbols discovered across `App/Sources/` and `Packages/InventoryCore/Sources/`:

| Symbol | Source | Declared in doc? |
|--------|--------|-----------------|
| `arrow.down.left.square.fill` | SemanticTokens (received kind) | Yes |
| `arrow.up.arrow.down` | LibraryListView sort menu | No — ad-hoc UI chrome |
| `arrow.up.right.square` | SettingsRootView help row | No — ad-hoc UI chrome |
| `arrow.uturn.left` | SemanticTokens (lent kind) | Yes |
| `barcode.viewfinder` | CaptureSheet mode switcher | No — add to v1.x selection |
| `book.closed.fill` | SemanticTokens (book medium) | Yes |
| `books.vertical` | SettingsRootView / other | No — ad-hoc UI chrome |
| `camera.slash` | Capture error state | No — ad-hoc UI chrome |
| `checkmark` | LibraryListView sort menu | No — standard sort indicator |
| `checkmark.circle.fill` | State feedback | No — ad-hoc UI chrome |
| `cloud.fill` | Export / data view | No — ad-hoc UI chrome |
| `cube.fill` | SemanticTokens (object medium) | Yes |
| `doc.text` | Data view | No — ad-hoc UI chrome |
| `exclamationmark.triangle` | CaptureSheet error state | No — ad-hoc UI chrome |
| `eye.slash` | Privacy view | No — ad-hoc UI chrome |
| `film.fill` | SemanticTokens (watched kind + movie medium) | Yes |
| `gearshape` | Settings tab | No — ad-hoc UI chrome |
| `gift.fill` | SemanticTokens (gifted kind) | Yes |
| `headphones` | SemanticTokens (listened kind) | Yes |
| `info.circle` | SettingsRootView about row | No — ad-hoc UI chrome |
| `iphone.and.arrow.forward` | Export view | No — ad-hoc UI chrome |
| `keyboard` | CaptureSheet mode switcher | No — add to v1.x selection |
| `lock.shield` | SettingsRootView privacy row | No — ad-hoc UI chrome |
| `mic.fill` | CaptureSheet voice mode | No — add to v1.x selection |
| `mic.slash` | Voice error state | No — ad-hoc UI chrome |
| `music.note` | SemanticTokens (music medium) | Yes |
| `pencil.line` | SemanticTokens (annotated kind) | Yes |
| `photo` | Image picker / cover art | No — ad-hoc UI chrome |
| `plus` | LibraryListView add button | No — standard add action |
| `questionmark.circle` | SettingsRootView help | No — ad-hoc UI chrome |
| `shippingbox.fill` | SemanticTokens (acquired kind) | Yes |
| `square.and.arrow.up` | SettingsRootView export row | No — ad-hoc UI chrome |
| `tablecells` | Data view | No — ad-hoc UI chrome |
| `text.book.closed.fill` | SemanticTokens (read kind) | Yes |
| `waveform.circle.fill` | Voice capture active state | No — ad-hoc UI chrome |
| `xmark` | CaptureSheet close button | No — standard dismiss |

### Symbols declared but no longer used

_(All 12 declared symbols are referenced via SemanticTokens.swift constants
which are used at call sites. No orphans detected as of R8.)_

### SF Symbols 7 iOS 26-exclusive recommendations

_(Hardcoded curated list per Step 4 of `check-sfsymbols.sh`. Copy applicable
rows into §4.2 for v1.x review.)_

| Current symbol | Context | Recommendation | Rationale |
|----------------|---------|----------------|-----------|
| `film.fill` | watched kind / movie medium | `film.stack.fill` (SF 6+) | "stack" evokes a collection vs single item |
| `cube.fill` | object medium | `cube.transparent` (SF 4+) | Better for glass/ceramic/porcelain objects |
| `music.note` | music medium | `music.note.list` | Implies album/tracklist vs single note |
| `info.circle` | Settings About row | `info.circle.fill` | Filled variant for interactive-destination rows |
| `lock.shield` | Settings Privacy row | `lock.shield.fill` | Filled = warmer, more reassuring |
| `questionmark.circle` | Settings Help row | `questionmark.circle.fill` | Consistent with other filled action icons |
| `exclamationmark.triangle` | Error state | `exclamationmark.triangle.fill` | Filled stronger as error state indicator |
| `gearshape` | Settings tab icon | `gearshape.fill` | Filled for selected/active tab state |
