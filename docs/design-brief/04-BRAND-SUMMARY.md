# Brand Summary — 디자이너 레퍼런스

> 팔레트 · 타이포그래피 · 스페이싱 · 래디어스. 자기완결 참조.  
> Source: `SemanticTokens.swift`, `Design.MD` §3 R11 (2026-05-21 확정).

---

## ⚠️ 팔레트 이력

2026-05-21 R11 pivot으로 **warm parchment (`#B85C38` burnt sienna) 폐기**.  
현재 = **cool-blue (청량, 비 갠 후 하늘 톤)**. 모든 디자인은 이 팔레트 기준.

---

## 색상 토큰

### Light Mode

| Token | Hex | 용도 |
|-------|-----|------|
| `background` | `#f4f7fb` | 앱 루트 배경 |
| `surface.primary` | `#ffffff` | 카드 / sheet |
| `surface.elevated` | `#eef3fa` | hover / pressed |
| `text.primary` | `#0b1220` | heading, body |
| `text.secondary` | `#5b6b80` | caption, metadata |
| `accent.default` | `#1d6fe5` | CTA, interactive |
| `accent.muted` | `#dbe7fa` | selected-row wash |
| `accent.subtle` | `#eff4fc` | Liquid Glass tint |
| `onAccent` | `#ffffff` | accent fill 위 텍스트 |
| `separator` | `#e2e8f0` | 0.5pt hairline |

### Dark Mode

| Token | Hex |
|-------|-----|
| `background` | `#0b1220` |
| `surface.primary` | `#121a2a` |
| `surface.elevated` | `#1a2336` |
| `text.primary` | `#f0f4fa` |
| `text.secondary` | `#8a98ad` |
| `accent.default` | `#4d8df0` |
| `accent.muted` | `#1a2940` |
| `accent.subtle` | `#15233a` |
| `separator` | `#1f2a3e` |

### 사용 규칙

- `accent.default`: interactive/active 전용. 장식 금지. normal body text 금지 (AA Large only).
- `accent.muted`: 텍스트 foreground **영구 금지** (WCAG Fail). skeleton/placeholder만.
- `onAccent`: CTA button text 전용.

---

## 타이포그래피

**Pair**: SF Pro (UI body) + New York serif (Item 제목, 브랜드 자산)

| Token | Font | Weight | Size | 용도 |
|-------|------|--------|------|------|
| `font.display` | New York | Medium | 28pt | Settings header |
| `font.heading.1` | New York | Medium | 22pt | Item 제목 |
| `font.heading.2` | SF Pro | Semibold | 17pt | Section header |
| `font.body` | SF Pro | Regular | 17pt | Memory note |
| `font.callout` | SF Pro | Regular | 16pt | Creator/Artist |
| `font.subhead` | SF Pro | Medium | 15pt | Kind label |
| `font.caption` | SF Pro | Regular | 12pt | Date/Place |

**브랜드 자산 전용** (아이콘, 카드 footer): New York Italic + SF Mono. 이모지 금지.  
**CJK**: ko → Apple SD Gothic Neo / ja → Hiragino Mincho W3 / zh → PingFang. Ceiling: `.accessibility3`

---

## 스페이싱 (Base grid: 4pt)

| Token | Value | 용도 |
|-------|-------|------|
| `space.xs` | 4pt | icon spacing |
| `space.sm` | 8pt | tight gap |
| `space.md` | 16pt | default padding |
| `space.lg` | 24pt | section gap |
| `space.xl` | 32pt | major divider |
| `space.2xl` | 48pt | empty state |

## 래디어스

| Token | Value | 용도 |
|-------|-------|------|
| `radius.sm` | 8pt | chip / tag |
| `radius.md` | 12pt | card |
| `radius.lg` | 16pt | sheet |
| `radius.xl` | 24pt | modal |

**UI 참조**: `screenshots/20-curation-root-baseline.png` — cool-blue 프로덕션.

_Source_: `Design.MD` §3 R11, `SemanticTokens.swift`
