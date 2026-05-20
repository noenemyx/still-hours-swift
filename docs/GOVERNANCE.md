# GOVERNANCE.md — Still Hours Decision Authority

> Version 1.0 | 2026-05-20 | sunghun.ahn
>
> _자문단의 역할과 사용자의 최종 결정 권한_ 의 명문화.

## 0. 1원칙 (Foundation Principle)

**모든 _Critical_ 결정은 사용자 (sunghun.ahn) 의 명시적 확인 후 진행한다.**

자문단 (advisory) 은 _권고_ 역할만. _결정 권한_ 없음. _자동 채택_, _권한 위임_ 표현 영구 금지.

이 원칙은 본 프로젝트의 _모든 다른 원칙_ 보다 우선한다 (사용자 oriented 1원칙 다음).

## 1. Tier 1 — Critical 결정 (반드시 사용자)

다음 카테고리는 _반드시_ 사용자 명시 확인 후 진행:

1. Naming / Brand identity (이름·로고·미감 핵심)
2. Pricing (launch 가격·transition·tier)
3. MVP scope (Tracer Bullet 순서·범위 변경)
4. Promise 5조항 변경 / 확장 / 약화
5. Launch timing / Wave 진입 시점
6. App icon 방향 / 핵심 디자인 언어
7. Quit criteria 작동 시점
8. ASC submission 직전
9. _Forever 약속_ 약화 가능성 있는 모든 결정

## 2. Tier 2 — 자동 진행 가능 (사용자 확인 없이 OK)

1. 코드 작성 (이미 결정된 scope 안)
2. Bug fix / 정정
3. 문서 형식 정정 (오타 / 줄바꿈 / 표 정렬)
4. 자문단 호출 자체
5. 검증 (test / lint / contrast)
6. Repo / file 생성 (이미 결정된 구조)
7. 자문단 결과 _보고_ + _옵션 제시_
8. Search / Read / 정보 수집

## 3. Decision Flow (필수 protocol)

Critical 결정 (Tier 1) 발생 시:

1. **자문단 호출** (필요 시 multi-panel parallel — Marketing / Strategy / UX / UI / Design / Engineer / Critic 중 적합한 perspective)
2. **자문 결과 종합 + 보고** — agreement / divergence / blind spots / 권고 + 근거
3. **사용자 결정 옵션 제시** — AskUserQuestion (2-4 옵션) 또는 명확한 선택 항목
4. **사용자 명시 확인 후 진행** — 자동 채택 / 자동 진행 _금지_

## 4. Dismissal 해석

사용자 _dismissed / do not proceed_ = **결정 보류**. _Advisory 결정 의미 아님_.

→ 자문 결과 _다시 보고_, _다른 옵션 brainstorm_, _재질문_ 중 하나로 진행. 자동 채택 금지.

## 5. 위반 사례 + 학습

### 사례 1 (2026-05-20) — Still Hours 채택 framing

- 상황: AskUserQuestion 으로 _Curium / Constella / 새 후보 brainstorm / 완전 재시작_ 옵션 제시 → 사용자 _dismissed_
- 나의 행동 (잘못): _"전문가 그룹 결정 = Still Hours 자동 채택"_ 으로 framing
- 사용자 정정: _"전문가 그룹 최종 결정 못하는 건가?"_ → _"자문단으로서의 역할만 한다. 중요한 최종 결정은 내가 한다."_
- 학습: dismissal = _결정 보류_, _자동 채택_ 표현 금지

### 사례 2 (2026-05-20) — Apple Search Ads 권고 채택

- 상황: ASO Strategy 자문 panel 권고 _"Apple Search Ads $300-500/월 활용 OK"_
- 나의 행동 (잘못): _자문 권고를 사용자 결정처럼_ PRD/DEVPLAN/README 에 명시
- 사용자 정정: _"Ads는 하지 않는다. No advertisement가 현재의 상황이다."_
- 학습: _자문 권고 ≠ 사용자 결정_. Promise 조항 (No advertising) 의 _명확한 정의_ = _Apple Search Ads 등 외부 광고 채널 영구 X_

## 6. Trigger words (즉시 STOP)

다음 표현 사용 즉시 _작업 중단 + 사용자 확인_:

- "자문단 결정 = X"
- "자동 채택"
- "권한 위임"
- "전문가 그룹이 결정"
- "advisory 합의로 X 진행"

위 표현은 모두 _권한 침범_ 가능성. 즉시 _사용자 명시 확인_ 으로 정정.

## 7. 자문단 호출 시 가이드

자문단은 _다음 형식_으로 호출:
- "본 문서는 _권고_ 만 작성. 결정은 사용자."
- "_최종 결정 표현_ 사용 금지. _권고 / 옵션 / 비교_ 만."
- "여러 panel 동시 호출 (≥4) 시 _agreement / divergence / blind spots_ 종합. _단일 답_ 강제 안 함."

## 8. 사용자 결정 효율화 패턴

사용자 결정 부담 줄이기 위한 (단 권한 침범 없는):

- _Default 권고 제시_ — 자문 결과 + _내 권고_ 명시 단 _사용자 결정_ 으로 표시
- _옵션 압축_ — 4 옵션 이하, 각 옵션 description + recommended 표시
- _Tier 2 자동 진행_ — 이미 결정된 scope 내 작업은 자동
- _자문 결과 사용자 가독 형식_ — 종합 표 / 매트릭스 / 우선순위

## 9. 변경 history

| Date | Version | Change | Reason |
|------|---------|--------|--------|
| 2026-05-20 | v1.0 | initial | 사용자 _"자문단 = 권고, 결정은 사용자"_ 명시 → 명문화 |
| 2026-05-20 | v1.1 | §10 병렬 작업 원칙 추가 | 사용자 3번째 강조 영구 명문화 |

---

## 10. 병렬 작업 원칙 (Parallel Execution Mandate)

**모든 _independent_ sub-task 는 _병렬_로 동시 진행한다. 직렬 진행은 _명시적 dependency_ 가 있을 때만.**

사용자 3번째 강조 (2026-05-20): _"가능한한 서브 에이전트들을 최대한 활용하고, 병렬 작업이 가능하면 병렬 작업을 하면서 효율을 높인다."_ _"서브 에이전트와 병렬 가능한 부분은 동시에 진행해야 한다."_

### 10.1 Self-check (모든 multi-step task 시작 _전_ 의무)

1. _"이 작업에서 병렬 가능한 sub-task 는 무엇인가?"_
2. _"이 작업의 sub-agent 위임 후보는 무엇인가? 어떤 model tier (haiku/sonnet/opus) 가 적절한가?"_
3. _"Long-running (≥30s) 작업은 무엇인가? `run_in_background: true` 로 전환?"_

답이 _N/A (단일 trivial step)_ 가 아니라면 즉시 병렬 / agent 위임 패턴 전환.

### 10.2 병렬 default — 강제 영역

- **≥2 독립 sub-task** = 병렬 실행 default. 직렬은 _명시적 dependency_ 있을 때만.
- **Multi-file Edit** (≥2 files, 다른 영역) = sub-agent 위임 OR 단일 message 안 multiple tool calls 병렬.
- **Long-running (≥30s)** — build / install / test / fetch / WebSearch chain — _항상_ `run_in_background: true`. 그 사이 다른 작업 병렬.
- **Pre-flight check + 실행** = 병렬 가능. status 확인 명령 여러 개는 single message multiple tool calls.

### 10.3 Sub-agent 위임 default — 적용 카테고리

다음 중 _하나라도 해당_하면 sub-agent 위임이 default:

- Multi-file 변경 (≥2 files in different domains)
- Independent task fanout (다른 영역 동시 작업)
- Long-running specialized work (build/test/research)
- Specialized expertise (executor / architect / code-reviewer / designer / writer / document-specialist)
- Advisory protocol trigger (Critical 결정 자문)
- Long Web research / 정보 수집 chain (≥3 sources)

### 10.4 직접 작업 default — Sub-agent 위임 _안 함_

- 단일 file edit
- 단일 정보 lookup
- Single command
- ≤10 small files (agent overhead 가 손해)
- 사용자 명시 결정 옵션 (AskUserQuestion 등 사용자 직접 interaction)

### 10.5 Model Tier 명시 의무

위임 시 _항상_ `model` 인자 명시:

- `haiku` — lookup / trivial edits / simple verifications
- `sonnet` — standard implementation / multi-file refactor / 분석
- `opus` — architecture decisions / deep analysis / advisory panels / 복잡 debugging

불명확 시 `sonnet`. opus 는 _전략·아키텍처_ 또는 _깊은 분석_ 에서만.

### 10.6 Parallel fanout 제약

`≤4 agents in parallel` (ceiling).

- Round 1: 4 agents max
- Round 2: 추가 2-4 agents (Round 1 완료 후)
- 6+ agent advisory 는 _자동 2-batch_ 분리

같은 자원 (file / DB / network endpoint) 동시 access = race condition 위험 = sequential 강제.

### 10.7 위반 점검 ritual

Task 종료 후 _retrospective_:
- _"이 작업에서 병렬화 누락한 부분은?"_
- _"Agent 위임 누락한 부분은?"_

답이 있으면 _다음 cycle 적용_, _GOVERNANCE.md §5 위반 사례_ 또는 _lessons-learned_ 에 기록.

### 10.8 위반 사례 (학습 보존)

#### 사례 3 (2026-05-20) — GOVERNANCE 작성 cycle 의 병렬 누락

- 상황: GOVERNANCE.md + PRD §0.0 + No ads 정정 + repo sync 작업
- 나의 행동 (잘못): _단일 Agent 위임_, _다른 병렬 가능 작업_ (예: Trademark 사전 점검 자동) 동시 진행 안 함
- 사용자 정정: 3번째 강조 _"서브 에이전트와 병렬 가능한 부분은 동시에 진행해야 한다."_
- 학습: _Critical 결정_ 자체는 Tier 1 사용자, 단 _Tier 2 정보 수집 / 검증 / 자동화_ 는 _병렬 default_. _자연스러운 다음 작업_ 동시 launch.

### 10.9 _Critical 결정 protocol_ 과 정합

Tier 1 사용자 결정 부분 = 직렬 (사용자 dependency).
Tier 2 자동 진행 부분 = 병렬 default.
혼합 가능: 사용자 결정 _기다리는 동안_ 다른 _independent Tier 2 작업_ 병렬.

---

_Note: Naming "Curium → Still Hours" on 2026-05-20 after 25 candidate validation cycle._

_End of GOVERNANCE.md v1.1._
