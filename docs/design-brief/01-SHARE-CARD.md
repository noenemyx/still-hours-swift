# Share Card — Design Brief

> 우선순위: v1.0 최고 우선. 카드 이미지 export가 v1.0 출시 기능.  
> v1.x: universal-link 수신 흐름 추가 예정.  
> 브랜드 토큰: `04-BRAND-SUMMARY.md` 참조.

---

## 필요한 비율

| 비율 | 용도 | 우선순위 |
|------|------|----------|
| **3:4** (세로) | Instagram Story 친화, 주요 공유 포맷 | v1.0 필수 |
| **1:1** (정방형) | 카카오톡/iMessage 썸네일 | v1.x 선택 |

---

## 레이아웃 명세 — 3:4 비율

```
┌────────────────────────┐
│                        │
│   [커버 이미지]         │ ← 상단 75%
│   (또는 SF Symbol      │
│    placeholder)        │
│                        │
├────────────────────────┤
│  제목 (semibold, 1-2줄) │ ← 하단 25%
│  창작자 (regular, 보조) │
│  기억 메모 1줄 (optional)│
│  ─────────────────     │
│  큐레이션 by OYC (소)  │
└────────────────────────┘
```

### 상단 영역 (75%)
- **커버 이미지 있을 때**: 중앙 크롭, fill, edge-to-edge
- **커버 이미지 없을 때**: `accent.default` 12% opacity 배경 위에 매체별 SF Symbol placeholder (48pt, `accent.default` tint)

### 하단 영역 (25%)
- 배경: `surface.primary` 또는 커버 이미지 위 frosted glass overlay
- 제목: New York Medium, 17–20pt, `text.primary`, 최대 2줄
- 창작자: SF Pro Regular, 14pt, `text.secondary`
- 기억 메모: SF Pro Regular Italic, 13pt, `text.secondary` — 사용자가 입력한 경우만 표시
- 브랜드 footer: SF Mono Regular, 11pt, `text.secondary` — "큐레이션 by Own Your Curation"
- 여백: 16pt 사방 (left/right/bottom), 12pt top

### 브랜드 마크 규칙
- Footer 텍스트는 **작게** (11pt). 절대 prominent 처리 금지.
- 로고 이미지/앱 아이콘 footer 배치 금지 (텍스트 only).
- 이모지 사용 금지.

---

## 5 Medium 목업 데이터

디자이너는 아래 5종 × 2비율 = **10개 목업** 제작.

| Medium | 제목 | 창작자 | 기억 메모 (예시) |
|--------|------|--------|-----------------|
| 책 | Norwegian Wood | 무라카미 하루키 | (없음) |
| 음반 | In Rainbows | Radiohead | (없음) |
| 영화 | Spirited Away | Hayao Miyazaki | (없음) |
| 오브제 | Leica M6 | Leica Camera AG | (없음) |
| 장소 | 도쿄 츠타야 | (창작자 없음) | 어머니와 함께, 2024-08 |

**커버 이미지**: 실제 앨범/영화 포스터/카메라 사진을 사용해 시각적 현실감 표현 권장.  
저작권 이슈 시 유사 톤의 placeholder 이미지 사용.

---

## 톤 & 무드

- **조용한 종이/잉크 톤**: cool-blue chrome이 물러나고 커버 이미지가 지배
- **Photo dominant, text minimal**: 텍스트는 필요 최소한
- **감성**: Letterboxd diary + Are.na channel 중간 어딘가 — 큐레이션의 진지함

---

## 색상 토큰 참조

`04-BRAND-SUMMARY.md` §색상 토큰 섹션 참조.  
핵심: `background #f4f7fb` (light), `accent.default #1d6fe5`.

---

## Apple HIG 참조

- iOS 26 Design Resources: Share Sheet image export 패턴
- Dynamic Type: 카드 내 텍스트는 고정 pt (export 이미지이므로 Dynamic Type 불필요)
- 최소 출력 해상도: 1200×1600px (3:4 @3x)

---

## 납품물

- Figma 파일 또는 PNG 10개 (5 medium × 2 ratio)
- 각 목업: 실제 목업 1장 + 커버 없는 placeholder 상태 1장 (총 20 frame)
- Figma 사용 시: 토큰 컴포넌트로 정의해 팔레트 변경에 자동 대응 가능하게

---

_참조 파일_: `00-CONTEXT.md` (앱 정의/브랜드), `04-BRAND-SUMMARY.md` (토큰), `08-CARD-RENDER-SPEC.md` (실제 코드 기준 상세 렌더 스펙 — 치수·padding·infoArea 구현 확인 시 우선 참조)
