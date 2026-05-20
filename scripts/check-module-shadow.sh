#!/usr/bin/env bash
# =============================================================================
# check-module-shadow.sh — Module Name Shadow Lint (Axis A)
#
# Purpose : Verify that no SPM module's entry file (or any source file)
#           declares a top-level type whose name equals the module itself.
#           Such a shadow causes `ModuleName.NestedType` lookups to resolve
#           against the type (member access) instead of the module namespace,
#           silently breaking `FetchDescriptor<ModuleName.Model>` type
#           inference in tests and anywhere the qualified name is used.
#
# Axis A  : R11A.3 — 2026-05-21
#           Root cause: `InventoryCore.swift` had `public enum InventoryCore {}`
#           which shadowed `InventoryCore.Collection`, `InventoryCore.Attachment`
#           etc. Fixed in commit f15da22. This lint prevents recurrence.
#           Cross-reference: docs/lessons-learned.md §"Axis A"
#
# Rules   :
#   FAIL  — Module entry file (<Module>.swift) declares a type named <Module>.
#   WARN  — Any other Swift file in the same Sources tree declares a type
#           named <Module> (rare intentional namespacing; flag for review).
#   SKIP  — Module entry file is absent (nothing to shadow; info only).
#
# Opt-out : Add `// LINT-IGNORE: ModuleShadow` on the same line as the type
#           declaration to suppress the WARN (not the FAIL — entry-file
#           shadows are always errors).
#
# Usage   : ./scripts/check-module-shadow.sh [source-root]
#           source-root defaults to the parent of the directory containing
#           this script.
#
# Exit    : 0 = no shadows (FAIL or un-suppressed WARN), 1 = violations found
# =============================================================================
set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[PASS]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }
header(){ echo -e "\n${YELLOW}==> $*${NC}"; }

# ── Config ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="${1:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

PACKAGES_DIR="${SOURCE_ROOT}/Packages"

LESSONS_LINK="docs/lessons-learned.md §Axis A"

# ── Sanity check ────────────────────────────────────────────────────────────
if [[ ! -d "$PACKAGES_DIR" ]]; then
  warn "No Packages/ directory found at: $PACKAGES_DIR — skipping module shadow check."
  exit 0
fi

# ── Helpers ─────────────────────────────────────────────────────────────────

# Returns list of module names discovered under Packages/<X>/Sources/<X>/
discover_modules() {
  # Pattern: Packages/<pkg>/Sources/<target>/ where target dir name == module
  # We use find to enumerate Sources/<X> directories then check they exist.
  find "$PACKAGES_DIR" -mindepth 3 -maxdepth 3 -type d \
    -path "*/Sources/*" \
    -not -path "*/.build/*" \
    -not -path "*/DerivedData/*" \
    2>/dev/null | while IFS= read -r src_dir; do
      module_name="$(basename "$src_dir")"
      # The Sources/<X> dir must sit inside Packages/<Anything>/Sources/
      # Already guaranteed by the find pattern — emit the module name.
      echo "$module_name"
    done | sort -u
}

# Greps a single file for a public type declaration whose name equals
# the module. Returns matching lines in "file:linenum: content" form.
grep_shadow_in_file() {
  local file="$1"
  local module="$2"
  # BSD grep (macOS) doesn't support -P; use ERE.
  # Pattern: optional whitespace + public + optional whitespace +
  #          (enum|struct|class|actor|protocol) + whitespace + <module> +
  #          word boundary (colon/open-brace/space/end).
  set +o pipefail
  grep -nE "^[[:space:]]*(public[[:space:]]+)?(enum|struct|class|actor|protocol)[[:space:]]+${module}([[:space:]]|:|[{]|$)" \
    "$file" 2>/dev/null || true
  set -o pipefail
}

# ── Main ─────────────────────────────────────────────────────────────────────
header "Module Name Shadow Lint (Axis A)"
echo "Source root  : $SOURCE_ROOT"
echo "Packages dir : $PACKAGES_DIR"
echo ""

OVERALL=0
modules_checked=0

while IFS= read -r module_name; do
  [[ -z "$module_name" ]] && continue
  (( modules_checked++ )) || true

  sources_dir="${PACKAGES_DIR}"
  # Find the concrete sources directory for this module (may be nested under any package)
  module_src=""
  while IFS= read -r candidate; do
    module_src="$candidate"
    break
  done < <(find "$PACKAGES_DIR" -mindepth 3 -maxdepth 3 -type d \
    -path "*/Sources/${module_name}" \
    -not -path "*/.build/*" \
    -not -path "*/DerivedData/*" \
    2>/dev/null)

  [[ -z "$module_src" ]] && continue

  entry_file="${module_src}/${module_name}.swift"

  # ── Entry file check (FAIL if shadow found) ────────────────────────────────
  if [[ ! -f "$entry_file" ]]; then
    info "[INFO] Module '${module_name}': no entry file ${module_name}.swift — skipping entry-file check."
  else
    matches=$(grep_shadow_in_file "$entry_file" "$module_name")
    if [[ -n "$matches" ]]; then
      fail "Module shadow detected in entry file: ${entry_file}"
      echo ""
      echo "$matches" | while IFS= read -r match_line; do
        echo "       ${entry_file}:${match_line}"
      done
      echo ""
      echo "       A type named '${module_name}' in '${module_name}.swift' shadows the SPM"
      echo "       module namespace. 'ModuleName.SomeType' lookups will resolve against"
      echo "       the type (member access), NOT the module, breaking FetchDescriptor<>"
      echo "       type inference in tests."
      echo ""
      echo "       Fix: Rename the type (e.g. '${module_name}NS', '${module_name}Utilities')"
      echo "            or move the declaration to a different file with a different name."
      echo "       Reference: ${LESSONS_LINK}"
      OVERALL=1
    else
      info "Module '${module_name}': entry file clean — no shadow."
    fi
  fi

  # ── Non-entry files scan (WARN if shadow found) ────────────────────────────
  while IFS= read -r -d '' swift_file; do
    # Skip the entry file itself (already handled above as FAIL)
    [[ "$swift_file" == "$entry_file" ]] && continue

    non_entry_matches=$(grep_shadow_in_file "$swift_file" "$module_name")
    [[ -z "$non_entry_matches" ]] && continue

    # Check for opt-out comment
    while IFS= read -r match_line; do
      linenum=$(echo "$match_line" | cut -d: -f1)
      line_content=$(echo "$match_line" | cut -d: -f2-)

      # Check same line for LINT-IGNORE
      if echo "$line_content" | grep -q "LINT-IGNORE: ModuleShadow"; then
        warn "Suppressed (LINT-IGNORE: ModuleShadow): ${swift_file}:${linenum}"
        continue
      fi

      warn "Possible shadow in non-entry file: ${swift_file}:${linenum}"
      echo "       Type '${module_name}' declared outside the entry file."
      echo "       If intentional, add '// LINT-IGNORE: ModuleShadow' on the same line."
      echo "       Reference: ${LESSONS_LINK}"
    done < <(echo "$non_entry_matches")

  done < <(find "$module_src" -name "*.swift" \
    -not -path "*/.build/*" \
    -not -path "*/DerivedData/*" \
    -print0 2>/dev/null)

done < <(discover_modules)

echo ""
echo "Modules checked: ${modules_checked}"
echo ""

if [[ $OVERALL -eq 0 ]]; then
  info "Module shadow lint PASSED — no module-name shadows found."
  exit 0
else
  fail "Module shadow lint FAILED — see output above."
  echo ""
  echo "  Root cause: a type named after its own module shadows the SPM namespace,"
  echo "  causing 'ModuleName.NestedType' to resolve as member access on the type"
  echo "  rather than qualified lookup in the module."
  echo "  Reference: ${LESSONS_LINK}"
  exit 1
fi
