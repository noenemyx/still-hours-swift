#!/usr/bin/env bash
# =============================================================================
# check-sfsymbols.sh — SF Symbols Usage Audit
#
# Purpose : Audit all SF Symbol references in Swift source, cross-reference
#           them against the declared selection in docs/SFSymbols-Selection.md,
#           verify against the SF Symbols 7 catalog when available, and
#           surface iOS 26-exclusive symbol recommendations.
#
# Round   : R8 — 2026-05-21
#
# Steps   :
#   1. Discover all SF Symbol names used in Swift source.
#   2. Cross-reference against docs/SFSymbols-Selection.md declared list.
#   3. Verify used symbols against SF Symbols 7 catalog (if installed).
#   4. Recommend iOS 26-exclusive symbol variants (curated, hardcoded).
#   5. Summary table.
#
# Design  : WARN-heavy by intent — this is a discovery tool, not a hard gate.
#           Only genuine catalog mismatches (Step 3) would FAIL, but Step 3
#           never FAILs — it degrades gracefully to SKIP when catalog is
#           unavailable or parsing fails.
#
# Usage   : ./scripts/check-sfsymbols.sh [source-root]
#           source-root defaults to the directory containing this script's
#           parent (project root heuristic).
#
# Exit    : 0 = OK (warnings allowed), 1 = at least one FAIL
# =============================================================================
set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[PASS]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }
note()  { echo -e "${CYAN}[NOTE]${NC} $*"; }
header(){ echo -e "\n${YELLOW}==> $*${NC}"; }
hr()    { echo -e "${YELLOW}──────────────────────────────────────────────────────${NC}"; }

# ── Config ──────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="${1:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

APP_SRC="${SOURCE_ROOT}/App/Sources"
PKG_SRC="${SOURCE_ROOT}/Packages/InventoryCore/Sources"
SELECTION_DOC="${SOURCE_ROOT}/docs/SFSymbols-Selection.md"
SF_APP="/Applications/SF Symbols.app"

# ── Step 1 — Discover all SF Symbol references in Swift source ───────────────
header "Step 1 — Discover SF Symbol names in Swift source"

FAIL_COUNT=0
USED_SYMBOLS=""
SOURCE_FILE_COUNT=0

# Count source files scanned
set +o pipefail
SOURCE_FILE_COUNT=$(find "${APP_SRC}" "${PKG_SRC}" -name "*.swift" \
  -not -path "*/\.*" -not -path "*/.build/*" -not -path "*/DerivedData/*" \
  2>/dev/null | wc -l | tr -d '[:space:]')
set -o pipefail

# Pattern 1: Image(systemName: "name") — with optional extra args
# Pattern 2: systemImage: "name" — Label/NavigationLink/Toolbar convenience
# Pattern 3: return "name" lines that are SF symbol-shaped strings (lowercase, dots)
# Pattern 4: static let x = "name" — SemanticTokens registry constants

# We grep each pattern and extract quoted strings that look like SF symbol names.
# SF symbol names are lowercase, contain letters, digits, dots.
# We exclude generic short strings: "yes", "no", plain words without a dot.

extract_symbols() {
  local pattern="$1"
  local paths=("${APP_SRC}" "${PKG_SRC}")
  set +o pipefail
  grep -rnE "$pattern" "${paths[@]}" 2>/dev/null \
    | grep -oE '"[a-z][a-z0-9._]+"' \
    | tr -d '"'
  set -o pipefail
}

# Collect from each pattern class
SYM_IMAGE=$(extract_symbols 'Image\(systemName:[[:space:]]*"[a-z][a-z0-9._]+"' || true)
SYM_SYSIMG=$(extract_symbols 'systemImage:[[:space:]]*"[a-z][a-z0-9._]+"' || true)
SYM_RETURN=$(extract_symbols 'return[[:space:]]+"[a-z][a-z0-9._]*\.[a-z][a-z0-9._]+"' || true)
SYM_STATIC=$(extract_symbols 'static let [a-z]+ = "[a-z][a-z0-9._]*\.[a-z][a-z0-9._]+"' || true)

# Merge all; require at least one dot or be a known standalone symbol to avoid
# picking up locale codes, keys, etc. We keep multi-segment names (contain ".")
# plus a curated list of known single-word SF symbols.
STANDALONE_KNOWN="checkmark plus xmark headphones keyboard photo gearshape"

ALL_RAW=$(printf "%s\n%s\n%s\n%s\n" \
  "$SYM_IMAGE" "$SYM_SYSIMG" "$SYM_RETURN" "$SYM_STATIC")

# Filter: keep names that contain a dot, OR are in the standalone known list
USED_SYMBOLS=""
while IFS= read -r sym; do
  [[ -z "$sym" ]] && continue
  # Keep if has a dot (multi-segment SF symbol)
  if echo "$sym" | grep -q '\.'; then
    USED_SYMBOLS="${USED_SYMBOLS}${sym}"$'\n'
    continue
  fi
  # Keep if it is a known standalone symbol
  if echo " $STANDALONE_KNOWN " | grep -q " ${sym} "; then
    USED_SYMBOLS="${USED_SYMBOLS}${sym}"$'\n'
  fi
done <<< "$ALL_RAW"

# Sort and deduplicate
USED_SYMBOLS=$(echo "$USED_SYMBOLS" | sort -u | grep -v '^$' || true)

USED_COUNT=0
if [[ -n "$USED_SYMBOLS" ]]; then
  USED_COUNT=$(echo "$USED_SYMBOLS" | grep -c '.' || true)
fi

echo "Source dirs   : ${APP_SRC}"
echo "              : ${PKG_SRC}"
echo "Swift files   : ${SOURCE_FILE_COUNT}"
echo ""
echo "Found ${USED_COUNT} distinct SF Symbol names across ${SOURCE_FILE_COUNT} source files."
echo ""
echo "Used symbols:"
while IFS= read -r sym; do
  [[ -z "$sym" ]] && continue
  echo "  • ${sym}"
done <<< "$USED_SYMBOLS"

# ── Step 2 — Cross-reference docs/SFSymbols-Selection.md ────────────────────
header "Step 2 — Cross-reference SFSymbols-Selection.md"

if [[ ! -f "$SELECTION_DOC" ]]; then
  warn "SFSymbols-Selection.md not found at: ${SELECTION_DOC}"
  warn "Skipping cross-reference. Create the file to enable this step."
  DECLARED_SYMBOLS=""
  DECLARED_COUNT=0
else
  # Parse the declared symbols from the doc.
  # The 12 confirmed symbols appear as `\`symbol-name\`` in the Selected rows.
  # We extract backtick-quoted names from lines containing "Selected" or from
  # the verification checklist table (pipe-delimited, first column).
  # Strategy: extract all backtick-quoted lowercase dot-names from the doc.
  set +o pipefail
  DECLARED_SYMBOLS=$(grep -oE '\`[a-z][a-z0-9._]+\`' "$SELECTION_DOC" \
    | tr -d '`' \
    | sort -u \
    | grep '\.' \
    || true)
  set -o pipefail

  DECLARED_COUNT=0
  if [[ -n "$DECLARED_SYMBOLS" ]]; then
    DECLARED_COUNT=$(echo "$DECLARED_SYMBOLS" | grep -c '.' || true)
  fi

  echo "Selection doc : ${SELECTION_DOC}"
  echo "Declared symbols (${DECLARED_COUNT}):"
  while IFS= read -r sym; do
    [[ -z "$sym" ]] && continue
    echo "  • ${sym}"
  done <<< "$DECLARED_SYMBOLS"

  echo ""

  # Cross-reference: USED + DECLARED (confirmed)
  CONFIRMED_COUNT=0
  USED_UNDECLARED_COUNT=0
  USED_UNDECLARED=""
  DECLARED_UNUSED_COUNT=0
  DECLARED_UNUSED=""

  # Find used-but-not-declared
  while IFS= read -r sym; do
    [[ -z "$sym" ]] && continue
    if ! echo "$DECLARED_SYMBOLS" | grep -qxF "$sym" 2>/dev/null; then
      USED_UNDECLARED="${USED_UNDECLARED}${sym}"$'\n'
      (( USED_UNDECLARED_COUNT++ )) || true
    else
      (( CONFIRMED_COUNT++ )) || true
    fi
  done <<< "$USED_SYMBOLS"

  # Find declared-but-not-used
  while IFS= read -r sym; do
    [[ -z "$sym" ]] && continue
    if ! echo "$USED_SYMBOLS" | grep -qxF "$sym" 2>/dev/null; then
      DECLARED_UNUSED="${DECLARED_UNUSED}${sym}"$'\n'
      (( DECLARED_UNUSED_COUNT++ )) || true
    fi
  done <<< "$DECLARED_SYMBOLS"

  # Report confirmed
  info "Used + Declared (confirmed): ${CONFIRMED_COUNT}"

  # Report used-but-undeclared (INFO, not WARN — expected during dev)
  if [[ $USED_UNDECLARED_COUNT -gt 0 ]]; then
    note "Used but not declared (${USED_UNDECLARED_COUNT}) — consider adding to SFSymbols-Selection.md:"
    while IFS= read -r sym; do
      [[ -z "$sym" ]] && continue
      echo "    ${sym}"
    done <<< "$USED_UNDECLARED"
  else
    info "All used symbols are declared in the selection doc."
  fi

  # Report declared-but-unused (WARN — orphaned entries in selection doc)
  if [[ $DECLARED_UNUSED_COUNT -gt 0 ]]; then
    warn "Declared but not used (${DECLARED_UNUSED_COUNT}) — orphaned in SFSymbols-Selection.md:"
    while IFS= read -r sym; do
      [[ -z "$sym" ]] && continue
      echo "    ${sym}"
    done <<< "$DECLARED_UNUSED"
  else
    info "All declared symbols are referenced in source."
  fi
fi

# ── Step 3 — Verify against SF Symbols 7 catalog ────────────────────────────
header "Step 3 — SF Symbols 7 catalog verification"

SF_CATALOG_STATUS="SKIP"

if [[ ! -d "$SF_APP" ]]; then
  note "SF Symbols.app not found at: ${SF_APP}"
  note "Skipping catalog check. Install SF Symbols 7 from developer.apple.com."
  note "See docs/Pre-flight-User-Actions.md for installation instructions."
  SF_CATALOG_STATUS="N/A"
else
  echo "SF Symbols 7 detected at: ${SF_APP}"

  # Locate the symbol catalog. SF Symbols stores names in a plist or sqlite.
  # Try several known paths — these can shift between versions.
  CATALOG_PLIST=""
  CANDIDATE_PATHS=(
    "${SF_APP}/Contents/Resources/Metadata/symbol_search.plist"
    "${SF_APP}/Contents/Resources/symbol_search.plist"
    "${SF_APP}/Contents/Resources/Metadata/name_availability.plist"
    "${SF_APP}/Contents/Resources/name_availability.plist"
  )

  for p in "${CANDIDATE_PATHS[@]}"; do
    if [[ -f "$p" ]]; then
      CATALOG_PLIST="$p"
      break
    fi
  done

  if [[ -z "$CATALOG_PLIST" ]]; then
    # Try a broader find within the app bundle (max depth 5)
    set +o pipefail
    CATALOG_PLIST=$(find "${SF_APP}/Contents/Resources" -maxdepth 5 \
      -name "*.plist" \( -name "*symbol*" -o -name "*name*" \) \
      2>/dev/null | head -1 || true)
    set -o pipefail
  fi

  if [[ -z "$CATALOG_PLIST" ]]; then
    note "Could not locate SF Symbols catalog plist inside the app bundle."
    note "Catalog structure may differ in this SF Symbols version. Skipping Step 3."
    note "Manual check: open SF Symbols 7 app and search each symbol name directly."
    SF_CATALOG_STATUS="SKIP"
  else
    echo "Catalog file  : ${CATALOG_PLIST}"
    echo ""

    # Extract symbol names from plist using plutil (macOS native, available on all macs)
    # plutil -p converts to human-readable; we grep for quoted keys or values
    # that look like SF symbol names (lowercase, dots).
    CATALOG_SYMBOLS=""
    set +o pipefail
    CATALOG_SYMBOLS=$(plutil -p "$CATALOG_PLIST" 2>/dev/null \
      | grep -oE '"[a-z][a-z0-9._]+"' \
      | tr -d '"' \
      | grep '\.' \
      | sort -u \
      || true)
    set -o pipefail

    CATALOG_SIZE=0
    if [[ -n "$CATALOG_SYMBOLS" ]]; then
      CATALOG_SIZE=$(echo "$CATALOG_SYMBOLS" | grep -c '.' || true)
    fi

    if [[ $CATALOG_SIZE -eq 0 ]]; then
      note "Could not extract symbol names from catalog plist (format may differ)."
      note "Skipping catalog verification. Step 3 result: SKIP."
      SF_CATALOG_STATUS="SKIP"
    else
      echo "Catalog entries: ${CATALOG_SIZE} symbols"
      echo ""

      CATALOG_OK=0
      CATALOG_MISSING=0

      while IFS= read -r sym; do
        [[ -z "$sym" ]] && continue
        if echo "$CATALOG_SYMBOLS" | grep -qxF "$sym" 2>/dev/null; then
          (( CATALOG_OK++ )) || true
        else
          warn "Symbol not found in SF Symbols 7 catalog: ${sym}"
          (( CATALOG_MISSING++ )) || true
        fi
      done <<< "$USED_SYMBOLS"

      if [[ $CATALOG_MISSING -eq 0 ]]; then
        info "All ${CATALOG_OK} used symbols found in SF Symbols 7 catalog."
        SF_CATALOG_STATUS="OK"
      else
        warn "${CATALOG_MISSING} symbol(s) not confirmed in catalog."
        note "These may be valid symbols not in this catalog file, or genuine typos."
        note "Verify manually in SF Symbols 7 app before shipping."
        SF_CATALOG_STATUS="WARN"
      fi
    fi
  fi
fi

# ── Step 4 — Recommend iOS 26-exclusive symbol variants ─────────────────────
header "Step 4 — iOS 26-exclusive symbol recommendations"

cat << 'RECTABLE'
The table below is a curated, hardcoded list of symbol upgrade opportunities.
None of these are required for v1.0. Review before each major version bump.

| Current symbol          | Context              | iOS 26 / SF 7 recommendation           | Rationale                                                    |
|-------------------------|----------------------|----------------------------------------|--------------------------------------------------------------|
| barcode.viewfinder      | CaptureSheet mode    | No upgrade needed (iOS 17+, stable)    | Already the best barcode-scan metaphor available.            |
| mic.fill                | CaptureSheet voice   | No upgrade needed                      | Standard mic fill is correct for active recording.           |
| keyboard                | CaptureSheet manual  | No upgrade needed                      | Direct hardware metaphor for manual entry.                   |
| exclamationmark.triangle| CaptureSheet error   | exclamationmark.triangle.fill          | Filled variant stronger as an error state icon.              |
| film / film.fill        | watched kind + movie | film.stack / film.stack.fill           | SF Symbols 6+ — "stack" evokes a collection vs single item.  |
| cube.fill               | object medium        | cube.transparent / archivebox.fill     | cube.transparent (SF 4+) for glass/ceramic; archivebox for general objects. |
| music.note              | music medium         | music.note.list                        | "list" variant implies album/tracklist vs single note.       |
| book.closed.fill        | book medium          | books.vertical.fill                    | Already used for Library tab; visual continuity option.      |
| info.circle             | Settings About       | info.circle.fill                       | Filled variant for interactive-destination rows.             |
| square.and.arrow.up     | Settings Export      | No upgrade needed                      | Standard iOS export icon; universal recognition.             |
| lock.shield             | Settings Privacy     | lock.shield.fill                       | Filled variant warmer, more reassuring for privacy context.  |
| questionmark.circle     | Settings Help        | questionmark.circle.fill               | Filled variant consistent with other filled action icons.    |
| arrow.up.right.square   | Settings Help ext.   | arrow.up.right.circle.fill             | Round variant less mechanical, softer feel.                  |
| gearshape               | Settings tab icon    | gearshape.fill                         | Filled for active/selected tab state.                        |
| shippingbox.fill        | acquired kind        | No upgrade needed (SF 3+, stable)      | Best-in-class for "received a shipment" metaphor.            |
| text.book.closed.fill   | read kind            | No upgrade needed (SF 4+, stable)      | Unique symbol; no better alternative in SF 7.                |
| headphones              | listened kind        | No upgrade needed (SF 1+, stable)      | Universal audio-listening metaphor.                          |
| arrow.uturn.left        | lent kind            | No upgrade needed                      | U-turn correctly implies "out then back" flow.               |
| arrow.down.left.square.fill | received kind    | No upgrade needed                      | Square-frame keeps visual family with lent kind.             |
| gift.fill               | gifted kind          | No upgrade needed                      | Universal gift metaphor; no better alternative.              |
| pencil.line             | annotated kind       | No upgrade needed                      | Closest to "writing in margins" without editing connotation. |

RECTABLE

note "Copy the rows with a recommendation into SFSymbols-Selection.md §4.2 for v1.x review."

# ── Step 5 — Summary table ───────────────────────────────────────────────────
header "Step 5 — Symbol Usage Audit Summary"

echo ""
hr
echo -e "  ${CYAN}Symbol Usage Audit${NC}"
hr
echo ""

# Fallback defaults if Step 2 was skipped (no selection doc)
CONFIRMED_COUNT="${CONFIRMED_COUNT:-0}"
USED_UNDECLARED_COUNT="${USED_UNDECLARED_COUNT:-0}"
DECLARED_UNUSED_COUNT="${DECLARED_UNUSED_COUNT:-0}"
DECLARED_COUNT="${DECLARED_COUNT:-0}"

printf "  %-45s : %s\n" "Distinct symbols used in source"        "${USED_COUNT}"
printf "  %-45s : %s\n" "Declared in SFSymbols-Selection.md"     "${DECLARED_COUNT}"
printf "  %-45s : %s\n" "Used + declared (confirmed)"             "${CONFIRMED_COUNT}"
printf "  %-45s : %s\n" "Used but not declared (add to doc?)"     "${USED_UNDECLARED_COUNT}"
printf "  %-45s : %s\n" "Declared but unused (orphaned)"          "${DECLARED_UNUSED_COUNT}"
printf "  %-45s : %s\n" "SF Symbols 7 catalog check"              "${SF_CATALOG_STATUS}"

echo ""
hr

# ── Exit ─────────────────────────────────────────────────────────────────────
if [[ $FAIL_COUNT -eq 0 ]]; then
  info "SF Symbols audit completed — no failures. Review WARNs and NOTEs above."
  exit 0
else
  fail "SF Symbols audit: ${FAIL_COUNT} failure(s)."
  exit 1
fi
