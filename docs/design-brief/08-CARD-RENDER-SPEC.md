# Share Card Render Spec — Design Brief

> `CardRenderView.swift` 구현 기준 상세 렌더 스펙.  
> `01-SHARE-CARD.md`의 의도를 실제 코드로 확인한 문서.  
> 브랜드 토큰: `04-BRAND-SUMMARY.md` 참조.

---

## 구현 파일

`App/Sources/App/Views/Sharing/CardRenderView.swift` (Build #9e)

---

## 렌더 파이프라인

```swift
// CardRenderView.swift line 118–123
let renderer = ImageRenderer(content: CardRenderView(item: item))
renderer.scale = 3.0  // @3x
return renderer.uiImage  // UIImage → ShareLink
```

- 기본 캔버스: **300pt × 400pt** (3:4)
- 출력 이미지: **900px × 1200px** PNG (@3x)
- 공유: `ShareLink(item: cardImage)` — native AirDrop/iMessage/Files

---

## 레이아웃 상세 (top → bottom)

### 커버 영역 (75% = 300pt × 300pt)

코드 기준 (line 41–58):

```
┌────────────────────────┐  ← 300pt wide
│                        │
│   커버 이미지          │  ← .scaledToFill().clipped()
│   (또는 placeholder)   │  ← coverFraction = 0.75 → 300pt height
│                        │
└────────────────────────┘
```

| 조건 | 렌더링 |
|------|--------|
| `item.coverImageData` 있음 | `Image(uiImage:).resizable().scaledToFill()` |
| 없음 | `Color.shAccentMuted` fill + SF Symbol 48pt `Color.shAccent` |

- `shAccentMuted` = `accent.default` 12% opacity (SemanticTokens 기준)
- `shAccent` = `accent.default` (#1d6fe5 light)

### 텍스트 영역 (25% = 300pt × 100pt)

코드 기준 (line 62–92, `infoArea`):

```
┌────────────────────────┐  ← 300pt wide, 100pt height
│ [title]                │  ← .body.semibold, lineLimit 2, shTextPrimary
│ [creator]              │  ← .subheadline, lineLimit 1, shTextSecondary (optional)
│           [Spacer]     │
│ 큐레이션 by Own Your   │  ← .caption2, shTextTertiary, lineLimit 1
│  Curation              │
└────────────────────────┘
│← 16pt →│         │← 16pt →│
```

- 전체 영역 padding: 16pt (all sides), `VStack spacing: 2`
- 배경: `Color.shBackground` (#f4f7fb light)
- `Spacer(minLength: 0)` — title/creator 상단 고정, footer 하단 고정

**현재 누락**: memory note (1-line tertiary). `01-SHARE-CARD.md`에는 포함 의도됨, `CardRenderView.swift` v1.0에는 미구현. 디자이너는 memory note 있는 경우도 목업에 포함.

### 전체 카드 컨테이너

- `background(Color.shBackground)`
- `clipShape(RoundedRectangle(cornerRadius: 12))`

---

## 5 Medium 목업 데이터

PRD §0.-1 line 131–138 기준:

| Medium | SF Symbol (placeholder) | Title | Creator | 1-line memory |
|--------|------------------------|-------|---------|---------------|
| 책 | `SemanticTokens.mediumIcon.book` | Norwegian Wood | 무라카미 하루키 | 도쿄 츠타야 · 2024.08 |
| 음반 | `SemanticTokens.mediumIcon.music` | In Rainbows | Radiohead | LP 한정판 |
| 영화 | `SemanticTokens.mediumIcon.movie` | Spirited Away | Hayao Miyazaki | 어머니와 마지막 본 영화 |
| 오브제 | `SemanticTokens.mediumIcon.object` | Leica M6 | Leica Camera AG | 30년 된 카메라 |
| 장소 | `SemanticTokens.mediumIcon.place` | 도쿄 츠타야 | (없음) | 어머니와 함께, 2024-08 |

각 medium: **커버 이미지 있는 버전 1장 + placeholder 버전 1장** 제작.

---

## 현재 비율 검토 과제

### 비율 3:4 vs 7:10

현재 정확한 비율: 300:400 = 3:4.  
텍스트 영역 100pt는 body semibold 2줄 + subheadline 1줄 + caption2 footer를 패딩 포함하면 빡빡.  
디자이너 검토: **70/30 분할**(텍스트 120pt)이 가독성에 유리한지 판단.

### 커버-텍스트 밸런스 (75/25 vs 70/30)

| 분할 | 커버 높이 | 텍스트 높이 | 장점 | 단점 |
|------|----------|------------|------|------|
| 75/25 (현행) | 300pt | 100pt | 이미지 지배, Letterboxd 감성 | memory note 공간 부족 |
| 70/30 | 280pt | 120pt | memory note + 여백 확보 | 커버 임팩트 소폭 감소 |

### 브랜드 마크 prominency

현재 `.caption2.tertiary` — "절대 prominent 처리 금지" (`01-SHARE-CARD.md`).  
디자이너 확인: 실제 렌더 이미지에서 tertiary가 충분히 subdued한지 검증.

### 폰트 페어링 기회

현재: title `.body.semibold` (SF Pro), footer `.caption2` (SF Pro).  
`04-BRAND-SUMMARY.md` 기준: footer에 **SF Mono Regular** 적용 가능 (브랜드 자산 보조).  
디자이너 옵션: footer `"큐레이션 by Own Your Curation"` → SF Mono 처리.

---

## 미래 비율 (Proof-of-Concept 요청)

| 비율 | 용도 | 캔버스 |
|------|------|--------|
| **1:1** | 카카오톡/iMessage 썸네일 | 300pt × 300pt |
| **9:16** | Instagram Story 전체 | 300pt × 533pt |

납품물: 책(Norwegian Wood) medium으로 1:1 + 9:16 각 1장 (커버 있는 버전).

---

## 납품물 요약

- 5 medium × 3:4 × 커버有/無 = **10 frame**
- 책 medium × 1:1 + 9:16 = **2 frame** (proof of concept)
- memory note 포함 변형 (책 medium 기준) = **1 frame**
- 합계: **13 frame 최소**
- 납품 경로: `docs/design-brief/mockups/08/`

---

_상세 의도 및 배경: `01-SHARE-CARD.md` 참조._
