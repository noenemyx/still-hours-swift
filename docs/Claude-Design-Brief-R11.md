# Claude Design Brief — Round 11 (Cool Blue Pivot)

> 2026-05-21 | Hand this file to Claude Design / Claude Sonnet Design.
> Single-document brief. Returns a single-document deliverable.

---

## TL;DR for Claude Design

Still Hours is an iOS 26 + iPadOS 26 paid one-time **$14.99** collection
app (books / music / movies / objects + memories per item). Previous
design direction was JOH-style **warm ink/paper** with `#B85C38` terra
accent. User decided **2026-05-21** to pivot the visual identity to:

- **청량 (cool / refreshing)**
- **투명 (transparent / Liquid Glass-leaning)**
- **파란색 (blue)**
- **Things 3 (by Cultured Code) as primary benchmark**

The warm-orange direction is **fully retired**. Foundation Color tokens,
semantic mappings, AccentColor asset, app icon — all need to be
re-derived from the new tone.

---

## What you need to deliver

A single markdown file `docs/Design-R11-ColdBlue.md` with these sections.
Each section is copy-pasteable into the codebase or token files
without further editing.

### §1 Tone rationale (3-4 paragraphs)

Explain in your own words why this palette serves Still Hours's
identity (item-as-memory-anchor, intimate 1-to-1 sharing, slow curator
ethos). Reference Things 3 explicitly — what about Things's tonal
discipline applies, what doesn't (Things is a task manager, Still Hours
is a memory archive). Acknowledge that **the new tone must receed so
that content (book covers, memory notes, photographs) is the
foreground**, not the chrome.

### §2 Foundation Color tokens (10 values × 2 modes)

Replace the warm-orange-era tokens wholesale. Required entries:

| Token | Light Hex | Light RGB 0-1 | Dark Hex | Dark RGB 0-1 | Notes |
|-------|-----------|---------------|----------|--------------|-------|
| `background` | _____ | _____ | _____ | _____ | App root background |
| `surface.primary` | _____ | _____ | _____ | _____ | Card / sheet base |
| `surface.elevated` | _____ | _____ | _____ | _____ | Hovered/elevated card |
| `text.primary` | _____ | _____ | _____ | _____ | Headings / body |
| `text.secondary` | _____ | _____ | _____ | _____ | Captions / metadata |
| `accent.default` | _____ | _____ | _____ | _____ | Primary CTAs / tab active |
| `accent.muted` | _____ | _____ | _____ | _____ | Subtle background tint |
| `accent.subtle` | _____ | _____ | _____ | _____ | Hover / dim state |
| `onAccent` | _____ | _____ | _____ | _____ | Text on accent fills |
| `separator` | _____ | _____ | _____ | _____ | Dividers / hairlines |

For each row, also include WCAG contrast ratio against the relevant pair
(text on background; text on surface; onAccent on accent.default) and
the AA/AA Large/AAA badge.

### §3 Semantic Color tokens (mapping foundation → uses)

26 semantic tokens mapping the 10 foundation values to specific UI
contexts. Examples to fill in:

- `nav.tint` → accent.default
- `card.background` → surface.primary
- `card.elevated` → surface.elevated
- `cta.primary.fill` → accent.default
- `cta.primary.text` → onAccent
- `tab.active.tint` → accent.default
- `tab.inactive.tint` → text.secondary (or text.tertiary if we add one)
- `liquidGlass.tint.subtle` → accent.subtle (for `.glassEffect(.regular)` tint param)
- `medium.book.tint` → ? (4 medium icon tints — should they be distinct or all accent?)
- `memory.kind.tint.<8 cases>` → ? (8 memory kind icon tints)
- `timeline.rail` → separator or accent.subtle (the 1pt accent line down MemoryTimelineView)
- `timeline.year.active` → accent.default (sticky year header current month)
- `error.fill` → ? (keep iOS system red, or define brand variant?)
- `warning.fill` → ? (keep iOS system amber, or define?)
- `success.fill` → ? (keep iOS system green, or define?)
- ... up to ~26

Document any decisions where a semantic token defines a NEW relationship
(e.g. "memory kind tints all use accent.subtle to keep the timeline
quiet" or "each kind gets its own muted blue variant — 8 colors derived
from accent.default by HSL shift").

### §4 Updated Design.MD §3 (Foundation Color) — verbatim replacement

Write the new §3 section as you'd want it to land in
`docs/Design.MD`. The current §3.1 documents the warm-orange palette
in detail; this replacement should be the same level of detail
(rationale per token, usage guidance, accessibility notes) — but for
the cool-blue palette.

Keep §3.2 (Typography), §3.3 (Spacing), §3.4 (Radius), §3.5 (Shadow),
§3.6 (Motion) untouched — those don't change with the palette pivot.

### §5 AccentColor.colorset Contents.json (Apple Asset Catalog format)

Exact JSON to drop into
`App/Resources/Assets.xcassets/AccentColor.colorset/Contents.json`.
Format:

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "...",
          "green" : "...",
          "red" : "..."
        }
      },
      "idiom" : "universal"
    },
    {
      "appearances" : [
        {
          "appearance" : "luminosity",
          "value" : "dark"
        }
      ],
      "color" : { "color-space" : "srgb", "components" : { ... } },
      "idiom" : "universal"
    }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```

Values must match §2 `accent.default` row exactly.

### §6 App icon concept v2 (1-page)

The previous A/B icon concepts (Wunderkammer cabinet / Light-on-paper)
in `docs/AppIcon-v1-Concept.md` were warm-orange. Pivot to a **single**
new direction matching cool blue + transparent + Things-influenced.

Provide:
- **Concept name** (1 phrase)
- **Concept description** (1 paragraph — what we see, what it evokes)
- **Composition** (ASCII or text mock of the 1024×1024 layout —
  background, foreground elements, focal point, negative space)
- **5-7 specific design elements** with intent
  (e.g. "1. Translucent blue gradient ring — references Liquid Glass
  material. 2. Tiny serif typographic mark in center …")
- **What it is NOT** (anti-references — e.g. "not a literal book stack;
  not Things 3's blue circle; not Day One's parchment")

We'll commission the actual PNG render later — text spec is enough.

### §7 Onboarding visual notes (per screen, 1 paragraph each)

The 3 onboarding screens are specified structurally in
`docs/Onboarding-3step-Design.md`. With the cool-blue pivot, how does
each screen's visual treatment shift?

- **Screen 1** (item-as-memory-anchor)
- **Screen 2** (4 medium typed)
- **Screen 3** (1-to-1 intimate share)

For each, call out: 1 visual change, 1 thing that stays the same.

### §8 Liquid Glass material treatment (key decision)

Things 3 doesn't use Liquid Glass (predates iOS 26). Apple's
Liquid Glass default is a frosted-clear material with subtle
specular highlights. With cool blue as our accent:

- Should `.glassEffect(.regular)` be tinted blue (subtle), or stay
  default frost-clear?
- Should tab bar Liquid Glass capsule pick up accent.subtle, or stay
  neutral?
- Should memory-count badges (top-right of ItemCardView) be tinted
  accent.subtle or neutral?

Decide and document the rationale. We want a clear, defensible answer
that any future view can follow without re-deciding.

### §9 Open questions back to user (only if needed)

If you have hard tradeoffs you can't resolve internally, surface 1-3
explicit questions for the user (안성훈). Format:

> **Q1**: <question>
> **Why it matters**: <impact>
> **Option A**: <one possible answer + tradeoffs>
> **Option B**: <another option + tradeoffs>
> **Your recommendation**: <which and why>

The user prefers options to be presented; don't decide alone if there's
real ambiguity.

---

## Files for you to read

Before answering, read these in order. They establish constraints and
context you must honor.

### Must-read (core)

1. **`docs/Design.MD`** — current 970-line design system. Sections §3
   (Foundation tokens), §4 (Semantic tokens), §5 (Components), §6
   (Liquid Glass guidance). The current values are warm-orange — your
   job is to replace §3 + §4 cleanly while keeping §5 + §6 structure.

2. **`docs/PRD.md`** — sections §0.1 (Identity, 4 axes), §1 (Niche),
   §3 (Persona — early-30s aesthetically-minded professional woman at
   a global company), §10 (Promise §1-5). The persona + promise
   constrain tone; the new palette must serve them.

3. **`docs/Onboarding-3step-Design.md`** — current 3-step spec with
   warm-orange treatment notes. Your §7 deliverable updates these.

4. **`docs/MemoryTimeline-Design.md`** — the brand's visual signature
   view. Sticky year header + 1pt accent rail. Your token choices must
   make this view feel distinctively Still Hours.

5. **`docs/AppIcon-v1-Concept.md`** — the rejected warm direction.
   Read to understand what tone signals NOT to repeat. Your §6 deliverable
   replaces this with v2.

### Should-read (supporting)

6. **`docs/Settings-Surface-Copy.md`** — the "Still Hours is..." copy.
   Your palette must support this copy's tone of voice.

7. **`docs/SFSymbols-Selection.md`** — 12 confirmed SF Symbols + R8
   audit. You don't change the symbols; you decide their tint mapping.

8. **`docs/LiquidGlass-Notes.md`** — WWDC 2025 study notes. Your §8
   decision on Liquid Glass tint builds on this.

9. **`docs/lessons-learned.md`** — 13 axes (A through M). Especially
   Axis B (UIColor + macOS host wrapping) and Axis I (`@MainActor`
   services). Your token implementation must respect these.

### Existing code to harmonize with (Swift)

10. **`Packages/InventoryCore/Sources/InventoryCore/DesignTokens/FoundationTokens.swift`**
    — the file that will receive your §2 values. Read to understand
    the current structure; your output preserves the structure (token
    name conventions), only the hex/RGB values change.

11. **`Packages/InventoryCore/Sources/InventoryCore/DesignTokens/SemanticTokens.swift`**
    — receives your §3 mappings. Same structure-preservation rule.

12. **`Packages/InventoryCore/Sources/InventoryCore/DesignTokens/Color+StillHours.swift`**
    — SwiftUI Color + UIColor extension surfaces. Values flow from
    Foundation + Semantic; you typically don't edit this file directly,
    but read it so your §2 + §3 align with the `Color.shFoo` /
    `UIColor.shFoo` API surface that views already use.

### Visual reference

13. **Things 3 by Cultured Code** — primary benchmark. Specifically:
    - Today view tonal restraint
    - Blue accent (~#007AFF) used sparingly — only for
      interactive/active states
    - Generous whitespace, type-led layout
    - No gradients, no shadows beyond shadow.elevated
    - Liquid-Glass-spirit before iOS 26 existed

14. **Current Still Hours screenshots** (`/tmp/stillhours-R9-light-ko.png`,
    `/tmp/stillhours-R9-dark-en.png`) — the warm-orange version we're
    pivoting away from. Reference for layout / spacing; ignore color.

---

## Constraints (immovable)

1. **WCAG AA on all text/background pairs at MINIMUM.** AA Large for
   accent fills with white text is OK. AAA preferred where reasonable.

2. **Foundation tokens stay at exactly 10 colors.** No expansion —
   discipline is the point. If you need a missing tone, derive it via
   opacity or HSL shift in the semantic layer.

3. **4-medium typed (book/music/movie/object) — icon system already
   chosen** (12 SF Symbols confirmed in `SFSymbols-Selection.md`).
   Your palette changes the TINTS of these symbols, not the symbols.

4. **Liquid Glass usage** — don't make it neon-blue or saturated. The
   cool blue should RECEDE so content is foreground.

5. **No emoji in any UI text** (brand asset rule).

6. **3 locale support (ko/en/ja) maintained** — palette doesn't
   constrain text, but your color names + section headers in the
   Design.MD replacement should be locale-neutral (English).

7. **iOS 26 + iPadOS 26 only.** You can use any iOS 26 / SwiftUI 26
   API in code snippets (e.g. Liquid Glass `.glassEffect(...)`).

8. **No subscription / no ads / no public profile** (Promise §1-4).
   These don't directly constrain palette but inform tone: a "no
   manipulation" tone is part of the brand — your palette should feel
   like a tool, not a product trying to sell itself.

---

## Open questions you can resolve OR ask back

These are questions where the user has not pre-decided. Pick the most
appropriate answer based on your taste + the constraints, OR if the
ambiguity is high, list them in §9.

- **Q-A**: Is "cool blue" cyan-leaning (#5AC8FA, refreshing/cold) or
  violet-leaning (#5856D6, dusk/contemplative) or neutral (#007AFF,
  Things-classic)? Different temperatures evoke different memory
  states — cyan = energetic recall, violet = quiet introspection,
  neutral = utilitarian.

- **Q-B**: Light mode background — pure white (#FFFFFF) like Things 3,
  or a slight cool off-white (#F8FAFC, hint of blue)? Pure white is
  more Things-like; off-white reads "premium minimalism" more.

- **Q-C**: Dark mode background — deep navy (#0F1419, cool/dark sky)
  or near-black with hint of blue (#0A0E14)? Affects mood overnight.

- **Q-D**: Should we have a 11th foundation token for `tint.tertiary`
  / `text.tertiary` to support 3-level type hierarchy (title /
  body / caption)? Currently we have 2 levels. Things 3 effectively
  has 3 (full black / medium gray / light gray).

- **Q-E**: Accent in Liquid Glass capsules — tinted (subtle blue
  cast through frost) or neutral (pure frost, accent only on the
  text/icon inside)? Things 3 doesn't have this question because
  no Liquid Glass; you're inventing the answer.

---

## Out of scope (explicit non-asks)

- **Typography palette pivot** — fonts stay (SF Pro / SF Mono / NY
  Serif). Use new colors only.
- **Spacing / radius / shadow / motion tokens** — unchanged.
- **Icon system** — 12 SF Symbols confirmed; you decide tints, not symbols.
- **Component-level redesign** (ItemCard / MemoryRow / etc.) — keep
  current layout; tokens change, components don't.
- **iPad-specific palette** — iPad uses same palette as iPhone.
- **Animation timing** — Motion presets stay.

---

## Constraints on output

- **Single markdown file**: `docs/Design-R11-ColdBlue.md`
- **Length**: 800-1400 lines is correct
- **Format**: GitHub-flavored markdown, no emoji
- **Tables**: GitHub tables (the `| col | col |` syntax)
- **Hex values**: lowercase 6-digit `#rrggbb` form
- **RGB floats**: 3-decimal precision `0.NNN` form for sRGB
- **WCAG ratios**: 2-decimal `N.NN:1` form

---

## Calibration — voice of the deliverable

Sober. Observer-tone. Decision-oriented. Not marketing copy.

> ✓ "Accent.default at #2563EB resolves to 4.8:1 contrast against
>    background.primary in light mode — AA Large for normal text,
>    AA for large text. Use as the primary CTA fill."
>
> ✗ "Our beautiful new blue makes Still Hours feel fresh and alive!"

---

## What to do when done

Save the deliverable as `docs/Design-R11-ColdBlue.md` in the
master docs directory:

`/Users/sunghun_ahn/Claude Code/_new-collection-product/docs/`

Then ping the human user. They (Claude main session) will:
1. Read your deliverable
2. Generate Swift token files via Edit tool
3. Generate AccentColor.colorset Contents.json via Write
4. Verify build + run sim screenshot
5. Apply Design.MD replacement
6. Commit + push as R11

If your deliverable has open questions (§9), the user resolves those
first, then proceeds.
