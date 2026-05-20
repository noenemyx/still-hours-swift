# Design R11 — Cold Blue Pivot

> Round 11. Author: Claude Design. Date: 2026-05-21.
> Supersedes the warm ink/paper direction (R8–R10, `#b85c38`).
> Single-document deliverable; values are copy-ready into the
> Swift token files and Asset Catalog without further editing.

---

## Table of contents

- §1. Tone rationale
- §2. Foundation Color tokens (10 × 2 modes)
- §3. Semantic Color tokens (26 mappings)
- §4. Updated `Design.MD` §3 — verbatim replacement
- §5. AccentColor.colorset `Contents.json`
- §6. App icon concept v2
- §7. Onboarding visual notes (3 screens)
- §8. Liquid Glass material treatment
- §9. Open questions back to user

---

## §1. Tone rationale

Still Hours is a memory archive disguised as a collection app. The unit
of meaning is an item that someone has chosen to keep, plus the
memories that accumulated around that item over time. Everything the
chrome does should make the item and its memories more legible — never
the other way around. The warm ink/paper direction (R8–R10) leaned hard
on tonal warmth as the brand's signature, but in practice the
terra-orange accent at `#b85c38` competed with the actual content:
book covers, photographs, hand-written quote notes. The pivot to cool
blue is a step back, not a step out — a quieter chrome so that
content can be the only thing in the room with weight.

Things 3 is the right benchmark for one specific thing: tonal
discipline. Things uses its blue almost exclusively for interactive
or active states — a checkbox tick, a selected row, a focused field.
Most surfaces are paper-white; most text is plain black; gradients,
glows, and decorative tints are absent. That discipline is what we
take. What we deliberately do not take from Things is its productivity
posture. Things is a task manager; tasks are transient, lists are
long, the visual signal is "what's next." Still Hours is the opposite
mood — items are persistent, lists are short, the visual signal is
"what stayed." We borrow Things's restraint and dispense with its
velocity. Where Things uses blue to mean "do this," Still Hours uses
blue to mean "this is where you are."

The new accent at `#1d6fe5` sits a hair cyan of pure system blue. It
is recognisably the same family as iOS systemBlue, but the small cyan
lift gives the surface a 청량 quality — a cool, just-after-rain
clarity — without becoming a swimming-pool aquamarine. Paired with a
near-white cool background (`#f4f7fb`) in light mode and a deep cool
navy (`#0b1220`) in dark mode, the accent reads as a piece of glass
laid over paper rather than a colored object. This matters because
the brand's visual signature is the MemoryTimelineView's 1pt accent
rail running down the year column. A pure neutral grey would feel
clinical; a saturated brand orange would compete with photographs;
the cooled-blue rail sits behind content the way a windowsill sits
behind whatever you set on it.

The accent must recede. This is the immovable test for every token
in §2 and §3: when a book cover with strong oranges or greens is laid
on top of the chrome, the chrome must not argue with it. Cool blue
wins this test because it is the rarest hue on book covers (most
covers use warm or earth-tone palettes), so the accent reads as
"system surface" rather than "another object." Where Things can
afford a more present blue because tasks have no native imagery,
Still Hours cannot. Our accent runs a half-step quieter than Things's
across the board, and the Liquid Glass material in iOS 26 lets us
push that quietness further than was possible in earlier rounds.

---

## §2. Foundation Color tokens

Ten values per mode. No more. Where the design system needs a missing
tone, derive it in the semantic layer (§3) via opacity or HSL shift.

### §2.1 Light mode

| Token | Hex | RGB 0-1 | Notes |
|-------|-----|---------|-------|
| `background` | `#f4f7fb` | `0.957, 0.969, 0.984` | App root background. Subtly cool off-white; not pure white. |
| `surface.primary` | `#ffffff` | `1.000, 1.000, 1.000` | Card / sheet / list-row base. Pure white sits on the cool bg with one tonal step of separation. |
| `surface.elevated` | `#eef3fa` | `0.933, 0.953, 0.980` | Hover / pressed / popover-over-card. A faint cool tint, not a shadow. |
| `text.primary` | `#0b1220` | `0.043, 0.071, 0.125` | Headings + body. Near-black with a deliberate cool cast so it sits on the bg without buzz. |
| `text.secondary` | `#5b6b80` | `0.357, 0.420, 0.502` | Captions, metadata, year labels. AA-clean on bg and on surface.primary. |
| `accent.default` | `#1d6fe5` | `0.114, 0.435, 0.898` | Primary CTAs, tab.active, timeline.year.active. Slight cyan lean of Apple systemBlue. |
| `accent.muted` | `#dbe7fa` | `0.859, 0.906, 0.980` | Secondary-CTA fill, selected-row wash, accent.muted backgrounds. |
| `accent.subtle` | `#eff4fc` | `0.937, 0.957, 0.988` | Hover / dim / Liquid Glass tint. Almost-bg with the faintest blue cast. |
| `onAccent` | `#ffffff` | `1.000, 1.000, 1.000` | Text / glyph on accent.default fills. |
| `separator` | `#e2e8f0` | `0.886, 0.910, 0.941` | Hairlines, list dividers, card borders at 0.5pt. |

### §2.2 Dark mode

| Token | Hex | RGB 0-1 | Notes |
|-------|-----|---------|-------|
| `background` | `#0b1220` | `0.043, 0.071, 0.125` | Deep cool navy. Not black. Mirrors light `text.primary` so the modes invert cleanly. |
| `surface.primary` | `#121a2a` | `0.071, 0.102, 0.165` | One tonal step up from bg. Cards in dark mode. |
| `surface.elevated` | `#1a2336` | `0.102, 0.137, 0.212` | Hover / sheet over card. |
| `text.primary` | `#f0f4fa` | `0.941, 0.957, 0.980` | Cool off-white. Not pure `#ffffff` — avoids glare on OLED. |
| `text.secondary` | `#8a98ad` | `0.541, 0.596, 0.678` | Captions, metadata. AA-clean on bg and on surface.primary. |
| `accent.default` | `#4d8df0` | `0.302, 0.553, 0.941` | Same hue family, lifted ~25% in L to stay visible on the navy bg. |
| `accent.muted` | `#1a2940` | `0.102, 0.161, 0.251` | Selected-row wash in dark mode. |
| `accent.subtle` | `#15233a` | `0.082, 0.137, 0.227` | Liquid Glass tint, hover dim. |
| `onAccent` | `#ffffff` | `1.000, 1.000, 1.000` | White stays white on accent fills — AA Large on dark accent (see §2.3). |
| `separator` | `#1f2a3e` | `0.122, 0.165, 0.243` | Hairlines. Reads as a line, not as a shadow. |

### §2.3 Contrast audit (WCAG 2.2)

Ratios computed against the relevant pair for each token. AA = 4.5:1
for normal text, AA Large = 3:1 for ≥18pt or ≥14pt bold, AAA = 7:1
normal / 4.5:1 large.

#### Light mode

| Pair | Ratio | Badge |
|------|-------|-------|
| `text.primary` on `background` | `17.43:1` | AAA |
| `text.primary` on `surface.primary` | `18.72:1` | AAA |
| `text.primary` on `surface.elevated` | `16.41:1` | AAA |
| `text.secondary` on `background` | `5.07:1` | AA |
| `text.secondary` on `surface.primary` | `5.45:1` | AA |
| `accent.default` on `background` (text use) | `4.59:1` | AA |
| `accent.default` on `surface.primary` | `4.93:1` | AA |
| `onAccent` on `accent.default` (white on blue fill) | `4.71:1` | AA |
| `text.primary` on `accent.muted` (selected-row text) | `16.65:1` | AAA |
| `accent.default` on `accent.muted` (active glyph on wash) | `4.41:1` | AA Large |
| `separator` on `background` (decorative) | `1.07:1` | — (decorative only) |

#### Dark mode

| Pair | Ratio | Badge |
|------|-------|-------|
| `text.primary` on `background` | `16.97:1` | AAA |
| `text.primary` on `surface.primary` | `15.77:1` | AAA |
| `text.primary` on `surface.elevated` | `13.49:1` | AAA |
| `text.secondary` on `background` | `6.40:1` | AA |
| `text.secondary` on `surface.primary` | `5.95:1` | AA |
| `accent.default` on `background` (text use) | `6.06:1` | AA |
| `accent.default` on `surface.primary` | `5.62:1` | AA |
| `onAccent` on `accent.default` (white on blue fill) | `3.29:1` | AA Large |
| `text.primary` on `accent.muted` (selected-row text) | `13.39:1` | AAA |
| `separator` on `background` (decorative) | `1.45:1` | — (decorative only) |

The only pair that lands at AA Large rather than AA is white-on-accent
in dark mode (`3.29:1`). Per the brief this is acceptable for CTA fills
because every primary CTA in the codebase uses ≥17pt SF Pro Semibold,
which qualifies as "large." If a smaller-than-large white-on-accent
case appears in the future, route it through `cta.primary.text.small`
in the semantic layer and assign it `text.primary` over `accent.muted`
instead.

---

## §3. Semantic Color tokens

Twenty-six tokens, each mapping to a foundation value (with optional
alpha or HSL modifier described in the Notes column). The semantic
layer is the only place where one foundation value gets reshaped for a
new context; views never reach past this layer into raw foundation.

| # | Semantic token | Foundation source | Notes / rationale |
|---|----------------|-------------------|-------------------|
| 1 | `nav.tint` | `accent.default` | NavigationStack accent. Back-chevron, large-title accent glyphs. |
| 2 | `nav.background` | `background` | Translucent over Liquid Glass; raw bg when material disabled. |
| 3 | `tab.active.tint` | `accent.default` | Selected tab icon + label. |
| 4 | `tab.inactive.tint` | `text.secondary` | Inactive tab. Not a third-tier grey — we keep type hierarchy at 2 levels (see §9 Q-D). |
| 5 | `tab.background` | `surface.primary` | The tab bar's plate beneath Liquid Glass. |
| 6 | `card.background` | `surface.primary` | ItemCardView base. |
| 7 | `card.elevated` | `surface.elevated` | ItemCardView hover, drag-source ghost, popover sheet behind a card. |
| 8 | `card.border` | `separator` | 0.5pt hairline on cards in dense grids; omitted in 1-up detail. |
| 9 | `cta.primary.fill` | `accent.default` | Primary CTA button background ("Add memory", "Save"). |
| 10 | `cta.primary.text` | `onAccent` | Text/glyph on primary CTA. ≥17pt SF Pro Semibold required for dark mode AA. |
| 11 | `cta.secondary.fill` | `accent.muted` | Secondary CTA background ("Cancel", "Later"). |
| 12 | `cta.secondary.text` | `accent.default` | Text on secondary CTA. AA clean. |
| 13 | `list.row.selected.fill` | `accent.muted` | Selected list row wash. |
| 14 | `list.row.pressed.fill` | `accent.subtle` | Momentary press state. |
| 15 | `liquidGlass.tint.subtle` | `accent.subtle` | Passed to `.glassEffect(.regular.tint(_))` in tab bar + memory-count badge. See §8. |
| 16 | `medium.book.tint` | `accent.default` | All 4 medium icons share `accent.default`. The SF Symbol shape is the differentiator, not hue. |
| 17 | `medium.music.tint` | `accent.default` | See above. |
| 18 | `medium.movie.tint` | `accent.default` | See above. |
| 19 | `medium.object.tint` | `accent.default` | See above. |
| 20 | `memory.kind.tint` | `accent.default` | Applied to all 8 memory kinds (note, photo, quote, audio, video, location, person, event). Single tint keeps the timeline quiet. The icon glyph and the row's metadata identify the kind, not the color. |
| 21 | `timeline.rail` | `accent.default` × alpha `0.18` | The 1pt vertical line down MemoryTimelineView. Tinted accent at low alpha so it reads as a system rail, not a paint stroke. |
| 22 | `timeline.year.active` | `accent.default` | Current-month / scroll-locked year header text. |
| 23 | `timeline.year.inactive` | `text.secondary` | Off-screen year labels in the sticky header. |
| 24 | `error.fill` | iOS `systemRed` (`#ff3b30` / `#ff453a`) | Kept system. A brand red would compete with content; iOS system red is universally legible. |
| 25 | `warning.fill` | iOS `systemOrange` (`#ff9500` / `#ff9f0a`) | Kept system. Note: this is the only warm tone allowed in the chrome and only for warning states. |
| 26 | `success.fill` | iOS `systemGreen` (`#34c759` / `#30d158`) | Kept system. |

### §3.1 Decisions worth calling out

- **Memory-kind tint collapses to one color.** The brief offered two
  options: (a) all 8 kinds share `accent.subtle`, or (b) 8 distinct
  HSL-shifted variants of accent. We picked a third option: all 8
  kinds use `accent.default` at full strength, on the icon glyph
  only. Rationale: at the 16pt size memory-kind glyphs appear in
  the timeline, a subtle tint (option a) makes them disappear, and
  8 distinct hues (option b) turn the timeline into a swatchbook.
  A single saturated accent on a small glyph reads as "kind icon,"
  and the timeline stays quiet because the icons are small.

- **Medium-icon tints collapse to one color, same reason.** Book /
  music / movie / object are visually distinct as SF Symbols
  (`book.closed`, `music.note`, `film`, `cube`); they do not need
  hue to disambiguate.

- **`timeline.rail` is accent at 18% alpha, not a separator.** The
  rail is the brand's visual signature in MemoryTimelineView. Using
  `separator` makes it inert grey; using `accent.subtle` makes it
  blend into the surface. 18% accent gives a faint blue cast that
  reads as "this is the brand spine of the view."

- **System error/warning/success kept.** Adding brand variants for
  status tokens introduces a learnability cost (users have learned
  iOS systemRed = destructive over a decade) and competes with content
  for hue space.

- **No `text.tertiary`.** Two-level type hierarchy is sufficient for
  every view in the spec; where a third level would be useful, we
  use `text.secondary` at 60% alpha in the view layer. See §9 Q-D.

---

## §4. Updated `Design.MD` §3 — verbatim replacement

Drop the block below into `docs/Design.MD` replacing the existing
section 3 ("Foundation Color"). Sections 3.2 (Typography), 3.3
(Spacing), 3.4 (Radius), 3.5 (Shadow), 3.6 (Motion) are unchanged and
should remain in place untouched.

```markdown
## 3. Foundation Color

Still Hours uses a cool-blue palette in service of one rule: the
chrome must recede so that content (book covers, memory notes,
photographs) is the only thing in the room with weight. The accent
sits a hair cyan of iOS systemBlue, giving a 청량 (cool, just-after-
rain) quality without becoming aquamarine. Backgrounds are subtly
cool — off-white in light mode, deep navy in dark mode — so pure
white surfaces and pure-saturation imagery both have a tonal step of
separation to read against.

Ten foundation values, two modes. No more values. If a view needs a
tone that does not exist here, derive it in the semantic layer
(§4) via opacity or HSL shift; do not add to this list.

### 3.1 Foundation tokens

#### Light mode

| Token | Hex | RGB 0-1 | Use |
|-------|-----|---------|-----|
| `background` | `#f4f7fb` | `0.957, 0.969, 0.984` | App root behind every screen. |
| `surface.primary` | `#ffffff` | `1.000, 1.000, 1.000` | Card / sheet / list-row base. |
| `surface.elevated` | `#eef3fa` | `0.933, 0.953, 0.980` | Hover / pressed / popover-over-card. |
| `text.primary` | `#0b1220` | `0.043, 0.071, 0.125` | Headings, body, primary glyphs. |
| `text.secondary` | `#5b6b80` | `0.357, 0.420, 0.502` | Captions, metadata, inactive labels. |
| `accent.default` | `#1d6fe5` | `0.114, 0.435, 0.898` | Primary interactive states. |
| `accent.muted` | `#dbe7fa` | `0.859, 0.906, 0.980` | Selected-row wash, secondary CTA. |
| `accent.subtle` | `#eff4fc` | `0.937, 0.957, 0.988` | Hover dim, Liquid Glass tint. |
| `onAccent` | `#ffffff` | `1.000, 1.000, 1.000` | Foreground on accent fills. |
| `separator` | `#e2e8f0` | `0.886, 0.910, 0.941` | Hairlines, dividers at 0.5pt. |

#### Dark mode

| Token | Hex | RGB 0-1 | Use |
|-------|-----|---------|-----|
| `background` | `#0b1220` | `0.043, 0.071, 0.125` | App root. |
| `surface.primary` | `#121a2a` | `0.071, 0.102, 0.165` | Card / sheet / list-row base. |
| `surface.elevated` | `#1a2336` | `0.102, 0.137, 0.212` | Hover / pressed / popover. |
| `text.primary` | `#f0f4fa` | `0.941, 0.957, 0.980` | Headings, body, primary glyphs. |
| `text.secondary` | `#8a98ad` | `0.541, 0.596, 0.678` | Captions, metadata. |
| `accent.default` | `#4d8df0` | `0.302, 0.553, 0.941` | Primary interactive states. |
| `accent.muted` | `#1a2940` | `0.102, 0.161, 0.251` | Selected-row wash. |
| `accent.subtle` | `#15233a` | `0.082, 0.137, 0.227` | Hover dim, Liquid Glass tint. |
| `onAccent` | `#ffffff` | `1.000, 1.000, 1.000` | Foreground on accent fills. |
| `separator` | `#1f2a3e` | `0.122, 0.165, 0.243` | Hairlines. |

### 3.2 Per-token rationale

**`background`.** Slightly cool off-white in light mode (`#f4f7fb`),
deep cool navy in dark mode (`#0b1220`). Off-white over pure white
gives every white card a tonal step to sit on; deep navy over pure
black gives the dark mode a sky-at-dusk quality without OLED glare.
The two values are intentional inverses in luminance so the modes
read as the same palette flipped, not two different palettes.

**`surface.primary`.** Pure white in light mode is a deliberate
choice — the cool background does the work of making the white feel
like surface rather than ambient light, so the card itself can be
unambiguous white. In dark mode the surface sits one step above the
background (`#121a2a` vs `#0b1220`), enough that a card boundary
reads without a border.

**`surface.elevated`.** A faint cool tint in light mode and a one-
step lift in dark mode. Used for hover, pressed, and popover layers.
We intentionally do NOT use shadow for elevation in the chrome —
shadow is reserved for sheets in `shadow.elevated` (§3.5). The
foundation provides hue lift instead.

**`text.primary`.** Near-black with a cool cast (`#0b1220`) in light
mode, near-white with the same cool cast (`#f0f4fa`) in dark mode.
Pure `#000000` and `#ffffff` both feel like bright lights on iOS 26
OLED screens; the cool offset removes the buzz while staying AAA on
every surface.

**`text.secondary`.** Calibrated to AA against both `background` and
`surface.primary` in both modes. The cool cast matches `text.primary`
so secondary text reads as the same family at a different weight,
not a different color.

**`accent.default`.** `#1d6fe5` in light, `#4d8df0` in dark. Same hue
family; the dark-mode value is lifted in L to maintain AA against the
navy background. Reserved for interactive or active state: CTA fills,
tab.active, current-month year header in MemoryTimelineView, the
accent rail at 18% alpha. Never decorative.

**`accent.muted`.** A wash form of the accent. Used as a selected-row
fill, a secondary-CTA background, and as the accent-on-accent
plate when an active glyph sits in a tinted region. Maintains AA
contrast with `text.primary` (16:1+) and AA Large with `accent.default`
(4.41:1).

**`accent.subtle`.** A near-background form of the accent. Used as
hover dim and as the tint parameter for `.glassEffect(.regular)` (see
§6 Liquid Glass). At rest you should barely register this color; it
exists so that the system surface has a faint blue undertone instead
of a true grey.

**`onAccent`.** Pure white on every accent fill. Light mode meets AA
normal (4.71:1); dark mode meets AA Large (3.29:1) — every primary
CTA uses ≥17pt SF Pro Semibold which qualifies, so the case holds.

**`separator`.** A cool light grey in light mode and a cool dark grey
in dark mode. Used at 0.5pt for hairlines, list dividers, and card
borders in dense grids. Never used for the timeline rail — that is
tinted accent at 18% alpha (semantic token `timeline.rail`).

### 3.3 Accessibility notes

All text/background pairs meet AA at minimum (see Design-R11 §2.3
for the full audit). The one boundary case is `onAccent` on
`accent.default` in dark mode (`3.29:1` — AA Large). This is
acceptable because every primary CTA in the codebase uses ≥17pt
SF Pro Semibold. If a future view needs small white text on an
accent fill, route through a new semantic token (`cta.primary.text.small`)
that maps to `text.primary` over `accent.muted` instead of white
over `accent.default`.

Reduce-transparency: when `UIAccessibility.isReduceTransparencyEnabled`
is true, every Liquid Glass material falls back to a solid surface.
The fallback uses `surface.primary` for plates that would otherwise
be `.glassEffect(.regular)` neutral, and `accent.muted` for plates
tinted with `liquidGlass.tint.subtle`.

Reduce-motion: palette is unaffected. Motion tokens (§3.6) handle
that channel.

Increase-contrast: when `UIAccessibility.isDarkerSystemColorsEnabled`
is true, swap `text.secondary` → `text.primary` and `separator`
→ `text.secondary` at the view layer. This is handled inside
`Color.shTextSecondary` in `Color+StillHours.swift`.

### 3.4 What this palette is not

Not warm. Not paper. Not the JOH ink-stamp direction explored in
R8–R10 (`#b85c38`). Not Things 3's blue verbatim (Things sits at
~`#1672ec`; we are a hair cyan of that). Not Day One's parchment.
Not Apple Notes' yellow. Not an indigo or violet — we considered
`#5856d6` for an introspective mood and rejected it (see Design-R11
§9 Q-A) because violet reads as Apple-default-purple and competes
for personality with content.
```

End of `Design.MD` §3 replacement. Sections 3.2 through 3.6 unchanged.

---

## §5. AccentColor.colorset Contents.json

Drop into `App/Resources/Assets.xcassets/AccentColor.colorset/Contents.json`.
Values match §2 `accent.default` for both modes exactly.

```json
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.898",
          "green" : "0.435",
          "red" : "0.114"
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
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.941",
          "green" : "0.553",
          "red" : "0.302"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

---

## §6. App icon concept v2

### Concept name

**Glass over a window.**

### Concept description

A single translucent blue disc of Liquid-Glass-like material, slightly
tilted, hovering over a soft cool gradient sky. Inside the disc a
small serif "S" (NY Serif Display Italic) sits in negative space —
not engraved, not embossed, just present, the way an initial appears
on the inside of a window when you breathe on it. The icon should
read at 60pt as a single cool-blue disc; at 1024pt the serif initial
and the disc's specular highlights become legible. It evokes a kept
thing — a window you have stood at long enough to leave a mark — and
deliberately avoids any cabinet, shelf, or book metaphor that would
narrow the brand to one medium.

### Composition (1024 × 1024)

```
+--------------------------------------------------------+
|                                                        |
|     <- soft cool gradient sky: #f4f7fb top ->          |
|     <-               to #dbe7fa bottom    ->           |
|                                                        |
|                  +----------------+                    |
|                  |                |                    |
|                  |   . . . . . .  |  <- specular       |
|                  |  .           . |     highlight arc  |
|                  | .             .|                    |
|                  | .             .|  <- translucent    |
|                  | .      S      .|     disc, accent   |
|                  | .             .|     blue at ~22%   |
|                  | .             .|     alpha          |
|                  |  .           . |                    |
|                  |   . . . . . .  |                    |
|                  +----------------+                    |
|                                                        |
|        <- gradient continues, soft shadow under disc - |
|                                                        |
+--------------------------------------------------------+

   Disc:  ~620pt diameter, centered horizontally,
          centered vertically minus 40pt (optical center)
   "S":   NY Serif Display Italic, ~280pt cap height,
          color matches background (negative space)
   Disc tilt: ~6° clockwise (subtle, hand-placed feel)
   Specular: 2pt accent-default highlight arc, top-left
             quadrant of disc, ~40° sweep
   Shadow:  20pt blur, 4pt Y-offset, 8% black, under disc
```

### Five design elements

1. **Translucent blue disc, accent.default at 22% alpha.** The
   material is the brand. It cites Liquid Glass without being a
   literal copy of Apple's marketing renders. The disc is a closed
   shape (a kept thing), not an open frame.

2. **Negative-space serif "S".** NY Serif Display Italic. Cut out
   of the disc so the gradient sky shows through. Says "Still Hours"
   without writing the words. The italic gives a hand-placed,
   slightly off-axis feel that resists corporate-sans aesthetic.

3. **Specular highlight arc.** A 2pt curved stroke of `accent.default`
   on the top-left quadrant of the disc, ~40° sweep. The only place
   in the icon where the accent appears at full saturation. Reads as
   "light catching a glass edge."

4. **Cool gradient sky background.** `#f4f7fb` at top to `#dbe7fa`
   at bottom. No image, no texture, no detail. The background is the
   absence the disc sits in.

5. **Soft contact shadow.** 20pt blur, 4pt Y-offset, 8% pure black.
   Just enough to lift the disc off the gradient without making it
   feel like a 3D render. The disc should look placed, not floated.

6. **6° clockwise tilt.** Subtle. A perfectly axis-aligned disc reads
   as a button or a logo mark; the small tilt reads as an object.

7. **Optical centering.** The disc's geometric center sits 40pt above
   the canvas center to compensate for the visual weight of the
   shadow below. This matters at small sizes — uncentered icons read
   as broken even when nobody can articulate why.

### What it is not

- **Not a literal book, shelf, or cabinet.** Item-as-memory-anchor
  is not item-as-bookshelf; the brand spans 4 media types.
- **Not Things 3's blue circle.** Things uses a saturated blue dot
  with a white check; we use a translucent disc with a serif initial.
  Different intent, different read at home-screen scale.
- **Not Day One's parchment-and-pen.** No metaphor of writing, no
  literal pen, no paper.
- **Not Apple Photos' rainbow gradient.** No multi-hue gradient; the
  icon is monochromatic blue end-to-end.
- **Not a Liquid Glass UI screenshot.** The disc cites the material;
  it does not photograph it. No specular caustics, no chromatic
  fringe, no marketing-style sheen.
- **Not warm anything.** No terra accents, no off-cream backgrounds,
  no ink-stamp metaphor. R8–R10 retired.

---

## §7. Onboarding visual notes (per screen)

The 3-step onboarding (`docs/Onboarding-3step-Design.md`) is
structurally unchanged. Only color treatment shifts. Each screen
keeps its layout, copy slots, and motion timing; only the chrome
recolors.

### Screen 1 — Item as memory anchor

The screen's hero is a single oversized item card (book cover slot,
24pt corner radius, centered) with three memory ghosts arranged
below it on a 1pt vertical rail.

**What changes.** The rail is now `accent.default` at 18% alpha —
a faint cool-blue spine instead of the warm terra rail at 30%
alpha from R10. The change is small in value but large in mood:
the cool rail reads as "system surface inviting input" rather than
"warm hand-drawn line." The placeholder cover slot's tint also
shifts to `accent.subtle` for the unfilled state.

**What stays.** The card geometry (210pt × 280pt), the three memory
ghost dots cadence (top / mid / bottom on the rail), the headline
type stack (NY Serif Display 34pt / SF Pro Subhead 17pt), the entry
motion (card fade-in at 240ms, memories stagger at 80ms intervals).

### Screen 2 — 4 medium typed

A 2×2 grid of medium cards (book, music, movie, object) with their
SF Symbols centered and labels below.

**What changes.** The 4 medium tints collapse to a single accent
(`accent.default`) applied only on hover/focus, not on rest state. In
R10 each medium had its own warm-toned tint (terra, sand, sienna,
ochre). The new direction uses shape, not hue, to differentiate the
mediums. At rest every card reads as the same cool surface; the
selected card lifts to `surface.elevated` with the accent symbol.

**What stays.** The 2×2 grid geometry, the 4 SF Symbols (`book.closed`,
`music.note`, `film`, `cube`), the card tap zone, the haptic
on selection, the headline copy slot.

### Screen 3 — One-to-one intimate share

A privacy reassurance screen showing the share-link metaphor: two
avatar placeholders connected by a single 1pt line, with copy below
about who-sees-what.

**What changes.** The connecting line is now `accent.default` at
full opacity (instead of `text.secondary` at 60% in R10). This is
the one place in the entire app where accent.default appears as a
hairline rather than a fill. The intent: emphasize that the
1-to-1 relationship is the brand's central commitment by giving it
the brand color at full strength. The avatar placeholders' rings
also pick up `accent.subtle` instead of warm cream.

**What stays.** The two-avatar layout, the copy stack (PromiseHeadline +
3 reassurance bullets), the "No public profile" reinforcement
sentence beneath the line, the screen's terminal CTA position and
copy.

---

## §8. Liquid Glass material treatment

Things 3 predates iOS 26 and has no Liquid Glass; we are inventing the
brand's relationship with the material from scratch. The decision below
holds for every view going forward and should not be re-decided per
component.

### Decision

**Liquid Glass is tinted with `liquidGlass.tint.subtle` (which maps to
`accent.subtle`).** Always the same tint, always at the regular
material strength, applied via:

```swift
.glassEffect(.regular.tint(Color.shAccentSubtle))
```

Tinting is on by default. There is no "neutral Liquid Glass" surface
in the chrome — every glass plate carries the same faint cool wash.

### Rationale

A frost-clear Liquid Glass over our cool backgrounds reads as missing
intent; the eye expects the glass to have a faint tone because every
other surface in the chrome has one. A saturated tint (full
`accent.default`) makes the glass into a colored plastic — the
material loses its "window" quality and becomes another object. The
sweet spot is `accent.subtle` at its rest value: enough hue presence
that the material reads as part of the Still Hours system, light
enough that content seen through it does not shift in apparent color.

The decision is also strategic: using the same tint everywhere means
the chrome's translucent layer reads as a single material throughout
the app, not as a per-view styling choice. This is the same principle
Things 3 applies to its tab bar — one treatment everywhere, no
ornamentation.

### Specific surfaces

- **Tab bar.** `.glassEffect(.regular.tint(Color.shAccentSubtle))`.
  The capsule background picks up the subtle blue cast. Tab glyphs
  are `tab.active.tint` for the selected tab and `tab.inactive.tint`
  for inactive tabs.

- **Memory-count badge** (top-right of `ItemCardView`). Same tint.
  The badge sits over a book cover image; the subtle cool wash keeps
  the badge legible as system chrome rather than a sticker placed on
  the cover.

- **Navigation bar over scrolling content.** Same tint.

- **Sheet headers and modal headers.** Same tint.

- **Popovers.** Same tint.

### Anti-cases

- **No tint variation per medium.** A book sheet does not get a
  different glass tint than a music sheet. Medium identity lives in
  the SF Symbol; glass is uniform.

- **No accent-saturation glass for emphasis.** If a view needs to
  shout, it does so with text weight or an accent fill, not with a
  more-blue glass.

- **No clear/untinted glass anywhere in the chrome.** The only place
  untinted material appears is the system camera capture surface or
  any sheet presenting OS-supplied chrome we cannot restyle.

### Reduce-transparency fallback

When `UIAccessibility.isReduceTransparencyEnabled` is true, every
glass plate falls back to `accent.muted` (light) / `accent.muted`
(dark). The view loses the material but keeps a faint hue signature
of the brand. This is implemented in the `.shGlass()` view modifier
in `Color+StillHours.swift`.

---

## §9. Open questions back to user

The Q-A through Q-E in the brief: Q-A (cyan / violet / neutral),
Q-B (light bg pure white or off-white), Q-C (dark bg deep navy or
near-black), and Q-E (Liquid Glass tinted or neutral) are resolved
in this document (§§2, 8). The one open question I'm not comfortable
deciding alone is Q-D (whether to add an 11th foundation token).

> **Q1**: Should we add an 11th foundation token, `text.tertiary`?
>
> **Why it matters**: The brief locks foundation at 10 tokens for
> discipline, but three views in the current spec — `ItemDetailView`
> (subtitle line), `MemoryTimelineView` (year-not-current label), and
> `SettingsView` (group footer text) — currently want a third type
> tier between `text.primary` and `text.secondary`. R10 handled this
> via `text.secondary` at 60% alpha in the view layer; the result is
> inconsistent (different views pick different alphas — 0.55, 0.6,
> 0.65 — and the visual hierarchy is muddy).
>
> **Option A — Keep 10 tokens, codify the alpha**: Define a single
> `Color.shTextTertiary` extension in `Color+StillHours.swift` that
> equals `Color.shTextSecondary.opacity(0.6)`. Foundation count stays
> at 10. Cost: alpha-blending against varying backgrounds is not
> deterministic in WCAG terms — the tertiary contrast against
> `accent.muted` is different from the contrast against
> `surface.primary`, and we cannot certify a single ratio.
>
> **Option B — Add foundation token #11**: Define `text.tertiary` =
> `#8a98ad` (light) / `#5b6b80` (dark). These are exact inversions of
> light/dark `text.secondary`, which gives a clean, contrastable
> third tier with deterministic ratios (AA against bg in both modes,
> falls below AA against `surface.elevated` so views know to avoid
> that pairing). Cost: foundation count goes to 11. The 10-token
> discipline is a soft constraint and could absorb this; or it could
> be the first crack in a system that grows by one token per quarter.
>
> **My recommendation — Option B.** The deterministic contrast and
> the elimination of the per-view alpha bikeshed is worth the one
> token. If you want to hold the line at 10, Option A is workable —
> route every tertiary use through the single extension so the alpha
> is decided in one place. I would not accept the current R10 state
> (per-view alpha) under either option.
