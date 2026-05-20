#!/usr/bin/env bash
# =============================================================================
# check-quote-escape.sh — Format String Quote Escape Lint (Axis F)
#
# Purpose : Catch un-escaped inner double-quotes inside Swift string literals.
#           An un-escaped inner `"` terminates the string early; the rest of
#           the line becomes unparseable, and the compiler reports the
#           misleading error "consecutive statements on a line must be
#           separated by ';'" pointing at the wrong column.
#
# Axis F  : R11A.3 — 2026-05-21
#           Pattern first hit ServiceError.swift (R4, commit f15da22),
#           recurred in CaptureSheet.swift (R6) — two different agents,
#           same mistake.  Sub-agents writing LocalizedError / NSLocalizedString
#           / printf format strings consistently omit backslash escaping.
#           Cross-reference: docs/lessons-learned.md §"Axis F"
#
# Pattern : Lines where a string literal appears to contain a SECOND un-escaped
#           double-quote followed by string interpolation `\(` or printf `%@`.
#           This is a HEURISTIC — false positives are expected and acceptable;
#           developers suppress them with `// LINT-IGNORE: QuoteEscape`.
#
# Regex   : BSD-compatible ERE (no -P / no PCRE).
#           Primary: `"[^\\"]*"[^"\\]*(\(|%@)`
#           Reads: open-quote, non-quote/backslash chars, close-quote (un-escaped),
#           any non-quote chars, then interpolation marker or %@.
#
# Opt-out : Add `// LINT-IGNORE: QuoteEscape` on the same line OR the line
#           immediately above to suppress for that occurrence.
#           Exit 0 if all matches are suppressed (WARN printed but no failure).
#
# Scanned : App/Sources/ and Packages/InventoryCore/Sources/
#           (configurable via SCAN_DIRS at top of Config section)
#
# Usage   : ./scripts/check-quote-escape.sh [source-root]
#           source-root defaults to the parent of the directory containing
#           this script.
#
# Exit    : 0 = no un-suppressed violations, 1 = violations found
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

# Directories to scan (relative to SOURCE_ROOT; missing dirs are skipped)
SCAN_DIRS=(
  "App/Sources"
  "Packages/InventoryCore/Sources"
)

IGNORE_MARKER="LINT-IGNORE: QuoteEscape"
LESSONS_LINK="docs/lessons-learned.md §Axis F"

# Heuristic ERE pattern (BSD grep -E compatible):
# Matches a line containing: open-quote, chars without quote/backslash,
# then a bare second double-quote immediately followed (no comma/paren
# gap) by string interpolation \( or printf %@.
# This catches: return "field "\(name)"." or value: "foo "%@"."
# Excludes: func("key", defaultValue: "\(x)") — comma between the quotes.
PATTERN='"[^\\"]*"[^"\\,)]*([\\][(]|%@)'

# ── Helpers ─────────────────────────────────────────────────────────────────

# Returns 0 if the line at $linenum in $file has an ignore comment
# on the same line or the immediately preceding line.
has_ignore_comment() {
  local file="$1"
  local linenum="$2"
  local above=$(( linenum - 1 ))

  # Same line check
  if sed -n "${linenum}p" "$file" 2>/dev/null | grep -q "$IGNORE_MARKER"; then
    return 0
  fi
  # Previous line check
  if [[ $above -ge 1 ]]; then
    if sed -n "${above}p" "$file" 2>/dev/null | grep -q "$IGNORE_MARKER"; then
      return 0
    fi
  fi
  return 1
}

# ── Main ─────────────────────────────────────────────────────────────────────
header "Format String Quote Escape Lint (Axis F)"
echo "Source root : $SOURCE_ROOT"
echo ""
echo "Heuristic: lines with un-escaped inner double-quote before string"
echo "interpolation \\( or printf format %@ — false positives suppressed"
echo "with '// LINT-IGNORE: QuoteEscape' on the same or preceding line."
echo ""

violations=0
suppressed=0
files_scanned=0

for rel_dir in "${SCAN_DIRS[@]}"; do
  scan_dir="${SOURCE_ROOT}/${rel_dir}"
  if [[ ! -d "$scan_dir" ]]; then
    warn "Scan directory not found, skipping: ${scan_dir}"
    continue
  fi

  while IFS= read -r -d '' swift_file; do
    (( files_scanned++ )) || true

    # Quick pre-filter: skip files with no double-quote patterns near interpolation.
    # `grep -c` returns one int per file; head -1 protects against multi-match concat.
    set +o pipefail
    quick_check=$(grep -cE "$PATTERN" "$swift_file" 2>/dev/null | head -1 || true)
    set -o pipefail
    quick_check="${quick_check:-0}"
    [[ "$quick_check" = "0" ]] && continue

    # Full scan with line numbers
    set +o pipefail
    while IFS=: read -r linenum line; do
      [[ -z "$linenum" ]] && continue
      [[ -z "$line" ]] && continue

      # Skip lines that are comments (whole line is a comment)
      if echo "$line" | grep -qE '^[[:space:]]*//' 2>/dev/null; then
        continue
      fi

      # Skip multi-line string literals (lines starting with """)
      if echo "$line" | grep -qE '^\s*"""' 2>/dev/null; then
        continue
      fi

      if has_ignore_comment "$swift_file" "$linenum"; then
        warn "Suppressed (LINT-IGNORE: QuoteEscape): ${swift_file}:${linenum}"
        (( suppressed++ )) || true
        continue
      fi

      fail "Un-escaped inner double-quote: ${swift_file}:${linenum}"
      echo "       Line   : $(echo "$line" | sed 's/^[[:space:]]*//')"
      echo ""
      echo "       The inner '\"' terminates the string literal early."
      echo "       Swift compiler reports 'consecutive statements' on that line,"
      echo "       pointing at the wrong column — misleading diagnostic."
      echo ""
      echo "       Fix: Escape inner quotes with backslash:"
      echo "         BAD:  return \"Invalid input for field \"\(field)\".\""
      echo "         GOOD: return \"Invalid input for field \\\"\(field)\\\".\""
      echo "         BAD:  value: \"field \"%@\".\""
      echo "         GOOD: value: \"field \\\"%@\\\".\""
      echo ""
      echo "       To suppress a false positive, add on the SAME or PRECEDING line:"
      echo "         // LINT-IGNORE: QuoteEscape"
      echo "       Reference: ${LESSONS_LINK}"
      echo ""
      (( violations++ )) || true

    done < <(grep -nE "$PATTERN" "$swift_file" 2>/dev/null || true)
    set -o pipefail

  done < <(find "$scan_dir" -name "*.swift" \
    -not -path "*/.build/*" \
    -not -path "*/DerivedData/*" \
    -print0 2>/dev/null)
done

echo ""
echo "Files scanned  : ${files_scanned}"
echo "Violations     : ${violations}"
echo "Suppressed     : ${suppressed}"
echo ""

if [[ $violations -gt 0 ]]; then
  fail "Quote escape lint FAILED — ${violations} un-escaped inner quote(s) found."
  echo ""
  echo "  This is a heuristic check. If a match is a false positive:"
  echo "  1. Add '// LINT-IGNORE: QuoteEscape' on the same or preceding line."
  echo "  2. If the pattern recurs, consider refining PATTERN in this script."
  echo "  Reference: ${LESSONS_LINK}"
  exit 1
elif [[ $suppressed -gt 0 ]]; then
  warn "Quote escape lint PASSED with ${suppressed} suppressed match(es)."
  info "All un-suppressed lines are clean."
  exit 0
else
  info "Quote escape lint PASSED — no un-escaped inner quotes found."
  exit 0
fi
