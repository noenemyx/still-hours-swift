# WCAG AA Contrast Verification — Still Hours Foundation Tokens

> 2026-05-20 | Pre-flight Week 1 Round 2 + Round 3 Fix Applied

---

## 1. Light Mode Combinations

Background `#F5F0E8` (L=0.8756) | Surface `#FAFAF5` (L=0.9529)

| Foreground | Background | Ratio | Grade | Note |
|---|---|---|---|---|
| text.primary `#1A1812` | background `#F5F0E8` | **15.64:1** | AAA ★ | |
| text.primary `#1A1812` | surface `#FAFAF5` | **16.95:1** | AAA ★ | |
| text.secondary `#665D4F` ✦ | background `#F5F0E8` | **5.71:1** | AA ★ | Fixed (was `#7A7060` 4.29:1 AA Large) |
| text.secondary `#665D4F` ✦ | surface `#FAFAF5` | **6.18:1** | AA ★ | Fixed (was `#7A7060` 4.65:1 AA ★) |
| accent.default `#B85C38` | background `#F5F0E8` | **4.00:1** | AA Large | ≥18pt or ≥14pt bold only |
| accent.default `#B85C38` | surface `#FAFAF5` | **4.34:1** | AA Large | ≥18pt or ≥14pt bold only |
| accent.muted `#D4A574` | background `#F5F0E8` | **1.96:1** | **Fail ✗** | TEXT FORBIDDEN — non-text use only |
| accent.muted `#D4A574` | surface `#FAFAF5` | **2.13:1** | **Fail ✗** | TEXT FORBIDDEN — non-text use only |
| onAccent `#1A1812` | accent.default `#B85C38` | **3.91:1** | AA Large | CTA button (≥18pt or ≥14pt bold) |
| text.primary `#1A1812` | accent.muted `#D4A574` | **7.97:1** | AAA ★ | Muted surface background OK |

✦ Round 3 fix: `text.secondary` Light adjusted `#7A7060` → `#665D4F` (4.29:1 → 5.71:1 on bg)

**Light AAA pass: 3/10 (30%)**
**Light AA+ pass: 5/10 (50%) + 2/10 AA Large (20%)**
**Light Fail: 2/10 (20%) — accent.muted text use, permanently forbidden**

---

## 2. Dark Mode Combinations

Background `#141210` (L=0.0062) | Surface `#1E1B17` (L=0.0112)

| Foreground | Background | Ratio | Grade | Note |
|---|---|---|---|---|
| text.primary `#F0EBE1` | background `#141210` | **15.73:1** | AAA ★ | |
| text.primary `#F0EBE1` | surface `#1E1B17` | **14.44:1** | AAA ★ | |
| text.secondary `#9A9285` | background `#141210` | **6.07:1** | AA ★ | |
| text.secondary `#9A9285` | surface `#1E1B17` | **5.57:1** | AA ★ | |
| accent.default `#D4734A` | background `#141210` | **5.65:1** | AA ★ | |
| accent.default `#D4734A` | surface `#1E1B17` | **5.19:1** | AA ★ | |
| accent.muted `#A88560` | background `#141210` | **5.51:1** | AA ★ | |
| accent.muted `#A88560` | surface `#1E1B17` | **5.05:1** | AA ★ | |
| onAccent `#1A1812` | accent.default `#D4734A` | **5.37:1** | **AA ★** ✦ | CTA button fix (was text.primary 2.78:1 Fail) |
| text.primary `#F0EBE1` | accent.default `#D4734A` | **2.78:1** | **Fail ✗** | OLD pattern — replaced by onAccent |

✦ Round 3 fix: dark CTA button now uses `onAccent #1A1812` on `#D4734A` = 5.37:1 AA ★

**Dark AAA pass: 2/10 (20%)**
**Dark AA+ pass: 8/10 (80%)** (onAccent added — old Fail row shown for reference only)

---

## 3. Critical Issues — Round 3 Fix Status

### Issue 1 — accent.muted as text foreground (Light mode) — RESOLVED (text use forbidden)

| Combination | Ratio | WCAG | Status |
|---|---|---|---|
| accent.muted on background | 1.96:1 | Fail | **Text use permanently forbidden** |
| accent.muted on surface | 2.13:1 | Fail | **Text use permanently forbidden** |

**Fix**: `accent.muted` 에 DocC `- Warning:` 주석 추가 — FoundationTokens.swift + SemanticTokens.swift + Color+StillHours.swift 3파일 모두. Design.md §4.3 명문화.  
색 자체를 변경하지 않음 (skeleton/placeholder fill 으로는 정상). 텍스트 필요 시 `text.secondary #665D4F` 사용.

---

### Issue 2 — text.primary on accent.default (Button text) — RESOLVED (onAccent token added)

| Combination | Light Ratio | Dark Ratio | Status |
|---|---|---|---|
| `onAccent #1A1812` on accent.default | 3.91:1 (AA Large) | **5.37:1 AA ★** | **Fixed** |
| ~~text.primary `#F0EBE1` on dark accent~~ | — | ~~2.78:1 Fail~~ | Deprecated pattern |

**Fix**: `FoundationTokens.Color.onAccent = #1A1812` 추가. `SemanticTokens.text.onAccent` + `SemanticTokens.accent.onAccent` 추가. `Color.shOnAccent` + `UIColor.shOnAccent` 추가.  
Dark mode CTA 버튼 텍스트: `#1A1812` on `#D4734A` = **5.37:1 AA ★** (5.65:1은 이전 문서 계산 오차, WCAG formula 재적용 결과 5.37:1 — 여전히 AA 통과).

---

### Issue 3 — text.secondary on background (Light mode) — RESOLVED (color adjusted)

| Combination | Old | New | WCAG |
|---|---|---|---|
| text.secondary on background | `#7A7060` 4.29:1 AA Large | `#665D4F` **5.71:1 AA ★** | **Fixed** |
| text.secondary on surface | `#7A7060` 4.65:1 AA ★ | `#665D4F` **6.18:1 AA ★** | Improved |

**Fix**: `lightTextSecondary` hex `#7A7060` → `#665D4F`. Warm tone 유지 (둘 다 warm muted gray), AA normal 통과. Dark mode secondary (`#9A9285`) 변경 없음 — 이미 6.07:1 AA.

---

### Issue 4 — accent.default on background/surface (Light mode) — NOTED (AA Large only, by design)

| Combination | Ratio | WCAG | Decision |
|---|---|---|---|
| accent.default on background | 4.00:1 | AA Large | By design — use ≥18pt or ≥14pt bold only |
| accent.default on surface | 4.34:1 | AA Large | By design — use ≥18pt or ≥14pt bold only |

**Decision**: 색 변경 없음. `accent.default` 는 _interactive element fill_ 이 primary use case (버튼, 토글). 텍스트 accent 는 AA Large 범위 내에서만 허용. SemanticTokens `accent.medium.*` 에 `- Note:` 주석 추가로 명문화. Design.md §4.3 업데이트.

---

## 4. AAA 통과 비율 (Round 3 Fix Applied)

### Light Mode (10 combinations)

| Combination | Ratio | Grade |
|---|---|---|
| text.primary on background | 15.64:1 | AAA ★ |
| text.primary on surface | 16.95:1 | AAA ★ |
| text.secondary `#665D4F` on background | 5.71:1 | AA ★ |
| text.secondary `#665D4F` on surface | 6.18:1 | AA ★ |
| accent.default on background | 4.00:1 | AA Large |
| accent.default on surface | 4.34:1 | AA Large |
| accent.muted on background | 1.96:1 | Fail (text forbidden) |
| accent.muted on surface | 2.13:1 | Fail (text forbidden) |
| onAccent on accent.default | 3.91:1 | AA Large |
| text.primary on accent.muted (surface) | 7.97:1 | AAA ★ |

**Light AAA: 3/10 (30%) | AA normal: 2/10 (20%) | AA Large: 3/10 (30%) | Fail: 2/10 (20%)**

> Fail 2건 = accent.muted on bg/surface. 이 두 조합은 text use가 영구 금지이므로 실제 UI 에서 발생하지 않음. **유효 조합 중 WCAG 위반 0건.**

### Dark Mode (10 combinations, new onAccent row replacing old Fail)

| Combination | Ratio | Grade |
|---|---|---|
| text.primary on background | 15.73:1 | AAA ★ |
| text.primary on surface | 14.44:1 | AAA ★ |
| text.secondary on background | 6.07:1 | AA ★ |
| text.secondary on surface | 5.57:1 | AA ★ |
| accent.default on background | 5.65:1 | AA ★ |
| accent.default on surface | 5.19:1 | AA ★ |
| accent.muted on background | 5.51:1 | AA ★ |
| accent.muted on surface | 5.05:1 | AA ★ |
| **onAccent on accent.default** | **5.37:1** | **AA ★** (Round 3 fix) |
| ~~text.primary on accent.default~~ | ~~2.78:1~~ | ~~Fail~~ (deprecated pattern) |

**Dark AAA: 2/9 (22%) | AA normal: 7/9 (78%) | Fail: 0/9 (0%)**

> 유효 조합 9건 (deprecated pattern 제외) 전부 AA 이상.

### 종합 비교

| | Round 2 (Before) | Round 3 (After) |
|---|---|---|
| Light Fail (in use) | 2 (text.secondary on bg) | **0** |
| Dark Fail (in use) | 1 (button text) | **0** |
| Light AA normal+ | 3/10 (30%) | 5/10 (50%) |
| Dark AA normal+ | 8/10 (80%) | **9/9 (100%)** |

주요 읽기 텍스트(text.primary on background/surface)는 양 모드 모두 **14.4:1 이상 AAA** — 핵심 가독성 excellent.

---

## 5. Apple Design Award Quality 평가

### 강점

- **핵심 텍스트 콘트라스트**: text.primary on background/surface — Light 15.64:1, Dark 15.73:1. 업계 최고 수준. ADA(Apple Design Award) 심사 기준 충족.
- **Dark mode text.secondary**: 6.07:1 / 5.57:1 — AA 통과. Light mode는 surface 위에서만 AA (5% 차이).
- **Dark mode accent**: 5.65:1 / 5.19:1 — 색 텍스트로도 AA 통과. Light mode accent는 large-only.

### 우려

- **accent.muted (Light)**: 1.96:1 / 2.13:1 Fail — 텍스트 용도 전면 금지 필요.
- **Dark mode CTA 버튼**: text.primary on accent.default 2.78:1 Fail — 버튼 디자인 패턴 재정의 필요.
- **Light mode secondary**: background 위 4.29:1 AA Large — normal body secondary text는 surface 위에만 허용.

### Reduce Transparency + Dynamic Type 가속 시

| 시나리오 | 영향 |
|---|---|
| Reduce Transparency ON | blur 제거 → 직접 background/surface 색상 노출. 현재 solid token 기반이므로 추가 변화 없음. |
| Dynamic Type (Accessibility XL+) | 텍스트 크기 증가 → AA Large 항목(3:1+)이 자동 통과 범위로 진입. text.secondary, accent.default 사용 제한 완화. |
| Both ON | AA Large 항목 = 사실상 모두 통과. 남은 위험: accent.muted (텍스트 금지 유지), dark button (색 반전 필요). |

---

## 6. 다음 Step

### 즉시 수정 (Foundation Tokens)

1. **`onAccent` 토큰 추가** — Dark mode CTA 버튼용:
   ```swift
   // Dark mode button label: #1A1812 on accent.default #D4734A = 5.65:1 AA
   static let onAccent = Color(hex: "#1A1812")  // dark mode
   ```

2. **accent.muted 사용 지침 명문화** — Component 문서에 "텍스트 foreground 사용 금지, 장식 전용" 주석 추가.

3. **text.secondary 사용 제한** — Light mode background 위 normal body text 금지. 반드시 surface 위 또는 large text.

### Component 적용 시 최소 AA 보장 Plan

| Component | 현재 조합 | 보장 방법 |
|---|---|---|
| Body text | text.primary on bg/surface | OK — 15:1+ |
| Caption / metadata | text.secondary on surface | OK — 4.65:1 |
| Caption on background | text.secondary on background | Large text only (18pt+) |
| CTA Button (Light) | text.primary on accent.default | Large text or underline only |
| CTA Button (Dark) | **onAccent on accent.default** | 5.65:1 AA ★ |
| Tag / Badge | text.secondary | accent.muted 사용 금지 |
| Link text | text.primary + underline | accent.default Fail (normal) |

---

*Calculated using WCAG 2.1 relative luminance formula. sRGB linearization via IEC 61966-2-1.*
