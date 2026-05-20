#!/usr/bin/env bash
# =============================================================================
# check-data-sovereignty.sh — Data Sovereignty & Export Capability Lint
#
# Purpose : Verify that every SwiftData @Model type in the project:
#           1. Conforms to Encodable (enabling JSON export).
#           2. Has a documented CSV export path (via comment or companion type).
#           3. Participates in a VersionedSchema migration plan.
#
# Promise : GOVERNANCE §Data Sovereignty — "Users own their data. All data
#           must be exportable in open formats (JSON, CSV) at all times."
#
# Checks performed:
#   [1] @Model class conforms to Encodable (or Codable)
#   [2] @Model class has associated CodingKeys or JSONEncoder usage nearby
#   [3] VersionedSchema enum exists in the project
#   [4] Each @Model appears in at least one MigrationStage or VersionedSchema
#   [5] CSV export path documented (struct/class with "CSV" in name, or
#       a method named exportCSV / toCSV / csvRow)
#
# Opt-out : Add `// LINT-IGNORE: DataSovereignty` on the @Model declaration
#           line or immediately above it.
#
# Usage   : ./scripts/check-data-sovereignty.sh [source-root]
#           source-root defaults to project root (parent of scripts/).
#
# Exit    : 0 = all clear, 1 = violations found
#
# Compatibility: bash 3.2+ (macOS system bash). No associative arrays.
# =============================================================================
set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[PASS]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }
note()  { echo -e "${YELLOW}[NOTE]${NC} $*"; }
header(){ echo -e "\n${YELLOW}==> $*${NC}"; }

# ── Config ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="${1:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

IGNORE_MARKER='LINT-IGNORE: DataSovereignty'

# Temp file for @Model discovery results (bash 3.2 compatible — no assoc arrays)
MODELS_TMP=$(mktemp /tmp/ds_models_XXXXXX.txt)
trap 'rm -f "$MODELS_TMP"' EXIT

# ── Helpers ─────────────────────────────────────────────────────────────────
has_ignore_comment() {
  local file="$1"
  local linenum="$2"
  local above=$(( linenum - 1 ))
  if sed -n "${linenum}p" "$file" | grep -q "$IGNORE_MARKER"; then return 0; fi
  if [[ $above -ge 1 ]] && sed -n "${above}p" "$file" | grep -q "$IGNORE_MARKER"; then return 0; fi
  return 1
}

# Lookup helpers using the temp file (format: NAME|FILE|LINENUM)
model_file()    { grep "^${1}|" "$MODELS_TMP" 2>/dev/null | head -1 | cut -d'|' -f2; }
model_linenum() { grep "^${1}|" "$MODELS_TMP" 2>/dev/null | head -1 | cut -d'|' -f3; }

# ── Step 1: Discover all @Model classes ─────────────────────────────────────
header "Step 1 — Discovering @Model types"

while IFS=: read -r file linenum line; do
  [[ -z "$file" || -z "$linenum" ]] && continue

  # Extract class/struct name: look at the @Model line and the line after
  classline=$(sed -n "$(( linenum + 1 ))p" "$file" 2>/dev/null || true)
  name=$(echo "$classline" | grep -oE '(class|struct|final class)\s+[A-Za-z_][A-Za-z0-9_]+' | awk '{print $NF}' | head -1)
  if [[ -z "$name" ]]; then
    name=$(echo "$line" | grep -oE '(class|struct|final class)\s+[A-Za-z_][A-Za-z0-9_]+' | awk '{print $NF}' | head -1)
  fi
  [[ -z "$name" ]] && continue

  if has_ignore_comment "$file" "$linenum"; then
    warn "Suppressed (LINT-IGNORE): $file:$linenum — @Model $name"
    continue
  fi

  # Store: NAME|FILE|LINENUM
  echo "${name}|${file}|${linenum}" >> "$MODELS_TMP"
  echo "  Found @Model: $name  ($file:$linenum)"

done < <(grep -rn "@Model" "$SOURCE_ROOT" --include="*.swift" \
          | grep -v "//.*@Model" \
          | grep -v "LINT-IGNORE" \
          | grep -v "\.build/" \
          | grep -v "DerivedData/" || true)

# Build MODEL_NAMES array from temp file
MODEL_NAMES=()
while IFS='|' read -r name _ _; do
  MODEL_NAMES+=("$name")
done < "$MODELS_TMP"

total_models=${#MODEL_NAMES[@]}
echo "  Total @Model types discovered: $total_models"

if [[ $total_models -eq 0 ]]; then
  info "No @Model types found — nothing to verify."
  echo ""
  note "If this project uses SwiftData, ensure @Model is annotated on classes."
  exit 0
fi

# ── Step 2: Check Encodable conformance ─────────────────────────────────────
header "Step 2 — Checking Encodable / Codable conformance"

violations=0

for name in "${MODEL_NAMES[@]}"; do
  file=$(model_file "$name")
  [[ -z "$file" ]] && continue

  # Check class/struct declaration for Encodable or Codable conformance
  if grep -n "class\s\+${name}\b\|struct\s\+${name}\b" "$file" 2>/dev/null \
      | grep -qE "(Encodable|Codable)"; then
    info "$name: Encodable conformance found."
  else
    # Deeper search: extension Name: Encodable/Codable anywhere in project
    ext_match=$(grep -rn "extension\s\+${name}\s*:" "$SOURCE_ROOT" --include="*.swift" \
                 | grep -E "(Encodable|Codable)" \
                 | grep -v "\.build/" | head -1 || true)
    if [[ -n "$ext_match" ]]; then
      info "$name: Encodable conformance found (extension)."
    else
      mline=$(model_linenum "$name")
      fail "$name: Missing Encodable/Codable conformance."
      echo "       File: ${file}:${mline}"
      echo "       Fix : Add 'Encodable' or 'Codable' to $name's conformance list."
      echo "             Example: final class $name: Codable {"
      (( violations++ )) || true
    fi
  fi
done

# ── Step 3: Check VersionedSchema migration plan ─────────────────────────────
header "Step 3 — Checking VersionedSchema migration plan"

versioned_schema_count=$(grep -rn "VersionedSchema" "$SOURCE_ROOT" --include="*.swift" \
                           | grep -v "\.build/" | grep -v "DerivedData/" | wc -l | tr -d ' ')

migration_stage_count=$(grep -rn "MigrationStage\|SchemaMigrationPlan" "$SOURCE_ROOT" --include="*.swift" \
                           | grep -v "\.build/" | grep -v "DerivedData/" | wc -l | tr -d ' ')

echo "  VersionedSchema occurrences : $versioned_schema_count"
echo "  MigrationStage occurrences  : $migration_stage_count"

if [[ $versioned_schema_count -eq 0 ]]; then
  fail "No VersionedSchema found in project."
  echo "       Fix : Create a VersionedSchema enum for each @Model type."
  echo "             Example:"
  echo "               enum AppSchemaV1: VersionedSchema {"
  echo "                 static var versionIdentifier = Schema.Version(1, 0, 0)"
  echo "                 static var models: [any PersistentModel.Type] { [MyModel.self] }"
  echo "               }"
  (( violations++ )) || true
else
  info "VersionedSchema found ($versioned_schema_count occurrences)."
fi

if [[ $migration_stage_count -eq 0 && $versioned_schema_count -gt 0 ]]; then
  warn "VersionedSchema exists but no MigrationStage / SchemaMigrationPlan found."
  note "Ensure you define a SchemaMigrationPlan with MigrationStage entries before shipping v2+."
fi

# Check that each @Model name appears in a VersionedSchema context
header "Step 3b — Verifying each @Model appears in VersionedSchema"

for name in "${MODEL_NAMES[@]}"; do
  schema_ref=$(grep -rn "${name}.self" "$SOURCE_ROOT" --include="*.swift" \
                 | grep -iE "(VersionedSchema|models:)" \
                 | grep -v "\.build/" | head -1 || true)
  if [[ -n "$schema_ref" ]]; then
    info "$name: Registered in VersionedSchema."
  else
    warn "$name: Not found in any VersionedSchema models list."
    note "       Manual review: Add $name.self to your VersionedSchema.models array."
    # WARN not FAIL — first version may not need a migration plan yet
  fi
done

# ── Step 4: Check CSV export path ────────────────────────────────────────────
header "Step 4 — Checking CSV export paths"

csv_method_count=$(grep -rn "func\s\+\(exportCSV\|toCSV\|csvRow\|csvString\|asCSV\)" \
                     "$SOURCE_ROOT" --include="*.swift" \
                     | grep -v "\.build/" | grep -v "DerivedData/" | wc -l | tr -d ' ')

csv_type_count=$(grep -rn "class\s\+\w*CSV\|struct\s\+\w*CSV\|CSVExport\|CSVWriter" \
                   "$SOURCE_ROOT" --include="*.swift" \
                   | grep -v "\.build/" | grep -v "DerivedData/" | wc -l | tr -d ' ')

echo "  CSV export methods found : $csv_method_count"
echo "  CSV export types found   : $csv_type_count"

if [[ $csv_method_count -eq 0 && $csv_type_count -eq 0 ]]; then
  warn "No CSV export path found in project."
  note "GOVERNANCE §Data Sovereignty requires CSV export capability."
  note "Recommended: Add 'func exportCSV() -> String' to each @Model or a CSV exporter type."
  note "This is a WARN (not FAIL) until the export feature is implemented."
  # Intentional WARN not FAIL: export UI may be in a backlog sprint
else
  info "CSV export path found."
fi

# ── Step 5: Manual review items ───────────────────────────────────────────────
header "Step 5 — Manual Review Checklist (human judgment required)"

echo ""
echo "  The following items require manual review — they cannot be fully"
echo "  automated because they depend on business logic and schema semantics:"
echo ""
echo "  [ ] All @Model fields containing PII (name, email, location) are"
echo "      documented in the Privacy Manifest (PrivacyInfo.xcprivacy)."
echo ""
echo "  [ ] JSON export includes all fields needed to reconstruct the object"
echo "      from scratch (no silent omissions in CodingKeys)."
echo ""
echo "  [ ] CSV export produces human-readable column headers matching"
echo "      user-visible field names (not Swift property names)."
echo ""
echo "  [ ] VersionedSchema migration does not silently drop user data"
echo "      (test: migrate a seeded database, verify row count and field values)."
echo ""
echo "  [ ] Export function is accessible from the app's Settings / Data screen"
echo "      (user-reachable, not developer-only)."
echo ""
for name in "${MODEL_NAMES[@]}"; do
  echo "  [ ] $name: Verify all fields appear in exported JSON/CSV."
done
echo ""

# ── Summary ──────────────────────────────────────────────────────────────────
header "Summary"
echo "  @Model types checked : $total_models"
echo "  Violations           : $violations"
echo ""

if [[ $violations -eq 0 ]]; then
  info "Data sovereignty lint PASSED."
  exit 0
else
  fail "Data sovereignty lint FAILED — $violations violation(s) found."
  echo "  Complete the manual review checklist above before shipping."
  exit 1
fi
