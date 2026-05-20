# Onboarding 3-step Design — Still Hours

> 2026-05-20 | Pre-flight Week 1 Round 3

---

## 1. Onboarding 목적

_Manifesto 안 만듬_ 결정 (PRD T1) → Onboarding 이 _제품 동작으로 증명_ 의 _첫 surface_.

3 화면 = 4축 정체성 중 _가장 강한 3축_ 시각화:

1. **Item-as-memory-anchor** (Day One 역방향 데이터 모델)
2. **다중 미디어 typed** (4 medium 통합)
3. **1-to-1 의도된 공유** (CKShare, public profile 없음)

사용자가 Skip 하더라도 이 3 화면은 여전히 _설치 직후 첫 접점_ — AppStore 스크린샷 다음으로 신뢰를 설득하는 유일한 기회. 철학 선언이 아닌 _제품 동작_ 을 시각으로 보여줌으로써 Manifesto 없이 브랜드 약속을 전달한다.

---

## 2. Screen 1: "자산이 기억의 입구가 된다"

### 2.1 Layout

| 영역 | 높이 비율 | 콘텐츠 |
|------|--------|-------|
| 상단 | 45% | ItemCard (3:4 portrait) — "Norwegian Wood" 책 표지 예시 |
| 중단 | 25% | Memory entry 1개 — 자동 등장 애니메이션 |
| 하단 | 30% | 카피 + Next / Skip |

카드 좌우 padding: `space.2xl` (48pt) → 카드 너비 ≈ 240pt (iPhone 14 기준). 카드 `radius.md` (12pt). 카드 배경: `surface.elevated` (`#FAFAF5`) + `shadow.elevated` (y:2, blur:8, opacity:0.06).

### 2.2 Animation — Liquid Glass shimmer 활용

아래 4단계는 _순차 실행_ (이전 단계가 끝난 뒤 시작).

| 단계 | 시작 시점 | 지속 | Easing | 동작 |
|------|--------|------|--------|------|
| 1. ItemCard 등장 | 0ms | 600ms | `easeOut` | opacity 0→1, y +12pt→0, 미세 tilt 8°→0° |
| 2. Specular sweep | 600ms | 1000ms | linear | `.glassEffect(.regular)` highlight 위→아래 한 번. 3초 간격 반복 |
| 3. Memory row 등장 | 1200ms | 500ms | `easeInOut` | opacity 0→1, x -8pt→0 (왼쪽 slide-in) |
| 4. 타이핑 효과 | 1700ms | ~1500ms | — | 1글자 / 45ms, 커서 깜빡 200ms 간격 |

타이핑 대상 텍스트: `"도쿄 츠타야 · 2024-08-15 · 어머니와 함께"`

Reduced Motion 활성 시: 단계 1~4 duration = 0, 최종 결과 상태만 cross-fade (200ms). Specular sweep 정지.

#### SwiftUI 구현 힌트

```swift
// 단계 1 — 카드 등장
.opacity(appeared ? 1 : 0)
.offset(y: appeared ? 0 : 12)
.rotationEffect(.degrees(appeared ? 0 : 8), anchor: .bottom)
.animation(.easeOut(duration: 0.6), value: appeared)

// 단계 3 — Memory row
.opacity(memoryVisible ? 1 : 0)
.offset(x: memoryVisible ? 0 : -8)
.animation(.easeInOut(duration: 0.5), value: memoryVisible)

// 단계 4 — 타이핑 (간이 구현)
private func typeNextChar() {
    guard charIndex < fullText.count else { return }
    displayedText += String(fullText[fullText.index(fullText.startIndex, offsetBy: charIndex)])
    charIndex += 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.045) { typeNextChar() }
}
```

### 2.3 카피

| 언어 | 헤드라인 | 서브 |
|------|--------|-----|
| 한국어 | "자산은 기록이 아닙니다. 입구입니다." | "가지게 된 이야기가 자산 안에 삽니다." |
| 영어 | "Items aren't records. They're entrances." | "The story of getting it lives inside." |
| 일본어 | "持つことは記録ではない。入口だ。" | "手に入れた物語が、その中に宿る。" |

폰트: `font.display` = New York Medium 28pt (헤드라인) / `font.body` = SF Pro Regular 17pt (서브). 색: `text.primary` (`#1A1812`) on `surface.primary` (`#F5F0E8`).

### 2.4 인터랙션

- **Skip** (top-right): `font.subhead` SF Pro Medium 15pt, `text.secondary` (`#7A7060`). Ghost — background 없음.
- **Next** (bottom-center): `buttonStyle(.glassProminent)` + `.glassEffect(.regular.tint(Color(hex: "#B85C38")).interactive())`. 텍스트 `font.heading.2` Semibold 17pt, `color.accent.default` 위 white.

---

## 3. Screen 2: "4 medium, 하나의 공간"

### 3.1 Layout

```
 ┌────────────┬────────────┬────────────┬────────────┐
 │   Book     │   Music    │   Movie    │  Object    │  ← 4 cards
 │  3:4 fixed │  3:4 fixed │  3:4 fixed │  3:4 fixed │
 │            │            │            │            │
 └──[badge]───┴──[badge]───┴──[badge]───┴──[badge]───┘
          카피 (아래 여백 24pt)
          Next button
```

카드 개별 너비: `(screen_width - 16×2 - 12×3) / 4` ≈ 74pt (iPhone 14 기준). 카드 높이: 너비 × (4/3) ≈ 99pt. 좌우 padding: `space.md` (16pt). 카드 간격: 12pt. 카드 `radius.sm` (8pt) — 작은 크기에서 `radius.md` 는 과함.

각 카드 하단 MediumBadge: SF Symbol + label, `font.caption` 12pt, `text.secondary`.

### 3.2 4 Medium 시각 콘텐츠

| Medium | 카드 예시 | SF Symbol | MediumBadge 텍스트 |
|--------|---------|----------|----------------|
| **Book** | "노르웨이의 숲" 책 표지 (따뜻한 톤 일러스트) | `book.closed` | "책" / "Book" / "本" |
| **Music** | Kind of Blue LP 슬리브 (파란 원형 느낌) | `music.note` | "음악" / "Music" / "音楽" |
| **Movie** | Wong Kar-wai 영화 포스터 (따뜻한 색조) | `film` | "영화" / "Movie" / "映画" |
| **Object** | 만년필 정물 (크림색 배경) | `cube` | "물건" / "Object" / "もの" |

v0.1 구현 시 실제 이미지 대신 `color.accent.muted` (`#D4A574`) 단색 placeholder 사용 허용. 실제 예시 이미지는 TestFlight 이전에 교체.

### 3.3 카피

| 언어 | 헤드라인 |
|------|--------|
| 한국어 | "책, 음악, 영화, 물건 — 하나의 책장." |
| 영어 | "Books, music, films, objects — kept under one shelf." |
| 일본어 | "本、音楽、映画、もの — ひとつの本棚に。" |

폰트: `font.display` New York Medium 28pt. 색: `text.primary`. 서브 카피 없음 (화면 공간 제약 + 브랜드 절제).

### 3.4 애니메이션

4 카드 순차 등장 (Reduced Motion OFF 기준):

| 카드 | delay | duration | easing |
|------|-------|----------|--------|
| Book | 0ms | 300ms | `easeOut` |
| Music | 120ms | 300ms | `easeOut` |
| Movie | 240ms | 300ms | `easeOut` |
| Object | 360ms | 300ms | `easeOut` |

각 카드: opacity 0→1, y +6pt→0. Liquid Glass refractive edge는 `.glassEffect(.clear)` 카드 외곽 자동 적용 (iOS 26 이상 자동).

Reduced Motion: 4 카드 동시 opacity cross-fade, 200ms, offset 없음.

---

## 4. Screen 3: "한 사람에게만"

### 4.1 Layout

```
        "Send to one person"        ← Sheet title 22pt New York Medium

  ┌─────────────────────────────────────┐
  │  ┌──┐  친구 미진                   │  ← Selected recipient (highlighted)
  │  │  │  minjin@example.com          │
  │  └──┘                              │
  │─────────────────────────────────────│
  │  ✗  Twitter                        │  ← 비활성 (greyed, crossed)
  │  ✗  Instagram                      │
  │  ✗  공개 프로필                     │
  └─────────────────────────────────────┘

  "공개 프로필 없음. 한 사람에게만."   ← 카피
           [ Start ]                  ← CTA (full width)
```

Sheet mockup은 `surface.elevated` + `radius.xl` (24pt) + `shadow.floating`. 비활성 행: `text.secondary` + strikethrough 스타일 (`Text(...).strikethrough(true, color: .secondary)`).

Selected recipient 행: 왼쪽 `accent.default` 2pt border + 배경 `color.accent.muted` opacity 0.12.

### 4.2 카피

| 언어 | 헤드라인 | 서브 |
|------|--------|-----|
| 한국어 | "공개 프로필 없음. 한 사람에게만." | "알고리즘이 아닌 당신이 선택한 한 사람." |
| 영어 | "No public profile. One person at a time." | "You choose who sees it. Not an algorithm." |
| 일본어 | "公開プロフィールなし。ひとりだけに。" | "アルゴリズムではなく、あなたが選ぶ。" |

폰트: 헤드라인 `font.display` New York Medium 28pt / 서브 `font.body` SF Pro Regular 17pt.

### 4.3 인터랙션

- **Start** 버튼: `buttonStyle(.glassProminent)`, full-width (좌우 `space.md` 16pt 여백만 빼고), 높이 52pt (Accessibility 권고 최소 44pt + 여유). `font.heading.2` Semibold 17pt.
- Tap → `withAnimation(.easeInOut(duration: 0.3))` → RootView (Library empty state) 전환.
- 전환 효과: Screen 3이 opacity 0으로 fade, Library empty state가 opacity 1로 교차.

---

## 5. 전체 흐름

| 화면 | 권장 체류 시간 | 전환 |
|------|-----------|-----|
| Splash (앱 launch) | 1.5초 | opacity cross-fade → Screen 1 |
| Screen 1 | 사용자 자유 (기준 8초) | swipe-left 또는 Next |
| Screen 2 | 사용자 자유 (기준 6초) | swipe-left 또는 Next |
| Screen 3 | 사용자 자유 (기준 6초) | "Start" tap → RootView |

총 기준 체류: 21.5초. Skip 경로: Screen 1 / 2 / 3 상단 Skip → 즉시 RootView.

### 5.1 스와이프 vs 버튼

TabView `.tabViewStyle(.page)` 사용 → 스와이프 자동 지원. 단, **역방향 스와이프 (되돌아가기) 는 허용** — 사용자가 Screen 2에서 Screen 1로 돌아갈 수 있어야 한다. PageIndicator dots: `color.accent.default` (active) / `color.text.secondary` opacity 0.4 (inactive). 크기 6pt.

---

## 6. Skip 정책

- 각 화면 상단 우측 Skip (`space.md` inset from edge).
- Skip 즉시 `UserDefaults.standard.set(true, forKey: "onboardingCompleted")` 저장.
- **다음 앱 실행부터 Onboarding 표시 안 함** — `@AppStorage("onboardingCompleted")` boolean.
- Settings → "Show onboarding again" 옵션은 v1.x 검토 항목 (v0.1 미구현).
- Onboarding 완료 (Start tap) 도 동일 key `true` 저장.

---

## 7. Accessibility

### 7.1 VoiceOver

| 요소 | VoiceOver label |
|------|----------------|
| Screen 1 ItemCard | "책 표지: 노르웨이의 숲. 당신의 자산이 기억의 입구가 됩니다." |
| Screen 1 Memory row | "기억 항목: 도쿄 츠타야, 2024년 8월 15일, 어머니와 함께" |
| Screen 2 각 카드 | "Book 미디어 예시", "Music 미디어 예시" 등 |
| Screen 3 Sheet mockup | "공유 대상: 친구 미진. 공개 프로필 없음. 소셜 미디어 공유 없음." |
| Skip 버튼 | "Skip onboarding, 건너뛰기" |
| Next 버튼 | "Next, 다음" |
| Start 버튼 | "Start, 시작. Still Hours를 시작합니다." |

### 7.2 Dynamic Type

- Ceiling: `.dynamicTypeSize(.xSmall ... .accessibility3)`.
- `accessibility4` / `accessibility5` 에서 레이아웃 붕괴 방지.
- 폰트 28pt → `.accessibility3` 에서 약 44pt — 4 카드 레이아웃이 2×2 grid로 자동 fallback 되도록 Screen 2 코드 분기.

### 7.3 Reduced Motion

모든 3 화면에서 `@Environment(\.accessibilityReduceMotion)` 확인:

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var animationDuration: Double { reduceMotion ? 0 : 0.6 }
```

Reduced Motion = true: 모든 duration = 0, offset 없음, cross-fade 200ms만 유지. 타이핑 효과 대신 텍스트 즉시 표시.

### 7.4 Contrast

- `text.primary` (`#1A1812`) on `surface.primary` (`#F5F0E8`): 대비율 16.8:1 (AAA 통과).
- `text.secondary` (`#7A7060`) on `surface.primary` (`#F5F0E8`): 대비율 4.7:1 (AA 통과).
- `accent.default` (`#B85C38`) on `surface.primary`: 대비율 4.5:1 (AA 통과, 18pt+ 기준).
- WCAG-Contrast-Verification.md §3 색 조합 표와 정합.

---

## 8. SwiftUI 구현 Spec

### 8.1 파일 구조

```
Sources/StillHours/Onboarding/
├── OnboardingCoordinator.swift      // AppStorage 체크, 표시 여부 결정
├── OnboardingView.swift             // TabView container, Skip/Next/Start 공통 로직
├── OnboardingScreen1.swift          // Item-as-memory-anchor 화면
├── OnboardingScreen2.swift          // 4 medium cards 화면
└── OnboardingScreen3.swift          // 1-to-1 share 화면
```

### 8.2 OnboardingCoordinator

```swift
struct OnboardingCoordinator: View {
    @AppStorage("onboardingCompleted") private var completed = false

    var body: some View {
        if completed {
            RootView()
        } else {
            OnboardingView(onComplete: { completed = true })
        }
    }
}
```

### 8.3 OnboardingView

```swift
struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var page = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $page) {
                OnboardingScreen1(onNext: { page = 1 })
                    .tag(0)
                OnboardingScreen2(onNext: { page = 2 })
                    .tag(1)
                OnboardingScreen3(onComplete: onComplete)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(reduceMotion ? nil : .easeInOut(duration: 0.3), value: page)

            // Skip button — Screen 1 / 2 만 표시
            if page < 2 {
                Button("Skip") { onComplete() }
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color("text.secondary"))
                    .padding()
            }
        }
        .background(Color("color.background"))
    }
}
```

### 8.4 OnboardingScreen1 핵심 state

```swift
@State private var appeared = false
@State private var memoryVisible = false
@State private var displayedText = ""
@State private var charIndex = 0

private let fullText = "도쿄 츠타야 · 2024-08-15 · 어머니와 함께"

.onAppear {
    // 단계 1: 카드 등장
    withAnimation(.easeOut(duration: 0.6)) { appeared = true }
    // 단계 3: Memory row (1200ms 후)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        withAnimation(.easeInOut(duration: 0.5)) { memoryVisible = true }
        // 단계 4: 타이핑 (1700ms 후)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { typeNextChar() }
    }
}
```

### 8.5 OnboardingScreen2 Dynamic Type 분기

```swift
@Environment(\.dynamicTypeSize) private var typeSize

private var useGridLayout: Bool {
    typeSize >= .accessibility4
}

// 2×2 그리드 fallback
var body: some View {
    if useGridLayout {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Medium.allCases) { medium in MediumCard(medium: medium) }
        }
    } else {
        HStack(spacing: 12) {
            ForEach(Medium.allCases) { medium in MediumCard(medium: medium) }
        }
    }
}
```

### 8.6 Liquid Glass 적용 위치

| 요소 | API |
|------|-----|
| ItemCard (Screen 1) | `.glassEffect(.clear, in: RoundedRectangle(cornerRadius: 12))` |
| Next / Start 버튼 | `.buttonStyle(.glassProminent)` |
| Skip 버튼 | `.buttonStyle(.glass)` |
| Screen 3 Share sheet mockup | `.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24))` |

---

## 9. 로컬라이제이션

### 9.1 Localizable.strings 키

```
// Screen 1
"onboarding.screen1.headline.ko" = "자산은 기록이 아닙니다. 입구입니다.";
"onboarding.screen1.headline.en" = "Items aren't records. They're entrances.";
"onboarding.screen1.headline.ja" = "持つことは記録ではない。入口だ。";
"onboarding.screen1.sub.ko" = "가지게 된 이야기가 자산 안에 삽니다.";
"onboarding.screen1.sub.en" = "The story of getting it lives inside.";
"onboarding.screen1.sub.ja" = "手に入れた物語が、その中に宿る。";

// Memory typing sample (locale-aware)
"onboarding.screen1.memorysample.ko" = "도쿄 츠타야 · 2024-08-15 · 어머니와 함께";
"onboarding.screen1.memorysample.en" = "Tsutaya Tokyo · 2024-08-15 · With my mother";
"onboarding.screen1.memorysample.ja" = "蔦屋書店 · 2024-08-15 · 母と一緒に";

// Screen 2
"onboarding.screen2.headline.ko" = "책, 음악, 영화, 물건 — 하나의 책장.";
"onboarding.screen2.headline.en" = "Books, music, films, objects — kept under one shelf.";
"onboarding.screen2.headline.ja" = "本、音楽、映画、もの — ひとつの本棚に。";

// Screen 3
"onboarding.screen3.sheet.title" = "Send to one person";
"onboarding.screen3.headline.ko" = "공개 프로필 없음. 한 사람에게만.";
"onboarding.screen3.headline.en" = "No public profile. One person at a time.";
"onboarding.screen3.headline.ja" = "公開プロフィールなし。ひとりだけに。";

// Common
"onboarding.skip" = "Skip";
"onboarding.next" = "Next";
"onboarding.start" = "Start";
```

---

## 10. v0.1 Effort 추정

DEVPLAN §5.2 Week 7 에 `Onboarding 3-step | 4h` 기재되어 있으나, 이는 _초기 스캐폴드 추정_ — 상세 spec 작성 후 현실 추정으로 대체한다.

| Task | Effort | 비고 |
|------|--------|------|
| OnboardingCoordinator + OnboardingView scaffold | 2h | TabView + AppStorage + Skip |
| Screen 1 ItemCard + Memory animation | 7h | 4단계 타이밍 + Liquid Glass glassEffect + 타이핑 효과 디버깅 |
| Screen 2 4 medium HStack + Dynamic Type 분기 | 4h | 2×2 grid fallback 포함 |
| Screen 3 Share sheet mockup + strikethrough | 4h | Mockup 레이아웃이 실제 CKShare 아님에 유의 |
| Skip / Next / Start navigation + UserDefaults | 2h | AppStorage + flow test |
| Accessibility — VoiceOver label + Dynamic Type + Reduced Motion | 3h | 각 3 화면 전수 |
| Localization (ko/en/ja) — Localizable.strings + locale-aware typing sample | 4h | ASO-Metadata-Wave1.md 정합 |
| **Total** | **26h** | |

**권고 4h 대비 +22h (5.5×)** 이유:

1. Liquid Glass `.glassEffect()` 는 iOS 26 신규 API — Xcode simulator 동작 확인 반복 필요.
2. 타이핑 애니메이션 (`DispatchQueue` 재귀) 은 Reduced Motion / Dynamic Type / 화면 회전 시 edge case 다수.
3. Screen 2 Dynamic Type 분기 (`accessibility4` 2×2 fallback) 는 별도 레이아웃 패스.
4. VoiceOver는 3 화면 × 5~7 요소 = 15~21 label 전수 작성.
5. Localizable.strings 키 수: 3 화면 × 3 언어 × 2 (headline+sub) + common = 30+ 키.

주간 22h 상한 (PRD §22h/week 엄수) 기준 → Week 7 배정 22h 소진 후 Week 8 초 4h로 완료.

---

## 11. 다음 Step

1. **Week 7**: OnboardingCoordinator + Screen 1 구현 (14h) — 애니메이션이 가장 risky → tracer bullet 우선.
2. **Week 7 후반**: Screen 2 + Screen 3 구현 (8h).
3. **Week 8 초**: Accessibility + Localization + Reduced Motion 검증 (4h).
4. **TestFlight 직전**: 실제 예시 이미지 교체 (v0.1 placeholder → 실 이미지).
5. **ASO-Metadata-Wave1.md** ko/en/ja 카피와 Onboarding 카피 정합 재확인 — 브랜드 톤 consistency.

---

_End of Onboarding 3-step Design._
