# ASO Metadata — Own Your Curation v1.0

Last updated: 2026-05-24 (Build #8 + C-2 Korea ASO research)
Status: en-US / ja **APPLIED to ASC** via PATCH /v1/appStoreVersionLocalizations
       ko — **REVISED per C-2 research, application PENDING user approval** (see §2.5)

---

## §1 App Info Localizations (3 locale)

### Name (all locales)
```
Own Your Curation
```
17 chars (under App Store 30-char limit).

### Subtitle (per locale, 30-char limit)
| Locale | Subtitle | Length |
|---|---|---|
| en-US | `Curate what stays with you.` | 27 |
| ko    | `책·음반·영화·오브제·장소 큐레이션` | 21 |
| ja    | `本・音楽・映画・モノ・場所のキュレーション` | 22 |

### Privacy Policy URL
```
https://noenemyx.github.io/still-hours-swift/legal/privacy-policy-{en,ko,ja}.html
```

---

## §2 App Store Version Localizations (per locale)

### Description (4000-char limit)

**en-US** (1465 chars):
> The bookshop where you bought it. The record a friend left. The silence after the film. The cafe you stopped at that day.
>
> Curation is the record of what you've chosen to keep close.
>
> Own Your Curation is a personal archive for books, music, films, objects, and **places**. Not a stack of things you own — a record of how each one came to shape your texture.
>
> ——
>
> Five kinds of curation
>
> Books: search by title or ISBN, auto-adopt cover and metadata. Date read, publisher, translator, personal notes.
>
> Music: search albums, auto-adopt formats (LP, CD, streaming). Track list, release year, listening notes.
>
> Films: search titles, auto-adopt director/cast/release info. Date watched, personal review.
>
> Objects: fountain pens, vintage cameras, ceramics, art books. Free entry, kept with a photo.
>
> Places: cafes, bookshops, galleries, travel destinations. Time spent, who you were with, a line worth remembering.
>
> ——
>
> The Own Your Curation Promise
>
> No algorithm. Your curations are ordered the way you ordered them.
> No public feed. No one else can see your collection.
> No advertising. Permanently.
> No subscription. One-time purchase. All features. All future updates included.
> No AI judgment. What you curate is your decision alone.
>
> ——
>
> Data sovereignty
>
> All data lives in your iCloud private database. Nothing sent to a server. Export anytime as JSON or CSV.
>
> ——
>
> Curation is not about forgetting. It is about keeping close.
>
> Made by sunghun.ahn — a one-person tool.

**ko** (778 chars): see ASC live or git log
**ja** (730 chars): see ASC live or git log

### Keywords (100-char limit per locale)

| Locale | Keywords (chars) |
|---|---|
| en-US | `curation,archive,collection,books,music,films,objects,places,bookshop,gallery,vinyl,memory` (90) |
| ko    | `큐레이션,아카이브,컬렉션,책,음반,영화,오브제,장소,서점,갤러리,LP,기억,일회구매,기록앱` (50) |
| ja    | `キュレーション,アーカイブ,コレクション,本,音楽,映画,モノ,場所,書店,ギャラリー,アルバム,記憶,買い切り` (56) |

### Promotional Text (170-char limit, updatable any time)

| Locale | Promo Text (chars) |
|---|---|
| en-US | `Curate books, music, films, objects, and places. A personal archive — no algorithm, no feed, no subscription. One-time purchase.` (128) |
| ko    | `책·음반·영화·오브제·장소를 큐레이션하는 개인 아카이브. 알고리즘 없음, 피드 없음, 구독 없음. 일회 구매.` (61) |
| ja    | `本・音楽・映画・モノ・場所をキュレーションする個人アーカイブ。アルゴリズムなし、フィードなし、サブスクなし。買い切り。` (59) |

---

## §2.5 C-2 Korea ASO Revision (2026-05-24) — PENDING application

**Source**: Korean ASO keyword research agent (general-purpose, opus, 2026-05-24).
**Status**: Documented here. ASC REST API PATCH 적용은 _사용자 승인 후_.

### Why revise

Korea-first 전략 확정 (PRD §0.-1) + 현재 ko 메타데이터의 한계 진단:
- Subtitle 이 _카테고리 나열_ ("책·음반·영화·오브제·장소 큐레이션") — 검색 의도와 매치 약함.
- Keywords 에 `컬렉션`/`기록앱` 토큰 중복 (각각 `큐레이션`/`아카이브`와 중복).
- Searcher 가 _큐레이션_ 보다 _취향_/_소장품_/_저널_/_다이어리_ 같은 _개인 행위 동사_ 로 검색하는 패턴 미반영.

### Revised ko fields (recommended)

**Subtitle (ko, 30자 한도)** — Hook A: Searcher-first

```
취향을 기록하는 개인 아카이브
```

16자. 현재 21자 대비 안전 마진 ↑. 핵심 동사 _기록_, 핵심 명사 _취향_/_아카이브_ 전면.

**Keywords (ko, 100자 한도)** — 18 토큰, 88자

```
큐레이션,아카이브,취향,소장품,수집,오브제,장소,책방,음반,LP,영화,갤러리,다이어리,메모,저널,여행,노트,일회구매
```

vs 현재:
- _제거_: `컬렉션` (큐레이션과 의미 중복), `기록앱` (`아카이브`와 중복 + 일반어 검색 약함), `기억` (`메모`/`저널`로 행위 명사화), `서점` (`책방` 으로 한국식 어휘), `책`/`음반`/`영화`/`오브제`/`장소` 일부는 subtitle 에서 cover 가능하므로 keywords 에 _다른_ 의도 토큰 우선
- _추가_: `취향`, `소장품`, `수집`, `책방`, `다이어리`, `메모`, `저널`, `여행`, `노트` (9개 신규)

12자 buffer 남김 (LP/소장품 같은 짧은 토큰 추가 옵션 v1.x).

**Description (ko)** — Searcher-first 첫 단락 교체

기존 첫 단락 (Wunderkammer/진열장 톤) 제거. 신규 hook:

> _당신이 좋아하는 것들을 한 곳에._
>
> 읽은 책, 들은 음반, 본 영화, 모은 오브제, 다녀온 장소.
> 알고리즘 없는 개인 아카이브에서 취향의 흐름을 봅니다.
>
> Own Your Curation 은 _가진 것_ 의 목록이 아닙니다. _고른 것_ 의 기록입니다.

이후 §2 의 5 medium 단락 + Promise + Data sovereignty + Made by 단락은 그대로 유지.

**Promotional Text (ko)** — 변경 없음 (현재 61자, 효과적).

### Application path — Manual via ASC web console (2026-05-24 결정)

API key 분리 보존을 위해 _자동 PATCH 대신_ ASC 웹 콘솔 수동 적용. ASO 문서 = source of truth.

**경로**: App Store Connect → My Apps → Own Your Curation (com.ownlifelab.stillhours) → App Store 탭 → 한국어 (ko) → Editable version (현재 1.0 prepare-for-submission 또는 다음 1.0.1)

**적용 3 필드** (위 코드 블록에서 그대로 복사):

| Field | Value (above) | Char count | Limit |
|---|---|---|---|
| Subtitle (Promotional) | `취향을 기록하는 개인 아카이브` | 16 | 30 |
| Keywords | `큐레이션,아카이브,취향,…,일회구매` (18 토큰) | 88 | 100 |
| Description (first paragraph) | `당신이 좋아하는 것들을 한 곳에…` (3 단락) | — | 4000 |

**적용 후 체크**:
1. ASC 콘솔 _Save_ 클릭 → 미리보기로 한국어 페이지 확인
2. 변경 ko subtitle 이 search snippet 에 노출되는지 확인 (반영 ~24h)
3. 14일 후 ASC Analytics → Impressions / Page Views ko 비교

**미적용 시 영향**: 기존 카테고리 나열 subtitle 유지 = ko 검색 첫 화면 진입 약 30~40% 손실 (research agent 추정).

### Anti-keywords (의도적 제외)

| Token | 제외 사유 |
|---|---|
| `일기` | 의도와 다른 검색 의도 (감정 일기) 유입 |
| `독서기록` | 책 단일 medium 으로 오해 유도 |
| `bookshelf`/`bookself` | 영어 토큰 ko subtitle/keywords 에 섞으면 ASC 검색 알고리즘 ko 가중 약화 |
| `pinterest`/`아레나`/`are.na` | 경쟁 브랜드 토큰 — ASC 정책 위반 위험 |
| `사진정리`/`갤러리앱` | iOS 시스템 앱 검색 의도 — 우리 앱 위치 X |
| `bullet journal` | OYL 영역. 본 앱과 페르소나 분리 의도 |

---

## §3 Differences from Still Hours v1.0 ASO

| 항목 | Still Hours | Own Your Curation |
|---|---|---|
| App name | Still Hours | Own Your Curation |
| Subtitle (en) | A slow archive for your things | Curate what stays with you. |
| Mediums | 4 (book/music/film/object) | **5** (+ **place**) |
| Core verb | "archive" / "collect" | **"curate"** / **"adopt"** |
| Brand family | (standalone) | OYL / OYB / **OYC** |

---

## §4 Open issues

- Wave 2 (zh-Hans, zh-Hant, fr, es, pt) descriptions: deferred to v1.1
- Screenshots: need to recapture after CurationFlow ships (Build #9+)
- App preview video: planned for v1.1 launch push
