# Performance Baseline — Still Hours

> R14.4 · Created 2026-05-22

---

## §1 Methodology

### Device / Simulator

| Key | Value |
|-----|-------|
| Simulator | iPhone 17 Pro (iOS 26) |
| Display | ProMotion 120 Hz |
| Configuration | Debug (in-memory SwiftData store) |
| Dataset | 50 synthetic items via `DemoSeederStress` (`--seed-stress-50`) |
| Memories | 1–5 per item, spread across last 5 years (timeline grouping stress) |

### Metrics

| Metric | XCTest class |
|--------|-------------|
| Scroll FPS | `XCTOSSignpostMetric.scrollDecelerationMetric` |
| Sheet presentation | `XCTClockMetric` (wall-clock time) |

### Iteration count

All tests run **5 iterations**. XCTest computes mean ± standard deviation and
flags regressions automatically once a baseline is set. On first run, XCTest
records the measured values as the baseline; subsequent runs compare against it.

---

## §2 Baseline Measurements

> Fill in these values after the first successful `xcodebuild test` run.
> Copy the values from Xcode's Result Bundle → Performance Tests panel.

### 2.1 Library Scroll (`testLibraryScrollPerformance`)

| Metric | Baseline | Std Dev |
|--------|----------|---------|
| Scroll Deceleration FPS | _TBD_ | _TBD_ |

### 2.2 Timeline Scroll (`testTimelineScrollPerformance`)

| Metric | Baseline | Std Dev |
|--------|----------|---------|
| Scroll Deceleration FPS | _TBD_ | _TBD_ |

### 2.3 Capture Sheet Presentation (`testCaptureSheetPresentation`)

| Metric | Baseline | Std Dev |
|--------|----------|---------|
| Wall-clock time (ms) | _TBD_ | _TBD_ |

---

## §3 Tolerance Thresholds

| Test | Metric | Minimum acceptable | Rationale |
|------|--------|-------------------|-----------|
| `testLibraryScrollPerformance` | Scroll Deceleration FPS | **≥ 55 FPS** | 8% headroom below 60 Hz; instrumentation overhead ~5 FPS |
| `testTimelineScrollPerformance` | Scroll Deceleration FPS | **≥ 55 FPS** | Same rationale; sticky header pass adds ~2 FPS draw cost |
| `testCaptureSheetPresentation` | Wall time | **≤ 400 ms** | One animation cycle at 60 Hz; sheet should feel instant |

A result below threshold flags a **regression** — investigate before merging.

XCTest's built-in regression detection (`maxStandardDeviations: 1`) fires
automatically once a baseline exists. The thresholds above are the floor; the
baseline may be tighter after the first real run.

---

## §4 Known Optimization Opportunities

These are _not_ active regressions — they are documented to guide future work
if the baseline degrades.

### 4.1 Image lazy loading

`ItemCardView` renders `coverImageData` inline. For 50 items the JPEG decode
cost is ~2 ms/frame on the main thread. If `coverImageData` is ever populated
with full-resolution images (not thumbnails), add `AsyncImage`-style lazy
decode via `Task.detached`.

### 4.2 `@Query` batching

`LibraryListView` uses `@Query(sort: \Item.createdAt)` with no `fetchLimit`.
At ≤ 500 items this is acceptable. Beyond ~500 items, add:

```swift
@Query(sort: \Item.createdAt, fetchLimit: 200, fetchOffset: page * 200)
```

Pair with `LazyVGrid`'s natural cell recycling — no explicit pagination
needed below 500 items at current `ItemCardView` complexity.

### 4.3 Timeline stagger animation at scale

`MemoryTimelineView.rowWithStagger` applies a `0.04 s × globalIndex` delay.
At 50 memories the last row delays `0.04 × 49 ≈ 2 s`. If memory counts grow
beyond 100, cap the delay:

```swift
.delay(min(Double(globalIndex) * 0.04, 0.8))
```

### 4.4 Sticky header overdraw

The year-header `.background(.ultraThinMaterial)` blurs the content behind
each pinned section. One blur pass per visible header is negligible at 5 years
of data. At 20+ year spans, consider switching to a solid `Color.shBackground`
to eliminate the blur compositor pass.

---

## §5 How to Re-run the Benchmark

```bash
xcodebuild test \
  -scheme StillHours \
  -only-testing:StillHoursUITests/PerformanceUITests \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  | grep -E "(PASS|FAIL|FPS|ms|Measurement)"
```

To run the full test suite (89 existing + 3 new performance tests):

```bash
xcodebuild test \
  -scheme StillHours \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO
```

Results are stored in the default `DerivedData` result bundle. Open in Xcode:
**Product → Open Xcode Result Bundle** → select the latest `.xcresult`.

---

_Last updated: 2026-05-22 · R14.4 · Author: sunghun.ahn_
