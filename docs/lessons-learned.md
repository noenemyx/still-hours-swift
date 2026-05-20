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
