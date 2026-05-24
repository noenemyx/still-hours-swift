# Still Hours App Icon — Claude Design Brief

> Use this brief in **Claude Design** (claude.ai or Claude Code with image-generation MCP).
> Goal: produce a 1024×1024 PNG that supersedes the current programmatic v4 SVG render.
> Brand reference: see [Design.MD](./Design.MD) and [AppIcon-v2-Concept.md](./AppIcon-v2-Concept.md).

---

## Brief

App name: **Still Hours**
Tagline (en): *A slow archive for your things*
Domain: personal collection app for books · music · films · physical objects
Brand pillars: JOH 조수용 minimalism + 김호 "direction over completion"

### Visual concept: **Glass over a window**

A single translucent cool-blue disc — glass-like, slightly tilted, hovering
over a pale cool gradient sky. Inside the disc, a serif italic "S" sits in
**negative space** (cut out, sky showing through), the way an initial appears
on the inside of a window when you breathe on it.

The icon must read as a single cool-blue disc at 60pt (Spotlight), and reveal
its serif initial + glass specular at 1024pt (App Store).

It evokes *a kept thing* — a window stood-at long enough to leave a mark — and
deliberately avoids any cabinet, shelf, book, or pen metaphor that would
narrow the brand to one medium.

---

## Composition (1024×1024 canvas)

- **Background**: cool gradient sky, `#EAF1FA` → `#C8DBF2` (top-to-bottom)
- **Disc**: ~640pt diameter, centered horizontally, **optical center** sits ~40pt above geometric center (shadow weight compensation)
- **Disc fill**: translucent cool-blue with radial gradient (highlight from upper-left), ~70% opacity, color family `#3F68A9`–`#7AA0D4`
- **Disc tilt**: ~6° clockwise (subtle hand-placed feel, NOT axis-aligned)
- **"S"**: NY Serif Display Italic (or Times New Roman Italic), ~420pt cap height, centered in disc, color = background gradient (cut-out / negative space)
- **Specular highlight**: ~55° arc on top-left disc edge, white-to-transparent gradient, 8–10pt stroke
- **Inner glow**: soft white highlight upper-left interior (~30%/25% from edge), radial fade
- **Contact shadow**: 20pt blur, 10pt Y-offset, 32% black
- **Glass edge**: thin (~2pt) `#3F68A9` stroke at 32% opacity around full disc

---

## What it must NOT be

- ❌ A literal book, shelf, cabinet, pen, paper, or any single-medium metaphor
- ❌ Things 3's saturated blue dot with white check
- ❌ Day One's parchment-and-pen
- ❌ Apple Photos' rainbow gradient (must be monochromatic blue end-to-end)
- ❌ A Liquid Glass UI screenshot (cites the material, doesn't photograph it; no chromatic fringe, no marketing-style sheen)
- ❌ Any warm tones (no terra, no off-cream, no ink-stamp metaphor)
- ❌ A circular sticker, button, or logo mark (the tilt and shadow make it an *object*, not UI chrome)

---

## Render brief

**Recommended tool**: Figma (vector) — draw the disc, cut out the "S" via boolean subtract, add the specular arc as a stroked path. Export as 1024×1024 PNG @1x.

**Source image specs**:
- 1024 × 1024 pixels exactly
- RGB color (no alpha needed; Xcode adds rounded-rect mask)
- PNG, no compression artifacts
- Drop into `App/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png` (overwrites current v4)

**Validation**:
- Run `xcodegen generate` + `xcodebuild build` for iOS Simulator
- Verify on iPhone 17 Pro Max simulator at 60pt (Spotlight) — disc must read as a single cool-blue shape
- Verify at 1024pt (App Store) — serif "S" + specular highlight must be legible

---

## Reference files

- Current programmatic v4 render: `/tmp/stillhours-icon-v4.png` (acceptable baseline; this prompt aims to supersede with higher fidelity)
- Detailed composition spec: [AppIcon-v2-Concept.md](./AppIcon-v2-Concept.md)
- Brand colors and tokens: [Design.MD](./Design.MD) §3

---

## Prompt for Claude Design (copy-paste)

> Design a 1024×1024 iOS app icon for "Still Hours", a personal memory archive
> for books, music, films, and objects. Aesthetic: JOH-minimalism, cool-blue
> monochrome, glass-like material. Composition: a single translucent cool-blue
> disc (~640pt diameter, ~70% opacity, radial fill #3F68A9 to #7AA0D4),
> tilted 6° clockwise, hovering over a pale cool gradient sky (#EAF1FA top to
> #C8DBF2 bottom). Inside the disc, cut out a serif italic capital "S" in
> negative space showing the sky gradient through. Add a 55°-sweep white
> specular highlight arc on the top-left disc edge. Soft inner glow upper-left
> interior. Subtle drop shadow under the disc (20pt blur, 10pt Y, 32% black).
> Thin 2pt glass edge at 32% opacity. Optical center: disc geometric center
> sits 40pt above canvas center. No texture, no photographic detail, no
> rainbow, no book/pen/shelf metaphor. The icon must read as a single cool-blue
> object at 60pt and reveal the serif S + glass specular at 1024pt. Aspiration:
> Things 3-quality icon craft, but cooler, slower, more contemplative.
