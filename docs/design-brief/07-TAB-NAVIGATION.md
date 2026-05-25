# Tab Navigation — Design Brief

> 3-tab floating pill bar. iOS 26 native TabView 자동 Liquid Glass 처리.  
> 브랜드 토큰: `04-BRAND-SUMMARY.md` 참조.

---

## 현재 상태 (코드 기준)

파일: `App/Sources/App/Views/Root/ContentView.swift` (Build #9c)

### 3탭 구조 (line 38–74)

| 탭 순서 | 레이블 | 현재 SF Symbol | 대상 뷰 |
|---------|--------|---------------|---------|
| 1 | 큐레이션 | `sparkle.magnifyingglass` | `CurationRootView` → `SearchFirstView` |
| 2 | 내 컬렉션 | `books.vertical` | `LibraryListView` |
| 3 | Settings | `gearshape` | `SettingsRootView` |

- Tint: `Color.shAccent` (전체 TabView)
- iOS 26: TabView가 Liquid Glass floating pill 자동 적용

---

## 탭 순서 근거

**탭 1 = 검색**이 불변 조건 — 검색-입구 패러다임(`§0.-1` PRD). 새 큐레이션의 진입은 항상 검색.

---

## 디자이너 검토 과제

### A. 탭 아이콘 최종 선택

각 탭 후보 5종 제안. 브랜드 적합성(JOH 최소주의) + 직관성 기준으로 1종 선택.

**탭 1 큐레이션 (현재: `sparkle.magnifyingglass`)**

| 후보 | SF Symbol | 특징 |
|------|-----------|------|
| 현행 | `sparkle.magnifyingglass` | "마법 검색" 연상 — 큐레이션 감성 |
| B | `magnifyingglass` | 단순 검색, 범용 |
| C | `square.and.pencil` | 기록 행위 강조 |
| D | `archivebox` | 아카이브 직접 연상 |
| E | `star.circle` | 선택/채택 연상 |

**탭 2 내 컬렉션 (현재: `books.vertical`)**

| 후보 | SF Symbol | 특징 |
|------|-----------|------|
| 현행 | `books.vertical` | 책장 연상, 직관적 |
| B | `square.grid.2x2` | 컬렉션 grid |
| C | `archivebox` | 아카이브 |
| D | `tray.2` | 레이어/스택 |
| E | `folder` | 파일 시스템 연상 (약함) |

**탭 3 설정 (현재: `gearshape`)**

| 후보 | SF Symbol | 특징 |
|------|-----------|------|
| 현행 | `gearshape` | 표준 설정 아이콘 |
| B | `gearshape.2` | 더 복잡, 불필요 |
| C | `slider.horizontal.3` | 조정/설정 |
| D | `person.circle` | 프로필+설정 겸용 |
| E | `ellipsis.circle` | 더보기 패턴 |

### B. 활성 상태 처리

iOS 26 Liquid Glass pill에서 active tab treatment:
- **Color**: tint(`shAccent`) fill vs 단순 opacity 증가
- **Scale**: 아이콘 약간 확대(1.05×) vs 고정
- **Label**: 항상 표시 vs 활성 탭만 표시 vs 항상 숨김

권장 참조: iOS 26 HIG Tab Bar 섹션.

### C. Floating pill 배경

iOS 26 자동 Liquid Glass — 별도 커스터마이징 없이 진행 권장.  
단, `tint(Color.shAccent)` 적용이 pill active indicator 색에 반영되는지 시각 검증 필요.

---

## 제약

- SF Symbols 7 only — 커스텀 아이콘 자산 금지
- Dynamic Type: label은 축약/숨김 처리 가능, 아이콘은 고정 크기 유지
- VoiceOver: 각 탭 `.accessibilityLabel` 이미 코드에 정의됨 (`nav.curation`, `nav.collection`, `nav.settings`)
- 탭 순서 변경 금지 (검색이 탭 1 불변)

---

## 납품물

- 각 탭 후보 아이콘 5종 비교 frame
- 최종 선택 아이콘 세트 1종 + 선택 근거
- Active/inactive 상태 비교 frame (light mode 1종, dark mode 1종)
- 납품 경로: `docs/design-brief/mockups/07/`
