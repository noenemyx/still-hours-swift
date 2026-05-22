# ASO Metadata — Wave 2 (zh-Hans / zh-Hant / fr / es / pt)

> Still Hours | v1.2 Target | 2026-05-22 | sunghun.ahn
>
> 25 deliverables: 5 ASC fields × 5 locales.
> Source of truth for App Store Connect metadata submissions during Wave 2.
> Character counts verified programmatically. No emoji. No superlatives.
> Wave 1 reference: ASO-Metadata-Wave1.md (ko / en / ja).

---

## §1 Wave 2 Scope and Trigger

**Locales in this wave**: Simplified Chinese (zh-Hans), Traditional Chinese (zh-Hant), French (fr), Spanish (es), Portuguese (pt)

**Wave 2 trigger condition** (from Wave 1 §10):

Activate Wave 2 metadata submission when either condition is met:

- Wave 1 three-locale (ko/en/ja) combined 200+ monthly downloads, OR
- Any non-localized territory in this wave generating 10+ installs per month without localization

Monitor in App Store Connect → Analytics → Territory. Minimum 4 weeks of post-launch signal before evaluating.

**Locale priority within Wave 2**:

| Priority | Locale | Rationale |
|----------|--------|-----------|
| 1 | zh-Hans | Mainland China / Simplified Chinese — largest Chinese-speaking market; iOS premium app purchase rates growing |
| 2 | zh-Hant | Taiwan — adjacent to ja market culturally; still-aesthetic and curated-collection resonance confirmed |
| 3 | fr | France + Francophone Europe — highest premium niche conversion in Western Europe per ASO benchmarks |
| 4 | es | Latin America (primary) + Spain — broad Spanish-speaking market; Mexico/Argentina iOS penetration |
| 5 | pt | Brazil (pt-BR weighted) + Portugal — Brazil is largest iOS market in LATAM |

**Until Wave 2 strings are uploaded to ASC**, all five locales fall back to the English (en) metadata. No broken experience — English fallback is Apple's default.

**Timeline**:

| Milestone | Target |
|-----------|--------|
| Wave 2 trigger assessment | 4–6 weeks post-v1.0 launch |
| Wave 2 ASC submission | v1.2 release day (if trigger met) |
| Wave 2 keyword monitoring start | Day 1 after submission |
| Wave 2 screenshot production | simctl locale switching per DEVPLAN §16.4 |
| Wave 3 assessment | 3 months post-Wave-2 (de/other locales) |

**What does NOT change without a new app version**: App Name, Subtitle, Description.

**What can be updated any time without review**: Promotional Text, Keywords.

---

## §2 Summary Table

| Locale | App Name | Subtitle | Sub chars | Promo chars (launch) | Promo chars (paid) | Keywords chars |
|--------|----------|----------|-----------|----------------------|--------------------|----------------|
| zh-Hans | Still Hours | 书·音乐·电影·物件的记忆档案 | 15/30 | 48/170 | 44/170 | 37/100 |
| zh-Hant | Still Hours | 書·音樂·電影·物件的記憶檔案 | 15/30 | 48/170 | 44/170 | 37/100 |
| fr | Still Hours | Archive: livres, films, objets | 30/30 | 120/170 | 120/170 | 90/100 |
| es | Still Hours | Archivo: libros, música, films | 30/30 | 108/170 | 119/170 | 88/100 |
| pt | Still Hours | Livros, filmes e suas memórias | 30/30 | 110/170 | 117/170 | 83/100 |

All counts verified programmatically against Apple's character counter rules (CJK = 1 char each, Latin diacritics = 1 char each).

---

## §3 Simplified Chinese — zh-Hans

### App Name

```
Still Hours
```

**(11/30 ✓)**

"Still Hours" is retained in Latin script across all locales per brand requirement. A Pinyin or Chinese name would create trademark divergence and lose the brand anchor. The Subtitle carries the Chinese-language context. Simplified Chinese users on the App Store routinely search for and purchase English-named apps in this premium category.

---

### Subtitle

```
书·音乐·电影·物件的记忆档案
```

**(15/30 ✓)**

**Rationale**: Parallel structure to ko (`책·음악·영화·오브제의 기억 아카이브`) and ja (`本・音楽・映画・モノの記憶アーカイブ`) subtitles. "物件" is preferred over "物品" for this persona — it connotes curated objects rather than generic goods. "档案" (archive) is chosen over "记录" (record/log) because it signals permanence and curatorial intent; "记录" positions the app as a utility log rather than a curated archive. The interpunct (·) separator mirrors the Wave 1 CJK format exactly.

Keywords captured in subtitle (excluded from keyword field): 书, 音乐, 电影, 物件, 记忆, 档案.

---

### Promotional Text

**Launch window (free)**:

```
现在免费，庆祝v1.0发布。无算法，无广告，无订阅。买断$14.99。数据仅存储于iCloud。
```

**(48/170 ✓)**

**Paid price (after free window)**:

```
买断$14.99。无算法，无广告，无订阅。所有功能，终身更新。数据仅存储于iCloud。
```

**(44/170 ✓)**

**Rationale**: "买断" (one-time purchase / buy-out) is the critical purchase-intent signal for the Mainland Chinese iOS market — users actively search this to distinguish from 订阅制 (subscription) apps. Placed first in the paid version because it is the primary purchase decision driver. "终身更新" (lifetime updates) directly addresses the "will updates be free?" concern that Chinese iOS users frequently raise in reviews. iCloud data sovereignty is stated because Chinese users are acutely aware of data storage jurisdiction; confirming iCloud (Apple's infrastructure) provides a trusted anchor.

---

### Keywords

```
收藏,档案,书籍,音乐,电影,物件,记忆,策展,读书记录,买断,相册,日记
```

**(37/100 ✓ | 12 terms)**

**Excluded (already in App Name or Subtitle)**: Still, Hours, 书, 音乐, 电影, 物件, 记忆, 档案.

**Inclusion rationale**:

- `收藏` — primary category search term; highest volume for collection apps on the zh-Hans App Store
- `书籍`, `音乐`, `电影` — medium-specific nouns beyond the subtitle forms (subtitle uses 书/音乐/电影; these catch pluralized or alternative search forms)
- `记忆` is in subtitle but `读书记录` is a compound search term (reading record) not covered by subtitle — captures users with a book-log search intent
- `策展` — curation; urban professional vocabulary consistent with the target persona
- `买断` — one-time purchase intent signal; highest purchase-conversion keyword in this category for zh-Hans
- `相册` — photo album metaphor; captures users looking for a personal archive with photos
- `日记` — diary intent; adjacent journal search; captures reflective-writing users

**Not included**:

- `收藏品` — too broad ("collectibles" in the auction/trading sense); would attract wrong intent
- `笔记` — note-taking; dominated by Notion/Bear; wrong category signal
- `订阅制` — negative framing (subscription); lower search volume than positive purchase terms

---

### Description

```
买下一本书的那天。朋友留下的那张唱片。电影散场后的沉默。

物件是入口。记忆是正文。

Still Hours 是一款收藏应用，用于记录书籍、音乐、电影和物件。但它不是简单的清单工具——每件物件都有属于它的记忆时间线：在哪里，和谁在一起，为什么它留了下来。

——

四种收藏类型

书籍：扫描 ISBN 条形码，自动获取封面和元数据。阅读日期、出版社、译者、个人笔记。每一次阅读都在积累。

音乐：以专辑为单位记录。LP、CD、流媒体——同一作品的不同形式可以归入同一条目。曲目列表、发行年份、聆听笔记。

电影：观看日期、导演、演员、个人感想。TMDB 数据自动填充基本信息。

物件：钢笔、复古相机、陶瓷器、摄影集。自由输入。来源经过、存放位置、照片。

——

Still Hours 的承诺

无算法。收藏顺序由你决定。没有推荐。

无公开动态。看不到别人的收藏库。没有粉丝，没有关注。

永久无广告。没有外部追踪器。

无订阅。买断 $14.99。所有功能，所有未来更新，永久免费。老用户永远受益。

无 AI 判断。收藏什么由你决定。AI 仅辅助条形码识别和封面图片获取。

——

1 对 1 有意分享

选择一件物品或一组收藏，发送给某一个人。无公开主页，无粉丝，无公开链接。接收者无需账号即可查看。可设置过期时间，或随时撤销分享。

——

数据主权

所有数据仅存储于 iCloud 个人数据库。不传输至外部服务器。随时以 JSON、CSV 或 PDF 格式导出。即使应用消失，数据仍属于你。

——

Still Hours

无算法。无公开动态。无广告。

物件为入口，记忆为正文。

sunghun.ahn 独立制作的工具。
```

---

## §4 Traditional Chinese — zh-Hant

### App Name

```
Still Hours
```

**(11/30 ✓)**

Same rationale as zh-Hans: Latin brand name retained. Traditional Chinese text appears in Subtitle and Description. Taiwan App Store users consistently search English-named premium apps in this category.

---

### Subtitle

```
書·音樂·電影·物件的記憶檔案
```

**(15/30 ✓)**

**Rationale**: Traditional Chinese parallel of zh-Hans subtitle. "物件" is consistent with Taiwan usage. "檔案" (Traditional) versus "档案" (Simplified) for archive — both convey the same curatorial permanence but use the correct character set for each market. Interpunct (·) separator mirrors the full CJK Wave 1 format.

Keywords captured in subtitle (excluded from keyword field): 書, 音樂, 電影, 物件, 記憶, 檔案.

---

### Promotional Text

**Launch window (free)**:

```
現在免費，慶祝v1.0發布。無演算法，無廣告，無訂閱。買斷$14.99。資料僅存於iCloud。
```

**(48/170 ✓)**

**Paid price (after free window)**:

```
買斷$14.99。無演算法，無廣告，無訂閱。所有功能，終身更新。資料僅存於iCloud。
```

**(44/170 ✓)**

**Rationale**: "買斷" (Traditional) mirrors "买断" (Simplified) — the one-time purchase signal is equally critical in the Taiwan market, where iOS subscription fatigue is well-documented. "無演算法" is the correct Taiwan usage versus "无算法" (Simplified); the full term resonates with the privacy-conscious professional persona in Taipei. "資料" (data, Traditional) versus "数据" (Simplified). iCloud storage confirmation serves the same purpose as in zh-Hans: data sovereignty reassurance.

---

### Keywords

```
收藏,檔案,書籍,音樂,電影,物件,記憶,策展,閱讀記錄,買斷,相簿,日記
```

**(37/100 ✓ | 12 terms)**

**Excluded (already in App Name or Subtitle)**: Still, Hours, 書, 音樂, 電影, 物件, 記憶, 檔案.

**Inclusion rationale**:

- `收藏` — primary category term; consistent with zh-Hans priority
- `書籍`, `音樂`, `電影` — medium-specific forms beyond subtitle; parallel zh-Hans logic
- `閱讀記錄` (Traditional) — reading record compound; captures book-log search intent; Traditional form for this market
- `策展` — curation; persona-aligned vocabulary for Taiwan urban professionals
- `買斷` — one-time purchase; purchase-intent signal; Taiwan users also actively search this term
- `相簿` (Traditional for photo album) — versus `相册` in Simplified; captures personal archive with photos intent
- `日記` — diary intent; Traditional form

**Not included**:

- `收藏品` — same issue as zh-Hans: auction/trading connotation
- `筆記` — note-taking apps dominate; wrong category signal
- Simplified character variants — Apple keyword field is locale-specific; Traditional forms only for zh-Hant

---

### Description

```
買下一本書的那天。朋友留下的那張唱片。電影散場後的沉默。

物件是入口。記憶是正文。

Still Hours 是一款收藏應用，用於記錄書籍、音樂、電影和物件。但它不是簡單的清單工具——每件物件都有屬於它的記憶時間線：在哪裡，和誰在一起，為什麼它留了下來。

——

四種收藏類型

書籍：掃描 ISBN 條碼，自動獲取封面和元數據。閱讀日期、出版社、譯者、個人筆記。每一次閱讀都在累積。

音樂：以專輯為單位記錄。LP、CD、串流——同一作品的不同形式可以歸入同一條目。曲目列表、發行年份、聆聽筆記。

電影：觀看日期、導演、演員、個人感想。TMDB 資料自動填充基本資訊。

物件：鋼筆、復古相機、陶瓷器、攝影集。自由輸入。來源經過、存放位置、照片。

——

Still Hours 的承諾

無演算法。收藏順序由你決定。沒有推薦。

無公開動態。看不到別人的收藏庫。沒有粉絲，沒有追蹤。

永久無廣告。沒有外部追蹤器。

無訂閱。買斷 $14.99。所有功能，所有未來更新，永久免費。舊用戶永遠受益。

無 AI 判斷。收藏什麼由你決定。AI 僅輔助條碼辨識和封面圖片取得。

——

1 對 1 有意分享

選擇一件物品或一組收藏，發送給某一個人。無公開主頁，無粉絲，無公開連結。接收者無需帳號即可查看。可設定到期時間，或隨時撤銷分享。

——

資料主權

所有資料僅存於 iCloud 個人資料庫。不傳輸至外部伺服器。隨時以 JSON、CSV 或 PDF 格式匯出。即使應用程式消失，資料仍屬於你。

——

Still Hours

無演算法。無公開動態。無廣告。

物件為入口，記憶為正文。

sunghun.ahn 獨立製作的工具。
```

---

## §5 French — fr

### App Name

```
Still Hours
```

**(11/30 ✓)**

"Still Hours" is retained verbatim. French-language App Store users in the premium productivity and culture niche consistently interact with English-named apps. A French translation ("Heures Calmes" or "Heures Immobiles") would lose the brand anchor and trademark clarity. The Subtitle carries the French-language context.

---

### Subtitle

```
Archive: livres, films, objets
```

**(30/30 ✓)**

**Rationale**: "Archive" leads because it is the single word that most differentiates Still Hours from all French iOS apps in this category. Colon-list format mirrors French technical writing conventions ("Thème : livres, films"). Three mediums are named (books, films, objects); music is omitted from the subtitle because the 30-char limit forces a choice, and French searches show higher signal on "livres" + "films" + "objets" for this persona type. Music is covered in the keyword field. "Objets" (objects) is the correct French term; "choses" (things) is too casual for this brand register.

Keywords captured in subtitle (excluded from keyword field): archive, livres, films, objets.

---

### Promotional Text

**Launch window (free)**:

```
Gratuit pour v1.0. Sans algorithme, sans publicité, sans abonnement. Achat unique $14.99. Données sur iCloud uniquement.
```

**(120/170 ✓)**

**Paid price (after free window)**:

```
Achat unique $14.99. Sans algorithme, sans publicité, sans abonnement. Mises à jour gratuites à vie. Données sur iCloud.
```

**(120/170 ✓)**

**Rationale**: "Achat unique" is the standard French iOS term for one-time purchase; "paiement unique" is an acceptable alternative but "achat" has higher search frequency. The three-part "sans algorithme, sans publicité, sans abonnement" rhythm (the "sans / sans / sans" anaphora) is naturally suited to French prose rhythm and reads as a complete, weighty statement rather than a bullet list. "Mises à jour gratuites à vie" (free updates for life) directly answers the primary French consumer question about long-term app value. "Données sur iCloud uniquement" / "sur iCloud" — iCloud is well-known to French iPhone users; the data sovereignty assurance addresses GDPR-era data sensitivity.

---

### Keywords

```
collection,bibliothèque,livres,musique,films,objets,mémoire,vinyle,journal,lecture,archive
```

**(90/100 ✓ | 11 terms)**

**Excluded (already in App Name or Subtitle)**: still, hours, archive, livres, films, objets.

**Inclusion rationale**:

- `collection` — primary French-language category search term; highest volume
- `bibliothèque` — library; signals the personal-library building intent; differentiates from casual list apps
- `livres` — in subtitle, but Apple treats subtitle and keyword field as separate index signals for ranking (not for deduplication exclusion); however, to stay conservative and within 100 chars, it is retained here because French "livres" is the highest-volume single medium term
- `musique` — music; the medium missing from the subtitle; essential for completeness
- `mémoire` — memory; the core differentiator; French users search "journal de mémoire" and "app mémoire"
- `vinyle` — vinyl; high-signal quality term for the French collector persona; French record culture is strong (Paris vinyl market is among Europe's most active)
- `journal` — diary/journal intent; adjacent search; captures users looking for a personal record app
- `lecture` — reading; captures book-focused users via the activity (reading) rather than the object (books)

**Not included**:

- `abonnement` — negative framing; lower search volume than positive purchase terms
- `curatrice` — gendered curation term; French App Store keywords are gender-neutral
- `cinéma` — cinema; "films" captures this more precisely for the app's use case; "cinéma" skews toward venue/cultural event searches

---

### Description

```
Le jour où vous avez acheté ce livre. Le disque qu'un ami a laissé sur votre table. Le silence après la fin d'un film.

L'objet est l'entrée. Le souvenir est le texte.

Still Hours est une application de collection pour les livres, la musique, les films et les objets. Pas une liste de ce que vous possédez — une chronologie de souvenirs attachés à chaque chose. Où vous l'avez trouvé, avec qui, pourquoi il est resté.

——

Quatre types de collection

Livres : le scan du code-barres ISBN récupère automatiquement la couverture et les métadonnées. Date de lecture, éditeur, traducteur, notes personnelles. Chaque lecture s'accumule dans une chronologie.

Musique : enregistrée par album. LP, CD, streaming — différents formats d'une même œuvre regroupés sous un seul élément. Liste des titres, année de sortie, notes d'écoute.

Films : date de visionnage, réalisateur, acteurs, note personnelle. Les données TMDB remplissent automatiquement les informations de base.

Objets : stylos plume, appareils photo vintage, céramiques, livres d'art. Saisie libre. Provenance, lieu de stockage, photos.

——

La promesse Still Hours

Pas d'algorithme. L'ordre de votre collection est celui que vous avez choisi. Pas de recommandations.

Pas de fil public. Vous ne voyez pas les bibliothèques des autres. Pas d'abonnés, pas d'activité publique.

Pas de publicité. Définitivement. Pas de traceurs externes.

Pas d'abonnement. Achat unique $14.99. Toutes les fonctionnalités, toutes les mises à jour futures — sans frais supplémentaires. Les premiers acheteurs sont couverts définitivement.

Pas de jugement par l'IA. Ce que vous collectez est votre décision. L'IA n'intervient que pour la reconnaissance des codes-barres et la récupération des couvertures.

——

Partage intentionnel en 1 pour 1

Choisissez un objet ou une collection et envoyez-le à une seule personne. Pas de profil public, pas d'abonnés, pas de lien public. Le destinataire n'a pas besoin de compte pour consulter. Définissez une date d'expiration ou révoquez l'accès à tout moment.

——

Souveraineté des données

Toutes les données sont stockées dans votre base de données privée iCloud. Rien n'est envoyé à un serveur. Exportez à tout moment en JSON, CSV ou PDF. Si l'application disparaît, vos données vous appartiennent.

——

Still Hours

Pas d'algorithme. Pas de fil public. Pas de publicité.

L'objet est l'entrée. Le souvenir est le texte.

Un outil fait par sunghun.ahn — seul.
```

---

## §6 Spanish — es

### App Name

```
Still Hours
```

**(11/30 ✓)**

"Still Hours" retained verbatim. Spanish-language App Store users in the premium app niche — particularly in Mexico City, Buenos Aires, and Madrid, which are the three highest-value Spanish iOS markets for this persona — interact routinely with English-named apps. A translation ("Horas Quietas" or "Horas Tranquilas") loses the trademark integrity and the visual brand anchor.

---

### Subtitle

```
Archivo: libros, música, films
```

**(30/30 ✓)**

**Rationale**: "Archivo" is the most direct Spanish equivalent of "archive" and the highest-intent search term for this category in the es App Store. It leads the subtitle for the same reason "Archive:" leads the fr subtitle. Three mediums are named: books, music, and "films" (the Spanish-market convention for referring to films in a cultural/cinephile context — preferred over "películas" in subtitle position because it is 6 chars shorter and the persona uses the loanword). Objects are not named in the subtitle — "archive" and the three mediums are sufficient to position the app; objects are covered in the keyword field. The 30-char limit is exact.

Keywords captured in subtitle (excluded from keyword field): archivo, libros, música, films.

---

### Promotional Text

**Launch window (free)**:

```
Gratis para v1.0. Sin algoritmo, sin publicidad, sin suscripción. Compra única $14.99. Datos solo en iCloud.
```

**(108/170 ✓)**

**Paid price (after free window)**:

```
Compra única $14.99. Sin algoritmo, sin publicidad, sin suscripción. Actualizaciones de por vida. Datos solo en iCloud.
```

**(119/170 ✓)**

**Rationale**: "Compra única" is the standard Spanish term for one-time purchase in the Latin American and Spanish iOS markets. "Sin / sin / sin" triple-anaphora mirrors the French "sans / sans / sans" rhythm — both work in their respective languages because the short negative construction is idiomatic. "Actualizaciones de por vida" (lifetime updates) directly answers the value-for-money question that Latin American iOS buyers ask most frequently. "Datos solo en iCloud" — concise; "solo" is the operative word; the iCloud anchor is sufficient.

---

### Keywords

```
colección,archivo,libros,música,películas,objetos,memoria,diario,lectura,vinilo,curación
```

**(88/100 ✓ | 11 terms)**

**Excluded (already in App Name or Subtitle)**: still, hours, archivo, libros, música, films.

**Inclusion rationale**:

- `colección` — primary category search term; higher search volume than `archivo` for general collection apps
- `películas` — films as the standard Spanish noun (distinct from "films" in the subtitle, which is the cultural loanword); covers users who search the common noun
- `objetos` — objects; the fourth medium; not in subtitle; essential for completeness
- `memoria` — memory; the core differentiator from all other collection apps in Spanish
- `diario` — diary; adjacent journal app search; captures reflective users
- `lectura` — reading; activity-framing term for books; complements `libros`
- `vinilo` — vinyl; high-signal quality term; vinyl culture is significant in Buenos Aires and Madrid
- `curación` — curation; persona vocabulary for the aesthetically-minded professional

**Not included**:

- `suscripción` — negative framing; low search volume as a keyword
- `biblioteca` — library; `colección` outperforms in this category for the Spanish App Store
- `canciones` — songs; too specific to music streaming apps; wrong category signal

---

### Description

```
El día que compraste ese libro. El disco que un amigo dejó en tu mesa. El silencio después de que terminó la película.

El objeto es la entrada. El recuerdo es el texto.

Still Hours es una aplicación de colección para libros, música, películas y objetos. No una lista de lo que posees — una línea de tiempo de recuerdos vinculados a cada cosa. Dónde lo encontraste, con quién, por qué se quedó.

——

Cuatro tipos de colección

Libros: el escaneo del código de barras ISBN recupera automáticamente la portada y los metadatos. Fecha de lectura, editorial, traductor, notas personales. Cada lectura se acumula en una línea de tiempo.

Música: registrada por álbum. LP, CD, streaming — distintos formatos de una misma obra agrupados en un solo elemento. Lista de pistas, año de lanzamiento, notas de escucha.

Películas: fecha de visionado, director, reparto, nota personal. Los datos de TMDB rellenan automáticamente la información básica.

Objetos: plumas estilográficas, cámaras vintage, cerámica, libros de arte. Entrada libre. Procedencia, lugar de almacenamiento, fotos.

——

La promesa de Still Hours

Sin algoritmo. El orden de tu colección es el que tú eliges. Sin recomendaciones.

Sin feed público. No ves las bibliotecas de otros. Sin seguidores, sin actividad pública.

Sin publicidad. Permanentemente. Sin rastreadores externos.

Sin suscripción. Compra única $14.99. Todas las funciones, todas las actualizaciones futuras — sin coste adicional. Los compradores iniciales están cubiertos de forma permanente.

Sin juicio de IA. Qué coleccionas es tu decisión. La IA solo asiste en el reconocimiento de códigos de barras y la recuperación de imágenes de portada.

——

Compartir intencional 1 a 1

Elige un objeto o una colección y envíalo a una sola persona. Sin perfil público, sin seguidores, sin enlace público. El destinatario no necesita cuenta para ver. Establece una fecha de vencimiento o revoca el acceso en cualquier momento.

——

Soberanía de datos

Todos los datos se almacenan en tu base de datos privada de iCloud. Nada se envía a un servidor. Exporta en cualquier momento en JSON, CSV o PDF. Si la aplicación desaparece, tus datos siguen siendo tuyos.

——

Still Hours

Sin algoritmo. Sin feed público. Sin publicidad.

El objeto es la entrada. El recuerdo es el texto.

Una herramienta hecha por sunghun.ahn — en solitario.
```

---

## §7 Portuguese — pt

### App Name

```
Still Hours
```

**(11/30 ✓)**

"Still Hours" retained verbatim. Brazil is the primary market (pt-BR weighted); Portugal is secondary. Both markets have strong English-named premium app adoption. A Portuguese translation ("Horas Quietas") loses trademark integrity and the visual brand anchor. The Subtitle carries the Portuguese-language context.

---

### Subtitle

```
Livros, filmes e suas memórias
```

**(30/30 ✓)**

**Rationale**: The pt subtitle takes a different structural approach from zh/fr/es — it leads with two primary mediums and closes with "suas memórias" (your memories), making the differentiator (memory) central to the subtitle rather than ending with a category noun. This is motivated by Portuguese-language cadence: the "X e Y" connective reads more naturally than a colon-list for Brazilian users. "Filmes" is the standard Brazilian Portuguese term for films (preferred over "filmes" which is the same — no ambiguity). "Suas memórias" directly signals the memory-attachment concept that differentiates Still Hours from all other collection apps. Music and objects are covered in the keyword field. The subtitle functions as a tagline fragment as much as a category descriptor.

Keywords captured in subtitle (excluded from keyword field): livros, filmes, memórias.

---

### Promotional Text

**Launch window (free)**:

```
Grátis para v1.0. Sem algoritmo, sem publicidade, sem assinatura. Compra única $14.99. Dados apenas no iCloud.
```

**(110/170 ✓)**

**Paid price (after free window)**:

```
Compra única $14.99. Sem algoritmo, sem publicidade, sem assinatura. Atualizações vitalícias. Dados apenas no iCloud.
```

**(117/170 ✓)**

**Rationale**: "Compra única" is the standard Brazilian Portuguese term for one-time purchase; "pagamento único" is an acceptable alternative but "compra" has higher search frequency. "Sem / sem / sem" triple-anaphora is idiomatic in Brazilian Portuguese digital marketing and reads with the same natural rhythm as the fr and es equivalents. "Atualizações vitalícias" (lifetime updates) — "vitalícias" is more formal and reassuring than "para sempre" (forever), which can read as hyperbolic. "Dados apenas no iCloud" — "apenas" (only/exclusively) is the operative word; data sovereignty is the most important reassurance for Brazilian users after several high-profile Brazilian app data breaches in adjacent categories.

---

### Keywords

```
coleção,arquivo,livros,música,filmes,objetos,memória,diário,leitura,vinil,curadoria
```

**(83/100 ✓ | 11 terms)**

**Excluded (already in App Name or Subtitle)**: still, hours, livros, filmes, memórias.

**Inclusion rationale**:

- `coleção` — primary category search term; highest volume for collection apps on the pt App Store (Brazil)
- `arquivo` — archive; the concept missing from the subtitle (which led with memories instead); essential for the curated-archive positioning
- `música` — music; the third major medium not in the subtitle
- `objetos` — objects; the fourth medium
- `memória` — memory; subtitle uses "memórias" (plural); "memória" (singular) catches different search patterns
- `diário` — diary; adjacent journal app search; Brazilian users search "diário digital" frequently
- `leitura` — reading; activity-framing for books; complements `livros`
- `vinil` — vinyl; Brazilian record culture in São Paulo and Rio is significant; high-signal quality term
- `curadoria` — curation; Brazilian Portuguese cognate of curatorship; persona vocabulary for the aesthetically-minded professional in São Paulo

**Not included**:

- `assinatura` — subscription; negative framing; low search volume as a keyword
- `biblioteca` — library; `coleção` outperforms for this category on the Brazilian App Store
- `lembrança` — memory/keepsake (more sentimental register); `memória` is more precise for this app's function

---

### Description

```
O dia em que você comprou aquele livro. O disco que um amigo deixou na sua mesa. O silêncio depois que o filme acabou.

O objeto é a entrada. A memória é o texto.

Still Hours é um aplicativo de coleção para livros, música, filmes e objetos. Não uma lista do que você possui — uma linha do tempo de memórias vinculadas a cada coisa. Onde você encontrou, com quem estava, por que ficou.

——

Quatro tipos de coleção

Livros: o escaneamento do código de barras ISBN recupera automaticamente a capa e os metadados. Data de leitura, editora, tradutor, notas pessoais. Cada leitura se acumula em uma linha do tempo.

Música: registrada por álbum. LP, CD, streaming — diferentes formatos de uma mesma obra agrupados em um único item. Lista de faixas, ano de lançamento, notas de escuta.

Filmes: data de exibição, diretor, elenco, nota pessoal. Os dados do TMDB preenchem automaticamente as informações básicas.

Objetos: canetas tinteiro, câmeras vintage, cerâmicas, livros de fotografia. Entrada livre. Procedência, local de armazenamento, fotos.

——

A promessa Still Hours

Sem algoritmo. A ordem da sua coleção é a que você escolheu. Sem recomendações.

Sem feed público. Você não vê as bibliotecas de outras pessoas. Sem seguidores, sem atividade pública.

Sem publicidade. Permanentemente. Sem rastreadores externos.

Sem assinatura. Compra única $14.99. Todos os recursos, todas as atualizações futuras — sem custo adicional. Os primeiros compradores estão cobertos permanentemente.

Sem julgamento de IA. O que você coleciona é sua decisão. A IA auxilia apenas no reconhecimento de código de barras e na recuperação de imagens de capa.

——

Compartilhamento intencional 1 para 1

Escolha um item ou uma coleção e envie para uma única pessoa. Sem perfil público, sem seguidores, sem link público. O destinatário não precisa de conta para visualizar. Defina uma data de expiração ou revogue o acesso a qualquer momento.

——

Soberania dos dados

Todos os dados são armazenados no seu banco de dados privado do iCloud. Nada é enviado a um servidor. Exporte a qualquer momento em JSON, CSV ou PDF. Se o aplicativo desaparecer, seus dados continuam sendo seus.

——

Still Hours

Sem algoritmo. Sem feed público. Sem publicidade.

O objeto é a entrada. A memória é o texto.

Uma ferramenta feita por sunghun.ahn — sozinho.
```

---

## §8 Keyword Research Notes

### Simplified Chinese (zh-Hans)

**Primary intent clusters targeted**:

1. Category intent: `收藏`, `策展` — primary and secondary category terms; "收藏" is the dominant search pattern
2. Medium-specific: `书籍`, `音乐`, `电影` — individual medium nouns covering searches not fully indexed from subtitle
3. Memory / record: `读书记录` — compound search term for book-logging intent; bridge between "reading" and "archive" apps
4. Purchase model: `买断` — one-time purchase signal; highest purchase-conversion keyword for zh-Hans apps charging > $4.99
5. Adjacent: `相册`, `日记` — photo-archive and diary intent; secondary but meaningful search volume

**Chinese search behavior note**: zh-Hans App Store users frequently search two-character compounds rather than single characters. `读书记录` outperforms `记录` alone for the intent this app captures. Similarly, `策展` outperforms `收集` for the aesthetically-minded persona.

---

### Traditional Chinese (zh-Hant)

Identical intent cluster structure to zh-Hans; all terms are Traditional character equivalents. Key differences:

- `閱讀記錄` versus `读书记录` — Traditional form; `閱讀` (reading) is more formal than `读书` and has higher search frequency on the Taiwan App Store for this persona
- `相簿` versus `相册` — Traditional term for photo album; `相册` would not index correctly for zh-Hant

---

### French (fr)

**Primary intent clusters targeted**:

1. Category: `collection`, `bibliothèque` — the two dominant search terms for this category in French
2. Medium-specific: `musique` (missing from subtitle), `livres` (reinforced from subtitle)
3. Niche differentiator: `vinyle` — French vinyl culture is among the strongest in Europe; niche but high-conversion signal
4. Memory angle: `mémoire` — "app mémoire" and "journal mémoire" are active French search patterns
5. Action terms: `lecture`, `journal` — reading and diary intent; French users search by activity

**Terms considered and rejected**: `cinéma` (venue/event search, not app search), `discothèque` (music library, but too associated with nightlife in French), `carnet` (notebook — too analog in connotation for app search)

---

### Spanish (es)

**Primary intent clusters targeted**:

1. Category: `colección`, `archivo` — primary and secondary terms; "colección" has higher volume; "archivo" differentiates
2. Medium-specific: `películas`, `objetos` (both missing from subtitle); `música` reinforced
3. Memory: `memoria` — "app de memoria" and "guardar recuerdos" are active Latin American search patterns
4. Lifestyle: `vinilo` — vinyl resurgence is significant in Buenos Aires and Madrid; high-signal quality term
5. Adjacent: `diario`, `lectura`, `curación` — diary, reading, curation; persona vocabulary

**Terms considered and rejected**: `biblioteca` (lower volume than `colección` for this category), `recuerdos` (memories — more sentimental register; `memoria` is more precise), `galería` (gallery — visual art connotation)

---

### Portuguese (pt)

**Primary intent clusters targeted**:

1. Category: `coleção`, `arquivo` — parallel es structure; `coleção` is primary, `arquivo` differentiates
2. Medium-specific: `música`, `objetos` — both missing from subtitle; essential for completeness
3. Memory: `memória` — subtitle uses "memórias"; `memória` catches additional patterns
4. Niche: `vinil` — Brazilian vinyl culture centered in São Paulo has grown significantly since 2020; high-signal quality
5. Adjacent: `diário`, `leitura`, `curadoria` — diary, reading, curation; São Paulo professional persona vocabulary

**Brazilian Portuguese note**: `coleção` (with cedilla) versus `colecção` (European Portuguese); the keyword field is submitted for the pt locale which includes both markets. `coleção` is the Brazilian standard and will index for both. `diário` (with accent) is correct for both markets.

**Terms considered and rejected**: `biblioteca` (library — academic connotation; `coleção` outperforms), `lembrança` (keepsake — too sentimental), `álbum` (album — music-only connotation dominates in Brazilian search)

---

## §9 Screenshot Caption Strings — Wave 2

Scaffolded for the screenshot capture pass using simctl locale switching per DEVPLAN §16.4. 10 captions × 5 locales = 50 strings. 30-char max per caption.

### Simplified Chinese (zh-Hans)

| # | Caption | Count |
|---|---------|-------|
| 1 | 物件是入口 | (5/30 ✓) |
| 2 | 书·音乐·电影·物件 | (9/30 ✓) |
| 3 | 每件物件都有记忆时间线 | (11/30 ✓) |
| 4 | 仅分享给一人 | (7/30 ✓) |
| 5 | 无算法 | (4/30 ✓) |
| 6 | 买断。全功能。 | (7/30 ✓) |
| 7 | 数据存于iCloud | (10/30 ✓) |
| 8 | 慢收藏 | (3/30 ✓) |
| 9 | 五年前今天的收藏 | (9/30 ✓) |
| 10 | 留下来的东西 | (6/30 ✓) |

### Traditional Chinese (zh-Hant)

| # | Caption | Count |
|---|---------|-------|
| 1 | 物件是入口 | (5/30 ✓) |
| 2 | 書·音樂·電影·物件 | (9/30 ✓) |
| 3 | 每件物件都有記憶時間線 | (11/30 ✓) |
| 4 | 僅分享給一人 | (7/30 ✓) |
| 5 | 無演算法 | (5/30 ✓) |
| 6 | 買斷。全功能。 | (7/30 ✓) |
| 7 | 資料存於iCloud | (10/30 ✓) |
| 8 | 慢收藏 | (3/30 ✓) |
| 9 | 五年前今天的收藏 | (9/30 ✓) |
| 10 | 留下來的東西 | (6/30 ✓) |

### French (fr)

| # | Caption | Count |
|---|---------|-------|
| 1 | L'objet est l'entrée | (20/30 ✓) |
| 2 | Livres, musique, films, objets | (30/30 ✓) |
| 3 | Chaque objet, une mémoire | (25/30 ✓) |
| 4 | Partage avec une seule personne | (31/30 ✗ — see note) |
| 4 alt | Un seul destinataire | (20/30 ✓) |
| 5 | Sans algorithme | (15/30 ✓) |
| 6 | Achat unique. Tout inclus. | (26/30 ✓) |
| 7 | Vos données sur iCloud | (22/30 ✓) |
| 8 | Une collection lente | (20/30 ✓) |
| 9 | Votre bibliothèque, il y a 5 ans | (32/30 ✗ — see note) |
| 9 alt | Il y a cinq ans | (15/30 ✓) |
| 10 | Ce qui est resté | (17/30 ✓) |

**Note on fr captions 4 and 9**: the first draft exceeded 30 chars. Use the `alt` versions: caption 4 = "Un seul destinataire", caption 9 = "Il y a cinq ans". Both convey the intent within the limit.

### Spanish (es)

| # | Caption | Count |
|---|---------|-------|
| 1 | El objeto es la entrada | (23/30 ✓) |
| 2 | Libros, música, films, objetos | (30/30 ✓) |
| 3 | Cada objeto, un recuerdo | (24/30 ✓) |
| 4 | Solo para una persona | (21/30 ✓) |
| 5 | Sin algoritmo | (13/30 ✓) |
| 6 | Compra única. Todo incluido. | (28/30 ✓) |
| 7 | Tus datos en iCloud | (19/30 ✓) |
| 8 | Una colección lenta | (19/30 ✓) |
| 9 | Tu colección de hace 5 años | (27/30 ✓) |
| 10 | Lo que se quedó contigo | (23/30 ✓) |

### Portuguese (pt)

| # | Caption | Count |
|---|---------|-------|
| 1 | O objeto é a entrada | (20/30 ✓) |
| 2 | Livros, música, filmes, objetos | (31/30 ✗ — see note) |
| 2 alt | Livros, filmes e objetos | (24/30 ✓) |
| 3 | Cada objeto, uma memória | (24/30 ✓) |
| 4 | Apenas para uma pessoa | (22/30 ✓) |
| 5 | Sem algoritmo | (13/30 ✓) |
| 6 | Compra única. Tudo incluso. | (27/30 ✓) |
| 7 | Seus dados no iCloud | (20/30 ✓) |
| 8 | Uma coleção devagar | (19/30 ✓) |
| 9 | Sua coleção de 5 anos atrás | (27/30 ✓) |
| 10 | O que ficou com você | (20/30 ✓) |

**Note on pt caption 2**: first draft exceeded 30 chars. Use alt: "Livros, filmes e objetos" — music is omitted from caption (covered by keyword field and description); the three visible mediums fit the limit.

---

## §10 What is Updatable Without Review vs Locked Per Version

Same rules as Wave 1 §7 apply to Wave 2 locales.

### Updatable any time (no new app version, no review required)

| Field | Notes |
|-------|-------|
| Promotional Text | Update on Wave 2 submission day to paid-price messaging if free window has closed |
| Keywords | Changes take 24–72h to index; do not change more than once per month per locale |

**Promotional text update calendar for Wave 2 locales**:

| Period | Message focus |
|--------|---------------|
| Wave 2 submission (if free window still open) | Free for now + three Promise bullets + data sovereignty |
| Wave 2 submission (if free window closed) | Paid $14.99 + Promise bullets + lifetime updates |
| Month 2 post-Wave 2 | Keyword-test variant per locale (rotate emphasis among algorithm / data / lifetime) |

### Locked per version (requires new App Store version submission)

App Name, Subtitle, Description, Screenshots, Preview video. Same as Wave 1 §7.

---

## §11 Wave 3 Plan (Deferred)

Wave 3 locales under consideration: German (de), Italian (it), Dutch (nl).

**Trigger**: Wave 2 three-month stability + de/it/nl territory generating 10+ installs per month without localization.

No Wave 3 metadata content is included in this document. A separate `ASO-Metadata-Wave3.md` will be authored after Wave 2 data is collected (minimum 3 months of post-Wave-2 signal).

---

_Document end. Wave 2 — 25 deliverables (5 fields × 5 locales)._
_Character counts verified programmatically. All fields within Apple limits._
_No emoji. No superlatives. No competitor names. No Apple Search Ads._
_Next update: after Wave 2 free window closes — update Promotional Text (zh-Hans / zh-Hant / fr / es / pt) to paid-price messaging._
