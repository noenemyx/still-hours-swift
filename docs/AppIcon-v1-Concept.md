# AppIcon v1.0 Concept — Still Hours

> 2026-05-20 | Senior visual + brand design pass
> Prerequisite: Design.MD §7 (Wunderkammer + Liquid Glass) + LiquidGlass-Notes.md §5 (재검토 필요 명시)

---

## 0. Executive Context

이 문서는 _Still Hours_ 앱 아이콘 v1.0 **1차 시안** spec이다.
목적은 두 가지다.

1. **Metaphor 결정**: Wunderkammer 유지 vs 새 metaphor 채택 — 근거와 함께 권고
2. **Spec 확정**: 선택된 시안의 1024×1024 / 60×60 / 3 variants / motion 레이어별 명시

사용자 결정이 난 뒤 Icon Composer 작업 시작. 본 문서는 _결정 입력값이지 최종 asset이 아님_.

---

## 1. Metaphor 결정 — 최종 권고

### 1.1 판정 기준

| 기준 | 가중 |
|------|------|
| Still Hours _이름 정합_ (고요 + 여전히) | 40% |
| Item-as-memory-anchor _데이터 모델 정합_ | 25% |
| Apple Design Award 후보 _시각 질_ | 20% |
| iOS 26 Layered Icon System _활용도_ | 15% |

### 1.2 Wunderkammer 유지 재평가

Wunderkammer는 _Curium_ / _Curio_ 어원에서 설계됐다. Still Hours로 이름이 바뀐 지금 정합을 재확인한다.

**유지 근거**:
- "유리 뚜껑 있는 진열장" 이미지가 iOS 26 Layered Icon System의 foreground / middle / background 레이어 구조와 물리적으로 일치한다. cabinet 문틀이 Liquid Glass refraction edge로 읽힌다.
- 4 medium (Book / Music / Movie / Object) 오브제를 한 프레임에 구성하는 데 캐비닛 구조가 _자연스러운 용기(容器)_를 제공한다.
- burnt sienna `#B85C38` — 도서관 가죽 제본 색 — 을 배경으로 쓰면 Wunderkammer의 _목재 + 유리_ 질감이 자연스럽게 연상된다.

**약점**:
- "가득 찬 호기심의 진열장" 정서는 _탐험·수집_ 에너지다. Still Hours가 말하는 _고요(stillness)_ 와 _여전히(still continuing)_ 는 _비움·정제·시간_ 에너지다.
- App Store 썸네일 60×60에서 cabinet 외형은 _비어 보이는 사각형_에 가까워 시인성이 낮다.

**수정 방향 (유지 시)**:
- 오브제 4개 → 오브제 1-2개로 줄이고 **여백을 절반 이상** 확보한다.
- cabinet을 _꽉 찬 진열장_이 아닌 _고요히 닫힌 문_ 이미지로 재해석한다.
- 배경에 burnt sienna glass를 쓰되 cab 네트 문틀의 실루엣을 최소화해 _정제_ 인상을 강화한다.

### 1.3 새 metaphor 후보 점수

| 후보 | 이름 정합 | 데이터 정합 | 시각 질 | Liquid Glass 활용 | 합계 |
|------|---------|-----------|-------|-----------------|------|
| A. 고요한 시간 — 모래시계·해시계 | 강 (시간 정지) | 약 (item 없음) | 중 | 중 | 67 |
| B. 기억의 입구 — 열린 책 한 페이지 | 강 (입구) | 강 (book medium) | 중 | 중 | 76 |
| C. 별자리 한 점 — 시간의 표식 | 중 | 약 | 중 | 약 | 58 |
| D. 나무의 나이테 — 자산 + 시간 | 강 | 중 | 중 | 중 | 65 |
| **E. 빛이 닿은 종이 + 오브제 실루엣** | **강** | **강** | **강** | **강** | **92** |
| F. 문지방 — 과거와 현재의 연결 | 중 | 중 | 중 | 약 | 60 |

> **E — "빛이 닿은 종이 위 오브제 실루엣"** 가 전 기준에서 가장 높다.

### 1.4 권고 결론

**2개 시안을 병렬 제시**하고 사용자가 결정한다.

| 시안 | Metaphor | 한 줄 정의 |
|------|---------|-----------|
| **시안 A** (Wunderkammer 재해석) | 고요히 닫힌 캐비닛 | "아직 열지 않은 조용한 진열장" — 캐비닛 구조 유지, 오브제 최소화, 여백 강화 |
| **시안 B** (새 metaphor) | 빛이 닿은 종이 + 오브제 | "warm light가 스며든 종이 위에 오브제 실루엣이 고요히 앉아 있는 순간" |

---

## 2. 시안 A — 고요히 닫힌 캐비닛 (Wunderkammer 재해석)

### 2.1 개념 정의

원래 Wunderkammer는 _욕망과 탐험_의 공간이다. 시안 A는 이것을 _기억과 정지_의 공간으로 재코딩한다.

> "진열장의 문이 닫혀 있다. 그 안에 무엇이 있는지 알지만, 지금은 조용히 있다."

문이 닫힌 Curio cabinet — Liquid Glass 뚜껑 — 그 뒤로 muted 오브제 실루엣 1-2개만 보인다. "가득 찬" 이미지가 아닌 "홀로 있는" 이미지다.

### 2.2 레이어 구조 (iOS 26 Icon Composer)

| Layer | 내용 | 재질 / 처리 |
|-------|------|-----------|
| Background | Warm burnt sienna `#B85C38` gradient — 상단 `#C4673F`, 하단 `#9A4A28`. 단색보다 깊이 부여. | Flat color, icon-rounded 마스크 |
| Middle | Cabinet 문틀 — 아치형 상단 + 직사각 하단. 선폭 2.5pt (1024 기준). 선 색 `#FAF5EE` (warm off-white). | Liquid Glass refractive stroke — 엣지에서 burnt sienna 배경이 굴절됨 |
| Foreground | 오브제 실루엣 2개: 작은 책 (닫힘, `book.closed` 형태) + 음표 (`music.note` 단음표). 배치: 화면 하단 1/3, 좌우 여백 각 30% 확보. 크기: 각 120pt (1024 기준). | Opacity 80%, warm off-white `#FAF5EE`. device tilt 시 horizontal shift |
| Specular | Cabinet 유리 뚜껑 상단 호 — 좌측 상단 specular highlight. 형태: 타원형 arc, 폭 340pt, 높이 40pt. | White `#FFFFFF` opacity 35%, blur radius 8pt. device tilt 시 이동 |

### 2.3 1024×1024 배치 수치

```
Canvas: 1024×1024 (icon-rounded mask 자동 적용)

Background: full bleed
  - gradient top-left: #C4673F
  - gradient bottom-right: #9A4A28

Cabinet frame (Middle):
  - outer rect: inset 128pt each side → 768×768 center
  - arch top: 384pt radius arc, top-center
  - frame stroke: 2.5pt, #FAF5EE, opacity 100%

Objects (Foreground):
  - book silhouette: 120×150pt, centered at (x:350, y:680)
  - music note silhouette: 80×120pt, centered at (x:650, y:700)
  - opacity: 80%, color #FAF5EE

Specular highlight:
  - position: top-left arc of cabinet glass top
  - ellipse: 340×40pt at (x:220, y:240)
  - fill: #FFFFFF, opacity 35%, blur 8pt
```

### 2.4 60×60 (Spotlight) 적용

- Cabinet frame 외형 실루엣만: arch 상단 + 직사각 하단, stroke 1pt
- 오브제: 점 2개 (book position, music note position). 각 8pt circle, `#FAF5EE` 80%
- Specular: 동일 위치 축소, 22×4pt 타원, opacity 25%

### 2.5 Variants

| Variant | Background | Frame | Objects |
|---------|----------|-------|---------|
| Light | `#B85C38` → `#9A4A28` | `#FAF5EE` | `#FAF5EE` 80% |
| Dark | `#3D1F12` → `#2A1509` (어두운 burnt sienna) | `#F0E8D8` | `#F0E8D8` 70% |
| Tinted | 단색 `#7A7060` (warm gray monochrome) | tint 색 `#B85C38` stroke | tint 색 80% |

### 2.6 Motion (Device Tilt)

- Foreground (오브제 2개): tilt X축 ±4pt, tilt Y축 ±2pt. Easing: `easeOut` 200ms
- Specular highlight: tilt X축 ±12pt. 오브제보다 3× 더 크게 이동 (시차 깊이감)
- Middle (cabinet frame): 고정. motion 없음.
- `accessibilityReduceMotion` 활성 시: motion 전부 0 (static)

### 2.7 시안 A 강점 / 약점

| | 내용 |
|--|------|
| 강점 | Liquid Glass layered 구조 최대 활용. refraction edge = cabinet 유리 직접 표현. 4 medium 상징 가능. |
| 약점 | Still Hours 이름의 _고요(stillness)_ 는 전달하나, _여전히(continuing)_ 이중 의미 표현이 약함. cabinet 구조가 Curium/Curio 브랜드 잔상을 남김. |

---

## 3. 시안 B — 빛이 닿은 종이 + 오브제 (새 metaphor)

### 3.1 개념 정의

> "새벽의 첫 빛이 책상 위 종이에 닿는다. 그 위에 오브제 하나가 놓여 있다. 아직 시간이 멈춰 있는 순간."

Still = 고요한 + 여전히 이중 의미를 한 이미지에 담는다.

- _고요(stillness)_: 시간이 멈춘 듯한 새벽 빛, 정제된 여백
- _여전히(still continuing)_: 오브제가 _계속_ 거기 있음 — 시간이 흘러도 사라지지 않는 것

Wunderkammer의 용기(容器) 대신, _빛이 만든 공간_이 용기다. 사물은 cage 없이 빛 안에 떠 있다.

### 3.2 레이어 구조 (iOS 26 Icon Composer)

| Layer | 내용 | 재질 / 처리 |
|-------|------|-----------|
| Background | Warm parchment `#F5F0E8` — 종이 톤. 상단 좌측에서 하단 우측으로 미세 gradient: `#FAF7F0` → `#EDE8DC`. | Flat color, icon-rounded mask |
| Middle — Light Pool | 중앙 상단에서 퍼지는 warm light pool. 타원형: 700×500pt, 중심 (x:512, y:350). | Liquid Glass `.regular` 변형: warm white `#FFF8EE` opacity 60%, feathered edge blur 80pt. specular center: opacity 85% |
| Foreground — Object Silhouette | 단일 오브제 1개: 책 (`book.closed` 형태). 크기: 240×290pt, centered at (x:512, y:580). | Near-black `#1A1812`, opacity 90%. _No outline, shadow only_ — 종이 위 실루엣처럼 |
| Accent — Thin Line | 오브제 아래 수평선 1pt. 오브제 폭과 동일 (240pt). 색: burnt sienna `#B85C38`. | opacity 70%. Liquid Glass refractive edge — 아이콘 배경과 합성 시 선이 굴절되어 보임 |

**설계 이유**:
- 오브제를 1개(책)로 단순화한 이유: App Store 1024와 Spotlight 60 모두에서 _즉각 인식_. 4 medium은 Medium Badge / TabBar에서 표현하면 충분하다.
- burnt sienna 수평선 1pt: Still Hours 브랜드 accent를 _절제_ 있게 삽입. 도서관 책등의 색을 연상시키는 동시에 "아이콘 안에 브랜드가 살아있다"는 신호.
- 중앙 light pool을 Liquid Glass material로 처리하는 이유: iOS 26 Layered Icon System에서 Middle layer에 `.regular` glass를 적용하면 배경 parchment 색이 glass를 통해 warm하게 투과된다. 자연스럽게 "빛이 스며든 종이" 질감이 된다.

### 3.3 1024×1024 배치 수치

```
Canvas: 1024×1024

Background: full bleed
  - gradient: #FAF7F0 (top-left) → #EDE8DC (bottom-right)

Light Pool (Middle — Liquid Glass):
  - ellipse: 700×500pt
  - center: (x:512, y:350)
  - fill: #FFF8EE, opacity 60%
  - feather: gaussian blur 80pt at edge
  - specular center (x:400, y:280): #FFFFFF opacity 20%, blur 40pt

Book silhouette (Foreground):
  - shape: closed book, cover visible, slight angle (5° clockwise)
  - size: 240×290pt
  - center: (x:512, y:600)
  - fill: #1A1812, opacity 90%
  - drop shadow: y+4, blur 12, opacity 12% (warm shadow, not pure black)

Accent line:
  - y: 720pt
  - x: 392pt ~ 632pt (240pt wide, centered)
  - stroke: 1pt, #B85C38, opacity 70%
```

### 3.4 60×60 (Spotlight) 적용

- Background: `#F5F0E8` 단색
- Light pool: 중앙 원형 40pt diameter, `#FFF8EE` opacity 55%, blur 8pt
- Book silhouette: 32×38pt, `#1A1812` 90%
- Accent line: 32pt wide, 1pt stroke, `#B85C38`
- Specular: 12×4pt arc, `#FFFFFF` 25%

### 3.5 Variants

| Variant | Background | Light Pool | Object | Accent Line |
|---------|----------|----------|-------|------------|
| Light | `#F5F0E8` → `#EDE8DC` | `#FFF8EE` 60% | `#1A1812` 90% | `#B85C38` 70% |
| Dark | `#141210` → `#1E1B17` (warm dark) | `#3A2E24` 50%, warm amber tint | `#F0EBE1` 85% | `#D4734A` 70% (light sienna, dark 대비 확보) |
| Tinted | 단색 `#7A7060` | monochrome white pool | monochrome `#F0EBE1` | tint accent color |

### 3.6 Motion (Device Tilt)

- Foreground (book silhouette): tilt X±3pt, tilt Y±2pt. Easing: `easeOut` 180ms. _미세하게_. 책이 종이 위에 _살짝 움직이는_ 느낌.
- Middle (light pool / specular): tilt X±8pt. 빛 자체가 더 크게 이동. _빛과 물체의 시차_ 로 깊이감 형성.
- Accent line: 고정. motion 없음.
- `accessibilityReduceMotion` 활성 시: all static.

### 3.7 시안 B 강점 / 약점

| | 내용 |
|--|------|
| 강점 | Still Hours 이름 정합 최고: "빛이 닿은 고요한 순간" = stillness. 오브제가 parchment 위에 "여전히" 있음 = still continuing. Wunderkammer 잔상 0. 여백 최대. Apple Design Award 후보 수준 — Things 3 / Darkroom / Tot 아이콘 계열의 _절제된 quality_. Light / Dark 모두 팔레트 자연 정합. |
| 약점 | 4 medium 상징이 아이콘에서 직접 보이지 않음 (book 1개). category 인식이 약할 수 있음. Wunderkammer의 "호기심의 진열장" 독특함이 없어짐 — 더 보편적인 아이콘이 될 위험. |

---

## 4. 비교 요약

| 기준 | 시안 A (캐비닛 재해석) | 시안 B (빛+오브제) |
|------|------------------|--------------------|
| Still Hours 이름 정합 | 중 (stillness O, continuing 약함) | 강 (두 의미 모두 내재) |
| Item-as-memory-anchor 정합 | 강 (진열장 = 메모리 공간) | 중 (빛이 기억의 공간) |
| Apple Design Award 시각 질 | 중 (복잡도 주의) | 강 (절제 + 정제) |
| Liquid Glass 활용도 | 강 (refraction edge = 유리문) | 강 (light pool = glass material) |
| 60×60 시인성 | 중 (frame 실루엣) | 강 (book 단일 실루엣 + 점) |
| Curium/Curio 잔상 | 있음 | 없음 |
| Light/Dark 자연 정합 | 중 (dark 변형 강함) | 강 (양쪽 모두) |

### 권고

**시안 B 채택을 권고**한다.

근거:
1. Still Hours 브랜드 네이밍이 _고요(stillness)_에서 온 만큼 아이콘도 같은 언어를 써야 한다. 시안 B는 이름과 아이콘이 _같은 순간을 묘사_한다.
2. Things 3 / Tot / Darkroom — Apple ecosystem에서 ADA(Apple Design Award)를 받은 paid app 아이콘은 _절제와 단일성_이 공통점이다. 시안 B가 이 계열에 있다.
3. 4 medium (Book/Music/Movie/Object) 표현은 아이콘에서 할 필요가 없다. TabBar, Library Grid, Medium Badge에서 표현한다. 아이콘은 _브랜드 정서_만 전달하면 된다.

단, 사용자가 "진열장 구조를 반드시 유지하고 싶다"면 시안 A를 선택한다. Wunderkammer 재해석 버전도 충분히 완성 가능하다. 두 시안 모두 Icon Composer 작업 가능 레벨의 spec이다.

---

## 5. Liquid Glass 재검토 — LiquidGlass-Notes.md 정합

LiquidGlass-Notes.md §5에서 "재검토 필요" 명시된 항목을 시안별로 확인한다.

### 5.1 Layered Icon System 구조 정합

| 구조 | 시안 A | 시안 B |
|------|--------|--------|
| Background layer | burnt sienna gradient | warm parchment gradient |
| Middle layer | cabinet frame (Liquid Glass stroke) | light pool (Liquid Glass .regular) |
| Foreground layer | 오브제 silhouette 2개 | book silhouette 1개 |

두 시안 모두 iOS 26 Icon Composer의 3-layer 구조와 정합한다. Liquid Glass의 _렌징(lensing)_ 특성이 각 middle layer에서 다르게 발현된다:
- 시안 A: cabinet 유리 문틀 엣지에서 burnt sienna 굴절 — _color refraction_
- 시안 B: light pool 중심부에서 parchment warm 투과 — _warm glow lensing_

### 5.2 Specular Highlight 위치

시안 A: cabinet 유리 뚜껑 좌상단 호 — device tilt X±12pt 이동
시안 B: light pool 중심부 + 좌상단 anchor — device tilt X±8pt 이동

두 경우 모두 _단일 specular source_ (복수 광원 금지 — 산만).

### 5.3 Device Tilt Motion 정합

Liquid Glass 아이콘의 device tilt motion은 foreground + specular가 _다른 속도로 이동_해 시차(parallax) 깊이감을 만든다. 두 시안 모두 이 원칙 준수.

### 5.4 Dark Variant Liquid Glass

Dark variant에서 Liquid Glass의 _adaptive tinting_이 dark background 색을 흡수한다:
- 시안 A dark (`#2A1509`): glass edge가 deep mahogany 색조 — 고풍스러운 나무 질감
- 시안 B dark (`#141210`): light pool glass가 amber glow로 전환 — 심야의 desk lamp 빛

---

## 6. 다음 Step (사용자 결정 후)

1. **시안 선택 (사용자)**: A 또는 B 확정. 또는 "A를 B 방식으로 수정" 등 hybrid 지시 가능.
2. **Icon Composer 작업**: WWDC25 Session 220 + Apple Design Resources iOS 26 Figma Layered Icon template 기반.
3. **3 variants 제작**: Light / Dark / Tinted. Icon Composer export.
4. **60×60 시인성 검증**: iOS Simulator Spotlight 화면에서 실제 확인.
5. **Motion 프리뷰**: Xcode 26 AppIcon preview에서 device tilt 확인.
6. **Design.MD §7 업데이트**: 채택된 시안 + 수정 이력 기록. `§15 update history` 추가.
7. **ASO Visual Strategy 정합 확인** (Design.MD §16.4): 1024 detail / 60×60 시인성 / App Store Preview Video 0-8초 내 아이콘 노출 대비.

---

## 7. 참조 문서

| 문서 | 참조 섹션 |
|------|----------|
| Design.MD | §3.1 Color tokens, §7 App Icon, §8 Liquid Glass, §16.4 ASO Icon sizing |
| LiquidGlass-Notes.md | §1 Layered Icon System, §5 Still Hours 정합 재검토 |
| PRD.md | §17.4 App Icon spec (원본 Wunderkammer spec) |
| WWDC25 Session 220 | Say hello to the new look of app icons — Icon Composer tutorial |
| Apple Design Resources | iOS 26 Figma — Layered icon template |

---

_Document end. Awaiting user decision on Concept A vs B._
