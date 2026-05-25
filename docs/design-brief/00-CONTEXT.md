# Own Your Curation — Design Context Brief

> 이 파일은 디자이너가 다른 문서 없이 실행할 수 있는 자기완결 컨텍스트입니다.

---

## 앱 정의

**Own Your Curation (OYC)** — 5가지 매체의 개인 아카이브 앱.  
Bundle ID: `com.ownlifelab.stillhours` | Brand code: OYC  
iOS 26 native. Apple Design Resources iOS 26 baseline 사용 중.

**5 medium (고정 표시 순서)**:  책 → 음반 → 영화 → 오브제 → 장소

---

## 핵심 패러다임

> **검색을 입구로, 채택을 본문으로.**

단일 검색 입력 → 결과 미리보기 → **채택(adopt)** → 자동 Item 생성 + Memory 작성.  
"추가"라는 언어 전면 폐기. 큐레이션 = _내가 고른 것의 기록_. 소유 사실이 아닌 선택의 기록.

---

## 브랜드 필라

| 필라 | 내용 |
|------|------|
| **JOH 조수용** | 최소주의, 정제된 표면. 불필요한 요소를 덜어내는 방향 |
| **김호 "direction over completion"** | 완료가 아닌 방향. 점수가 아닌 목격 |
| **Typography** | SF Pro (UI body) + New York serif (Item 제목, 브랜드 자산). SF Mono (브랜드 자산 보조) |
| **이모지 금지** | 브랜드 자산(아이콘/카드 footer)에 이모지 사용 불가 |

---

## Promise 5조항 (영구 약속)

1. No algorithm — 알고리즘 추천 없음
2. No public feed — 공개 피드 없음
3. No advertising — 광고 없음
4. No subscription — 구독 없음
5. No AI judgment — AI 판단 없음

---

## 타겟 페르소나

30대 초반, 글로벌 기업 여성 직장인.  
취향 중심, 미감 비타협. 아름다움과 우아함은 필수 조건.  
Letterboxd/Are.na 사용자 감성. 도구를 10년 쓰는 관점.

---

## 출시 전략

- **v1.0**: Korea-first (ko 우선, en/ja sub-locale). Free for now (traction 후 paid 복귀 검토).
- **v1.x**: Japan fast-follow (3~6개월)
- **v2.0**: Global (en/de/fr/es/pt/zh)

---

## 현재 UI 톤 참조

`/tmp/curium-swift/screenshots/20-curation-root-baseline.png` — 현재 SearchFirstView 프로덕션 화면.  
cool-blue 팔레트 (R11, 2026-05-21 pivot). 이 톤에 맞춰 디자인.

---

---

## Build #9 반영 (2026-05-24)

Build #8 (rename + 5 medium) 및 Build #9 (r18 SearchFirstView + r19 CardRenderView) 출시 완료. 이 디렉토리의 모든 디자인 브리프는 해당 시점의 현재 상태를 반영하며, Build #8 이전 "자산-입구" 패러다임 및 Still Hours 브랜딩 시대의 결정은 역사적 참조로만 유지됨. 신규 브리프: `06-SEARCH-FIRST-UI.md` (SearchFirstView UI), `07-TAB-NAVIGATION.md` (3-tab floating pill), `08-CARD-RENDER-SPEC.md` (CardRenderView 렌더 스펙).

_상세 토큰: `04-BRAND-SUMMARY.md` 참조._
