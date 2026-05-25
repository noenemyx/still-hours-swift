# SearchFirstView — Design Brief

> Tab 1 루트 화면. 디자이너가 이 파일 하나로 실행할 수 있도록 작성.  
> 브랜드 토큰: `04-BRAND-SUMMARY.md` 참조.

---

## 현재 상태 (코드 기준)

파일: `App/Sources/App/Views/Curation/SearchFirstView.swift` (R19, Build #9a)

### 검색 입력 (line 63–96)

- HStack: `magnifyingglass` SF Symbol + `TextField` + `xmark.circle.fill` 클리어 버튼
- 배경: `.regularMaterial` + `RoundedRectangle(cornerRadius: 10)`
- 수평 패딩 16pt, 수직 10pt (input 내부), 외부 상하 12pt
- Placeholder: `"제목, 창작자, 바코드, URL"`
- 디바운스 300ms, submit label `.search`

### 최근 채택 섹션 (line 143–154)

- `@Query` 역순 최대 5개
- `RecentAdoptedRow`: 40×54pt rounded rect placeholder (opacity 0.12) + SF Symbol (medium) + title (`.subheadline.weight(.medium)`) + creator (`.caption`, secondary)
- 수평 패딩 16pt

### 검색 결과 카드 (line 266–333, `SearchResultCard`)

- `HStack`: 56×76pt cover placeholder + title/creator/year/publisher stack + `arrow.right.circle` 트레일링
- 배경: `.regularMaterial` + `RoundedRectangle(cornerRadius: 10)`
- 내부 패딩 12pt
- 채택 시 `onAdopt` 콜백 → `AddMemoryView` push

### 빈 상태 (line 201–218, `manualFallbackLink`)

- `"─  찾는 것이 없으신가요?  ─"` (caption, tertiary)
- `"직접 기록하기 →"` (subheadline, tint color)

### 제로 상태 (query 비어있고 아이템 없음, line 156–170)

- `sparkle.magnifyingglass` SF Symbol (36pt, tertiary)
- `"제목, 창작자, 바코드로 검색해 보세요"` (subheadline, secondary)

### 5 Medium SF Symbol (SemanticTokens.mediumIcon)

| Medium | 역할 |
|--------|------|
| `book` | 책 |
| `music` | 음반 |
| `movie` | 영화 |
| `object` | 오브제 |
| `place` | 장소 |

---

## 스크린샷 참조

`screenshots/20-curation-root-baseline.png` (없을 경우 코드 기준으로 진행)

---

## 디자이너 검토 과제

### A. 검색 입력 어포던스

현재: grey `.regularMaterial` rounded rect.  
검토 대안 3가지:

| 옵션 | 설명 | 참조 |
|------|------|------|
| **Liquid Glass** | iOS 26 `.ultraThinMaterial` + specular border | Apple iOS 26 HIG |
| **Bordered** | 1pt `accent.default` 12% border + white background | Day One 스타일 |
| **Underlined** | 하단 1pt line만, 배경 없음 | Are.na 검색창 |

브랜드 적합성 기준: JOH 최소주의 — 불필요한 chrome 제거 방향.

### B. 최근 채택 row 레이아웃

현재: 좁은 portrait-ratio 플레이스홀더 + 텍스트 row.  
검토 대안:

| 옵션 | 설명 |
|------|------|
| **Row (현행)** | 세로형 thumbnail + title/creator inline |
| **Card grid** | 2열 grid, cover dominant |
| **Compact list** | cover 없이 텍스트 only, 구분선 |

Sublime / Are.na 레퍼런스: row가 적절한 밀도로 권장되나 cover thumbnail 크기 재검토.

### C. 빈 상태 · 제로 상태 문구 및 시각 부드러움

- 현재 `sparkle.magnifyingglass` 아이콘 크기(36pt) → 더 작게(28pt)? 더 크게(48pt)?
- 문구 tone: `"제목, 창작자, 바코드로 검색해 보세요"` → 더 브랜드 감성으로 다듬기 여지 있음
- `"직접 기록하기 →"` 화살표: → 기호 vs SF Symbol `arrow.right` 분리 렌더링

---

## 제약

- iOS 26 Liquid Glass 호환 (`.regularMaterial` / `.ultraThinMaterial` 계열만)
- 커스텀 팔레트 금지 — `04-BRAND-SUMMARY.md` 브랜드 토큰만
- 브랜드 자산 accent: SF Mono 또는 New York Serif 사용 가능 (UI body는 SF Pro)
- 이모지 금지

---

## 납품물

- Figma 변형 3개 (옵션 A/B/C 검색 입력 어포던스 × 현행 row layout)
- 최종 권장 1개 + 근거 1문단
- 참조: Sublime (검색 중심), Are.na (row density), Day One (재질감)
- 납품 경로: `docs/design-brief/mockups/06/`
