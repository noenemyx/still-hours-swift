# Lessons Learned — Still Hours

> Cross-session institutional memory. Hard bugs (≥1 commit to root-cause,
> rollbacks needed, or recurring pattern) get entries here. _Trivial
> fixes_ stay out. Consult this before designing similar code in future
> sessions.

---

## Process rule

For each entry: **(1) symptom** the developer observes, **(2) root cause**
explained, **(3) prevention** as concrete code/test/lint pattern to apply
in future similar situations. Where automatable, add a lint check to
`scripts/check-*.sh` and wire it into `scripts/test.sh`.

When designing code that pattern-matches an entry below, follow the
prevention rule. If you're about to write a pattern this doc explicitly
warns against, STOP and reconsider.

---

## Axis A — Module name must not be shadowed by a same-named type

**Pre-flight Round 4 (2026-05-20, commit `f15da22`)**

### Symptom

Swift compiler reports `error: generic parameter 'T' could not be
inferred` on `context.fetch(descriptor)` calls even when `descriptor`
is declared `FetchDescriptor<InventoryCore.Collection>()`. Cleaning the
build directory and rebuilding does NOT help. Only one specific test
case in `CollectionModelTests.swift` triggers the error — other tests
in the same file using the same pattern compile fine.

### Root cause

`Packages/InventoryCore/Sources/InventoryCore/InventoryCore.swift`
contained `public enum InventoryCore {}`. The empty enum shadows the
SPM module name `InventoryCore`. When tests wrote
`InventoryCore.Collection`, Swift's name lookup found the enum first
(member access on a type) instead of the module namespace (qualified
name resolution), so the lookup failed silently — the compiler couldn't
find a `Collection` _nested_ in the enum, so type inference broke
downstream in `context.fetch(...)`.

### Prevention

1. **The module-name file (e.g. `InventoryCore.swift`) must NOT declare
   any top-level type with the module's name.** It is a header-only file
   for documentation comments and module-level imports.

2. If you need a "namespace" for related utilities, give it a
   _different_ name (e.g. `InventoryCoreUtilities`, `InventoryNS`,
   `IC`). Never reuse the module name.

3. Lint check (add to `scripts/check-data-sovereignty.sh` Step 6 or
   create `scripts/check-module-shadow.sh`):

   ```bash
   # Module-name shadowing check
   module_name="InventoryCore"
   shadow=$(grep -rn "^\s*public\s\+\(enum\|struct\|class\|actor\|protocol\)\s\+${module_name}\b" \
            Packages/InventoryCore/Sources --include="*.swift" || true)
   if [[ -n "$shadow" ]]; then
     fail "Module name '${module_name}' is shadowed by a same-named type:"
     echo "$shadow"
     echo "Rename the type to avoid breaking 'InventoryCore.<TypeName>' resolution."
     exit 1
   fi
   ```

---

## Axis B — UIColor is unavailable on macOS host SPM builds

**Pre-flight Round 4 (2026-05-20, commit `f15da22`)**

### Symptom

`swift build --package-path Packages/InventoryCore` reports
`error: cannot find type 'UIColor' in scope` even though
`Package.swift` declares `.iOS("26.0")` as the only platform. The
errors point to a Color extension that uses `UIColor` for adaptive
light/dark color resolution.

### Root cause

SPM compiles the package against the developer's host platform first
(macOS) before cross-compiling to iOS. `UIColor` is part of UIKit,
which is **iOS-only**. macOS has `NSColor`. Declaring `.iOS("26.0")`
in `Package.swift` does not exclude macOS from the host compile
check — it only excludes packages that depend on this one from being
imported on macOS.

### Prevention

1. **Wrap UIKit-only code in `#if canImport(UIKit)`** at the file or
   extension level. The `else` branch can either omit the API entirely
   or provide a macOS-shaped fallback.

   ```swift
   #if canImport(UIKit)
   import UIKit

   public extension UIColor {
       static var shAccent: UIColor { ... }
   }
   #endif
   ```

2. For SwiftUI `Color(light:dark:)` adaptive helpers, use the platform
   conditional **inside** the initializer rather than gating the
   entire init out:

   ```swift
   init(light: Color, dark: Color) {
       #if canImport(UIKit)
       self.init(UIColor { traits in
           traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
       })
       #else
       self = light  // macOS host fallback — never shipped
       #endif
   }
   ```

3. In `Package.swift`, also declare `.macOS(...)` so the host compile
   actually has a known floor:

   ```swift
   platforms: [
       .iOS("26.0"),
       .macOS("26.0"),
   ],
   ```

   This is _SPM compile-check support only_ — the shipped app is
   iOS-only (see `project.yml`).

---

## Axis C — Swift Testing `@Test` macro is incompatible with `@available`

**Pre-flight Round 4 (2026-05-20, commit `f15da22`)**

### Symptom

Adding `@available(iOS 26, *)` to a `@Test`-decorated function (or its
enclosing struct) produces:

> error: Attribute 'Test' cannot be applied to this function because
> it has been marked '@available(iOS 26, *)' (from macro 'Test ')

Even when the availability matches the package's declared platforms.

### Root cause

The `@Test` macro generates its own wrapping availability metadata
based on the surrounding context. When the user-supplied `@available`
disagrees with what the macro would generate, the macro expansion
fails. There's no escape hatch via `@_silgen_name` or `@_alwaysEmit`.

### Prevention

1. **Do NOT put `@available` on test structs or `@Test` functions.**
2. Let `Package.swift` declare the platform floor — Swift Testing
   inherits from the target's deployment target automatically.
3. If you need a test to run on a specific platform version newer than
   the package floor, gate it with `#if available(...)` _inside_ the
   function body, not via `@available` on the function signature.

---

## Axis D — Two types named `Attachment` (or `Collection`) need explicit qualification

**Pre-flight Round 4 (2026-05-20, commit `f15da22`)**

### Symptom

`FetchDescriptor<Attachment>()` fails with `generic parameter 'T'
could not be inferred` _only inside tests_. The same pattern compiles
fine in `Sources/` files.

### Root cause

- Tests import `Testing` (Swift Testing framework).
- Swift Testing exports `Testing.Attachment` — its type for attaching
  artifacts to test results.
- Our domain model exports `InventoryCore.Attachment` — the @Model
  type for photos/voice/receipts/documents.
- Swift's name resolution doesn't know which `Attachment` the developer
  meant. It picks one (the test framework's), gets a non-PersistentModel
  type, and `FetchDescriptor<T : PersistentModel>` constraint fails.
- Similar pattern with `Collection` (Swift stdlib protocol vs our
  @Model class).

### Prevention

1. **In test files, always qualify domain types with the module name**
   when they could collide with framework types:
   ```swift
   let descriptor = FetchDescriptor<InventoryCore.Attachment>()
   let descriptor = FetchDescriptor<InventoryCore.Collection>()
   ```

2. **Beware: this only works if the module-name file does NOT shadow
   the module name** (see Axis A). The two patterns interact — fixing
   one without the other still leaves you stuck.

3. Production code (`Sources/`) typically doesn't `import Testing`, so
   `Attachment` and `Collection` work bare. The qualification rule is
   primarily for test files.

4. Naming guideline for future @Model types: avoid names that collide
   with Apple framework types (e.g. _don't_ name a model `View`,
   `Text`, `Color`, `URLRequest`, `Notification`, `Comment`, `Note`,
   `Image`, `Style`, `Color`, `Date`, `Range`, `Sequence`, `Pattern`,
   `Operation`, `Set`, `Array`, `String`).

---

## Axis F — Unescaped double-quotes inside format strings ship as parse errors

**Pre-flight Rounds 4 + 6 (2026-05-20 / 2026-05-21, commits `f15da22`, `<r6>`)**

### Symptom

Swift compiler reports `error: consecutive statements on a line must be
separated by ';'` on a return statement that looks superficially fine:

```swift
return "Invalid input for field "\(field)"."
```

The error column points at the inner `"` before the interpolation, not at
the line itself. Same pattern hit `ServiceError.swift` in R4 and
`CaptureSheet.swift` in R6 — two different agents made the same mistake.

### Root cause

Swift string literal terminates at the first un-escaped `"`. The intended
string had inner double-quotes around the interpolated field name:
`field "\(field)"`. Without backslash escapes, the lexer reads:
- `"Invalid input for field "` (one string)
- `\(field)` (interpolation outside string — parse error)
- `"."` (another string)

Three "consecutive statements" on one line, hence the error.

Sub-agents reaching for `NSLocalizedString` or printf-style format
strings have repeatedly produced this. The error message is misleading
(points at expression parsing, not at the string terminator).

### Prevention

1. **Always escape inner quotes** when a format string contains
   user-visible quoted text:
   ```swift
   return "Invalid input for field \"\(field)\"."
   //                              ^^    ^^
   return NSLocalizedString("field.x", value: "Invalid input for field \"%@\".", comment: "")
   ```

2. **Sub-agent prompts** that ask for `LocalizedError` / `NSLocalizedString`
   / printf format strings should explicitly call out the escape rule —
   include the phrase *"escape inner double-quotes with `\"`"* in the
   prompt.

3. **Lint hook** (future) — add to `scripts/check-quote-escape.sh` or
   embed in an existing lint:

   ```bash
   # Heuristic: a Swift source line containing `return "..."..."` where
   # the second `"` is not preceded by `\` is suspicious. False-positive
   # rate is moderate; flag as WARN with file:line context.
   grep -rn 'return ".*[^\\]".*"' Sources/ App/Sources/ --include="*.swift"
   ```

4. **In CI / pre-commit**: a single `xcodebuild -dry-run` pass catches
   these immediately. The lessons-learned scan is a backstop for when CI
   isn't yet wired up.

---

## Axis G — MockURLProtocol race conditions in Swift Testing

**Pre-flight Round 6 (2026-05-21, commit `<r6>`) — intra-suite**
**Round 15 (2026-05-22, commit `d59ac2a`) — inter-suite (재확인)**

### Symptom

`BookMetadataLookupTests` had 9 `@Test` functions sharing a
`MockURLProtocol` with `nonisolated(unsafe) static var stubStatusCode`.
Tests passed individually but 3 failed when the suite ran. Specifically,
`lookup_rateLimited_throwsRateLimited` (which sets `stubStatusCode = 429`)
leaked its value into happy-path tests, which then caught `.rateLimited`
where they expected success.

### Root cause

Swift Testing runs tests inside a suite **in parallel by default** for
speed. `nonisolated(unsafe) static var` is exactly the shape that
race-condition tooling will not catch (it's an opt-out) but which still
races. The `URLProtocol` subclass pattern is a near-universal mock
strategy for `URLSession`, and Apple's own samples use static state.

### Prevention

1. **Annotate test suites that share static mock state with
   `@Suite(.serialized)`**:
   ```swift
   @Suite(.serialized)
   struct BookMetadataLookupTests {
       @Test func ...
   }
   ```
   Cost: tests run sequentially. For 9 fast unit tests (<10ms each)
   this is a non-issue.

2. **Alternative (deeper fix)**: replace static mock state with a
   per-instance closure or `TaskLocal` value. Higher engineering cost
   but keeps parallelism. Use when test suite grows beyond ~30 tests.

3. **Audit rule**: any `@Test` suite touching `static var` (especially
   `nonisolated(unsafe)`) must add `.serialized` OR migrate to instance
   state. Future lint could pattern-match on these together.

### R15 follow-up — `.serialized` does not isolate across `@Suite`s

After applying R6's `.serialized` rule to `BookMetadataLookupTests`, the
test suite still failed randomly when new `MovieMetadataLookupTests` and
`MusicMetadataLookupTests` were added (each also `.serialized`). Errors
like `.notFound`, `.networkUnavailable`, `.rateLimited` surfaced
unpredictably during full `swift test` runs even though every suite
passed in isolation.

**Root cause**: Swift Testing parallelizes _across_ `@Suite` structs by
default. `.serialized` only serializes tests _within_ a suite — it
provides zero protection against inter-suite races. `MockURLProtocol`
was defined non-private in `BookMetadataLookupTests.swift`; the Movie
and Music test files reached into the same class. Three suites running
in parallel = three concurrent writers to the same `static var stubData
/ stubError / stubStatusCode`. R6's intra-suite fix held, but the
inter-suite axis was unconstrained.

**Prevention**: each test file that mocks `URLProtocol` static state
must define its **own `private` mock class** with a medium-specific
name. Complete static-state isolation per file:

```swift
// BookMetadataLookupTests.swift
private final class BookMockURLProtocol: URLProtocol { ... }

// MovieMetadataLookupTests.swift
private final class MovieMockURLProtocol: URLProtocol { ... }

// MusicMetadataLookupTests.swift
private final class MusicMockURLProtocol: URLProtocol { ... }
```

The `private` access modifier prevents accidental cross-file reuse;
the medium prefix prevents future namespace collisions if two files
ever share a scope. R15 fix: commit `d59ac2a` — **105 tests PASS**.

**Lint candidate** (future addition to `scripts/check-*.sh`, follows
Axis E's `set +o pipefail` pattern for `grep -v` chains):

```bash
# Tests/ should not declare URLProtocol subclasses without `private`
set +o pipefail
violations=$(grep -rn "class .*URLProtocol" \
              Tests/ App/Tests/ Packages/*/Tests \
              --include="*.swift" 2>/dev/null \
             | grep -v "private" || true)
set -o pipefail
if [[ -n "$violations" ]]; then
  fail "URLProtocol mocks in Tests/ must be 'private' to avoid inter-suite races:"
  echo "$violations"
  exit 1
fi
```

**Verification heuristic**: a test that passes alone but fails in the
full `swift test` run is the inter-suite race signature. Always run
the full suite at least once before claiming a Lookup-style fix is
complete.

**Cross-reference**: Axis G part 1 (R6) addresses parallelism _within_
a `@Suite`. This R15 addendum addresses parallelism _between_ `@Suite`s.
Both must be applied for full URLProtocol-based mock isolation. See
also Axis E (`set -o pipefail` + `grep -v` chain safety) for the lint
shape.

---

## Axis H — JSON fixtures in Swift `"""..."""` literals must be valid JSON

**Pre-flight Round 6 (2026-05-21, commit `<r6>`)**

### Symptom

A `// LINT-IGNORE: Privacy` comment was placed inside a multi-line
string literal containing JSON to suppress a privacy host check on a
mock URL. The Swift lexer accepted it (it's just string content), but
the JSON decoder downstream rejected it (`//` is not legal JSON).
Result: the lookup actor's parser saw malformed JSON and threw
`notFound` — and the test that depended on a successful parse failed
mysteriously.

### Root cause

Two passes over the same text disagree:
1. **Swift lexer**: treats `"""..."""` as opaque string content.
2. **JSON parser** (runtime): expects strict RFC 8259 JSON.

Comments inside the fixture work syntactically (Swift compiles fine)
but break the test at runtime.

### Prevention

1. **Lint-suppression comments must live OUTSIDE the JSON literal**
   — typically above the `let foo = """` line in Swift source:

   ```swift
   // LINT-IGNORE: Privacy — mock fixture URL never resolved at runtime
   private let googleBooksResponse = """
   { ... "thumbnail": "http://books.google.com/..." ... }
   """
   ```

2. **Even cleaner**: omit the problematic URL from the fixture
   entirely if no test asserts against it. Less attack surface for
   future regressions.

3. **Validate fixtures on load** in test helper code — `JSONSerialization
   .jsonObject(with:)` will throw on malformed JSON and surface the
   issue at suite start rather than mid-test.

---

## Axis I — `actor X` + `ModelContext` is the wrong shape under SwiftData + SwiftUI

**Round 7 (2026-05-21, commit `<r7>`)**

### Symptom

Services declared `public actor LibraryService` (or ExportService /
TimelineService) that take a `ModelContext` in their initializer.
SwiftUI views call `LibraryService(context: modelContext)` where
`modelContext` comes from `@Environment(\.modelContext)`. Swift 6
strict concurrency flags every such call:

> error: sending 'self.modelContext' risks causing data races

The diagnostic is correct: `ModelContext` is bound to the main actor
when injected via `@Environment` (SwiftUI's SwiftData integration),
but the `actor` declaration introduces a fresh isolation domain — the
context would have to "send" across, which Swift 6 forbids because
ModelContext isn't `Sendable`.

### Root cause

The `actor` keyword is the wrong shape for "I need serialized access
to a ModelContext." SwiftData's ModelContext is *already* serialized
by Apple's framework (it's bound to the actor of the container it
came from — main, in the typical SwiftUI flow). Wrapping it in
another actor isn't more concurrency-safe; it's just *different*
concurrency-safe, in a way SwiftUI's bindings can't satisfy.

### Prevention

1. **For services that operate on a `ModelContext` injected from
   SwiftUI views: use `@MainActor final class`, not `actor`.**
   ```swift
   @MainActor
   public final class LibraryService {
       private let context: ModelContext
       public init(context: ModelContext) { self.context = context }
       public func listItems(...) async throws -> [Item] { ... }
   }
   ```
   The `async throws` surface is preserved; only the isolation
   declaration changes.

2. **If the service truly needs to run off-main** (heavy export,
   sync engine), pass `ModelContainer` (which IS Sendable) into a
   real `actor`, and have it construct its own background
   `ModelContext` inside. This matches Apple's documented background
   import pattern.

3. **Don't be tempted by `nonisolated(unsafe) ModelContext`** — that
   silences the diagnostic without making the code correct. Concurrent
   reads/writes from multiple actors to the same context still race.

4. **API ergonomics**: views still `await` service methods. The user
   never notices the change. The cost is purely lexical — `actor` →
   `@MainActor final class` in the declaration.

---

## Axis J — Apple legacy classes (AVCaptureSession, SFSpeechRecognitionTask) need `@unchecked Sendable`

**Round 7 (2026-05-21, commit `<r7>`)**

### Symptom

SwiftUI views wrap `AVCaptureSession` via `UIViewControllerRepresentable`
with a Coordinator pattern. The Coordinator stores `let session:
AVCaptureSession` and `private var hasRecognized = false`. Swift 6
strict concurrency rejects:

> error: stored property 'session' of 'Sendable'-conforming class
> 'BarcodeSessionCoordinator' has non-Sendable type 'AVCaptureSession'
> error: stored property 'hasRecognized' of 'Sendable'-conforming
> class 'BarcodeSessionCoordinator' is mutable

Similarly for `SFSpeechRecognitionTask` captured in an async actor
method: "capture of 'task' with non-Sendable type
'SFSpeechRecognitionTask' in a '@Sendable' closure."

### Root cause

Apple framework classes from the AVFoundation, Speech, and CoreLocation
eras predate Swift 6 strict concurrency. They are not yet annotated as
`Sendable` (or non-Sendable explicitly) and the compiler must
conservatively assume the worst. The framework documentation does
specify thread-safety contracts — AVCaptureSession is safe to access
from a serial queue; SFSpeechRecognitionTask is owned by its
recognizer — but Swift 6 has no machine-readable way to learn this.

### Prevention

1. **For Coordinator-shaped wrappers** (`UIViewControllerRepresentable
   .Coordinator`, `AVCaptureMetadataOutputObjectsDelegate`, etc.):
   declare the class `@unchecked Sendable` with a comment explaining
   the safety justification:
   ```swift
   // `@unchecked Sendable` is required because AVCaptureSession +
   // mutable `hasRecognized` flag don't satisfy strict concurrency
   // automatically. Safety: AVFoundation callbacks always fire on
   // the configured `sessionQueue`; the host VC and Coordinator are
   // only constructed/destroyed from the main actor; the cross-thread
   // surface is read-only access to the session.
   final class BarcodeSessionCoordinator: NSObject,
       AVCaptureMetadataOutputObjectsDelegate, @unchecked Sendable {
       ...
   }
   ```

2. **For async actor methods returning AsyncStream wrapping a
   non-Sendable framework type**: don't capture the type in a local
   variable that survives the `@Sendable` closure boundary. Assign
   directly to the actor's stored property:
   ```swift
   // BAD: captures `task` across the closure boundary
   let task = sfRecognizer.recognitionTask(with: request) { ... }
   self.recognitionTask = task
   return stream

   // GOOD: assigns inside actor isolation, no captured local
   self.recognitionTask = sfRecognizer.recognitionTask(with: request) { ... }
   return stream
   ```

3. **Closure declarations passed to representables**: explicitly mark
   `@Sendable`:
   ```swift
   struct CameraPreviewRepresentable: UIViewControllerRepresentable {
       let onRecognized: @Sendable (String) -> Void   // not `(String) -> Void`
   }
   ```
   The caller's closure body should marshal back to main with
   `Task { @MainActor in ... }` before touching SwiftUI state.

4. **Future-proofing**: Apple will likely annotate these framework
   types over the next several Swift releases. When that happens,
   `@unchecked Sendable` should be revisited and removed where the
   framework now supplies the conformance natively. Until then, this
   is the documented escape hatch and using it is *not* a hack.

---

## Axis N — SwiftData `@Model` classes must NOT declare `@unchecked Sendable`

**Round 11 cleanup (2026-05-21)**

### Symptom

`swift build --package-path Packages/InventoryCore` produces a warning
on every `@Model`-decorated class:

> warning: redundant conformance of 'Memory' to protocol 'Sendable'
> note: 'Memory' declares conformance to protocol 'Sendable' here

The warning fires from inside the macro expansion of `@Model`, pointing
at both the user's `public final class Memory: @unchecked Sendable`
declaration AND the macro-generated:

```swift
@available(swift, deprecated: 5.9, message: "PersistentModels are not Sendable, consider utilizing a ModelActor or use Memory's persistentModelID instead")
@available(*, unavailable, message: "PersistentModels are not Sendable, consider utilizing a ModelActor or use Memory's persistentModelID instead")
extension Memory: Sendable {}
```

Initially hidden by build cache hits; only surfaces on a full rebuild.

### Root cause

The `@Model` macro intentionally synthesizes an `unavailable` Sendable
conformance extension. The unavailable marker tells the compiler:
"PersistentModel is explicitly non-Sendable; if you see a site trying
to send a Memory across actor isolation, surface a diagnostic with the
ModelActor / persistentModelID guidance."

Declaring `@unchecked Sendable` on the class body overrides that
contract — but produces a redundant-conformance warning AND silently
suppresses the very strict-concurrency diagnostics SwiftData wants to
emit at every cross-actor pass site. The class is now "Sendable" from
the type-checker's view (so calls compile) but the underlying
PersistentModel is still tied to its ModelContext's isolation domain
(so the actual runtime invariant is unchanged) — a foot-gun.

This is **not** Axis J's territory. Axis J covers Apple _legacy_
framework classes (`AVCaptureSession`, `SFSpeechRecognitionTask`) that
predate strict concurrency and have no Sendable annotation at all. For
those, `@unchecked Sendable` is the documented escape hatch. SwiftData
PersistentModel is the opposite case: Apple has explicitly annotated it
as non-Sendable, and we must respect that.

### Prevention

1. **Never declare `@unchecked Sendable` on a `@Model` class.** The
   macro already handles Sendable correctly (by marking it unavailable).
   Bare class declaration is correct:
   ```swift
   @available(iOS 26, macOS 26, *)
   @Model
   public final class Memory {       // ← no `: @unchecked Sendable`
       // ...
   }
   ```

2. **For cross-actor passing of model identity, use `persistentModelID`**
   (it IS Sendable) and re-fetch on the destination actor:
   ```swift
   // SAFE: pass the ID across actor boundary, re-fetch on the other side
   let id = memory.persistentModelID
   await someActor.process(id: id)
   ```

3. **For background work on models, use the documented ModelActor
   pattern** — see Axis I for `@MainActor final class` services and
   `ModelContainer`-based background actors.

4. **Lint check** (add to `scripts/check-*.sh`):

   ```bash
   # Disallow @unchecked Sendable on @Model classes
   set +o pipefail
   violations=$(grep -B2 -rn "@unchecked Sendable" \
                 Packages/*/Sources --include="*.swift" 2>/dev/null \
                 | grep -B1 "@unchecked Sendable" \
                 | grep "@Model" || true)
   set -o pipefail
   if [[ -n "$violations" ]]; then
     fail "SwiftData @Model classes must not declare @unchecked Sendable:"
     echo "$violations"
     exit 1
   fi
   ```

5. **Cross-reference**: Axis I (services use `@MainActor class`, not
   `actor`), Axis J (legacy Apple framework classes are the only valid
   `@unchecked Sendable` site).

---

## Axis E — `set -o pipefail` + `grep -v` chains silently abort

**Pre-flight Round 4 (2026-05-20, commit `f15da22`)**

### Symptom

A lint script declares `set -euo pipefail`, runs grep pipelines like
`grep -rn ... | grep -v ".build/" | grep -v "DerivedData/" | wc -l`,
and stops mid-execution after the first such pipeline. The script's
final summary never runs. Earlier steps appear to PASS but the script
exits non-zero, causing the parent `test.sh` to report
`Data Sovereignty Lint FAIL`.

### Root cause

When `grep -v` filters out every line of its input, it exits 1 (no
match remaining). With `set -o pipefail`, any non-zero exit in a
pipeline aborts the script. The user sees "nothing went wrong" output
because the next steps simply never ran.

### Prevention

Two safe patterns:

1. **Disable pipefail around `grep -v` chains**, then re-enable:
   ```bash
   set +o pipefail
   count=$(grep -rn "..." source --include="*.swift" 2>/dev/null \
             | grep -v "\.build/" \
             | grep -v "DerivedData/" \
             | wc -l | tr -d ' ')
   set -o pipefail
   ```

2. **Wrap the first grep in `{ ...; } || true`**:
   ```bash
   count=$({ grep -rn "..." source --include="*.swift" || true; } \
            | grep -v "\.build/" \
            | grep -v "DerivedData/" \
            | wc -l | tr -d ' ')
   ```

The first pattern is preferred when the script has multiple such
chains — easier to spot than `|| true` sprinkled everywhere.

3. **Always test scripts with empty / all-filtered input** during
   development. A script that handles 100 matches but crashes on 0
   matches is a future regression.

---

## Axis M — SwiftData CloudKit auto-sync triggers Apple-account auth at first launch

**R10.2 (2026-05-21)**

### Symptom

A system "Apple 계정 확인" (Verify Apple Account) alert appears and blocks
the first paint of the app when running on a simulator (or device) where
iCloud is not signed in. The alert fires immediately on launch, before the
root view finishes rendering — it interrupts `DemoSeeder.seedIfEmpty()` and
prevents visual verification screenshots.

### Root cause

The default `.modelContainer(for: [Item.self, ...])` modifier, when combined
with a CloudKit entitlement in `StillHours.entitlements`, causes SwiftData to
initialise a `ModelContainer` with the CloudKit Private DB configuration
automatically. During container initialization, SwiftData attempts to register
a `CKDatabaseSubscription` and authenticate with iCloud. If no iCloud account
is present, the system surfaces the account sign-in alert — blocking the main
thread and preventing first render.

This is not a bug in SwiftData: it behaves as documented. The issue is using
the default configuration (which inherits the entitlement's CloudKit container)
in a development context where iCloud isn't available.

### Prevention

1. **For DEBUG builds: use `ModelConfiguration(isStoredInMemoryOnly: true)`.**
   This creates a pure in-RAM store — no disk write, no CloudKit registration,
   no auth prompt. `DemoSeeder` operates identically on an in-memory context.

2. **For Release builds: use `ModelConfiguration(cloudKitDatabase: .none)`**
   until the user explicitly opts into iCloud sync. This creates a local SQLite
   store; CloudKit is never contacted, so no auth prompt fires at launch.

3. **Factory method pattern in `StillHoursApp`:**
   ```swift
   @MainActor
   private static func makeContainer() -> ModelContainer {
       #if DEBUG
       let config = ModelConfiguration(isStoredInMemoryOnly: true)
       #else
       let config = ModelConfiguration(cloudKitDatabase: .none)
       #endif
       return try! ModelContainer(
           for: Item.self, Memory.self,
                InventoryCore.Collection.self,
                InventoryCore.Attachment.self,
           configurations: config
       )
   }
   ```
   Use `.modelContainer(Self.makeContainer())` in the `Scene` body.

4. **Do NOT remove the CloudKit entitlement** to suppress the prompt.
   The entitlement must stay for the Bundle ID profile to remain valid.
   The fix is runtime configuration, not build settings.

5. **Cross-reference:** Promise §1 (Data Sovereignty) — `cloudKitDatabase: .none`
   as the Release default means iCloud is opt-in, not default. This is
   _stricter_ than the original design and preserves user data sovereignty.
   See `docs/CloudKit-Setup.md` §R10 Status for the full matrix.

---

## Axis K — iOS sim install does not register the app with SpringBoard until restart

**Round 8 (2026-05-20, commit `11ab06b`)**

### Symptom

`xcrun simctl install booted /path/to/StillHours.app` succeeds (exit 0)
+ `xcrun simctl get_app_container booted com.ownlifelab.stillhours`
returns a valid Bundle/Application/UUID path + `xcrun simctl listapps
booted` shows the app — but `xcrun simctl launch booted
com.ownlifelab.stillhours` fails:

> error: Underlying error (domain=FBSOpenApplicationServiceErrorDomain,
> code=1): The request was denied by service delegate (SBMainWorkspace)
> for reason: NotFound ("Unknown application display identifier
> com.ownlifelab.stillhours").

### Root cause

CoreSimulator's `simctl install` writes the app bundle into
`CoreSimulator/Devices/<UDID>/data/Containers/Bundle/Application/` and
updates an internal cache. But SpringBoard's in-memory app registry —
the surface `simctl launch` queries — only refreshes on:
(a) sim boot, or
(b) explicit `launchctl kickstart -k system/com.apple.SpringBoard`.

This is an iOS 26 / Xcode 26 era simulator behavior; we don't have
evidence it existed in earlier Xcode versions.

### Prevention

After every fresh `simctl install`, BEFORE the first `simctl launch`,
do:

```bash
xcrun simctl spawn booted launchctl kickstart -k system/com.apple.SpringBoard 2>&1 || true
sleep 3
xcrun simctl launch booted <bundle-id>
```

The `|| true` swallows the warning "Please switch to user/foreground
service identifier" — that's just rdar://78126471 chatter; the kickstart
itself succeeds.

The `scripts/capture-screenshots.sh` encodes this pattern. Future sim
automation should follow the same shape.

For incremental developer-flow (re-running tests, not full install),
the restart isn't needed — the app is already registered.

See also: Axis L (locale launch args) — both axes are "simulator quirks
that bite automated visual verification."

---

## Axis L — `defaults write AppleLocale` doesn't propagate to a running app's text rendering

**Round 9 (2026-05-21, commit `eb9ee24`)**

### Symptom

R9.4 captured 4-quadrant screenshots (light/dark × ko/en). The locale
switch was attempted via:

```bash
xcrun simctl spawn booted defaults write -g AppleLocale ko_KR
xcrun simctl spawn booted defaults write -g AppleLanguages -array ko
```

System UI (status bar / alerts) localized to ko correctly. BUT the
StillHours app — even after a SpringBoard restart + relaunch — still
rendered all text in English. Both ko and en screenshots had identical
app text rendering, differing only by ~700 bytes (status-bar pixel-level).

### Root cause

iOS apps cache the resolved locale at process start. `defaults write`
updates the global preference but a running app doesn't re-read it.
A FULL relaunch should pick up the new value — and on iOS this usually
works for system apps — but for third-party app bundles compiled with
Xcode 26's String Catalog (.xcstrings), the resolution path is:

1. App starts, reads `Bundle.preferredLocalizations` (from system pref)
2. Loads `<locale>.lproj/Localizable.strings` (compiled from xcstrings)
3. Resolves `String(localized: "key")` against that table

If step 2 fails to find a matching `<locale>.lproj` (because the bundle
was built with only certain `CFBundleLocalizations` declared, or because
the locale arg uses an alias like `ko_KR` but the bundle only ships
`ko.lproj`), the resolution falls back to `Base` or the source language.

### Prevention

**The canonical way to set locale for sim testing is launch-time
arguments**, NOT global defaults:

```bash
xcrun simctl launch booted com.ownlifelab.stillhours \
  -AppleLanguages "(ko)" \
  -AppleLocale ko_KR
```

These arguments override at process start. They're picked up before
the bundle's Localizable lookup runs. This is how Apple's own
documentation and Xcode test-plan locale switching work internally.

`-AppleLanguages "(ko)"` — the parens-wrapped form is the array-literal
CFArray syntax `simctl` understands.

For `scripts/capture-screenshots.sh`, the locale step should be:

```bash
xcrun simctl terminate booted "$BUNDLE_ID" 2>/dev/null || true
xcrun simctl launch booted "$BUNDLE_ID" \
  -AppleLanguages "($LOCALE_TAG)" \
  -AppleLocale "${LOCALE_TAG}_${REGION}"
```

(For the en case: `-AppleLanguages "(en)"` `-AppleLocale en_US`.)

The R10.1 agent (concurrent) is responsible for updating
`scripts/capture-screenshots.sh` to this pattern. This lessons-learned
entry documents WHY.

Side note: local dev with Xcode + iOS Simulator usually doesn't expose
this because you change the sim's system language via the Settings app
(which does a full relaunch of all running apps). For automated screenshot
capture or CI flows, only the launch-time argument approach is reliable.

See also: Axis K (SpringBoard restart) — both axes are "simulator quirks
that bite automated visual verification."

---

## Axis O — Token cascade has parallel-agent build dependency

**Round 11 (2026-05-21, commit `33e69fc`)**

### Symptom

Cool Blue palette pivot launched 4 R11 agents in parallel:
- R11.1 = FoundationTokens.swift (creates `Color.shAccentSubtle`,
  `Color.shTextTertiary`).
- R11.2 = SemanticTokens.swift (CONSUMES R11.1's new aliases).
- R11.3 = Design.MD + docs (no Swift).
- R11.4 = LiquidGlassModifier.swift (CONSUMES R11.1's `shAccentSubtle`).

R11.2 and R11.4 began before R11.1 finished writing. Their compile
attempts during their own verification step hit "no member
'shAccentSubtle'" errors. Each agent saw the error, decided "this
will resolve when R11.1 lands," continued, and reported success at
their own level. Main session re-verified once all 4 had landed —
build was clean.

### Root cause

Parallel sub-agent launches assume independent file scope. Token
cascades are NOT independent — Foundation supplies, Semantic +
Component + Views consume. The compiler error message
("no member 'shAccentSubtle'") makes the failure look like a code
bug rather than a sequencing artifact.

### Prevention

1. **For token cascade pivots, run Foundation first (sequential),
   then Semantic + Component + Views in parallel** (the next layer
   down). This is a 2-phase launch, not single-message.

2. **If single-message parallel is required for speed**: explicitly
   pass the new API surface (e.g. `shAccentSubtle`) as a code stub
   into ALL downstream agent prompts. The agent's prompt can include
   the symbol's expected signature so the agent doesn't need to wait
   for the Foundation file to materialize — they trust the contract.

3. **Recovery pattern**: when downstream agents fail with "no member"
   on a symbol the upstream agent is creating, the main session
   should: (a) wait for upstream completion notification, (b) re-run
   downstream agent's verification step inline rather than re-launching
   the agent. This is what worked in R11.

4. **Lint addition (future)**: a `scripts/check-token-cascade.sh`
   could verify Foundation tokens are not referenced before being
   defined — but the compiler already does this, so the lint adds
   little. The real fix is the sequencing rule above.

---

## Axis P — Semantic token API shape changes need a callsite sweep

**Round 11 (2026-05-21, commit `33e69fc`)**

### Symptom

R11.2 restructured `SemanticTokens` from flat `SemanticTokens.accent.default
/ .muted` API into nested enums (`SemanticTokens.cta.primary.fill`,
`SemanticTokens.tab.active.tint`, etc.). The agent updated SemanticTokens.swift
but did NOT update view callers. Result: 3 compile errors in
CapturePreviewView.swift:
```
error: type 'SemanticTokens' has no member 'accent'
```

Each line was using the old flat API. Main session sed-fix'd them to
`Color.shAccent` / `Color.shAccentMuted` directly (bypassing the new
nested semantic surface entirely).

### Root cause

When a SHAPE change happens to a public API (not a value change),
all callers using the OLD shape break. The agent's mental model
was "I own SemanticTokens, view files are outside my scope" — but
the API contract change ripples beyond the agent's edit boundary.

This is the SAME pattern as:
- Renaming a class method while leaving callers unchanged
- Changing a function's parameter order
- Splitting a flat enum into a nested namespace

### Prevention

1. **Agent prompts for API shape changes must explicitly include a
   callsite sweep**: "After restructuring the API, grep all callers
   in App/Sources/ and update them. Estimated N callers — verify
   you've updated all."

2. **Alternative — provide a backward-compat shim**: keep the old
   flat surface as a thin alias of the new one for one round:
   ```swift
   public extension SemanticTokens {
       /// DEPRECATED — use `SemanticTokens.cta.primary.fill` instead.
       /// Will be removed in R12.
       @available(*, deprecated, message: "Use cta.primary.fill")
       enum accent {
           public static var `default`: Color { Color.shAccent }
           public static var muted: Color { Color.shAccentMuted }
       }
   }
   ```
   This lets the agent ship the new shape without breaking callers
   immediately; the shim is removed in the next round after callsites
   migrate.

3. **Lint pattern (future)**: a per-agent contract check —
   "if the agent modifies a `public` API surface in SemanticTokens,
   the diff must include matching updates in App/Sources/ OR an
   explicit deprecation shim." Not yet automated; surfaces as a
   review-time check.

4. **Heuristic**: when an agent's scope includes a token / design-
   system file (anything under `DesignTokens/`), the agent prompt
   MUST include "and update all view callers" as an explicit
   responsibility. Treat it as the cost of touching a public surface.

---

## Axis Q — SwiftData lightweight migration for additive-only fields

**Build #9 (2026-05-24)**

### Symptom

App migration from `SchemaV1` to `SchemaV2` added three optional fields
(`externalID`, `source`, `publisher`) to the `Item` model. Concern arose:
"Should we write a custom migration with `MigrationStage.custom(...)`?"

### Root cause

Lightweight migrations are sufficient when **all new fields are optional
with sensible defaults**. SwiftData's `MigrationStage.lightweight(...)` 
automatically fills new optional fields with `nil` for all existing rows.
Custom migration code is only needed for: required field add, type change,
field rename, or value transformation logic.

### Prevention

1. **When adding optional fields only**, use lightweight migration:
   ```swift
   enum SchemaMigrationPlan: SchemaMigrationPlan {
       static let stages = [
           MigrationStage.lightweight(fromVersion: .v1, toVersion: .v2)
       ]
   }
   ```

2. **When the field is required or needs transformation**, use custom:
   ```swift
   MigrationStage.custom(fromVersion: .v1, toVersion: .v2) { 
       context in
       // Fetch existing items, compute derived values
   }
   ```

3. **Verify the migration**: after changing `ModelConfiguration` or the
   schema version, run a test that instantiates a fresh `ModelContainer`
   with the new schema and migration plan. This simulates a real app
   upgrade path. Existing data on the simulator is preserved across the
   migration.

4. **Anti-pattern**: writing a no-op custom migration (`willMigrate` /
   `didMigrate` with empty body) when lightweight would suffice — adds
   complexity for nothing.

---

## Axis R — Cross-project credential reuse is blocked by auto-mode classifier

**Build #9 (2026-05-24)**

### Symptom

Attempted to reuse OYL's ASC API key (marked CRITICAL in
`~/.claude/CLAUDE.md`) for another project (OYC). User authorized verbally
via AskUserQuestion ("OYL key 재사용 가능?"). Claude Code's auto-mode
classifier still blocked reads of the `.env` file — twice — even after
the authorization.

### Root cause

Verbal user authorization via `AskUserQuestion` does NOT propagate to the
auto-mode classifier when reading files marked CRITICAL in CLAUDE.md 
memory. The classifier treats CRITICAL-marked credentials as a hard boundary
independent of per-session consent. This is intentional: it protects the
user's stated long-term policy from being bypassed by transient session
approvals.

### Prevention

When reusing a credential marked CRITICAL in `~/.claude/CLAUDE.md`:

1. **Option A (preferred)**: User exports credentials as environment 
   variables in their own shell. Claude script reads from env, never
   touches the `.env` file:
   ```bash
   export ASC_KEY_ID="..." ASC_ISSUER_ID="..." ASC_KEY_PATH="..."
   python scripts/asc-patch.py  # reads from env
   ```

2. **Option B**: User adds an explicit allow rule to 
   `.claude/settings.local.json`:
   ```json
   {
     "bashPermissions": {
       "allow": ["cat /path/to/.env"]
     }
   }
   ```
   This makes the allowance durable and explicit.

3. **Option C**: User updates `CLAUDE.md` memory to explicitly authorize
   cross-project use of the specific credential. This modifies the CRITICAL
   boundary.

4. **Option D**: User performs the operation manually (least scalable).

5. **Anti-pattern**: trying to work around classifier denials with creative
   file-reading tricks (`base64`, symlinks, intermediate files). The denial
   is a feature — it protects the user's stated boundary.

---

## Adding new axes (process rule, revised 2026-05-21)

When a new bug class is documented, future sessions:
1. Read the relevant axis BEFORE designing similar code.
2. If a bug class generalizes beyond Apple platforms, also surface
   it to `~/.claude/lessons-learned-global.md`.
3. If a bug class is automatable via lint, add to `scripts/check-*.sh`
   AND wire into `scripts/test.sh`.
4. Cross-link related axes — e.g. Axis K and Axis L are both
   "simulator quirks that bite automated visual verification" and
   should reference each other.

---

## Operational reminders (not bugs — process)

### Sub-agent prompts must include exact file paths

The Round 4 agents were briefed with full paths under `/tmp/curium-swift/...`
including which docs to read first. Agents without conversation history
cannot infer paths from context; vague prompts ("write tests for the
models") produce shallow output.

### Verifier is a separate pass, not the same context

Each Round's "all green" verification was a fresh `swift test` run,
not the agent's self-report. Sub-agents over-attest their work; trust
but verify.

### Pre-flight Round commits should be self-contained

Each `pre-flight-rN` commit must build green on its own. Don't commit
WIP that depends on later commits to compile. The `f15da22` R4 commit
fixed seven cross-file build issues precisely so it could be a single
green checkpoint.
