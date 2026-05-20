#!/usr/bin/env bash
# =============================================================================
# check-i18n.sh — Localization Lint (Axes A, B, J, M)
#
# Purpose : Verify the String Catalog (Localizable.xcstrings) and Swift source
#           for i18n correctness across Wave 1 locales (ko / en / ja).
#
# Axes checked:
#   A — Key naming convention (lowercase-led dotted segments, camelCase allowed)
#   B — No hardcoded user-visible strings in Swift source (WARN, not FAIL)
#   J — Binary locale anti-pattern (isEnglishLocale ? en : ko) — FAIL
#       This pattern broke OYL (Own Your Life) multiple times when new locales
#       were added and the ternary silently served the wrong language to ja/zh/
#       fr users. Lesson-learned: use a locArray() / switch pattern instead.
#       Reference: ~/.claude/lessons-learned-global.md §"OYL axis J" (commit ead846b)
#   M — ASO metadata coverage (Wave 1 §2/§3/§4 locale sections present)
#
# Wave 1 locales : ko (sourceLanguage) · en · ja
# Wave 2 deferred: de · fr · es · pt-BR · zh-Hant (v1.2)
#
# Usage   : ./scripts/check-i18n.sh [source-root]
#           source-root defaults to the parent of the directory containing this script.
#
# Exit    : 0 = all critical axes (A, J, M) pass, 1 = one or more fail.
#           Axis B is WARN-only and does not affect exit code.
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

XCSTRINGS="${SOURCE_ROOT}/App/Resources/Localizable.xcstrings"
SWIFT_SOURCES="${SOURCE_ROOT}/App/Sources"
ASO_DOC="${SOURCE_ROOT}/docs/ASO-Metadata-Wave1.md"
PLIST="${SOURCE_ROOT}/App/Resources/Info.plist"

EXPECTED_LOCALES="en ja ko"   # sorted for comparison

# Per-axis results (PASS / FAIL / WARN)
RESULT_A="PASS"; RESULT_B="PASS"; RESULT_J="PASS"; RESULT_M="PASS"
OVERALL=0

mark_fail() { eval "RESULT_${1}=FAIL"; OVERALL=1; }
mark_warn() { eval "RESULT_${1}=WARN"; }   # warn-only: no OVERALL change

# ── Step 1 — Declared locales from Info.plist ───────────────────────────────
header "Step 1 — Declared locales (CFBundleLocalizations)"

if [[ ! -f "$PLIST" ]]; then
  fail "Info.plist not found at: $PLIST"
  OVERALL=1
else
  DECLARED=$(PLIST_PATH="$PLIST" python3 -c "
import plistlib, os
with open(os.environ['PLIST_PATH'], 'rb') as f:
    d = plistlib.load(f)
locs = d.get('CFBundleLocalizations', [])
print(' '.join(sorted(locs)))
")
  if [[ "$DECLARED" == "$EXPECTED_LOCALES" ]]; then
    info "CFBundleLocalizations = [$DECLARED] (Wave 1 correct)"
  else
    fail "CFBundleLocalizations mismatch."
    echo "       Expected : $EXPECTED_LOCALES"
    echo "       Got      : $DECLARED"
    OVERALL=1
  fi
fi

# ── Step 2 — xcstrings file exists ─────────────────────────────────────────
header "Step 2 — Localizable.xcstrings presence"

if [[ ! -f "$XCSTRINGS" ]]; then
  fail "Localizable.xcstrings not found at: $XCSTRINGS"
  echo "       Fix: Create App/Resources/Localizable.xcstrings (Apple String Catalog v1.0 JSON)."
  echo ""
  echo "Axes A/J cannot run without Localizable.xcstrings. Aborting."
  exit 1
fi
info "Localizable.xcstrings exists."

# ── Step 3 — Parse xcstrings: completeness check ────────────────────────────
header "Step 3 — xcstrings completeness (all 3 locales, non-empty values)"

PARSE_RESULT=$(XCSTRINGS_PATH="$XCSTRINGS" python3 -c "
import json, os
path = os.environ['XCSTRINGS_PATH']
locales = ['ko', 'en', 'ja']
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)
strings = data.get('strings', {})
total = len(strings)
errors = []
for key, entry in strings.items():
    locs = entry.get('localizations', {})
    for loc in locales:
        if loc not in locs:
            errors.append('MISSING locale ' + repr(loc) + ' for key: ' + key)
            continue
        su = locs[loc].get('stringUnit', {})
        value = su.get('value', '')
        state = su.get('state', '')
        if not value:
            errors.append('EMPTY value locale ' + repr(loc) + ' key: ' + key)
        if state not in ('translated', 'new'):
            errors.append('SUSPICIOUS state ' + repr(state) + ' locale ' + repr(loc) + ' key: ' + key)
print('TOTAL_KEYS=' + str(total))
for e in errors:
    print('ERROR:' + e)
")

TOTAL_KEYS=$(echo "$PARSE_RESULT" | grep "^TOTAL_KEYS=" | cut -d= -f2)
set +o pipefail
STEP3_ERRORS=$(echo "$PARSE_RESULT" | grep "^ERROR:" | sed 's/^ERROR:/  /' || true)
set -o pipefail

if [[ -n "$STEP3_ERRORS" ]]; then
  fail "xcstrings completeness issues:"
  echo "$STEP3_ERRORS"
  OVERALL=1
else
  info "xcstrings: ${TOTAL_KEYS} keys, all 3 locales complete, all states valid."
fi

# ── Step 4 — Axis A: key naming convention ─────────────────────────────────
header "Step 4 — Axis A: Key naming (lowercase-led dotted segments)"

# Convention: each segment starts with lowercase; camelCase allowed within segment.
# Examples: nav.close, capture.error.titleRequired, capture.modeUnavailable.barcode
AXIS_A_VIOLATIONS=$(XCSTRINGS_PATH="$XCSTRINGS" python3 -c "
import json, re, os
path = os.environ['XCSTRINGS_PATH']
# Each dot-separated segment: starts with lowercase letter, rest can be alpha
segment = r'[a-z][a-zA-Z]*'
pattern = re.compile(r'^' + segment + r'(\.' + segment + r')*$')
with open(path, 'r', encoding='utf-8') as f:
    data = json.load(f)
for key in data.get('strings', {}).keys():
    if not pattern.match(key):
        print('  BAD KEY: ' + key)
")

if [[ -n "$AXIS_A_VIOLATIONS" ]]; then
  fail "Axis A violations — invalid key naming:"
  echo "$AXIS_A_VIOLATIONS"
  echo "       Convention: each segment starts lowercase; camelCase allowed within segment."
  echo "       Examples: nav.close, capture.error.titleRequired, capture.modeUnavailable.barcode"
  mark_fail "A"
else
  info "Axis A: all key names conform to convention."
fi

# ── Step 5 — Axis B: hardcoded user strings in Swift source (WARN) ─────────
header "Step 5 — Axis B: Hardcoded user-visible strings in Swift source (WARN)"

if [[ ! -d "$SWIFT_SOURCES" ]]; then
  warn "App/Sources directory not found — skipping Axis B scan (no Swift files yet)."
else
  set +o pipefail
  AXIS_B_VIOLATIONS=""

  while IFS= read -r -d '' swift_file; do
    while IFS=: read -r linenum line; do
      [[ -z "$line" ]] && continue
      literal=$(echo "$line" | grep -oE '"[^"]{1,200}"' | head -1 | tr -d '"' || true)
      [[ -z "$literal" ]] && continue
      # Hangul
      if echo "$literal" | grep -qE '[가-힣]'; then
        AXIS_B_VIOLATIONS="${AXIS_B_VIOLATIONS}  ${swift_file}:${linenum} — Hangul literal: \"${literal}\"\n"
        continue
      fi
      # CJK unified
      if echo "$literal" | grep -qE '[一-鿿]'; then
        AXIS_B_VIOLATIONS="${AXIS_B_VIOLATIONS}  ${swift_file}:${linenum} — CJK literal: \"${literal}\"\n"
        continue
      fi
      # Capital-starting ≥4 chars (likely user-visible, not an identifier placeholder)
      if echo "$literal" | grep -qE '^[A-Z].{3,}$'; then
        AXIS_B_VIOLATIONS="${AXIS_B_VIOLATIONS}  ${swift_file}:${linenum} — Capital literal (>=4): \"${literal}\"\n"
      fi
    done < <(grep -nE '(Text|Label|\.navigationTitle)\("' "$swift_file" 2>/dev/null || true)
  done < <(find "$SWIFT_SOURCES" -name "*.swift" -not -path "*/\.*" -print0 2>/dev/null)

  set -o pipefail

  if [[ -n "$AXIS_B_VIOLATIONS" ]]; then
    warn "Axis B — hardcoded user strings (prefer String(localized:) or LocalizedStringKey):"
    echo -e "$AXIS_B_VIOLATIONS"
    mark_warn "B"
  else
    info "Axis B: no hardcoded user-visible strings found."
  fi
fi

# ── Step 6 — Axis J: binary locale anti-pattern ────────────────────────────
header "Step 6 — Axis J: Binary locale helper anti-pattern"
#
# Pattern blocked: `isEnglishLocale ? en : ko` or locale == "xx" ? ... : ...
# OYL DemoSeeder bug: ternary on single locale silently broke ja/zh/fr/es/pt.
# Root fix: locArray() helper covering all Wave 1 locales (OYL commit ead846b).
# Reference: ~/.claude/lessons-learned-global.md §"OYL axis J"

if [[ ! -d "$SWIFT_SOURCES" ]]; then
  warn "App/Sources not found — skipping Axis J scan."
else
  set +o pipefail
  AXIS_J_VIOLATIONS=$(
    grep -rn \
      -E '(isEnglishLocale|isKoreanLocale|isJapaneseLocale|locale\s*==\s*"[a-z]{2}")\s*\?' \
      "$SWIFT_SOURCES" 2>/dev/null \
    | grep -v "LINT-IGNORE: AxisJ" \
    || true
  )
  set -o pipefail

  if [[ -n "$AXIS_J_VIOLATIONS" ]]; then
    fail "Axis J — binary locale anti-pattern detected:"
    echo "$AXIS_J_VIOLATIONS" | while IFS= read -r line; do echo "  $line"; done
    echo ""
    echo "       This pattern breaks silently when new locales are added."
    echo "       Fix: use a locale-keyed dictionary or switch covering all Wave 1 locales."
    echo "       Reference: OYL lessons-learned §Axis J (commit ead846b)."
    mark_fail "J"
  else
    info "Axis J: no binary locale anti-pattern found."
  fi
fi

# ── Step 7 — Axis M: ASO metadata coverage ─────────────────────────────────
header "Step 7 — Axis M: ASO metadata Wave 1 locale sections"

if [[ ! -f "$ASO_DOC" ]]; then
  fail "ASO-Metadata-Wave1.md not found at: $ASO_DOC"
  echo "       Fix: Create docs/ASO-Metadata-Wave1.md with §2 (ko), §3 (en), §4 (ja) sections."
  mark_fail "M"
else
  set +o pipefail
  HAS_S2=$(grep -c "## §2" "$ASO_DOC" 2>/dev/null || echo "0")
  HAS_S3=$(grep -c "## §3" "$ASO_DOC" 2>/dev/null || echo "0")
  HAS_S4=$(grep -c "## §4" "$ASO_DOC" 2>/dev/null || echo "0")
  set -o pipefail

  AXIS_M_OK=true
  if [[ "${HAS_S2:-0}" -lt 1 ]]; then
    fail "ASO §2 (Korean) section missing from ASO-Metadata-Wave1.md"; AXIS_M_OK=false; mark_fail "M"
  fi
  if [[ "${HAS_S3:-0}" -lt 1 ]]; then
    fail "ASO §3 (English) section missing from ASO-Metadata-Wave1.md"; AXIS_M_OK=false; mark_fail "M"
  fi
  if [[ "${HAS_S4:-0}" -lt 1 ]]; then
    fail "ASO §4 (Japanese) section missing from ASO-Metadata-Wave1.md"; AXIS_M_OK=false; mark_fail "M"
  fi

  if [[ "$AXIS_M_OK" == true ]]; then
    info "Axis M: §2 (ko) + §3 (en) + §4 (ja) all present in ASO-Metadata-Wave1.md."
  fi
fi

# ── Summary table ───────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
printf "  %-42s %-8s\n" "Axis" "Result"
printf "  %-42s %-8s\n" "──────────────────────────────────────────" "──────"

print_axis_row() {
  local label="$1"
  local result="$2"
  local color="$NC"
  case "$result" in
    PASS) color="$GREEN" ;;
    FAIL) color="$RED"   ;;
    WARN) color="$YELLOW";;
  esac
  printf "  %-42s ${color}%-8s${NC}\n" "$label" "$result"
}

print_axis_row "Axis A — Key naming convention"         "$RESULT_A"
print_axis_row "Axis B — No hardcoded strings (WARN)"   "$RESULT_B"
print_axis_row "Axis J — Binary locale anti-pattern"    "$RESULT_J"
print_axis_row "Axis M — ASO Wave 1 locale sections"    "$RESULT_M"

echo ""

if [[ $OVERALL -eq 0 ]]; then
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  info "i18n lint PASSED."
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  exit 0
else
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  fail "i18n lint FAILED — see output above."
  echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  exit 1
fi
