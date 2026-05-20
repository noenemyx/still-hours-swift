# Curium

> iOS 26 + iPadOS 26 native collection app. _Item-as-memory-anchor × multi-medium typed (Book/Music/Movie/Object) × intimate 1-to-1 share × Slow curator_. Paid one-time **$14.99**.
>
> 자산을 입구로, 기억을 본문으로.

---

## What is this

Curium is a collection management app where each item (book, album, film, object) becomes the entry point for the memories attached to it. Day One organizes by date entries; Curium organizes by items and lets memories accumulate underneath each one.

**Naming**: After Marie Curie + element 96 (Cm) + the Latin root *curiositas*. Adopted 2026-05-20 following 4-panel naming advisory (Marketing / Branding / Design / Critic) + Web verification (the earlier candidate _Curio_ was discarded due to App Store market collision; _Vaulta_ was discarded due to EOS Network rebrand). See `docs/PRD.md §19` for the full naming history.

---

## Status

- **Pre-flight stage** (2026-05-20)
- Repo: `noenemyx/curium-swift` (private)
- Bundle ID: `com.ownlifelab.curium` (TBD by user)
- Launch target: iOS 26 + iPadOS 26 only (Liquid Glass full, SwiftUI 26 APIs)
- Mac native: v2.0 (post-launch month 7-12)

---

## Identity (4 axes)

1. **Item-as-memory-anchor** — items are the entry, memories are the body (Day One inverse)
2. **Multi-medium typed × work/manifestation** — books, music, films, physical objects in one data model (Discogs work/release pattern, multi-domain)
3. **1-to-1 intimate share** — CloudKit CKShare, no public profile
4. **Apple-native iOS 26 first** — Liquid Glass design language, SwiftUI 26 APIs

---

## Promise (default reserve)

1. No algorithm — sort by explicit user choice only
2. No feed — no public stream
3. No advertising / no data sale
4. No AI judgment — AI assist only for OCR/image recognition
5. **No subscription IAP** — code-enforced via lint (the one Promise made non-negotiable in code)

Plus Data Sovereignty: CloudKit Private DB only, plaintext JSON/CSV/PDF export always available.

---

## Documents (`docs/`)

| File | Lines | Description |
|------|-------|-------------|
| `PRD.md` | ~1200 | Product Requirements — niche, persona, JTBD, hero moments, user stories, data model, modules, pricing, open questions, v2.1 naming history, v2.2 ASO Optimization |
| `DEVPLAN.md` | ~1300 | Development Plan — tech stack, architecture, MVP definition (Tracer Bullet), milestones, risk register, release strategy, burnout protection, ASO Implementation |
| `BENCHMARK.md` | ~440 | Market benchmark — 22 apps × 9 categories, 5 product hypotheses, niche definition |
| `ADVISORY.md` | ~230 | 6-panel advisory synthesis (Marketing / Strategy / UX / UI / Design / Engineer) |
| `Design.md` | ~900 | Design system living document — Sunsama + Things 3 + benchmark + Claude Design collaboration + ASO Visual Strategy |

---

## ASO Optimization (continuous practice)

ASO is treated as a _continuous practice from development stage_, not a launch-only activity. See `PRD.md §20` / `DEVPLAN.md §16` / `Design.md §16` for full strategy.

Monthly ASO ritual = 매월 1일 1시간 (advisory ritual과 분리):
- Keyword ranking 30분 + Competitor scan 20분 + Review analysis 10분

ASO Quit signal (6개월 시점):
- 3-month rolling rating < 4.0 _AND_ paid downloads < 100 _AND_ 30-day refund > 8% _AND_ DAU/MAU < 15% — 4개 중 3개 이상 동시 충족 시 제품 재검토

---

## Pre-flight Week 1-3 (36h checklist)

Tracer Bullet sequence (`Book full → Music full → Movie basic → Object basic`) starts after Pre-flight gate clears all items:

- [ ] Trademark search (KIPRIS + USPTO Class 9 + EUIPO + App Store dupes) for "Curium"
- [ ] Apple Design Resources iOS 26 Figma download + study
- [ ] SF Symbols 7 macOS app install
- [ ] Liquid Glass material reference study (WWDC 2025)
- [ ] Foundation tokens v1.0 (Color 10 + Type 8 + Space 6 + Radius 4 + Shadow 2 + Motion 4)
- [ ] Semantic tokens v1.0
- [ ] Component tokens v1.0 (ItemCard / MemoryRow / CollectionCover / MediumBadge)
- [ ] App icon v1.0 draft (Wunderkammer cabinet + Liquid Glass layered)
- [ ] Memory Timeline visual signature design pass
- [ ] WCAG AA contrast verification chart
- [ ] Settings → "Curium is" surface copy (ko/en draft)
- [ ] App Store metadata 8-locale 1차 draft (Wave 1 ko/en/ja 우선)
- [ ] Search Ads budget setup ($300-500/월 상한, brand defense + negative keywords)
- [ ] Promise lint scripts (Privacy + Data Sovereignty + No subscription IAP — 3 lint baseline)

---

## Build (TBD during Pre-flight)

```bash
# bash scripts/test.sh        # All lints + SPM tests + Xcode build
# bash scripts/build.sh       # Xcode archive
# bash scripts/check-i18n.sh  # i18n axis A-J + axis M ASO
# bash scripts/check-promise.sh  # Promise lint (Privacy + Data Sovereignty + No subscription)
```

---

## License

Proprietary. © sunghun.ahn 2026-.
