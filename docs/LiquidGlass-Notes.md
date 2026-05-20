# Liquid Glass — Still Hours 적용 plan

> 2026-05-20 | Pre-flight Week 1

---

## 1. Liquid Glass 개요 (WWDC 2025)

Apple이 2025년 6월 9일 WWDC25에서 발표한 새로운 통합 design language. iOS 26 / iPadOS 26 / macOS Tahoe 26 / watchOS 26 / tvOS 26 / visionOS 26 전 플랫폼에 동시 적용된다.

### 핵심 정의

Liquid Glass는 기존처럼 특정 물리 소재를 재현하는 것이 아닌, **디지털 메타 소재(digital meta-material)** 다. 실시간으로 빛을 굴절·집광하며, 터치와 앱 다이나믹스에 반응해 액체처럼 유기적으로 움직인다.

### 핵심 시각 특성

| 속성 | 설명 |
|------|------|
| **Lensing (렌징)** | 실시간으로 빛을 굽히고 집광. 기존 frosted glass의 "빛 산란"과 달리, 투명하고 가벼운 컨트롤을 구현하면서도 시각적 구분을 유지 |
| **Specular highlights** | 환경 광원이 소재 표면에 반응. 디바이스 모션(기기 기울기)에 따라 광점 이동 |
| **Adaptive shadow** | 아래 콘텐츠(텍스트·이미지 등)에 따라 그림자 불투명도 자동 조절 |
| **Internal illumination** | 터치 시 손가락에서 시작해 소재 전체와 인근 glass 요소로 glow 전파 |
| **Refraction** | 요소 크기에 따라 굴절 강도 조절 — 큰 요소(메뉴·사이드바)일수록 굴절 더 깊음 |

### Motion과의 통합

visuals과 motion이 분리된 것이 아닌, **설계 단계부터 통합**됐다. Material이 유연하게 늘어나며 상태 전환 시 morphing 효과를 보여준다. 요소 진입/퇴장도 단순 fade-in/out 대신 light bending 강도 변화로 표현한다.

### Layered App Icon System

WWDC25 Session 220("Say hello to the new look of app icons")에서 발표. iOS 26 / iPadOS / macOS 아이콘이 레이어 구조로 재정의됐다. Light / Dark tint / Clear 옵션을 지원하며, Apple의 **Icon Composer** 툴로 제작한다.

---

## 2. SwiftUI API (iOS 26)

### 자동 적용 범위

Xcode 26으로 리컴파일만 해도 다음 시스템 컴포넌트에 Liquid Glass가 자동 적용된다:
- TabBar, NavigationBar, Toolbar
- Sheet, Popover
- Context menu

### 핵심 modifier: `glassEffect()`

```swift
// 기본 (regular 변형, 캡슐 모양)
.glassEffect()

// 전체 시그니처
func glassEffect<S: Shape>(
    _ glass: Glass = .regular,
    in shape: S = DefaultGlassEffectShape,
    isEnabled: Bool = true
) -> some View
```

### Glass 변형 (Variant)

| 변형 | 용도 | 투명도 |
|------|------|--------|
| `.regular` | 기본값. 툴바·버튼·네비게이션 | 중간 |
| `.clear` | 미디어 콘텐츠 위 고투명 요소 | 높음 |
| `.identity` | 조건부 비활성화 (레이아웃 유지) | 없음 |

### Glass 메서드 (chainable)

```swift
.glassEffect(.regular.tint(.blue))         // 컬러 tint (주요 액션에만)
.glassEffect(.regular.interactive())        // iOS 전용: 스케일·바운스·shimmer·터치 glow
.glassEffect(.regular.tint(.orange).interactive()) // 체이닝 가능
```

### 버튼 스타일

```swift
.buttonStyle(.glass)           // 반투명 — 보조 액션
.buttonStyle(.glassProminent)  // 불투명 — 주요 액션
```

### Container + Morphing

여러 glass 요소를 묶어 단일 샘플링 + morphing 지원:

```swift
GlassEffectContainer {
    HStack {
        Button("Edit").glassEffect()
        Button("Delete").glassEffect()
    }
}

// morphing ID (상태 전환 애니메이션)
.glassEffectID("toggle", in: namespace)
```

### Clear 변형 사용 조건 (셋 모두 충족 시만)

1. 미디어 풍부한 콘텐츠(사진·영상) 위에 위치
2. dimming layer가 콘텐츠를 해치지 않음
3. 위에 올라오는 콘텐츠가 굵고 밝음

### Anti-pattern (사용 금지)

- 콘텐츠 레이어(테이블뷰·리스트·미디어)에 glass 적용 — glass-on-content
- Glass 위에 glass 쌓기 — glass-on-glass
- 모든 요소에 tint — 시각 혼란
- Regular + Clear 혼용

### Accessibility 자동 대응

코드 수정 없이 시스템 설정에 따라 자동 조절된다:

| 설정 | glass 반응 |
|------|-----------|
| Reduce Transparency | 더 불투명하게(frosted) |
| Increase Contrast | 흑/백 + 대비 테두리 |
| Reduce Motion | 애니메이션 감쇠 + elastic 비활성 |

---

## 3. Still Hours 적용 위치 (Design.md §8 정합)

| 위치 | Liquid Glass 활용 방향 | 변형 |
|------|----------------------|------|
| **App Icon** | 레이어드 glass cabinet — warm parchment 위 Wunderkammer 오브제 / 뚜껑이 glass layer로 구성 | Layered Icon (Icon Composer) |
| **TabBar** | Xcode 26 리컴파일로 자동 적용. still/warm 톤 유지 | `.regular` (자동) |
| **NavigationBar** | 자동 Liquid Glass — warm paper 위 translucent | `.regular` (자동) |
| **Floating CTA** | 주요 저장·추가 버튼에 `.glassProminent` | `.regular.interactive()` |
| **Item Card header strip** | 상단 accent strip에 `.regular.tint(.init(hex:"#B85C38"))` burnt sienna glass | `.regular` + tint |
| **Settings "Still Hours is" header** | 반투명 glass 헤더로 브랜드 선언 — `.clear` 조건 검토 필요 | `.regular` or `.clear` |
| **Memory Timeline accent line** | specular line effect — SwiftUI Canvas + glassEffect | custom shape |

**주의**: Item Card 리스트 자체(테이블뷰)에는 glass 적용 금지. 헤더·오버레이 strip만 대상.

---

## 4. Still Hours brand palette + Liquid Glass 합성

Still Hours 브랜드 컬러(`Design.md` 기준)와 Liquid Glass 특성의 합성 가능성을 점검한다.

### Warm parchment 배경 위 glass

`color.background` `#F5F0E8` (warm parchment) 위에 `.regular` glass가 올라오면, Liquid Glass의 **adaptive tinting system**이 warm 색조를 흡수해 glass 자체가 warm parchment 색감을 미묘하게 띤다. 별도 tint 없이도 브랜드 팔레트와 자연스럽게 정합한다.

### Burnt sienna glass 효과

`color.accent.default` `#B85C38` burnt sienna를 `.tint()`에 적용하면, Liquid Glass의 물리적 색유리 아날로그 동작으로 배경 밝기에 따라 hue·brightness·saturation이 자연스럽게 변한다. 도서관 가죽 + 유리 질감이라는 Wunderkammer metaphor와 정합한다.

### 권장 tint 사용처

tint는 **주요 액션 1~2곳**에만 한정한다. Apple 가이드라인 준수.

| 적용 위치 | Tint 색 | 근거 |
|-----------|--------|------|
| 주요 CTA (저장·추가) | `#B85C38` burnt sienna | 주요 액션 강조 |
| Item Card header strip | `#B85C38` 변형 | 브랜드 아이덴티티 |
| 그 외 | tint 없음 | 시각 혼란 방지 |

---

## 5. Curium → Still Hours 변경 영향 (재검토)

### Wunderkammer metaphor 현황

기존 Design.md의 app icon concept은 "호기심의 진열장(Wunderkammer / Curio cabinet)" — 사물을 수집·전시하는 캐비닛이다. 이 metaphor는 Curium 브랜드 시절 설계됐다.

### Still Hours와의 정합 평가

| 기준 | Wunderkammer metaphor | Still Hours 브랜드 |
|------|----------------------|-------------------|
| 감성 | 호기심·탐험·진귀함 | 고요·정지·시간의 흐름 |
| 시각 이미지 | 가득 찬 캐비닛 | 비움·여백·정제 |
| Liquid Glass 아이콘 | 유리 뚜껑 + 오브제 | 고요한 순간 속 오브제 |

**판단**: Wunderkammer의 "유리 진열장" 이미지는 Liquid Glass 아이콘 구조와 시각적으로 잘 맞으나, "Still Hours(고요한 시간)"라는 이름과의 감성적 거리가 있다. "가득 찬 호기심의 진열장" vs "고요한 시간 속 소중한 것들"은 다른 정서다.

**권고**: App icon metaphor를 Wunderkammer 구조는 유지하되, 오브제의 양을 줄이고 여백과 고요함을 살리는 방향으로 재조정. "아직 열려 있지 않은 조용한 캐비닛" 이미지 탐색. Icon Composer 작업 전에 사용자 최종 확인 필요.

---

## 6. 학습 우선순위

| 순위 | Task | 예상 소요 |
|------|------|---------|
| 1 | WWDC 2025 "Meet Liquid Glass" (Session 219) 시청 | 1h |
| 2 | WWDC 2025 "Get to know the new design system" (Session 356) 시청 | 1h |
| 3 | WWDC 2025 "Say hello to the new look of app icons" (Session 220) 시청 | 1h |
| 4 | Xcode 26 설치 + SwiftUI `glassEffect()` 실습 | 4h |
| 5 | Apple Design Resources iOS 26 UI Kit for Sketch — Liquid Glass 컴포넌트 탐색 | 2h |
| 6 | Icon Composer 툴 학습 + Still Hours 레이어드 아이콘 초안 | 2h |
| 7 | Still Hours brand × Liquid Glass 적용 위치 실물 목업 검토 | 2h |

---

## 7. 다음 step

- **Foundation tokens v1.0** 작성 (병렬 진행 중) — `color.glass.accent` 토큰 포함
- **App icon v1.0 draft** — Liquid Glass layered + Still Hours 감성 재조정
- **Memory Timeline visual signature** — Liquid Glass refractive edge 실험
- **TabBar/NavigationBar 자동 적용 확인** — Xcode 26 리컴파일 후 시뮬레이터 시각 검토

---

## Sources

- [Meet Liquid Glass — WWDC25 Session 219](https://developer.apple.com/videos/play/wwdc2025/219/)
- [Get to know the new design system — WWDC25 Session 356](https://developer.apple.com/videos/play/wwdc2025/356/)
- [Say hello to the new look of app icons — WWDC25 Session 220](https://developer.apple.com/videos/play/wwdc2025/220/)
- [Apple Design — What's New (HIG)](https://developer.apple.com/design/whats-new/)
- [Human Interface Guidelines: Materials](https://developer.apple.com/design/human-interface-guidelines/materials)
- [Adopting Liquid Glass — Apple Documentation](https://developer.apple.com/documentation/TechnologyOverviews/adopting-liquid-glass)
- [iOS 26 Liquid Glass: Comprehensive Swift/SwiftUI Reference — Conor Luddy](https://www.conor.fyi/writing/liquid-glass-reference)

---

_End of Liquid Glass Notes._
