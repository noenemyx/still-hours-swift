# MemoryTimeline-Design.md — Still Hours

> Version 1.0 | 2026-05-20 | Design.MD §5.2 정합
> Memory Timeline 화면 완전 spec. ItemDetail 아래 2/3 영역.

---

## A. Information Architecture

### A.1 ItemDetail 화면 분할

```
┌──────────────────────────────┐
│  [Asset Info — 위 1/3]       │
│  Cover image (3:4)           │
│  Title (New York 22pt)       │
│  Creator · Year · Medium     │
│  ─────────────────────────── │
│  Medium badge  [+ Memory]    │
│                              │  ← 분할선 (visually implicit)
├──────────────────────────────┤
│                              │
│  [Memory Timeline — 아래 2/3]│
│  ScrollView vertical         │
│  (reverse-chronological)     │
│                              │
│                              │
│                              │
└──────────────────────────────┘
```

- Asset Info 영역: NavigationStack 에 고정 (스크롤 불포함)
- Memory Timeline 영역: 단독 ScrollView (pull-to-refresh 없음)
- 분할 비율: 위 36% / 아래 64% (iPhone 16 Pro 기준 393pt width)

### A.2 Timeline 정렬

**Default: 역시간순 (reverse-chronological)**

```
▲ 최근 (2024-08-15) ← 화면 상단
│
│
▼ 오래된 (2019-03-01) ← 화면 하단
```

- 근거: Day One, Are.na 모두 역시간순. "가장 최근 기억을 먼저" = 실사용 정합
- 전환 없음. v1.0 고정 역시간순. v1.x sort toggle 검토 (default 유지)

### A.3 빈 Timeline 상태 (Empty State)

```
         ·

    처음 기억을 적어보세요.

    [+ 첫 기억 남기기]
```

- 일러스트 없음 (Things 3 패턴)
- `·` 점 하나 (burnt sienna accent.default)
- 본문: `font.heading.2` SF Pro Semibold 17pt, `text.primary`
- CTA 버튼: `accent.default` filled pill

---

## B. Layout Spec

### B.1 Container

| 항목 | 값 |
|------|-----|
| Horizontal padding | 16pt (`space.md`) 좌우 |
| Timeline 상단 상단 여백 | 16pt (`space.md`) |
| Timeline 하단 여백 | 80pt (FAB 겹침 방지) |
| ScrollView clip | `.clipped()` 없음 — 자연 스크롤 |

### B.2 Accent Line

| 항목 | 값 |
|------|-----|
| Width | 1pt |
| Color | `color.accent.default` `#B85C38` (medium-shared, v1.0 단일 accent) |
| Left indent | 16pt (`space.md`) from container leading |
| Top | 첫 row top (icon 중앙 정렬) |
| Bottom | 마지막 row bottom (icon 중앙 정렬) |
| Cap style | `.butt` (flat, no rounded cap) |

```swift
// Implementation reference
Rectangle()
    .fill(Color("accent.default"))
    .frame(width: 1)
    .padding(.leading, 16)
```

### B.3 Icon

| 항목 | 값 |
|------|-----|
| SF Symbol | Kind 별 (§C 참조, SFSymbols-Selection.md) |
| Size | 16pt (`.font(.system(size: 16))`) |
| Color | `accent.default` `#B85C38` |
| Rendering | `.hierarchical` 또는 `.monochrome` — v1.0 monochrome |
| Left offset | 16pt — 1pt accent line 위 중앙 정렬 (line center = icon center) |
| Alignment | vertically centered to row first-line baseline |

### B.4 MemoryRow 구조

```
│  [Icon 16pt]  [Title — font.body 17pt]          [Photo thumb 48pt]
│               [Date · Place · withWhom]
│               [font.caption 12pt, text.secondary]
```

| 항목 | 값 |
|------|-----|
| Icon ↔ Text gap | 8pt (`space.sm`) |
| Text 우측 photo gap | 8pt (`space.sm`) |
| Row 내부 상단 padding | 8pt (`space.sm`) |
| Row 내부 하단 padding | 8pt (`space.sm`) |
| Row 간 vertical gap | 8pt (`space.sm`) |
| Row 배경 | 없음 (parchment background 투과) |

### B.5 Typography

| 요소 | Font | Weight | Size | Color |
|------|------|--------|------|-------|
| Memory note 첫 줄 | SF Pro Text | Regular | 17pt (Body) | `text.primary` |
| Date · Place · withWhom | SF Pro Text | Regular | 12pt (Caption 1) | `text.secondary` |
| Meta separator `·` | SF Pro Text | Regular | 12pt | `text.secondary` |

### B.6 Photo Thumbnail

| 첨부 수 | 표현 |
|--------|------|
| 0 | thumbnail 없음, text 우측 끝까지 |
| 1 | 48×48pt square, `radius.sm` 8pt, right-aligned |
| 2+ | horizontal scroll grid (§D.1 참조) |

---

## C. Memory Kind 시각 구분

### C.1 원칙: Icon + Accent Line (Color 구분 아님)

**v1.0 결정**: color-per-kind 아님. 단일 `accent.default` burnt sienna + kind-specific SF Symbol.

근거:
- Design.MD §4.3: `accent.medium.book/music/movie/object` = v1.0 모두 `accent.default` (단일)
- Color-per-kind 시 palette 과부하 + WCAG 부담
- Icon 차이만으로 충분한 semantic 구분 (Day One 패턴 정합)

### C.2 8 Kind → Icon 매핑

| Kind | SF Symbol | 크기 | 비고 |
|------|-----------|------|------|
| `acquired` | `shippingbox` | 16pt | filled |
| `read` | `text.book.closed` | 16pt | filled |
| `listened` | `headphones` | 16pt | regular |
| `watched` | `film` | 16pt | filled |
| `lent` | `arrow.uturn.left` | 16pt | regular |
| `received` | `arrow.down.left.square` | 16pt | filled |
| `gifted` | `gift` | 16pt | filled |
| `annotated` | `pencil.line` | 16pt | regular |

상세 rationale + alternatives → `SFSymbols-Selection.md §1`

---

## D. Photo / Voice 첨부 UI

### D.1 Photo — 1장

```
│  [Icon]  Memory note text here...    [■ 48pt]
│           2024-08-15 · Tsutaya       [photo]
```

- Thumbnail: 48×48pt, `radius.sm` 8pt, center-crop
- Tap → full-screen viewer (iOS native QuickLook 또는 custom modal)
- 다운로드 실패: `color.accent.muted` skeleton 플레이스홀더

### D.2 Photo — 2장 이상

```
│  [Icon]  Memory note text here...
│           2024-08-15 · Tsutaya

│  ┌────┐ ┌────┐ ┌────┐ →
│  │ 96 │ │ 96 │ │+12 │
│  └────┘ └────┘ └────┘
```

- 96×96pt square grid, horizontal scroll
- 3장 초과 시 마지막 셀 `+N` overflow label (SF Pro Text Semibold 17pt, white on dim overlay)
- Grid 상단 여백: 4pt (`space.xs`)

### D.3 Voice 첨부

```
│  [Icon]  Memory note text here...
│           2024-08-15

│  ┌──────────────────────────────┐
│  │  ▶  ■■■▮■■■■■■■▮■■■  0:42  │
│  └──────────────────────────────┘
```

| 항목 | 값 |
|------|-----|
| Play button | SF Symbol `play.circle` 또는 `pause.circle`, 24pt, `accent.default` |
| Waveform | 3pt width × N bars, `accent.muted` (미재생) / `accent.default` (재생 진행) |
| Duration | `font.caption` 12pt, `text.secondary`, right-aligned |
| Container | `surface.elevated` background, `radius.sm` 8pt, `space.sm` 8pt padding |
| Container 상단 여백 | 4pt (`space.xs`) |

---

## E. Add Memory CTA

### E.1 Floating Action Button (FAB)

```
┌──────────────────────────────┐
│                              │
│   [Memory Timeline]          │
│                              │
│                              │
│              ┌─────────────┐ │
│              │  +  기억 추가 │ │
│              └─────────────┘ │
└──────────────────────────────┘
```

| 항목 | 값 |
|------|-----|
| Position | `.bottom` `.trailing`, `space.md` 16pt inset |
| Label | `+  기억 추가` (SF Pro Semibold 15pt, white) |
| Background | `accent.default` `#B85C38` |
| Height | 48pt |
| Min-width | 140pt |
| Radius | 24pt (pill) |
| Shadow | `shadow.floating` |
| Tap animation | `motion.quick` 200ms scale 0.96 → 1.0 |

### E.2 Quick Capture Sheet

| 항목 | 값 |
|------|-----|
| Presentation | `.sheet` + `.presentationDetents([.medium])` |
| Default detent | `.medium` |
| Content | Kind picker + Note 입력 + Date/Place/withWhom + Photo/Voice 첨부 |
| CTA | `저장` filled button, `accent.default` |
| Cancel | `취소` plain, `text.secondary` |
| Keyboard dismiss | `.scrollDismissesKeyboard(.interactively)` |

Kind picker 위치: sheet 상단 horizontal scroll chip row

```
┌────────────────────────────────┐
│  ⊗ 취소               저장    │
│ ─────────────────────────────  │
│  [ 📦 획득 ] [ 📖 읽음 ] [ 🎧 ]  │
│                                │
│  [  메모를 입력하세요...      ]  │
│                                │
│  📅 2024-08-15  (자동)         │
│  📍 Tsutaya Daikanyama  (자동) │
│  👤 withWhom (선택)            │
│                                │
│  [사진 추가]  [음성 추가]       │
└────────────────────────────────┘
```

---

## F. Edit History

### F.1 이전 버전 보존 (PRD §7.5 정합)

- Memory entry 수정 시 _원본 삭제 아님_ — `EditHistory` entity 별도 저장
- Data model:

```
MemoryEntry
├── id: UUID
├── current: MemoryContent (최신)
└── history: [MemoryContent] (역시간순)

MemoryContent
├── note: String
├── kind: MemoryKind
├── date: Date
├── place: String?
├── withWhom: String?
├── photos: [PhotoRef]
├── voiceNote: VoiceRef?
└── editedAt: Date
```

### F.2 Edit History 접근 (Long-press Menu)

Long-press MemoryRow → context menu:

```
[연필] 수정
[시계] 수정 기록 보기
[공유] 공유
─────────────────
[휴지통] 삭제
```

"수정 기록 보기" → modal (`.sheet` `.presentationDetents([.large])`)

### F.3 Edit History Modal

```
┌────────────────────────────────┐
│  수정 기록                  ✕  │
│ ─────────────────────────────  │
│  현재 버전  2024-08-20         │
│  ────────────────────────      │
│  [current note text]           │
│                                │
│  이전 버전  2024-08-15         │
│  ────────────────────────      │
│  [previous note text]          │
│                                │
│  이전 버전  2024-08-10         │
│  ────────────────────────      │
│  [oldest note text]            │
└────────────────────────────────┘
```

| 항목 | 값 |
|------|-----|
| Section header (날짜) | `font.subhead` SF Pro Medium 15pt, `text.secondary` |
| Note content | `font.body` 17pt, `text.primary` |
| Separator | 0.5pt, `color.accent.muted` |
| Restore action | v1.x 검토 (복원 → 현재 버전 교체, 현재 버전 history 보존) |

---

## G. Time Travel 연동

### G.1 Anniversary Surface

Memory entry 에 `date` 필드 존재 → Time Travel 탭에서:

```
On this day 5 years ago

  [ 📦 acquired  노르웨이의 숲 ]
  2019-08-15 · Tsutaya Daikanyama

  [→ 해당 기억 보기]
```

| 항목 | 값 |
|------|-----|
| Header | "On this day N years ago" — `font.heading.2` SF Pro Semibold 17pt |
| Entry preview | MemoryRow 축소 (icon + note 첫 줄 + date/place) |
| CTA | `→ 해당 기억 보기` — accent text button |
| 트리거 | 앱 실행 시 _오늘 날짜_ 와 과거 기억 date 비교 (±1일 tolerance) |
| 알림 | v1.x opt-in (default OFF) |

### G.2 ItemDetail 내 Time Travel 표면

ItemDetail Memory Timeline 상단에 인라인 카드:

```
┌──────────────────────────────────┐
│  5년 전 오늘의 기억               │
│  [icon] 처음 구입했던 날. Tsutaya │
│  2019-08-15                      │
└──────────────────────────────────┘
```

- 조건: 해당 Item 에 N년 전 오늘 기억이 있을 때만 노출
- 카드: `surface.elevated`, `radius.md` 12pt, `shadow.elevated`
- 상단 여백: Timeline 진입부 `space.md` 16pt 전

---

## H. Accessibility

### H.1 VoiceOver Labels

| 요소 | VoiceOver label |
|------|----------------|
| MemoryRow | `"\(kind.label) on \(date) at \(place), with \(withWhom)"` |
| kind = acquired | "Acquired" |
| kind = read | "Read" |
| kind = listened | "Listened" |
| kind = watched | "Watched" |
| kind = lent | "Lent" |
| kind = received | "Received" |
| kind = gifted | "Gifted" |
| kind = annotated | "Annotated" |
| Photo thumbnail | "Photo attachment, \(photoCount) photos" |
| Voice note | "Voice note, \(duration) seconds" |
| FAB | "Add memory" |
| Edit history modal | "Edit history for this memory entry" |

```swift
// Implementation reference
memoryRow
    .accessibilityLabel(
        "\(memory.kind.accessibilityLabel) on \(memory.formattedDate)"
        + (memory.place.map { " at \($0)" } ?? "")
        + (memory.withWhom.map { ", with \($0)" } ?? "")
    )
    .accessibilityHint("Double tap to expand. Long press for more options.")
```

### H.2 Dynamic Type Ceiling

| 요소 | Ceiling |
|------|---------|
| Memory note (Body 17pt) | `.accessibility3` |
| Meta caption (12pt) | `.accessibility2` — 이 이상은 row 높이 부담 |
| Kind icon (16pt) | ScaledMetric ceiling 24pt (1.5×) |
| FAB label | `.accessibility1` — pill 너비 대응 |

```swift
@ScaledMetric(relativeTo: .body) var iconSize: CGFloat = 16
let cappedIconSize = min(iconSize, 24)
```

### H.3 Reduced Motion

| 효과 | Reduced Motion = ON |
|------|---------------------|
| Row 진입 stagger | 제거 (즉시 표시) |
| FAB tap scale animation | 제거 |
| Voice waveform 재생 animation | 정지 (progress bar 표시로 대체) |
| Photo swipe momentum | 유지 (system ScrollView 기본) |
| Sheet present transition | Cross-fade 200ms (기본 slide 대체) |

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

.animation(reduceMotion ? .none : .easeOut(duration: 0.2), value: isPressed)
```

### H.4 Keyboard / Focus Navigation

- VoiceOver swipe → MemoryRow 순서대로 (역시간순)
- FAB: `.accessibilityAddTraits(.isButton)`
- Long-press context menu: `.accessibilityShowsLargeContentViewer()` (iOS 13+)
- Edit history modal: `.accessibilityLabel("Edit history")` + `.accessibilityViewIsModal(true)`

---

## I. Motion — High-Impact Moments Only

| 순간 | Effect | Duration | Easing |
|------|--------|----------|--------|
| Memory Timeline 첫 로드 | Row stagger fade-in (top → bottom, 40ms gap) | 300ms | `easeOut` |
| FAB tap | Scale 0.96 → 1.0 | 200ms | `easeOut` |
| Quick Capture Sheet 닫힘 + row 삽입 | New row slide-in from top | 300ms | `easeInOut` |
| Long-press context menu | System default | — | — |
| Photo viewer open | System QuickLook transition | — | — |
| Voice play/pause | Waveform bar height animate | 200ms | `easeInOut` |

**금지**:
- Row 개별 parallax scroll
- Accent line 자체 animation (정적 유지)
- Auto-play voice note

---

_End of MemoryTimeline-Design.md v1.0_

| Date | Change |
|------|--------|
| 2026-05-20 | v1.0 initial — Design.MD §5.2/6.2/6.3 정합, 전 섹션 A-I 작성 |
