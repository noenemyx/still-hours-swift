# App Icon v2 — Glass over a window

R11 2026-05-21 | Cool Blue direction | Supersedes v1 (warm orange Wunderkammer / Light-on-paper)

---

## §1 Concept

**Concept name**

Glass over a window.

**Concept description**

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

---

## §2 Composition (1024×1024)

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

---

## §3 Design elements

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

---

## §4 What it is NOT

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

## §5 Render brief for production

**Tool recommendations**

Figma (vector) — draw the disc, cut out the "S" via boolean subtract,
add the specular arc as a stroked path. Export a 1024px PNG. Download
the Apple Design Resources iOS 26 UI Kit from the Apple Design
Resources page for the correct rounded-rect mask and safe-zone guides.

**Required slots per iOS 26**

A single 1024×1024 source is sufficient. Xcode 14+ collapses all
platform size variants (60pt, 76pt, 83.5pt, 1024pt App Store) from
this one source — no per-size export is needed. Xcode generates each
variant by downscaling. Verify that the disc reads as a disc and the
specular highlight is visible at 60×60 (Spotlight) after Xcode
downscaling; if the specular disappears, widen the arc to ~60°.

**File location once produced**

`App/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon.png`

**Validation**

Drop the PNG into the `.appiconset` catalog in Xcode. Run:

```
xcodegen generate
xcodebuild build -scheme StillHours -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

Boot the simulator and take a screenshot of the home screen to verify
the icon renders correctly at home-screen scale. Check that the disc
reads as a single cool-blue shape at 60pt and that the "S" negative
space is legible at 1024pt.

---

## §6 Status

Concept finalized 2026-05-21. PNG rendered 2026-05-21 R12.2 — programmatic SVG-based approximation. Final polished render via Figma deferred to post-launch v1.1+ icon refinement sprint.
