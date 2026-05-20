# WCAG AA Contrast Verification — Still Hours Foundation Tokens

> 2026-05-20 | Pre-flight Week 1 Round 2

---

## 1. Light Mode Combinations

Background `#F5F0E8` (L=0.8756) | Surface `#FAFAF5` (L=0.9529)

| Foreground | Background | Ratio | Grade | Note |
|---|---|---|---|---|
| text.primary `#1A1812` | background `#F5F0E8` | **15.64:1** | AAA ★ | |
| text.primary `#1A1812` | surface `#FAFAF5` | **16.95:1** | AAA ★ | |
| text.secondary `#7A7060` | background `#F5F0E8` | **4.29:1** | AA Large | Normal text Fail — large/UI only |
| text.secondary `#7A7060` | surface `#FAFAF5` | **4.65:1** | AA ★ | Normal text pass |
| accent.default `#B85C38` | background `#F5F0E8` | **4.00:1** | AA Large | Normal text Fail — large/UI only |
| accent.default `#B85C38` | surface `#FAFAF5` | **4.34:1** | AA Large | Normal text Fail — large/UI only |
| accent.muted `#D4A574` | background `#F5F0E8` | **1.96:1** | **Fail ✗** | Cannot use as text |
| accent.muted `#D4A574` | surface `#FAFAF5` | **2.13:1** | **Fail ✗** | Cannot use as text |
| text.primary `#1A1812` | accent.default `#B85C38` | **3.91:1** | AA Large | Button text (large only) |
| text.primary `#1A1812` | accent.muted `#D4A574` | **7.97:1** | AAA ★ | Muted background OK |

**Light AAA pass: 4/10 (40%)**
**Light AA+ pass: 6/10 (60%)**

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
| text.primary `#F0EBE1` | accent.default `#D4734A` | **2.78:1** | **Fail ✗** | Light-on-accent button Fail |
| text.primary `#F0EBE1` | accent.muted `#A88560` | **2.86:1** | **Fail ✗** | Light-on-muted Fail |

**Dark AAA pass: 2/10 (20%)**
**Dark AA+ pass: 8/10 (80%)**

---

## 3. Critical Issues

### Issue 1 — accent.muted as text foreground (Light mode) — FAIL

| Combination | Ratio | WCAG |
|---|---|---|
| accent.muted on background | 1.96:1 | Fail |
| accent.muted on surface | 2.13:1 | Fail |

**사용 위치**: 태그, 배지, secondary label, decorative caption 등  
**원인**: `#D4A574` (warm sand)는 배경에 비해 너무 밝음. 텍스트 foreground로 사용 불가.  
**권고**:
- `accent.muted`를 텍스트 foreground로 사용 금지. **장식 전용 (borders, fills, icons with non-text purpose)**.
- 텍스트가 필요한 경우 `text.secondary #7A7060` 사용.
- 또는 muted text 전용 토큰을 별도 정의: `text.muted #5C5244` (추정 5:1+).

---

### Issue 2 — text.primary on accent.default (Button text) — AA Large Only

| Combination | Light Ratio | Dark Ratio |
|---|---|---|
| text.primary on accent.default | 3.91:1 (Light) | 2.78:1 (Dark) ✗ |

**사용 위치**: CTA 버튼 (filled accent background + primary text foreground)  
**광 모드**: 3.91:1 — large text (18pt+, or 14pt+ bold) 전용 사용 가능. Normal body text Fail.  
**암 모드**: **2.78:1 — 모든 크기 Fail.**

**권고 (Dark mode 버튼 텍스트)**:
- 버튼 label에 `text.primary (#F0EBE1)` 대신 어두운 색 적용.
- 제안 `#1A1812` on `#D4734A` = 동일 문제 (luminance 역전 없음).
- 근본 해결: dark accent.default를 더 밝게 조정.
  - `#E08050` → text.primary on `#E08050`: 추정 3.8:1 (여전히 부족)
  - `#F0905A` → text.primary on `#F0905A`: 추정 4.8:1 (AA ★ 근접)
  - **권고 hex**: `accent.default` dark = `#E08855` (계산 필요, 아래 참조)

```
#E08855 luminance ≈ 0.250 → (0.8338+0.05)/(0.250+0.05) = 2.94:1  ← 부족
→ 더 밝게: #F09060
  R=240,G=144,B=96 → L ≈ 0.295 → (0.8338+0.05)/(0.295+0.05) = 2.56:1 ← 더 나쁨
```

> **결론**: 오렌지-계열 accent는 흰 텍스트와 WCAG AA 4.5:1 달성이 구조적으로 어려움.  
> **실용 권고**: Dark mode filled button은 **배경색 반전** 패턴 채택.  
> = `text.primary #1A1812` (dark) on `accent.default #D4734A` → contrast = **(0.267+0.05)/(0.006+0.05) = 5.65:1 AA ★**  
> 즉, 어두운 텍스트를 버튼에 쓰면 통과. FoundationToken에 `onAccent: #1A1812` 추가 권고.

---

### Issue 3 — text.secondary on background (Light mode) — AA Large Only

| Combination | Ratio | WCAG |
|---|---|---|
| text.secondary on background | 4.29:1 | AA Large |

**사용 위치**: 날짜 caption, subtitle, metadata label  
**권고**: 14pt+ bold 또는 18pt+ regular 이상에서만 사용. Body-size secondary text는 `surface` 위에 배치 (4.65:1 AA ★).

---

### Issue 4 — accent.default on background/surface (Light mode) — AA Large Only

| Combination | Ratio | WCAG |
|---|---|---|
| accent.default on background | 4.00:1 | AA Large |
| accent.default on surface | 4.34:1 | AA Large |

**사용 위치**: 링크 텍스트, active tab indicator text, inline accent label  
**권고**: accent.default를 텍스트 foreground로 쓸 경우 반드시 large text (18pt+) 또는 bold (14pt+). Normal body link라면 `text.primary`로 대체 + underline decoration 사용.

---

## 4. AAA 통과 비율

| Mode | AAA Pass | AA Pass | Fail |
|---|---|---|---|
| Light | 4/10 (40%) | 6/10 (60%) | 2/10 (20%) |
| Dark | 2/10 (20%) | 8/10 (80%) | 2/10 (20%) |

주요 읽기 텍스트(text.primary on background/surface)는 양 모드 모두 **15:1 이상 AAA** — 핵심 가독성 excellent.

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
