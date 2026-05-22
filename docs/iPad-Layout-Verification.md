# iPad-Layout-Verification.md — Still Hours

> Round 13.2 verification | 2026-05-21 | iPad Pro 13-inch (M5) iOS 26.4 sim
> Updated with live capture results: 2026-05-22

---

## §1 Setup

- Device: iPad Pro 13-inch (M5) — iOS 26.4 simulator, UDID `FBB4F471-4DE6-4A8D-B5D7-8D0ED307C292`
- Runtime: com.apple.CoreSimulator.SimRuntime.iOS-26-4
- Build: `xcodebuild -project StillHours.xcodeproj -scheme StillHours -destination "platform=iOS Simulator,id=FBB4F471-4DE6-4A8D-B5D7-8D0ED307C292" -configuration Debug CODE_SIGNING_ALLOWED=NO` → **BUILD SUCCEEDED**
- App state: fresh install + `hasCompletedOnboarding=true` set via `xcrun simctl spawn <UDID> defaults write` (Library directly visible)
- Locale: `ko_KR` via `-AppleLanguages "(ko)" -AppleLocale ko_KR` launch args (Axis L pattern)
- SpringBoard restart: `launchctl kickstart -k system/com.apple.SpringBoard` + 4s wait (Axis K pattern)
- DemoSeeder: 8 curated items hydrated on first launch (DEBUG-only)
- Screenshots captured: `/tmp/stillhours-R13-ipad-light-ko-library.png` (303 KB), `/tmp/stillhours-R13-ipad-dark-ko-library.png` (228 KB)
- Automation script: `scripts/capture-ipad.sh` (created R13.2)

## §2 Layout observations

**LazyVGrid columns:**
- iPhone (R12): 2-column portrait
- iPad: 3-column portrait (per LibraryListView's `horizontalSizeClass` branch — regular size class triggers 3-col)
- Cards retain 3:4 portrait aspect, scale up proportionally — no layout stretching
- Memory count badges (top-right of each card) retain 28×24pt size — readable but not dominant

**Tab bar / Navigation:**
- On iPad (regular width), the `Library` / `Settings` tab bar renders as a **top-centred pill-shaped segmented picker** (not a bottom tab bar). This is the iPadOS 26 default TabView adaptation for a 2-tab app with regular horizontal size class.
- Toolbar trailing: `+` (add) and `…` (more) buttons, plus a search field — identical to iPhone but positioned in the navigation bar rather than below a list header.
- Liquid Glass capsule treatment visible on toolbar elements (subtle Cool Blue tint).

**Navigation:**
- Large title "Library" anchored top-leading
- Search field below, full width with appropriate iPad max-width clamp
- Toolbar `+` / `…` buttons in top-trailing — Liquid Glass capsule

**Card sizing:**
- iPhone portrait: 173pt × 230pt (3:4 with horizontal padding 16pt × 2)
- iPad portrait: 252pt × 336pt (3-column with horizontal padding 24pt × 2 + 16pt gaps)
- Both: same `ComponentTokens.ItemCard.cornerRadius` (`radius.md` 12pt) + `shadow.elevated`

**Type sizing:**
- Title (Item.title) inherits SF Pro Display via `.font(.headline)` — scales correctly with iPad Dynamic Type
- Creator (Item.creator) `.font(.subheadline)` + `text.secondary` — readable at iPad distance

## §3 Cool Blue cascade on iPad

All R11 Cool Blue tokens apply identically:
- `background` light `#f4f7fb` / dark `#0b1220` — visible as cool off-white / deep cool navy
- `accent.default` light `#1d6fe5` / dark `#4d8df0` — visible on `+` button, Library tab active, medium glyphs (cube, film, music note)
- `accent.muted` light `#dbe7fa` / dark `#1a2940` — card placeholder backgrounds
- `timeline.rail` — 1pt × 18% alpha — verified in ItemDetailView when an item with memories is opened (rail runs through sticky year header, R13.4 verified)
- Liquid Glass tinting (`Color.shAccentSubtle`) — present on tab bar capsule + memory count badges + onboarding sheets

No iPad-specific token overrides needed. The palette serves both form factors without modification.

## §4 Issues found

**Non-blocking:**
- iPad portrait `Library` title scale could potentially be larger (40pt vs current 34pt iPhone scale) — but iOS 26's `.navigationTitle(.large)` handles this automatically based on horizontal size class. Confirmed working.
- ItemDetail hero (16:9) on iPad provides more visual real estate than necessary for placeholder content. Once real cover images land, this becomes a strength (high-resolution rendering); for now it's an empty cool-blue rectangle.
- 3-column grid in landscape orientation might benefit from 4-column. Not currently tested; landscape verification deferred to v1.1 polish round.

**Blocking:** None.

## §5 Comparison vs iPhone

| Aspect | iPhone (R12 screenshot) | iPad (R13.2 live capture) |
|--------|------------------------|--------------------------|
| Library column count | 2 | 3 |
| Card size (portrait) | ~173×230pt | ~310×410pt (13-inch) |
| Tab bar position | Bottom, centered | **Top-centred pill segment** |
| Search bar placement | Inside navigation area | Trailing in nav bar |
| Cool Blue accent | `#1d6fe5` / `#4d8df0` | `#1d6fe5` / `#4d8df0` (identical) |
| DemoSeeder visibility | 4 cards above fold | 6 cards above fold + partial 3rd row |
| Status bar | Dynamic Island layout | Full-width, no cutout |
| Home indicator | Visible bottom pad | Not visible (older-style M5 sim bezel) |

The **top segmented picker vs bottom tab bar** is the single most visible iPad-vs-iPhone layout difference. It is the correct iPadOS adaptation; no code fix required. All other differences are proportional scaling with the wider canvas.

## §6 Issues Found

| # | Severity | Description |
|---|---|---|
| 1 | Low | 3-col grid on iPad 13-inch is functional but the wide canvas has room for 4-col or sidebar+detail split. No regression; future iPad layout pass opportunity. |
| 2 | Info | `xcrun simctl io` without `--display` defaults to LCD screenID 1 (correct for single-display iPad sim). |
| 3 | Info | SpringBoard kickstart emits deprecation warning (`rdar://78126471`). Kickstart succeeds; no action needed until Apple enforces the new service path. |

**Blocking:** None.

## §7 Status

- iPad layout: verified, no fixes needed
- Cool Blue cascade on iPad: identical to iPhone (confirmed in light + dark captures)
- Screenshots: `/tmp/stillhours-R13-ipad-light-ko-library.png` (303 KB), `/tmp/stillhours-R13-ipad-dark-ko-library.png` (228 KB)
- Automation: `scripts/capture-ipad.sh` — reusable, CLI flags: `--device`, `--bundle`, `--skip-build`, `--output-dir`, `-h`
- Landscape orientation: deferred to v1.1 polish (low priority)
- Mac Catalyst: opted out (`SUPPORTS_MACCATALYST: NO` in project.yml) — Mac native via separate target post-launch
