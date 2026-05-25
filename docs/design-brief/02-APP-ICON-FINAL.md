# App Icon — Final Design Brief

> 현재 상태: v1 concept (시안 없음) / v2 시안 + 1024 PNG + SVG (현재 production) / v3 brief 작성 완료, **최종 결정 미정**.  
> 이 brief는 v3 brief 기반 final icon 제작 지시서.

---

## 기존 자료 참조 (디자이너 input)

| 자료 | 경로 |
|---|---|
| **v3 brief 원본** | `docs/AppIcon-v3-ClaudeDesignPrompt.md` (이 brief의 source) |
| **v1 concept** | `docs/AppIcon-v1-Concept.md` (Wunderkammer 컨셉 초안) |
| **v2 concept** | `docs/AppIcon-v2-Concept.md` (Light on Paper 방향 — 채택 안 됨, R11 Cool Blue로 전환) |
| **v2 SVG (vector)** | `Assets/AppIcon-v2.svg` |
| **v2 PNG 1024×1024 (현재 production)** | `Assets/AppIcon-v2-1024.png` |
| **xcassets에 install 된 v2** | `App/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png` |

→ v2 SVG/PNG를 _현재 production reference_로 검토. v3 brief 기반 _next iteration_ 제작 지시.

---

## 앱 정보

앱명: **Own Your Curation**  
Domain: 책 · 음반 · 영화 · 오브제 · 장소 — 5 medium 개인 아카이브  
Platform: iOS 26 (Layered Icon System 지원)

---

## 비주얼 컨셉: _큐레이션의 진열장_

Wunderkammer (경이의 방) cabinet + Liquid Glass layered.  
5가지 미세 오브제가 유리 cabinet 안에 진열된 이미지.

### 구성 (1024×1024 캔버스)

| 레이어 | 내용 |
|--------|------|
| **배경** | warm parchment gradient `#EAF1FA` → `#C8DBF2` — 또는 cool-blue sky (R11 팔레트 정합) |
| **중간** | 반투명 cool-blue glass disc 또는 cabinet 문틀 (white line drawing, refractive edge) |
| **전경** | 5개 미세 오브제 silhouette — 각 medium 1개 (아래 명세 참조) |

### 5 Medium 미세 오브제

| Medium | 오브제 표현 | 비고 |
|--------|------------|------|
| 책 | 작은 책 spine 실루엣 | |
| 음반 | LP 원반 실루엣 | |
| 영화 | 필름 스트립 또는 film reel | |
| 오브제 | 작은 도자기 또는 카메라 silhouette | |
| 장소 | **디자이너 자유 결정** — pin/map 메타포? 작은 카페 silhouette? 아치 입구? |

**장소 오브제 open question**: 장소 medium은 메타포가 가장 모호함. 핀/지도보다 감성적인 표현 권장. 최종 결정은 디자이너 재량.

---

## 스타일

- **색조**: cool-blue 팔레트 (R11). `accent.default #1d6fe5` 계열. warm tone 사용 금지.
- **소재감**: Liquid Glass depth — translucent, refractive edge, subtle specular highlight
- **선**: 정제된 선묘. 두껍거나 복잡한 stroke 금지.
- **이모지 금지**. serif/mono 텍스트 요소만 허용 (필요 시).

---

## iOS 26 Layered Icon System

| 레이어 | 내용 |
|--------|------|
| Background | cool gradient sky |
| Middle | glass disc / cabinet frame |
| Foreground | 5 micro objects |

| Variant | 처리 |
|---------|------|
| Light | 표준 (위 스펙) |
| Dark | background를 deep navy `#0b1220` 계열로, 오브제 white line 유지 |
| Tinted | monochrome, iOS accent tint 적용 |

---

## 크기별 단순화

| 크기 | 표현 수준 |
|------|----------|
| 1024×1024 (App Store) | 5 micro objects 모두 visible, glass detail 완전 표현 |
| 180×180 (iPhone Home) | 오브제 → 점 5개로 단순화, glass disc 형태 유지 |
| 60×60 (Spotlight) | cabinet/disc 외형 실루엣만. 오브제 부재 허용 |

---

## 납품물

- 1024×1024 PNG (RGB, no alpha — Xcode가 rounded-rect mask 처리)
- iconset assets: iPhone (20@2x, 20@3x, 29@2x, 29@3x, 40@2x, 40@3x, 60@2x, 60@3x) + iPad + macOS + App Store
- Figma source file (레이어 구조 보존)
- Drop target: `App/Resources/Assets.xcassets/AppIcon.appiconset/`

---

## 금지 사항

- 단일 medium 메타포 (책만, LP만 등) — 5 medium 포용 필수
- 이모지
- Warm orange/sienna tone (`#B85C38` 계열) — R8-R10 deprecated
- Apple Photos rainbow gradient
- 복잡한 texture나 photographic detail

---

_참조_: `AppIcon-v3-ClaudeDesignPrompt.md` (원본 v3 brief), `04-BRAND-SUMMARY.md` (토큰), `00-CONTEXT.md` (브랜드)
