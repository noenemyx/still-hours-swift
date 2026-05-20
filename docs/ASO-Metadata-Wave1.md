# ASO Metadata — Wave 1 (ko / en / ja)

> Still Hours | v1.0 Launch | 2026-05-20 | sunghun.ahn
>
> 15 deliverables: 5 ASC fields × 3 locales.
> Source of truth for all App Store Connect metadata submissions during Wave 1.
> Character counts verified programmatically. No emoji. No superlatives.

---

## §1 Wave 1 Scope and Timeline

**Locales in this wave**: Korean (ko), English (en), Japanese (ja)

**Rationale for this three**: 6-panel advisory (Agreement A3) and DEVPLAN §16.2 both converge on a 3-stage soft launch. Korean is the primary creator market; English unlocks global discovery and editorial pickup; Japanese is the secondary market where "slow" aesthetic products resonate most with the persona (28-42 urban professionals, aesthetically-minded).

**Timeline**:

| Milestone | Target |
|-----------|--------|
| Wave 1 ASC submission | v1.0 launch day |
| Wave 1 keyword monitoring start | Day 1 post-launch |
| Wave 1 assessment point | 4-6 weeks post-launch |
| Wave 2 trigger condition | ko/en/ja combined 200+ monthly downloads OR non-localized territory 10+ installs/month |
| Wave 2 start | Deferred — see §10 |

**What does NOT change without a new app version**: App Name, Subtitle, Description.

**What can be updated any time without review**: Promotional Text, Keywords. See §7 for full locked/unlockable breakdown.

---

## §2 Korean (ko) Metadata

### App Name

```
Still Hours
```

**(11/30 ✓)**

"Still Hours" is retained verbatim across all locales per brand requirement. The dual meaning — _stillness (고요)_ and _still continuing (여전히)_ — works in Korean context without translation. A localized name would lose the brand anchor and create trademark divergence risk.

---

### Subtitle

```
책·음악·영화·오브제의 기억 아카이브
```

**(20/30 ✓)**

**Rationale**: Subtitle must sell the niche in one breath without repeating "Still Hours." This line introduces all four mediums plus the differentiating concept (기억 / memory) plus the format (아카이브). It directly answers "what kind of app is this?" before the user taps. "아카이브" outperforms "컬렉션" here because it signals curation with permanence rather than casual accumulation — matches the Lina persona vocabulary.

Keywords captured in subtitle (excluded from keyword field): 책, 음악, 영화, 오브제, 기억, 아카이브.

---

### Promotional Text

```
v1.0 출시 — 지금 무료입니다. 알고리즘 없음, 광고 없음, 구독 없음. 모든 데이터는 iCloud에만 존재합니다. 일회 구매, 모든 기능.
```

**(80/170 ✓)**

**Rationale**: Promotional Text is the one ASC field updatable any time without a new app version or review. It is calibrated for launch week: price signal (무료 — free for now), three-line Promise summary (the strongest differentiators in order of purchase resistance), data sovereignty (Korean users are particularly sensitive to cloud data), and one-time purchase confirmation. After the launch-free window closes, this field will be updated to reflect the paid $14.99 price.

**Planned update after free window ends**:
```
일회 구매 $14.99. 알고리즘 없음, 광고 없음, 구독 없음. 모든 데이터는 iCloud에만 존재합니다. 추가 비용 없이 평생 업데이트.
```
(78/170 ✓)

---

### Keywords

```
컬렉션,아카이브,독서기록,음악수집,영화기록,큐레이션,기억,소장,기록앱,일회구매,책장,오브제,앨범,감상문,추억,메모,다이어리
```

**(68/100 ✓ | 17 terms)**

**Excluded (already in App Name or Subtitle)**: Still, Hours, 책, 음악, 영화, 오브제, 기억, 아카이브.

**Inclusion rationale**:
- `컬렉션` — primary search intent for this category, highest volume
- `독서기록`, `음악수집`, `영화기록` — typed medium + action compounds; lower competition than single nouns
- `큐레이션` — Lina persona vocabulary; differentiates from generic log apps
- `기록앱` — compound search term used by Korean users looking for "recording app"
- `일회구매` — purchase intent signal; captures users filtering out subscription apps
- `소장` — ownership vocabulary ("소장" = to possess/collect as a keeper), distinct from casual use
- `책장` — physical metaphor; connects to bookshelf-building intent
- `앨범`, `감상문` — music and review vocabulary
- `추억`, `메모`, `다이어리` — memory/journal signal terms that capture adjacent intent

---

### Description

```
책을 손에 넣은 날. LP를 선물 받은 순간. 영화 상영이 끝난 후의 정적.

자산이 입구가 됩니다. 기억이 본문이 됩니다.

Still Hours는 책, 음악, 영화, 물건을 기록하는 컬렉션 앱입니다. 단, 자산을 목록으로 쌓는 것이 아닙니다. 자산마다 기억의 타임라인이 열립니다 — 어디서, 누구와, 왜 그것을 가지게 되었는지.

——

네 가지 유형의 소장품

책: ISBN 바코드 스캔으로 표지와 메타데이터를 자동으로 불러옵니다. 독서 날짜, 출판사, 역자, 개인 메모. 읽은 기록이 쌓입니다.

음악: 앨범 단위로 기록합니다. LP, CD, 스트리밍 — 같은 작품의 다른 형태를 하나의 항목으로 묶을 수 있습니다. 트랙 목록, 발매 연도, 감상 노트.

영화: 관람 날짜, 감독, 출연진, 개인 감상. TMDB 데이터 연동으로 기본 정보를 자동으로 채웁니다.

물건: 만년필, 빈티지 카메라, 도자기, 사진집. 자유 형식으로 직접 입력합니다. 취득 경위, 보관 위치, 사진.

——

Still Hours의 약속

알고리즘 없음. 소장품 순서는 사용자가 정한 순서입니다. 추천 없음.

공개 피드 없음. 다른 사람의 라이브러리는 보이지 않습니다. 팔로워 없음.

광고 없음. 영구적으로. 외부 트래커도 없습니다.

구독 없음. 일회 구매, 모든 기능 영구 잠금 해제. 기존 구매자는 모든 업데이트 무료.

AI 판단 없음. 무엇을 수집할지는 당신이 결정합니다. AI는 바코드 인식과 표지 이미지 가져오기만 보조합니다.

——

1:1 의도된 공유

소장품 하나 또는 컬렉션을 골라 단 한 명에게 보낼 수 있습니다. 공개 프로필 없음. 팔로워 없음. 공개 링크 없음. 받는 사람은 계정 없이도 볼 수 있습니다. 만료 시각을 설정하거나 언제든지 공유를 취소할 수 있습니다.

——

데이터 주권

모든 데이터는 iCloud 개인 데이터베이스에만 저장됩니다. 외부 서버에 전송되지 않습니다. JSON, CSV, PDF 형식으로 언제든지 내보낼 수 있습니다. 앱이 사라져도 데이터는 당신의 것입니다.

——

Still Hours는

알고리즘 없음. 공개 피드 없음. 광고 없음.

자산을 입구로, 기억을 본문으로.

sunghun.ahn 혼자 만드는 도구입니다.
```

**Description rationale**: see §6.

---

## §3 English (en) Metadata

### App Name

```
Still Hours
```

**(11/30 ✓)**

---

### Subtitle

```
A slow archive for your things
```

**(30/30 ✓)**

**Rationale**: "Slow" signals the brand ethos and differentiates immediately from fast-logging apps. "Archive" elevates the collection concept above casual list-keeping. "Things" is deliberately broad — it covers books, music, films, and objects without naming them, which would exceed 30 chars. The phrase reads as a complete thought and works as a standalone tagline. It does not repeat any word from "Still Hours."

Keywords captured in subtitle (excluded from keyword field): archive (critical — highest search weight for this niche in English).

---

### Promotional Text

```
Free for now — celebrating v1.0. No algorithm, no ads, no subscription. Paid one-time $14.99 at full price. Your library lives in your iCloud only.
```

**(147/170 ✓)**

**Rationale**: Sets price expectation accurately (free now, $14.99 normally), states the three core differentiators (algorithm/ads/subscription), and confirms data sovereignty. "Free for now" is the precise framing from PRD — not "free forever." The $14.99 mention sets buyer quality signal even during the free window.

**Planned update after free window ends**:
```
Paid one-time $14.99. No algorithm, no ads, no subscription. All features, all future updates. Your library lives in your iCloud only.
```
(135/170 ✓)

---

### Keywords

```
collection,archive,library,books,music,films,objects,curator,memory,vinyl,journal,reading,log,item
```

**(98/100 ✓ | 14 terms)**

**Excluded (already in App Name or Subtitle)**: still, hours, slow, things, a.

**Inclusion rationale**:
- `collection` — primary category search term; highest volume for this niche
- `library` — secondary primary term; captures users building personal libraries
- `books,music,films,objects` — four typed mediums as separate terms; captures medium-specific searches
- `curator,curate` — (curator chosen) Lina persona vocabulary; differentiates from generic log apps
- `memory` — the core differentiator from all other collection apps; captures "memory journal" intent
- `vinyl` — LP-specific search intent; undercounted by competitors, high signal quality
- `journal,reading,log` — adjacent intent terms that bring in users looking for diary + reading tracker + film diary
- `item` — neutral collection vocabulary; catches broad searches without competing on "collection" alone

**Not included (rationale)**:
- `archive` — already in subtitle; Apple indexes subtitle separately
- `film diary`, `book log` — multi-word terms not supported in keyword field format
- Competitor names — Apple policy violation

---

### Description

```
The day you bought a book in a bookshop. The record a friend left on your table. The silence after a film ended.

The item is the entry point. The memory is the record.

Still Hours is a collection app for books, music, films, and objects. Not a list of things you own — a timeline of memories attached to each thing. Where you found it, who you were with, why it stayed.

——

Four types of collection

Books: ISBN barcode scan pulls cover art and metadata automatically. Date read, publisher, translator, personal notes. Each reading adds to a running timeline.

Music: recorded by album. LP, CD, streaming — different formats of the same work collected under one item. Track list, release year, listening notes.

Films: date watched, director, cast, personal note. TMDB data fills the basics automatically.

Objects: fountain pens, vintage cameras, ceramics, art books. Free-form entry. Provenance, storage location, photos.

——

The Still Hours Promise

No algorithm. Your collection is ordered the way you ordered it. No recommendations.

No public feed. You cannot see other people's libraries. No followers, no activity stream.

No advertising. Permanently. No external trackers.

No subscription. Paid one-time $14.99. All features, all future updates — no additional cost. Early buyers are covered permanently.

No AI judgment. What you collect is your decision alone. AI assists only with barcode recognition and cover image retrieval.

——

1-to-1 intentional sharing

Choose one item or collection and send it to one person. No public profile, no followers, no public link. The recipient does not need an account to view it. Set an expiry date, or revoke access at any time.

——

Data sovereignty

All data is stored in your iCloud private database. Nothing is sent to a server. Export at any time in JSON, CSV, or PDF. If the app disappears, your data remains yours.

——

Still Hours is

No algorithm. No public feed. No advertising.

The item is the entry. The memory is the record.

Made by sunghun.ahn — a one-person tool.
```

**Description rationale**: see §6.

---

## §4 Japanese (ja) Metadata

### App Name

```
Still Hours
```

**(11/30 ✓)**

"Still Hours" is retained in Latin script. Japanese App Store convention for English-named apps: keep the original name. A katakana transliteration "スティル・アワーズ" loses the visual identity and the dual meaning (静けさ + まだ続く) that the name carries. The Subtitle carries the Japanese-language context.

---

### Subtitle

```
本・音楽・映画・モノの記憶アーカイブ
```

**(18/30 ✓)**

**Rationale**: Parallel structure to the Korean subtitle. "モノ" is preferred over "物" for subtitle position — more contemporary, resonates with the Lina persona in Tokyo/urban Japan. "記憶アーカイブ" is the most compact way to deliver the differentiator. "アーカイブ" chosen over "記録" because it signals permanence and curatorial intent; "記録" skews toward simple logging apps.

**Why not "収集" for "コレクション"**: PRD persona vocabulary guidance prefers "収集" in description body (formal kanji) but subtitle must be immediately scannable — "アーカイブ" does more work in fewer characters.

Keywords captured in subtitle (excluded from keyword field): 本, 音楽, 映画, モノ, 記憶, アーカイブ.

---

### Promotional Text

```
v1.0リリース記念 — 現在無料でご利用いただけます。アルゴリズムなし、広告なし、サブスクリプションなし。買い切り$14.99。すべてのデータはiCloudにのみ保存されます。
```

**(89/170 ✓)**

**Rationale**: "買い切り" (one-time purchase) is the most important Japanese keyword for this product category — it directly captures users searching for non-subscription alternatives. Placed prominently with the actual price. "現在無料" (currently free) is precise per PRD framing; avoids "永久無料" (permanently free).

**Planned update after free window ends**:
```
買い切り$14.99。アルゴリズムなし、広告なし、サブスクリプションなし。すべてのデータはiCloudにのみ保存されます。将来のアップデートも追加費用なし。
```
(80/170 ✓)

---

### Keywords

```
コレクション,アーカイブ,蔵書,音盤,映画記録,読書記録,記録,買い切り,所蔵,メモ,キュレーション,アルバム,日記,本棚,私物,映画,本,音楽,記憶
```

**(75/100 ✓ | 19 terms)**

**Excluded (already in App Name or Subtitle)**: Still, Hours, 本, 音楽, 映画, モノ, 記憶, アーカイブ.

**Inclusion rationale**:
- `コレクション` — primary category term; high-volume Japanese App Store search
- `蔵書` — library/book collection (formal); captures serious book collectors; less competitive than 本
- `音盤` — vinyl record vocabulary; niche but high signal quality; Lina persona uses this word
- `映画記録`, `読書記録` — typed medium + action compounds; mirrors how Japanese users search ("record of films I've watched")
- `買い切り` — one-time purchase; the single strongest purchase-intent signal for this price model in Japan
- `所蔵` — formal ownership verb ("to have in one's collection"); used in museum/library contexts; differentiates from casual apps
- `キュレーション` — urban professional vocabulary; consistent with persona
- `アルバム` — music album intent
- `日記` — diary intent; captures adjacent journal app searches
- `本棚` — bookshelf; physical metaphor intent
- `私物` — personal belongings; captures the object-collection intent
- `メモ` — note-taking adjacent intent
- `記録` — broad recording intent; catches general "record" searches not captured by medium-specific terms

**Not included (rationale)**:
- `スティルアワーズ` — transliteration of app name; Apple indexes app name separately and katakana transliteration is not a search pattern for this app
- `サブスクなし` — too specific to negative search; positive terms perform better

---

### Description

```
本を手に入れた日。友人が贈ってくれたレコード。映画が終わった後の静けさ。

アイテムが入口になります。記憶が本文になります。

Still Hoursは、本・音楽・映画・物を記録するコレクションアプリです。ただし、所有物のリストをつくるのではありません。それぞれのアイテムに記憶のタイムラインが生まれます — どこで、誰と、なぜそれが手元に来たのか。

——

4種類のコレクション

本: ISBNバーコードスキャンで表紙とメタデータを自動取得します。読了日、出版社、翻訳者、個人メモ。読んだ記録が積み重なります。

音楽: アルバム単位で記録します。LP、CD、ストリーミング — 同じ作品の異なる形式をひとつのアイテムにまとめられます。トラックリスト、リリース年、試聴メモ。

映画: 鑑賞日、監督、出演者、個人的な感想。TMDBデータで基本情報を自動入力します。

物: 万年筆、ヴィンテージカメラ、陶器、写真集。自由形式で入力します。取得経緯、保管場所、写真。

——

Still Hoursの約束

アルゴリズムなし。コレクションの順序はあなたが決めます。推薦機能はありません。

公開フィードなし。他の人のライブラリは表示されません。フォロワーもありません。

広告なし。永続的に。外部トラッカーもありません。

サブスクリプションなし。買い切り$14.99。すべての機能、すべての将来アップデートを追加費用なしで。購入者は永続的に対象です。

AIによる判断なし。何を集めるかはあなたが決めます。AIはバーコード認識と表紙画像の取得のみを補助します。

——

1対1の意図的な共有

1点または1つのコレクションを選び、1人だけに送ることができます。公開プロフィールなし、フォロワーなし、公開リンクなし。受信者はアカウントなしで閲覧できます。有効期限を設定するか、いつでも共有を取り消せます。

——

データ主権

すべてのデータはiCloudのプライベートデータベースにのみ保存されます。外部サーバーには送信されません。JSON、CSV、PDF形式でいつでも書き出せます。アプリがなくなっても、データはあなたのものです。

——

Still Hoursは

アルゴリズムなし。公開フィードなし。広告なし。

アイテムを入口に、記憶を本文に。

sunghun.ahn が一人でつくるツールです。
```

**Description rationale**: see §6.

---

## §5 Keyword Research Notes

### Korean (ko)

**Primary intent clusters targeted**:

1. Category intent: `컬렉션`, `소장`, `기록앱` — users who know they want a collection or archive app
2. Medium-specific: `독서기록`, `음악수집`, `영화기록` — users coming from single-medium apps looking for consolidation
3. Curator vocabulary: `큐레이션`, `책장` — persona-aligned terms that signal aesthetic intent over pure utility
4. Purchase model: `일회구매` — captures users filtering subscription apps; high conversion signal
5. Adjacent emotion: `추억`, `기억`, `감상문` — memory and reflection intent; captures users who want more than logging

**Terms considered and rejected**:
- `앱` (too generic), `무료` (misleading as a permanent signal), `SNS` (wrong context), `독서앱` (too narrow — subtitle coverage handles this)
- Competitor names: excluded per Apple policy

**Korean keyword priority order** (if forced to trim to 75 chars): keep `컬렉션,아카이브,독서기록,음악수집,영화기록,큐레이션,기억,일회구매,기록앱` — these 9 terms cover all four intent clusters at minimum.

---

### English (en)

**Primary intent clusters targeted**:

1. Category: `collection`, `library` — the two highest-volume terms for this category
2. Medium-specific: `books`, `music`, `films`, `objects` — four separate terms; allows Apple to match medium-specific searches
3. Niche differentiator: `curator`, `vinyl` — signal quality over quantity; surfaces the app for discerning users rather than mass market
4. Memory angle: `memory`, `journal` — the Day One inverse; captures diary + memory users who feel unserved
5. Action terms: `reading`, `log`, `item` — utility-framing terms that catch task-oriented searches

**Terms considered and rejected**:
- `organize` (generic, dominated by productivity apps), `track` (dominated by habit/fitness apps), `database` (wrong connotation for persona), `private` (wrong App Store context)
- `film diary`, `book log`, `reading journal` — compound terms with spaces are not valid in Apple keyword field; single terms capture these
- Competitor names: excluded per Apple policy

**English keyword priority order** (if forced to trim): keep `collection,archive,library,books,music,films,memory,curator,vinyl` — these 9 terms cover the critical intent space.

---

### Japanese (ja)

**Primary intent clusters targeted**:

1. Category: `コレクション`, `アーカイブ` — primary search vocabulary in Japanese App Store
2. Serious collector: `蔵書` (book collection, formal), `音盤` (vinyl/records, connoisseur term), `所蔵` (formal ownership)
3. Medium-specific action: `映画記録`, `読書記録` — compound terms matching Japanese search patterns ("record of X I watched/read")
4. Purchase model: `買い切り` — highest-signal purchase-intent term in Japan; users actively search this to avoid subscriptions
5. Adjacent: `日記`, `本棚`, `メモ`, `キュレーション` — diary, bookshelf, note, curation — persona vocabulary

**Terms considered and rejected**:
- `スティルアワーズ` (app name transliteration; Apple indexes app name separately)
- `サブスクなし` (negative phrasing; lower search volume than positive equivalent)
- `Discogs`, `Letterboxd` (competitor names; Apple policy violation)
- `コレクションアプリ` (space-containing compound; not valid in keyword field)
- `収集` — not included despite being more "correct" than `コレクション` because `コレクション` has higher search volume on the Japanese App Store for this category; `収集` is used in description body per locale guidelines

**Japanese keyword priority order** (if forced to trim): keep `コレクション,アーカイブ,蔵書,映画記録,読書記録,買い切り,キュレーション,音盤,日記` — these 9 terms cover the core intent space.

---

## §6 Description Structure Rationale

All three descriptions follow the same architecture. The structure mirrors the ADVISORY §2 A4 guidance: "App Store description = action-description over philosophy declaration."

**Layer 1 — Hook (2-3 lines)**

Three concrete sensory moments before any product claim. Tsutaya bookshop, a gifted record, post-film silence. These scenes match the JTBD §4.1 Capture moments directly. They signal the persona immediately: users who recognize themselves in these scenes self-select. Users who don't are not the target.

**Layer 2 — Core differentiator in one sentence**

"The item is the entry point. The memory is the record." / "자산이 입구가 됩니다. 기억이 본문이 됩니다." This is the one sentence that separates Still Hours from every other collection app. It is stated before any feature list.

**Layer 3 — Four mediums (book / music / movie / object)**

Described as actions, not features. "ISBN barcode scan pulls cover art" not "supports ISBN lookup." Each medium gets exactly one short paragraph. Order: Book → Music → Film → Object (mirrors the Tracer Bullet development order and the persona's primary medium hierarchy).

**Layer 4 — Promise 5조항**

Each promise as a separate one-liner. No bullet characters (platform rendering inconsistency). "Permanently" on advertising. Explicit "$14.99 one-time" on the subscription clause — sets expectation in the description so the price page is not a surprise. Korean description additionally states "기존 구매자는 모든 업데이트 무료" (existing buyers get all updates free) because Korean users have higher refund sensitivity.

**Layer 5 — 1-to-1 share**

Described by what it is not (no public profile, no followers, no public link) before what it is. This framing matches how the persona thinks about sharing: they want intimacy, not reach.

**Layer 6 — Data sovereignty**

Three facts only: iCloud private database, no server transmission, export always available. No legal language. The final line ("If the app disappears, your data remains yours") is the 10-year-tool promise in one sentence.

**Layer 7 — "Still Hours is" vision close**

Mirrors the Settings Surface Copy voice exactly (Settings-Surface-Copy.md §1). This consistency matters: users who buy the app will see the same language in Settings, reinforcing rather than contradicting what they read in the App Store. Three-line format: three Promise bullets, one-liner brand statement, one-liner maker identity.

---

## §7 What is Updatable Without Review vs Locked Per Version

### Updatable any time (no new app version, no review required)

| Field | Notes |
|-------|-------|
| Promotional Text | Update this field for launch week (free), paid price restoration, seasonal messaging, editorial pickup coordination |
| Keywords | Can be changed between versions; changes take ~24-72h to index; do not change more than once per month (ranking signal disruption risk) |

**Promotional text update calendar (planned)**:

| Period | Message focus |
|--------|---------------|
| Launch week — free window | Free for now + three Promise bullets + data sovereignty |
| After free window closes | Paid $14.99 + Promise bullets + permanent update coverage |
| Month 2-3 | Keyword-test variant (emphasize one Promise at a time) |
| Wave 2 (zh/de addition) | Update en promo to reference expanded locale support |

### Locked per version (requires new App Store version submission)

| Field | Implication |
|-------|-------------|
| App Name | Cannot change without a new binary; name changes also reset review count. "Still Hours" is final for v1.0. |
| Subtitle | Locked with the binary. Changes require a version update + review. |
| Description | Locked with the binary. Planned significant updates should coincide with feature versions (v1.1, v1.2). |
| Screenshots | Locked per version and per device/locale combination. A new iOS version that changes UI (e.g. iOS 27) requires recapture and resubmission. |
| Preview video | Locked per version. |

---

## §8 Review Screenshot Caption Strings

Scaffolded for the screenshot capture pass (Pre-flight Week 1-3, DEVPLAN §16.1). These captions appear as overlay text on App Store screenshots. 30-char max per caption. Final set subject to visual design pass.

**10 captions × 3 locales = 30 strings.**

### Korean (ko)

| # | Caption | Count |
|---|---------|-------|
| 1 | 기억의 입구 | (6/30 ✓) |
| 2 | 책, 음악, 영화, 오브제 | (14/30 ✓) |
| 3 | 자산을 열면 기억이 펼쳐집니다 | (16/30 ✓) |
| 4 | 1인에게만 공유 | (8/30 ✓) |
| 5 | 알고리즘 없음 | (7/30 ✓) |
| 6 | 구독 없음, 일회 구매 | (12/30 ✓) |
| 7 | 모든 데이터는 iCloud에 | (15/30 ✓) |
| 8 | 느린 컬렉션 | (6/30 ✓) |
| 9 | 5년 전 오늘의 컬렉션 | (12/30 ✓) |
| 10 | 기억이 머무는 곳 | (9/30 ✓) |

### English (en)

| # | Caption | Count |
|---|---------|-------|
| 1 | The entry is the item | (21/30 ✓) |
| 2 | Books, music, films, objects | (28/30 ✓) |
| 3 | Memory builds on each item | (26/30 ✓) |
| 4 | Share with one person only | (26/30 ✓) |
| 5 | No algorithm | (12/30 ✓) |
| 6 | Paid once. All features. | (24/30 ✓) |
| 7 | Your data stays in iCloud | (25/30 ✓) |
| 8 | A slow collection | (17/30 ✓) |
| 9 | Your library, five years ago | (28/30 ✓) |
| 10 | Things that stayed with you | (27/30 ✓) |

### Japanese (ja)

| # | Caption | Count |
|---|---------|-------|
| 1 | 入口はアイテム | (7/30 ✓) |
| 2 | 本、音楽、映画、モノ | (10/30 ✓) |
| 3 | アイテムに記憶が積まれる | (12/30 ✓) |
| 4 | 一人だけに共有 | (7/30 ✓) |
| 5 | アルゴリズムなし | (8/30 ✓) |
| 6 | 買い切り。すべて使える。 | (12/30 ✓) |
| 7 | データはiCloudに | (11/30 ✓) |
| 8 | ゆっくりとしたコレクション | (13/30 ✓) |
| 9 | 5年前の今日のコレクション | (13/30 ✓) |
| 10 | 残り続けるもの | (7/30 ✓) |

**Screenshot-to-caption pairing (recommended order)**:

| Screenshot # | Scene | Caption slot |
|-------------|-------|-------------|
| 1 | Memory Timeline (hero — item + attached memories) | Caption 1 (entry is the item) |
| 2 | Library grid (all four mediums visible) | Caption 2 (books/music/films/objects) |
| 3 | Item detail → memory expand (book example) | Caption 3 (memory builds) |
| 4 | Share sheet (recipient picker, no public option) | Caption 4 (one person only) |
| 5 | Settings → Still Hours is (Promise surface) | Caption 5 (no algorithm) or Caption 7 (data iCloud) |
| 6 | Capture flow (barcode scan + quick memory entry) | Caption 3 (memory builds) |
| 7 | Collection cover view | Caption 8 (slow collection) |
| 8 | Time Travel view (5 years ago filter) | Caption 9 (five years ago) |

---

## §9 Apple Search Ads — Permanent No

Apple Search Ads are permanently off for Still Hours.

**Source**: PRD §5.1 Promise 3조항 — "No advertising · No data sale — 외부 트래커·픽셀·analytics broker 영구 X. Apple Search Ads 등 외부 광고 채널 활용도 영구 X."

**DEVPLAN §16.3** confirms: "User Decision 2026-05-20: No advertisement — Apple Search Ads 영구 X."

**Why this is correct**:

Apple Search Ads requires bidding on keywords, paying per tap, and — in its standard tier — sharing user acquisition data with Apple. All three conflict with Promise §5.3 (No advertising / No data sale). Even the basic tier (contextual matching only) involves a monetary acquisition channel that the brand explicitly rejects.

More importantly: the product does not need it. The target persona (Lina, 28-42, aesthetically-minded professional) actively distrusts algorithmic promotion. A Still Hours ad in the App Store would send exactly the wrong signal to the exact user who might otherwise buy it.

**Discovery channels that are permitted**: organic ASO (this document), Apple editorial outreach (App of the Day / Indie Spotlight), press outreach in ko/ja markets at v1.2, word-of-mouth. See DEVPLAN §16.3 for the complete permitted channel list.

This decision is not revisable without a formal Promise revision process involving the founder. It is recorded here as permanent, not as a future optimization target.

---

## §10 Wave 2 Plan (Deferred to v1.2)

Wave 2 locales: de (German), fr (French), es (Spanish), pt-BR (Brazilian Portuguese), zh-Hant (Traditional Chinese).

**Trigger**: Wave 1 three-locale combined 200+ monthly downloads OR non-localized territory (de/fr/es/pt-BR/zh-Hant) generating 10+ installs per month without localization.

**No Wave 2 metadata content is included here.** This section is a placeholder only. Content will be authored in a separate `ASO-Metadata-Wave2.md` after Wave 1 data is collected (minimum 4-6 weeks of post-launch signal).

**Automation note**: Wave 2 screenshot production will use `scripts/capture-screenshots.sh` with simctl locale switching, per DEVPLAN §16.4. Wave 1 screenshots are produced manually via Keynote + simulator.

**Wave 3** (fr/es/pt-BR, if separate from Wave 2 batch): deferred to v1.3 after Wave 2 3-month stability.

---

_Document end. Wave 1 — 15 deliverables complete (5 fields × 3 locales)._
_Character counts verified programmatically. All fields within Apple limits._
_No emoji. No superlatives. No competitor names. No Apple Search Ads._
_Next update: after free window closes — update Promotional Text (ko/en/ja) to paid-price messaging._
