# Design.MD — Still Hours Design System

> Version 1.0 (Living Document) | 2026-05-20 | sunghun.ahn
>
> _This document is meant to be updated continuously throughout the project._
> Sunsama 따뜻한 톤 + Things 3 단순강력 + World Top Class Benchmark 좋은 점 + Claude Design 협업.

---

## 0. About This Document

### 0.1 목적

본 문서는 _Still Hours_ 의 design system 의 _single source of truth_. PRD/DEVPLAN 은 _무엇을 / 어떻게 / 언제_, Design.MD 는 _어떻게 보이고 어떻게 느껴지는가_.

### 0.2 사용 방식

- _모든 시각 결정_ 은 본 문서를 참조
- _Claude Design (가칭)_ 과 함께 협업 시 본 문서가 _공통 언어_
- _Component 추가 / palette 변경 / typography 결정_ 모두 _섹션 추가_ 형태로 history 보존
- _Figma file_ (Apple Design Resources iOS 26 baseline + Still Hours 독립) 과 _이중 sync_ — Figma 가 _Visual single source_, Design.MD 가 _Decision + 근거 single source_

### 0.3 업데이트 절차

1. 결정 사항 발생 → 본 문서 _해당 섹션_ 또는 _새 섹션_ 추가
2. 결정 _근거_ 명시 (어느 benchmark 의 어느 패턴 차용? 어느 advisor 권고?)
3. _v__버전__ 표기 (예: `## 3.1 Color (v1.0 final)` → `## 3.1 Color (v1.5 added Aurora)`)
4. _하단 §15 update history_ 에 한 줄 기록
5. _Figma file_ 도 동시 update

### 0.4 협업 패턴 (Claude Design 가칭)

- _Decision request_ 시 본 문서 인용 (예: "§3.1 palette 의 `accent-default` `#B85C38` 는 _burnt sienna_, _도서관 가죽 제본색_ 정합")
- _Iteration variants_ 생성 시 _기존 token 재사용_ default, _신규 token_ 은 §15 history 등록
- _Living document_ — _수정 자유로움_, 단 _Forever 약속 (Promise §5)_ 위반 불가
- _UI quality bar_ = Apple Design Award 후보 수준 (Things 3 / Tot / Day One / Are.na 사이)

---

## 1. Design Philosophy

### 1.1 두 가지 정신적 기둥

#### 기둥 1 — **Sunsama** (calm + intentional 일일 의례)

> Sunsama 는 _daily planner that helps you feel calm and stay focused_.

**차용 항목**:

| 차용 | Still Hours 적용 |
|----|------|
| _Calm + muted color palette_ — 산만함 없는 환경 | Warm parchment background (`#F5F0E8`) + muted accent (burnt sienna `#B85C38`) |
| _Mindful planning + intentional workflows_ — 자기 _의례_ 로 도구 사용 | 3-second capture flow + Memory entry 의 _의식적_ 보존 |
| _White background + clean layout_ | 단 Still Hours 는 _warm white_ (parchment) — _차가운 흰색_ 보다 _따뜻한 종이_ 톤 |
| _Avenir typography_ — 부드러운 sans-serif | Still Hours 는 _System SF Pro_ (Apple-native, 8 locale fallback) + _New York serif_ (Item 제목, _slow + library_ 톤) |
| _Time-blocking 일일 의례_ | Still Hours 의 _Time Travel_ (anniversary / "On this day") = _시간 의례_ 의 collection 버전 |

**Sunsama 와 Still Hours 의 _다른_ 점**:

| Sunsama | Still Hours |
|---------|-------|
| _일일 작업_ 관리 (tasks / calendar) | _자산 + 기억_ 컬렉션 |
| _Today_ 중심 _현재 시간_ | _When/Where/From-whom_ 중심 _과거의 의미_ |
| _Calm 톤은 muted gray + 흰색_ | _Calm 톤은 warm parchment + burnt sienna_ |
| _Avenir_ (라이센스 sans-serif) | _SF Pro + New York_ (Apple system) |

→ Sunsama 정신은 _"calm + intentional"_ 핵심. Still Hours 의 _"느린 큐레이션"_ 과 합성.

#### 기둥 2 — **Things 3** (minimal + elegant + power tucked away)

> 2007년 창립, Apple Design Award _2회_ 수상. _Things 3_ 는 _Apple ecosystem 의 craftsmanship 표준_.

**차용 항목**:

| 차용 | Still Hours 적용 |
|----|------|
| _Minimalism + elegance_ — 첫 인상은 단순, 깊이 들어갈수록 능력 발견 | Library Grid 첫 화면 = 작품들의 _시각 인상_ 만, _typed metadata_ 는 ItemDetail tap 후 발견 |
| _Power tucked away_ — tags / checklist / start date / deadline 은 _corner_ 에 숨김 | Memory entry _상세 필드_ (date / place / contact / photo / voice) 는 _초기 hidden_, _필요 시_ disclosure |
| _"It's just you and your thoughts"_ — 산만함 0 | _No algorithm / No feed / No public profile_ (Promise §5) |
| _Apple ecosystem exclusive_ — Mac / iPhone / iPad / Watch / Vision Pro | Still Hours 도 _Apple-native first_, iOS 26 only deployment |
| _Quick Entry_ — keyboard shortcut 으로 즉시 task 추가 | Still Hours 의 _3-second capture_ (바코드 스캔 + 음성 메모) + Quick Capture 위젯 (v1.x) |
| _Today / Upcoming / Anytime / Someday_ 단순 카테고리 | Still Hours 의 _Library / Collections / Time Travel_ 3 카테고리 (no algorithm) |

**Things 3 와 Still Hours 의 _다른_ 점**:

| Things 3 | Still Hours |
|---------|-------|
| _Task management_ (할 일) | _Asset + memory_ (가진 것의 이야기) |
| _작업 완료_ 가 목표 | _기억 보존_ 이 목표 |
| _Today_ + _checklist_ + _project_ 데이터 모델 | _Item + Memory + Manifestation_ 데이터 모델 |
| 색은 _accent_ 만 사용 (대부분 흰 배경) | _palette 6색_ + _Liquid Glass material_ |

→ Things 3 정신은 _"minimal + elegant + power tucked away"_ 핵심. Still Hours 의 _Item-as-memory-anchor_ 와 합성.

### 1.2 합성된 Still Hours Design 정신 (4 차원)

| 차원 | 정신 | 구체 표현 |
|----|----|------|
| 1. _Calm_ | Sunsama 차용 | Warm parchment background, muted accent, no algorithm/feed/ad 환경 |
| 2. _Intentional_ | Sunsama + 사용자 의지 | 모든 capture / share / curate 가 _사용자 결정_ — 자동 분류 없음 |
| 3. _Minimal_ | Things 3 차용 | First impression 은 단순, 깊이는 disclosure 필요 시 노출 |
| 4. _Elegant_ | Things 3 + Apple Design Award 표준 | SF Pro + New York pair, Liquid Glass material, Wunderkammer cabinet icon |

→ **Still Hours = _Slow library of memory_** — Things 3 의 _craftsmanship_ + Sunsama 의 _calm intentionality_ + Item-as-memory-anchor 데이터 모델.

---

## 2. World Top Class Benchmark — 차용 항목

각 benchmark 의 _좋은 점_ 만 의식적으로 차용. anti-pattern 회피.

### 2.1 Are.na — anti-algorithm 정신

**차용**:
- _User-as-customer_ 순수성 (no advertiser interference)
- _Block + Channel + M:N connection_ → Still Hours _Item + Collection + M:N_ 매핑
- _재귀 Channel nesting_ → v1.x+ 검토 (Pre-flight v1.0 단순 유지)
- _Editorial layer_ (Are.na editorial) → Still Hours 의 _Settings "Still Hours is" surface + Founder voice_

**회피**:
- _Public-default channel_ — Still Hours default = private
- _Web-first_ — Still Hours = Apple-native first

### 2.2 Day One — Apple ecosystem 깊이 통합

**차용**:
- _Watch / Shortcuts / Health / Siri_ integration → Still Hours v2.0+
- _Encrypted entries_ → CloudKit Private DB (자동 encryption)
- _"On this day"_ 회고 → Still Hours 의 _Time Travel anniversary_
- _Entry photo + voice + drawing_ attachments → Still Hours 의 _Memory.photos / .voiceNote_

**회피**:
- _Entry-anchored_ 데이터 모델 — Still Hours 의 _Item-anchored_ 역방향
- _Daily Chat_ AI (Gold tier 2026) — Promise §5.4 (No AI judgment)
- _Subscription model_ — Still Hours 의 paid one-time

### 2.3 Letterboxd — Lists 의도된 큐레이션

**차용**:
- _Lists_ 기능 (사용자가 만든 의미 단위 묶음) → Still Hours _Collection_
- _Diary_ 시간 기록 → Still Hours _Memory.kind = watched_
- _Year in Review_ 연말 회고 → Still Hours v1.x _1주년 Letter_ (T5 정합)
- _Beautiful design_ — film posters 의 _visual treatment_

**회피**:
- _Star rating_ 강요 → Still Hours default OFF (별점 자체 없음, T2 Tier)
- _Social network_ (follow / like / comment) — Promise §5.2 (No feed)

### 2.4 Discogs — Work/Release 데이터 모델 시각화

**차용**:
- _Master/Release_ 패턴 → Still Hours _Item / Manifestation_ 1:N
- _External identifiers_ (catalog number, ISBN, MusicBrainz ID) 정규화
- _깊은 typed metadata_ (Format / Country / Label) → Still Hours Music typed metadata

**회피**:
- _Marketplace_ 기능 — Forever §5.3 약속 위반 가능
- _UX dated_ — Still Hours 는 modern minimal

### 2.5 Plumerie — Lending tracker first-class

**차용**:
- _대출 / 선물 / 받음_ 흐름 first-class → Still Hours _Loan_ entity
- _Overdue flag_ → Still Hours v1.x 알림 (default OFF, opt-in)
- _Family sharing_ → Still Hours 는 _v2.0+ 검토_ (Forever 정합 검토 후)

**회피**:
- _Web-first_ — Still Hours Apple-native
- _책 전용_ — Still Hours 4 medium

### 2.6 Tot — Apple-native paid one-time premium quality

**차용**:
- _$20 paid one-time_ premium positioning → Still Hours $14.99 (Tot 가격대 정합)
- _Apple-native_ + _system font (SF Pro)_ 충실
- _Minimum viable UI_ — 7 슬롯만 (deep simplicity)

**회피**:
- _Limited 7 슬롯_ — Still Hours 는 unlimited items
- _노트 only_ — Still Hours 다중 medium

### 2.7 1SE — 시간 단위 archive

**차용**:
- _시간 단위 mosaic_ → Still Hours Time Travel 시각화 (5년 전 오늘 / 시기별)
- _Anniversary 알림_ → Still Hours v1.x

**회피**:
- _시간 axis only_ — Still Hours _Item axis_ 가 primary
- _Subscription_ — Still Hours paid one-time

### 2.8 Polarsteps — 자동 GPS 추적

**차용**:
- _CoreLocation 자동_ 위치 메타데이터 → Still Hours Capture flow (위치 자동 제안)
- _인쇄 책자_ (PDF export 정교화) → Still Hours v2.0+ 검토
- _Trip Reels_ — Still Hours Time Travel 시각화 영감

**회피**:
- _여행 only_ — Still Hours 다중 medium

### 2.9 Sunsama — Calm + Intentional

**차용**:
- _Calm + muted_ 디자인 톤 → Still Hours palette warm parchment
- _Mindful planning_ — 매 capture / share 가 _의식적_
- _Avenir 영감_ → Still Hours 의 _SF Pro_ (Avenir 와 _humanist sans_ 정합)

**회피**:
- _Daily planner_ 기능 — Still Hours 는 collection
- _Avenir 직접 차용_ X — System SF Pro

### 2.10 Things 3 — Minimal + Elegant + Power tucked away

**차용**:
- _First impression simple, deep on disclosure_
- _Apple ecosystem 깊이_ (Watch / Vision Pro)
- _Quick Entry_ — Still Hours _3-second capture_ 영감
- _Today/Upcoming/Anytime/Someday_ 단순 카테고리 → Still Hours _Library / Collections / Time Travel_

### 2.11 Still Hours _차용 안 하는_ 항목 (anti-pattern)

| Anti-pattern | 출처 | 이유 |
|----------|-----|----|
| Public social profile / follow | Goodreads / Letterboxd / Are.na | Promise §5.2 |
| 별점 강요 | Goodreads / Letterboxd | Still Hours Tier 2 (별점 자체 없음) |
| Algorithm 추천 | MyMind / Cosmos / Listy | Promise §5.1 |
| Gamification (뱃지 / 스트릭) | Untappd / WatchBox Game | Promise §5.2 |
| LLM Daily Chat | Day One Gold 2026 | Promise §5.4 |
| Subscription IAP | Day One / MyMind / Sublime / Listy / Plumerie | Promise §5.5 + lint 강제 |
| Marketplace 통합 | Discogs / Kolekto | Still Hours 정체성 |
| 광고 / Amazon affiliation | Goodreads | Forever Clause |

---

## 3. Foundation Tokens

### 3.1 Color (v1.0 Final)

#### Light Mode (6색)

| Token | Hex | 용도 |
|-------|-----|----|
| `color.background` | `#F5F0E8` | Warm parchment (Still Hours 의 정체성 색) — _차가운 흰색 회피_, _도서관의 종이_ 톤 |
| `color.surface` | `#FAFAF5` | Card / sheet / popover. _Near-white with warmth_ |
| `color.text.primary` | `#1A1812` | Near-black with warmth. _Pure black 회피_, _묽은 잉크_ |
| `color.text.secondary` | `#665D4F` | Muted warm gray. Subtitle / Caption. WCAG AA: 5.71:1 on bg / 6.18:1 on surface. (Adjusted from `#7A7060` which was AA Large only on background.) |
| `color.accent.default` | `#B85C38` | Burnt sienna — _도서관 가죽 제본_, _Curio cabinet_ 색. interactive elements. WCAG AA Large only on bg/surface (4.00 / 4.34:1) — ≥18pt or ≥14pt bold only. |
| `color.accent.muted` | `#D4A574` | Warm sand. _이미지 fallback / skeleton state / non-text accent_. **텍스트 foreground 사용 영구 금지** (WCAG Fail: 1.96 / 2.13:1). |
| `color.onAccent` | `#1A1812` | CTA button label text on accent-colored backgrounds. **Always use on filled accent buttons.** WCAG: 3.91:1 on light accent (AA Large), 5.37:1 on dark accent (AA ★). |

#### Dark Mode (4색 + 2 fallback)

| Token | Hex | 용도 |
|-------|-----|----|
| `color.dark.background` | `#141210` | Warm dark, _pure black 회피_ |
| `color.dark.surface` | `#1E1B17` | Slightly elevated |
| `color.dark.text.primary` | `#F0EBE1` | Warm off-white |
| `color.dark.text.secondary` | `#9A9285` (inferred) | Muted warm light gray |
| `color.dark.accent.default` | `#D4734A` | Burnt sienna +30% lightness (contrast) |
| `color.dark.accent.muted` | `#A88560` (inferred) | Warm sand dark variant |

#### Semantic 활용 가이드

- `color.background` 는 _전체 화면 root_
- `color.surface` 는 _floated card / detail sheet_
- `color.accent.default` 는 _interactive elements only_ (button / link / toggle ON)
- `color.accent.muted` 는 _non-interactive accent_ (skeleton / disabled)
- _Liquid Glass material_ 위에 _accent_ 사용 시 _자동 specular highlight_ 적용

### 3.2 Typography (v1.0 Final)

**Pair**: SF Pro (system sans) + New York (system serif, iOS 17+)

| Token | Font | Weight | Size (Dynamic Type baseline) | 용도 |
|-------|------|--------|--------------------------|----|
| `font.display` | New York | Medium | 28pt (Large Title) | Still Hours 명함 / Settings header |
| `font.heading.1` | New York | Medium | 22pt (Title 2) | _Item 제목_ (책 / LP / 영화 / 오브제) |
| `font.heading.2` | SF Pro Text | Semibold | 17pt (Headline) | Section header / Modal title |
| `font.body` | SF Pro Text | Regular | 17pt (Body) | _Memory note_ 본문 / 자유 텍스트 |
| `font.callout` | SF Pro Text | Regular | 16pt (Callout) | _Creator / Artist / Director_ subtitle |
| `font.subhead` | SF Pro Text | Medium | 15pt (Subhead) | _Memory kind label_ |
| `font.caption` | SF Pro Text | Regular | 12pt (Caption 1) | _Date / Place / Tag meta_ |
| `font.caption.small` | SF Pro Text | Regular | 11pt (Caption 2) | _Metadata sub_ |

#### CJK Locale Fallback Stack

SF Pro / New York 은 _라틴 only_. CJK locale 자동 fallback:

```swift
enum StillHoursTypeface {
    static func heading1(for locale: Locale) -> Font {
        let lang = locale.language.languageCode?.identifier
        switch lang {
        case "ko": return .custom("AppleSDGothicNeo-Medium", size: 22)
            // 한국어는 시스템 폰트 — Medium weight 가 New York Medium 와 시각 weight 정합
        case "ja": return .custom("HiraginoMincho-W3", size: 22)
            // 일본어는 Mincho (serif) — New York 정신과 정합 (글자에 _serif elegance_)
        case "zh-Hans": return .custom("PingFangSC-Medium", size: 22)
        case "zh-Hant": return .custom("PingFangTC-Medium", size: 22)
        default: return Font.custom("NewYork-Medium", size: 22)
            // Latin / Cyrillic / 기타 → New York
        }
    }
    // body / callout / subhead 도 동일 패턴
}
```

#### Dynamic Type 대응

- _Custom font_ 사용 시 `.scaledFont(.title2, relativeTo: .title2)` 또는 SwiftUI `.dynamicTypeSize(.xSmall ... .accessibility5)` 의 _ceiling_ 명시
- 권고 ceiling = `.accessibility3` (Dynamic Type 이 _UI 깨짐 없는_ 한계)
- _Custom fonts 의 Dynamic Type_ 은 OYL `DesignTokens.swift` 의 _1.4× cap_ 패턴 참고 (단 코드는 독립 작성)

### 3.3 Spacing (v1.0 Final)

**Base grid**: 4pt + 8pt grid (SwiftUI default 정합)

| Token | Value | 용도 |
|-------|-------|----|
| `space.xs` | 4pt | _Inline_ icon spacing |
| `space.sm` | 8pt | _Tight_ vertical gap |
| `space.md` | 16pt | _Default_ padding (card 내부) |
| `space.lg` | 24pt | _Section_ gap |
| `space.xl` | 32pt | _Major_ section divider |
| `space.2xl` | 48pt | _Empty state_ generous padding |

#### Card padding

- Item Card 내부: `space.md` 사방
- Memory Row vertical: `space.sm` (8pt) — _slow + 공기_
- Library Grid gap: `space.sm` ~ `space.md` (column count 따라)

### 3.4 Radius (v1.0 Final)

| Token | Value | 용도 |
|-------|-------|----|
| `radius.sm` | 8pt | _Small button / chip / tag_ |
| `radius.md` | 12pt | _Card_ (Item / Memory / Collection cover) |
| `radius.lg` | 16pt | _Sheet / popover_ |
| `radius.xl` | 24pt | _Modal / large surface_ |

iOS 26 _Liquid Glass_ 는 _둥근 사각형_ 자체가 _refractive edge_ 형성 — radius 가 _시각 정체성_ 의 일부.

### 3.5 Shadow (v1.0 Final)

_Light mode_:
- `shadow.elevated` — Card 가 _surface 위_ 일 때: `y: 2, blur: 8, opacity: 0.06` warm gray
- `shadow.floating` — Sheet / popover: `y: 4, blur: 16, opacity: 0.10` warm gray

_Dark mode_:
- Shadow 대신 _border + lighter surface_ 활용 — Liquid Glass dark variant 자체가 _depth_ 형성

### 3.6 Motion (v1.0 Final)

**원칙**: _Calm motion_ — Sunsama 정신. 빠르지도, 느리지도 않음. _Slow + intentional_.

| Token | Duration | Easing | 용도 |
|-------|----------|--------|----|
| `motion.quick` | 200ms | `easeOut` | Tap response / button press |
| `motion.standard` | 300ms | `easeInOut` | Sheet present / navigation push |
| `motion.deliberate` | 500ms | `easeInOut` | Onboarding step transition / Time Travel transition |
| `motion.slow` | 800ms | `easeInOut` | _드물게_ — Memory entry _자동 추가_ 애니메이션 |

**금지**:
- _Spring animation_ 과도 사용 (overshoot _giddy_)
- _Parallax_ excessive (산만)
- _Auto-play video_

**Reduced Motion 대응**:
- `accessibilityReduceMotion` 활성 시 모든 motion `duration = 0` (즉시 전환)
- _Cross-fade_ 만 유지 (300ms → 200ms 단축)

---

## 4. Semantic Tokens

### 4.1 Surface

- `surface.primary` = `color.background` (전체 화면)
- `surface.elevated` = `color.surface` (card)
- `surface.floated` = `color.surface` + `shadow.floating` (sheet)

### 4.2 Text

- `text.primary` = `color.text.primary` (본문)
- `text.secondary` = `color.text.secondary` (subtitle / meta)
- `text.accent` = `color.accent.default` (interactive)
- `text.muted` = `color.text.secondary` (disabled / placeholder)

### 4.3 Accent

- `accent.default` = `color.accent.default` (button / link / focused)  
  Light: 4.00:1 on bg / 4.34:1 on surface — **AA Large only** (≥18pt or ≥14pt bold). Normal body text 금지.
- `accent.muted` = `color.accent.muted` (skeleton / muted highlight)  
  **텍스트 foreground 사용 영구 금지 (WCAG Fail).** 허용 용도: skeleton fill, disabled border/background, image placeholder, non-text icon fill.
- `accent.onAccent` = `color.onAccent` (`#1A1812`) — **CTA button text 전용 토큰.**  
  Dark mode filled button: 5.37:1 AA ★. Light mode filled button: 3.91:1 AA Large (≥18pt or ≥14pt bold).  
  `text.primary` 또는 `text.muted` 를 accent 배경 위 텍스트에 사용하는 것 금지.
- `accent.medium.book` = `color.accent.default` (v1.0 single-accent baseline)
- `accent.medium.music` = `color.accent.default` (v0.5 시점 medium-별 시안 비교 후 결정)
- `accent.medium.movie` = `color.accent.default`
- `accent.medium.object` = `color.accent.default`

→ v1.0 baseline = _single-accent_. v0.5 medium-별 다름 검토 시 _아래 token_ 분기:
- `accent.medium.book` = warm amber (TBD)
- `accent.medium.music` = deep teal (TBD)
- `accent.medium.movie` = dusty rose (TBD)
- `accent.medium.object` = sage (TBD)

### 4.4 Memory kind

- `memory.kind.icon.acquired` = SF Symbol `shippingbox`
- `memory.kind.icon.read` = SF Symbol `text.book.closed`
- `memory.kind.icon.listened` = SF Symbol `headphones`
- `memory.kind.icon.watched` = SF Symbol `film`
- `memory.kind.icon.lent` = SF Symbol `arrow.uturn.left`
- `memory.kind.icon.received` = SF Symbol `arrow.down.left.square`
- `memory.kind.icon.gifted` = SF Symbol `gift`
- `memory.kind.icon.annotated` = SF Symbol `pencil.line`

→ _모두 SF Symbols 7_, single-tint accent line 으로 _kind 구분_ (color 아님)

---

## 5. Component Library

### 5.1 ItemCard (3:4 portrait fixed)

```
┌─────────────────────┐
│                     │
│  [Cover image       │
│   center-crop +     │
│   medium-color      │
│   accent strip]     │
│                     │
├─────────────────────┤
│  Title (New York)   │
│  Creator (SF Pro)   │
└─────────────────────┘
```

**규격**:
- Aspect ratio: 3:4 (book cover 표준)
- Music / Movie / Object: 종횡비 다른 image 는 _center-crop_ + _상하 medium-color accent strip_ (4pt)
- Padding: `space.md` 사방
- Radius: `radius.md` (12pt)
- Shadow: `shadow.elevated`
- Tap response: `motion.quick`

### 5.2 MemoryRow + Timeline

```
│ ⬤  icon  Memory note text first line...
│   Date · Place · withWhom (caption)
│
│ ⬤  icon  Another memory entry...
│   Date · Place
│
```

**규격**:
- Vertical timeline _accent line_ (medium-shared, 1pt) 왼쪽 16pt
- Icon: SF Symbol, 16pt size, `accent.default` color
- Icon ↔ text gap: `space.sm` (8pt)
- Row vertical gap: `space.sm` (8pt)
- Date / Place / withWhom: `font.caption`, `text.secondary`

### 5.3 CollectionCover

```
┌───────────────┐
│  [Hero image] │
│               │
│  Collection   │
│  Title        │
│  N items      │
└───────────────┘
```

**규격**:
- Aspect ratio: 16:9 (landscape, ItemCard 와 시각 차별)
- _Cover image_ = 사용자 지정 Item 중 하나 또는 _첫 N개 mosaic_
- Title: `font.heading.1` (New York Medium 22pt)
- Item count: `font.caption`

### 5.4 MediumBadge

```
[📖 Book]  [🎵 Music]  [🎬 Movie]  [🎁 Object]
```

**규격**:
- Pill shape, `radius.sm` (8pt)
- Icon (SF Symbol) + label (`font.subhead`)
- Background: `surface.elevated` 또는 _medium-specific muted accent_
- Padding: 4pt vertical / 8pt horizontal

### 5.5 CaptureSheet (Capture Flow)

```
┌────────────────────────┐
│  [Barcode scan area]   │
│                        │
│  Scanned: 9784785......│
│  Auto: Murakami, ...   │
│                        │
│  📍 Where? (auto)      │
│  📅 When? (auto: now)  │
│  💬 Why? (voice/text)  │
│                        │
│  [Save to Library]     │
└────────────────────────┘
```

**규격**:
- _Half-screen sheet_ (iOS 16+ `.presentationDetents([.medium])`)
- _3-second goal_: 바코드 → 자동 메타 → "Why?" 음성 → Save = _직렬 3초_
- _권한 요청_ 은 _onboarding 마지막 step 에 분리_ (UX R1)

### 5.6 Settings → "Still Hours is" surface

```
Still Hours is
———————————————
· No algorithm
· No public feed
· No advertising

Data Sovereignty
———————————————
[Export Library (JSON)]
[Export Library (CSV)]
[Export Library (PDF)]

Your data lives in your iCloud only.

Made by
———————————————
sunghun.ahn
sober collection design
[blog]
```

**규격**:
- 3 섹션, 각 섹션 _heading 2_ + body
- _Semi-translucent Liquid Glass material_ (iOS 26 자동)
- 카피 톤: _담백, observer, no exclamation_

### 5.7 Empty States

#### Empty Library

```
        (no illustration)

   처음 자산을 추가하면
   기억의 입구가 열립니다.

       [ + Add first item ]
```

**규격**:
- _텍스트 단독_, 일러스트 _없음_ (Things 3 패턴)
- Body text: `font.heading.2`, `text.primary`
- Sub text: `font.body`, `text.secondary`
- CTA: `accent.default`

#### Empty Collection / Empty Memory Timeline

각각 _카피만 다르게_, 시각 패턴 동일.

---

## 6. Iconography

### 6.1 SF Symbols 7 Baseline

- _모든 icon_ 은 SF Symbols 7 우선
- Custom icon 도입 = _10× 가치 통과 시만_
- SF Symbols 7 _Multicolor_ 옵션은 _default 사용 안 함_, _accent.default_ tint 만 사용

### 6.2 Memory Kind 7+1 Icons

| Kind | SF Symbol |
|------|-----------|
| `acquired` | `shippingbox` |
| `read` | `text.book.closed` |
| `listened` | `headphones` |
| `watched` | `film` |
| `lent` | `arrow.uturn.left` |
| `received` | `arrow.down.left.square` |
| `gifted` | `gift` |
| `annotated` | `pencil.line` |

→ 8가지. (PRD 에 7가지 명시되었으나 실제 enum 은 8가지. 향후 PRD update.)

### 6.3 Medium 4 Icons

| Medium | SF Symbol |
|--------|-----------|
| `book` | `book.closed` |
| `music` | `music.note` |
| `movie` | `film` |
| `object` | `cube` |

→ TabBar / Library filter / ItemCard medium badge 모두 동일 icon 활용.

### 6.4 Custom Icons (v1.0 _없음_)

App Icon (Wunderkammer cabinet) 만 custom. 그 외 _모두 SF Symbols 7_.

---

## 7. App Icon

### 7.1 Wunderkammer + Liquid Glass Layered

**Concept** (PRD §17.4 + UI R7):
- Background: burnt sienna `#B85C38` glass material
- Middle: 백색 선묘 cabinet 문틀 (refractive edge)
- Foreground: 4 미세 오브제 silhouette (책 / 음표 / 필름 frame / 점 = object)
- Motion: device tilt → cabinet 안 오브제 _horizontal shift_

### 7.2 Variants (iOS 26 Layered Icon System)

- Light variant: 위 standard
- Dark variant: background `#5C3020` (어두운 burnt sienna), 백색 선묘 유지
- Tinted variant: monochrome, accent tint 적용 (iOS 18+ 도입 패턴)

### 7.3 Sizing Adaptation

- 1024×1024 (App Store): 4 미세 오브제 모두 visible
- 180×180 (iPhone Home): 4 오브제 점 4개로 단순화
- 60×60 (Spotlight): cabinet 문틀만, 오브제 _부재_ 가능

### 7.4 Apple Design Resources 활용

Apple Design Resources iOS 26 Figma 의 _Layered icon_ template 활용. Pre-flight Week 1 에 1차 시안 작성.

---

## 8. Liquid Glass Application

### 8.1 Xcode 26 자동 적용 (default)

iOS 26 target + Xcode 26 recompile = _기본 Liquid Glass 자동_:
- TabBar / NavigationBar / Sheet / Popover 모두 _translucent material_ 자동
- 별도 코드 _없음_

### 8.2 Custom Material 활용 위치

| 위치 | 활용 |
|-----|----|
| App Icon | Layered Glass (§7.1) |
| Item Card cover image overlay | _상하 medium-color accent strip_ 의 _glass refraction_ |
| Memory Timeline accent line | _specular line_ effect |
| Settings → "Still Hours is" header | Semi-translucent material |

### 8.3 Still Hours Palette + Liquid Glass 합성

- `color.background` `#F5F0E8` 위 _semi-translucent surface_ = 자연스러운 _warm parchment_
- `color.accent.default` `#B85C38` 가 _refractive edge_ 와 합성 시 _burnt sienna glass_ 느낌 (도서관 가죽 + 유리)

---

## 9. Locale-Specific

### 9.1 CJK Typography Fallback Stack

§3.2 참조. `StillHoursTypeface` helper namespace 로 _locale 기반 자동 fallback_.

### 9.2 8 Locale 검증 항목

| Locale | Typography | 검증 항목 |
|--------|----------|--------|
| ko | Apple SD Gothic Neo Medium | Item 제목 weight 정합, Dynamic Type 깨짐 없음 |
| en | SF Pro + New York | Default |
| ja | Hiragino Mincho W3 | _Serif feel_ 유지, 가나 + 한자 weight 정합 |
| zh-Hans | PingFang SC Medium | Latin 과 weight 정합 |
| zh-Hant | PingFang TC Medium | Latin 과 weight 정합 |
| fr | SF Pro + New York | Default + accent 글자 |
| es | SF Pro + New York | Default + accent 글자 |
| pt | SF Pro + New York | Default |
| de | SF Pro + New York | Long compound word 줄바꿈 |

### 9.3 RTL (right-to-left)

v1.0 _RTL locale 없음_ (8 locale 모두 LTR). v2.0+ 아랍어 / 히브리어 검토 시 _full RTL audit_.

### 9.4 Wave 1 (ko/en/ja) 우선 검증

- `bash scripts/check-i18n.sh` (독립 lint, 10 axis) — v0.1 부터 ko/en active
- v0.5 ja 추가 시 _시뮬레이터 ja locale_ 실제 검증
- _Native speaker_ review _ja 만_ v0.9 단계 (한국어/영어는 본인)

---

## 10. Accessibility

### 10.1 VoiceOver

- _모든 SF Symbol_ = label 명시 (예: `Image(systemName: "shippingbox").accessibilityLabel("Acquired")`)
- _Memory Timeline_ = _entry 별_ 명시 라벨 ("Acquired on 2024-08-15 at Tsutaya Daikanyama")
- _Item Card_ = 종합 label ("Norwegian Wood, Murakami, 1987, book medium")

### 10.2 Dynamic Type

- Type scale (§3.2) 모두 _system Dynamic Type_ + custom font scaling
- Ceiling = `.accessibility3`
- Layout `ScaledMetric` + `MinimumScaleFactor(0.7)` for tight rows

### 10.3 Reduced Motion

- `accessibilityReduceMotion` 활성 시:
  - 모든 animation `duration = 0` (즉시)
  - Cross-fade _만_ 유지 (200ms)
  - App icon _device tilt motion_ → static
  - Liquid Glass _refraction effect_ → reduced

### 10.4 Color Contrast (WCAG AA)

| 조합 | Light | Dark |
|----|----|----|
| `text.primary` on `surface.primary` | _verify_ — `#1A1812` on `#F5F0E8` ≈ 12:1 (AAA) | `#F0EBE1` on `#141210` ≈ 13:1 (AAA) |
| `text.secondary` on `surface.primary` | `#7A7060` on `#F5F0E8` ≈ 4.5:1 (AA) | _verify_ |
| `accent.default` button text | _verify_ |  |

→ Pre-flight Week 1 에 _contrast 검증 chart_ 생성. _WCAG AA_ 미달 _0 token_ 목표.

---

## 11. Editorial Surface (Manifesto 부재 대체)

PRD T1 결정: Manifesto _만들지 않음_. _제품 자체로 증명_.

### 11.1 Settings → "Still Hours is" 3 섹션

- §5.6 컴포넌트 참조
- 카피 톤: 담백 + observer + no exclamation
- 사용자 _최초 진입_ + _Settings 접근_ 모두 자연스러운 surface

### 11.2 Founder Voice (Twitter / Threads / Blog)

- _월 1-2회 founder voice_ (Marketing P5)
- Tone: sober, _고밀도 1-2 post_ (Hacker News Show HN 등) launch 시점 집중
- Visual continuity: _Still Hours 의 burnt sienna accent_ + _시스템 폰트_ 사용한 cover image

### 11.3 v1.x 1주년 Letter

- Launch 1년 시점 _1주년 Letter_ 발행 (8 locale)
- _Manifesto-grade_ 톤 (Are.na editorial 정합)
- _제품 1년 회고 + 개발자 1년 + 다음 1년 방향_

---

## 12. Claude Design 협업 가이드라인

### 12.1 Document 업데이트 절차

1. _결정 사항_ 발생 → 본 Design.MD 의 _해당 섹션_ 업데이트
2. _근거 명시_ (어느 advisor 권고 / 어느 benchmark 패턴)
3. `§15 update history` 하단 추가
4. Figma file 동시 sync

### 12.2 Design Decision Pattern

**4-step decision flow**:

1. _문제 정의_ (예: "Memory Timeline 의 entry _순서가 reverse chronological_ 인가 chronological 인가?")
2. _benchmark 참고_ (Day One = reverse chrono / 1SE = chrono mosaic / Are.na = reverse chrono)
3. _Still Hours 정신 정합_ (Time Travel = 과거 회고 → _chronological 정합_, 단 default 진입은 _최근 entry_ 보이게)
4. _결정 + Design.MD 섹션 추가 + Figma_

### 12.3 Figma File 연계

- Apple Design Resources iOS 26 Figma = _baseline_
- Still Hours Figma file = _독립_ workspace (Apple baseline 위 _독립 design tokens_ 와 _component library_)
- Foundation tokens 변경 시 _Figma + Design.MD + Swift code_ 3-way sync

### 12.4 Iteration / Variants

- _A/B variants_ 생성 시 _기존 token 재사용_ default
- 신규 token 도입 시 _§15 history_ 등록
- Memory Timeline / Item Card / Onboarding 등 _핵심 surface_ 는 _3 variants 비교_ 단계 권고

### 12.5 Working Patterns

| Pattern | When | How |
|---------|------|----|
| _Token-only edit_ | 새 색 / 새 size 등 | Foundation token 1개 추가 → 모든 component 자동 영향 |
| _Component spec_ | 새 component (예: TimeTravel Mosaic) | §5 새 subsection 추가 + Figma component 동시 작성 |
| _Surface design_ | 새 화면 (예: Onboarding screen 1) | _기존 component_ 조합 + spacing 결정 + 카피 |
| _Iconography update_ | 새 SF Symbol 도입 | §6 추가 + SF Symbols 7 검증 |
| _Accessibility audit_ | 분기별 review | §10 항목별 verification |

---

## 13. v1.0 → v2.0 Design Evolution

### 13.1 v1.0 Final State (Wave 1 launch)

- Foundation tokens: §3 final
- Semantic tokens: §4 final
- Component library: §5 _1-7 모두_
- App Icon: §7 Wunderkammer + Liquid Glass
- Editorial: §11 Settings "Still Hours is" + Founder voice

### 13.2 v1.x (post-launch)

- 위젯 (Lock Screen / Home Screen) — Apple Design Resources iOS 26 widget template
- 알림 (default OFF) — _quiet notification_ 디자인
- 가격 transition $14.99 → $19.99 — _UI 변경 없음_

### 13.3 v2.0 Mac Native

- macOS Tahoe 26 Sidebar + Split View
- Mac-only Drag & Drop capture
- Apple Watch (회고 알림)
- Foundation tokens _공통_ + Mac-specific _확장 token_
  - `space.mac.sidebar` = 240pt
  - `space.mac.contentMin` = 600pt
  - `card.mac.maxWidth` = 220pt (Grid 4 columns)

### 13.4 v3.0+ (검토)

- Vision Pro (visionOS 27?)
- Place / Experience medium
- 그룹 컬렉션 (3+ 명) — Forever 정합 검토 후

---

## 14. Pre-flight Week 1 Deliverable Checklist

DEVPLAN v2.0 §15.2 와 정합. 본 Design.MD _구체화_:

- [ ] Apple Design Resources iOS 26 Figma 다운로드
- [ ] SF Symbols 7 macOS 앱 install
- [ ] Memory kind 8 + Medium 4 = 12 SF Symbols selection 검증
- [ ] Liquid Glass material reference 학습 (WWDC 2025 video)
- [ ] Xcode 26 + iOS 26 simulator 환경 셋업
- [ ] Foundation tokens 1차 코드 작성 (Color 10 + Type 8 + Space 6 + Radius 4 + Shadow 2 + Motion 4)
- [ ] Semantic tokens 1차 코드 작성 (§4 모든 token)
- [ ] Component tokens 1차 (ItemCard / MemoryRow / CollectionCover / MediumBadge)
- [ ] App icon 1차 시안 작성 (Wunderkammer + Liquid Glass layered)
- [ ] Memory Timeline visual signature design pass (8-12h 별도)
- [ ] Settings → "Still Hours is" 카피 ko/en 1차 draft
- [ ] WCAG AA contrast 검증 chart
- [ ] Trademark 사전 조사 (KIPRIS + USPTO Class 9 + EUIPO + App Store 동명 앱 전수)

---

## 15. Update History

| Date | Section | Change | Reason |
|------|---------|--------|--------|
| 2026-05-20 | v1.0 initial | _All sections_ created | Pre-flight 시작 직전, 사용자 instruction (Sunsama + Things + benchmark + Claude Design 협업) 반영 |
| 2026-05-20 | §16 정정 | No ads (Apple Search Ads 포함) 명시 | 사용자 결정 |

→ 추후 모든 design 결정 본 history 에 추가.

---

| 2026-05-20 | All sections | Curio → Curium 일괄 변경 | 4-panel + critic advisory + Web verification → Vaulta EOS Network 충돌 폐기, Curium 자동 채택 |
| 2026-05-20 | §16 added | ASO Visual Strategy 섹션 추가 | 3-panel ASO advisory 종합 |
| 2026-05-20 | All sections | Curium → Still Hours 일괄 변경 | 25 후보 검증 후 최종 채택 (advisor 권고, Branding 1위) |

---

## 16. ASO Visual Strategy (지속 운영)

> 사용자 instruction: "ASO는 우리의 지속 과제. 개발 단계부터 철저히 고려."

3-panel advisory (Marketing / Strategy / Design) 종합 결과 — 시각 관련 항목.

### 16.1 Screenshot 8장 순서 + 시각 일관성

| # | 장면 | 감정 목적 |
|---|------|----------|
| 1 | Memory Timeline | 감정 훅 — 기억의 축적 |
| 2 | Story Capture 3초 | 핵심 UX 증명 |
| 3 | Library 4-tab | 전체 구조 전달 |
| 4 | Promise 5조항 manifesto | 신뢰 구축 |
| 5 | Tsutaya 도쿄 장면 | 감성 맥락 (Joon 캐릭터) |
| 6 | Collection 의미 묶음 | M:N 연결 |
| 7 | Intimate Share | 1-to-1 공유 |
| 8 | Data Sovereignty | 차별화 마무리 |

**시각 일관성 원칙**:
- 배경: `#F5F0E8` parchment 단색 고정 (화면 콘텐츠와 배경 혼재 금지)
- 기기 frame: iPhone 16 Pro 실버 단일 통일
- accent 강조 요소: `#B85C38` 1개 요소만 per screenshot
- 상·하 여백: 20-24pt 고정

### 16.2 Preview Video 30초 (Wave 1, en 1개)

| 구간 | 내용 | 감정 |
|------|------|------|
| 0-8s | Capture — 바코드 스캔 → 자동 메타 | 즉각성 |
| 8-20s | Memory Timeline — 시간 흐름 회고 | 깊이 |
| 20-30s | Promise 3조항 fade (No algorithm / No subscription / Data Sovereignty) | 신뢰 |

제작 도구: Rotato + QuickTime + iMovie (Wave 1, 6-8h). Wave 2 이후 자동화 검토.

### 16.3 Custom Product Pages 3개 시각 분화

| Page | 타겟 | 주요 시각 요소 |
|------|------|--------------|
| A — Lina (큐레이터) | 취향 중심, 여성 30대 | Library Grid + Memory Timeline — parchment 풀 화면 |
| B — Joon (출장자) | 도시 탐방, 여행자 | Tsutaya 도쿄 Capture 장면 우선 + Map annotation |
| C — Book-only | Goodreads 이탈자 | Book medium 특화 screenshot 전면 배치 + Promise 비교 |

각 Page는 screenshot 8장 중 2-3장 교체. 나머지 기본 세트 공유.

### 16.4 App Icon 60×60 vs 1024×1024 Detail 분리

| 크기 | 표현 수준 |
|------|----------|
| 1024×1024 (App Store) | Cm/96 이스터에그 visible, 4 미세 오브제 모두 표현 |
| 180×180 (iPhone Home) | 4 오브제 → 점 4개로 단순화 |
| 60×60 (Spotlight/Notification) | cabinet 외형 실루엣만. 오브제 부재 허용 |

**Pre-flight 24h 안 방향 확정 필수** (변경 비용: App Store 재제출 + 마케팅 자산 전체 재작업).

### 16.5 Wave별 Screenshot 제작 계획

| Wave | 수량 | 방식 |
|------|------|------|
| Wave 1 (ko/en/ja) | 24장 (8 × 3 locale) | 수동 — Keynote + iOS Simulator capture |
| Wave 2 (zh/de) | 16장 추가 | 반자동 — scripts/capture-screenshots.sh |
| Wave 3 (fr/es/pt) | 24장 추가 | 자동화 — xcodebuild UI Test + simctl screenshot |

Sketch/Figma 의존성 회피. Keynote 단독으로 device frame + caption 합성 가능.

### 16.6 Screenshot Ritual

| 주기 | 내용 |
|------|------|
| 매월 1일 | Promotional Text 170자 검토 + 업데이트 (심사 없이 update 가능) |
| 분기 1회 (1/4/7/10월) | 8장 재검토 — 경쟁자 변화 / 앱 UI 변경 반영 여부 판단 |
| 메이저 iOS 출시 직후 | 전체 재캡처 — 시스템 UI 변화 (Liquid Glass 업데이트 등) |

### 16.7 iOS 27 Liquid Glass v2 대비

- WWDC 발표 당일: 시뮬레이터 점검 (screenshot 시각 깨짐 여부)
- 발표 2주 안: 전체 재캡처 + ASC 재제출
- Beta 2 이후에만 제출 (Beta 1 UI 불안정)
- 재캡처 범위: 8장 + Preview Video 도입부 (0-8s Capture 장면)

### 16.8 ADA Nomination Visual Quality Bar

| 시점 | 체크 항목 |
|------|----------|
| WWDC 2개월 전 (3월) | Screenshot 전체 검토 + Liquid Glass 최신 표현 확인 |
| Nomination 직전 | VoiceOver Memory Timeline labels 검증 (현재 blind spot) — 모든 entry label 명시 |
| v2.0 macOS 완료 후 | Mac screenshot 추가 + Universal 앱 표현 |

VoiceOver label 미구현 시 ADA 심사 제출 금지.

### 16.9 Screenshot 제작 도구 권고

| 도구 | 용도 | 이유 |
|------|------|------|
| Keynote | device frame + caption 합성 | Apple-native, 의존성 0, PNG export |
| iOS Simulator (Xcode) | 실제 앱 화면 capture | xcrun simctl io booted screenshot |
| Rotato | Preview Video 기기 모션 | 30초 영상 Wave 1 필수 |
| QuickTime + iMovie | Video 편집 | Apple-native, 추가 비용 없음 |

Sketch / Figma는 _의존성으로 추가하지 않음_. design token 변경 시 Keynote 슬라이드만 업데이트.

_End of Design.md v2.3._
