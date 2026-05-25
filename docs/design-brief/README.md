# Design Brief — Index

> Own Your Curation (OYC) 디자이너 브리프 디렉토리.  
> 각 파일은 디자이너가 다른 파일 없이 실행할 수 있는 자기완결 구조.  
> 현재 기준: Build #9 (r18+r19, 2026-05-24).

---

## 파일 목록

| 파일 | 요약 |
|------|------|
| `00-CONTEXT.md` | 앱 정의, 브랜드 필라, Promise 5조항, 타겟 페르소나, Build #9 반영 |
| `01-SHARE-CARD.md` | Share Card 변주 의도 및 10 mockup 납품 요구사항 (3:4 + 1:1) |
| `02-APP-ICON-FINAL.md` | 앱 아이콘 최종 결정 스펙 |
| `03-MEDIUM-ICONS.md` | 5 medium SF Symbol 확정 및 사용 규칙 |
| `04-BRAND-SUMMARY.md` | 색상 토큰, 타이포그래피, 여백 시스템 전체 요약 |
| `06-SEARCH-FIRST-UI.md` | SearchFirstView (Tab 1 루트) UI 개선 브리프 — 검색 입력·row·빈 상태 |
| `07-TAB-NAVIGATION.md` | 3-tab floating pill bar 아이콘 선택 및 active 상태 처리 |
| `08-CARD-RENDER-SPEC.md` | CardRenderView.swift 코드 기준 상세 렌더 스펙, 13 frame 납품 요구 |

---

## 권장 검토 순서

1. `00-CONTEXT.md` — 앱 정의 및 브랜드 필라
2. `04-BRAND-SUMMARY.md` — 색상 토큰 및 타이포그래피
3. `02-APP-ICON-FINAL.md` — 앱 아이콘
4. `03-MEDIUM-ICONS.md` — 5 medium SF Symbol 체계
5. `06-SEARCH-FIRST-UI.md` — 검색 입구 UI 개선
6. `07-TAB-NAVIGATION.md` — 탭 아이콘 및 navigation 처리
7. `08-CARD-RENDER-SPEC.md` — Share Card 렌더 상세 스펙
8. `01-SHARE-CARD.md` — Share Card 변주 의도 및 전체 납품 요구

---

## 현재 UI 상태 — Baseline 스크린샷

`docs/design-brief/baseline/` — launch-sim.sh + 실제 KOBIS/Naver API 키 + demo data로 캡처한 현재 앱 UI.

| 파일 | 설명 |
|------|------|
| `01-curation-root-light.png` | Tab 1 큐레이션 (light) |
| `02-curation-root-dark.png` | Tab 1 큐레이션 (dark) |
| `03-library-light.png` | Tab 2 내 컬렉션 (light) |
| `04-library-dark.png` | Tab 2 내 컬렉션 (dark) |
| `05-settings-light.png` | Tab 3 설정 (light) |
| `06-settings-dark.png` | Tab 3 설정 (dark) |

상세 설명은 `docs/design-brief/baseline/README.md` 참조.

---

## 납품 방법

Figma 파일 링크 **또는** PNG mockup을 아래 경로에 제출:

```
docs/design-brief/mockups/<파일번호>/
예시:
  docs/design-brief/mockups/06/   ← SearchFirstView 3 variant
  docs/design-brief/mockups/07/   ← Tab icon comparison
  docs/design-brief/mockups/08/   ← Card render 13 frame
```

Figma 사용 시: 토큰 컴포넌트로 정의해 팔레트 변경에 자동 대응.
