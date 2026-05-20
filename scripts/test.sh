#!/usr/bin/env bash
# =============================================================================
# test.sh — Single Entry Point for All Verifications
#
# Purpose : Run the full verification suite in one command:
#           1. Promise lint: check-privacy
#           2. Promise lint: check-data-sovereignty
#           3. Promise lint: check-no-subscription
#           4. i18n lint: check-i18n (Axis A/B/J/M)
#           5. SF Symbols audit: check-sfsymbols (WARN-only discovery)
#           6. Swift Package Manager tests (swift test)
#           7. Xcode build (xcodebuild)
#
# Pattern : Matches OYL scripts/ convention — one script to run everything.
#           CI/CD, pre-release, and developer "is this shippable?" checks
#           all go through this single entry point.
#
# Usage   : ./scripts/test.sh [options] [source-root]
#
# Options :
#   --lint-only    Run only the 3 Promise lint checks (skip build/test)
#   --build-only   Run only SPM test + Xcode build (skip lint)
#   --scheme NAME  Xcode scheme name (default: auto-detected)
#   --config NAME  Xcode build configuration (default: Debug)
#   -h, --help     Show this help
#
# Exit    : 0 = all checks passed, 1 = one or more checks failed
# =============================================================================
set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[PASS]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()  { echo -e "${RED}[FAIL]${NC} $*"; }
step()  { echo -e "${CYAN}[STEP]${NC} $*"; }
header(){ echo -e "\n${YELLOW}━━━ $* ━━━${NC}"; }
hr()    { echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# ── Arg parsing ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT=""
LINT_ONLY=false
BUILD_ONLY=false
XCODE_SCHEME=""
XCODE_CONFIG="Debug"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --lint-only)   LINT_ONLY=true; shift ;;
    --build-only)  BUILD_ONLY=true; shift ;;
    --scheme)      XCODE_SCHEME="$2"; shift 2 ;;
    --config)      XCODE_CONFIG="$2"; shift 2 ;;
    -h|--help)
      sed -n '/^# =/,/^# =/p' "$0" | grep '^#' | sed 's/^# \?//'
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2; exit 1 ;;
    *)
      SOURCE_ROOT="$1"; shift ;;
  esac
done

SOURCE_ROOT="${SOURCE_ROOT:-$(cd "${SCRIPT_DIR}/.." && pwd)}"

if [[ "$LINT_ONLY" == true && "$BUILD_ONLY" == true ]]; then
  fail "--lint-only and --build-only are mutually exclusive."
  exit 1
fi

# ── Timing helper ────────────────────────────────────────────────────────────
elapsed_since() {
  local start="$1"
  local end
  end=$(date +%s)
  echo "$(( end - start ))s"
}

# ── State tracking (bash 3.2 compatible — no associative arrays) ─────────────
# Each step result/time stored in a flat scalar: RESULT_<name>, TIME_<name>
OVERALL=0

set_result() { eval "RESULT_${1}=${2}"; }
set_time()   { eval "TIME_${1}=${2}"; }
get_result() { eval "echo \"\${RESULT_${1}:-SKIP}\""; }
get_time()   { eval "echo \"\${TIME_${1}:---}\""; }

run_step() {
  local name="$1"
  local label="$2"
  shift 2
  local cmd=("$@")

  header "$label"
  local start
  start=$(date +%s)

  if "${cmd[@]}"; then
    set_result "$name" "PASS"
    info "$label: PASSED"
  else
    set_result "$name" "FAIL"
    fail "$label: FAILED"
    OVERALL=1
  fi
  set_time "$name" "$(elapsed_since "$start")"
}

skip_step() {
  local name="$1"
  set_result "$name" "SKIP"
  set_time   "$name" "—"
}

# ── Xcode project/workspace detection ────────────────────────────────────────
detect_xcode_project() {
  local root="$1"

  # Prefer workspace
  local ws
  ws=$(find "$root" -maxdepth 2 -name "*.xcworkspace" \
         -not -path "*/\.build/*" -not -path "*/DerivedData/*" \
         -not -name "*.xcodeproj" 2>/dev/null | head -1 || true)
  if [[ -n "$ws" ]]; then
    echo "-workspace $ws"
    return
  fi

  # Fall back to project
  local proj
  proj=$(find "$root" -maxdepth 2 -name "*.xcodeproj" \
           -not -path "*/\.build/*" -not -path "*/DerivedData/*" \
           2>/dev/null | head -1 || true)
  if [[ -n "$proj" ]]; then
    echo "-project $proj"
    return
  fi

  echo ""
}

detect_xcode_scheme() {
  local xcode_arg="$1"
  # Try to list schemes and pick the first non-system one
  local scheme
  scheme=$(xcodebuild $xcode_arg -list 2>/dev/null \
             | awk '/Schemes:/,0' | grep -v "Schemes:" | grep -v "^$" \
             | head -1 | sed 's/^[[:space:]]*//' || true)
  echo "$scheme"
}

# ── Main ─────────────────────────────────────────────────────────────────────
SUITE_START=$(date +%s)

echo ""
hr
echo -e "  ${CYAN}Still Hours — Full Verification Suite${NC}"
echo -e "  Source: $SOURCE_ROOT"
echo -e "  Mode  : $([ "$LINT_ONLY" = true ] && echo 'Lint only' || ([ "$BUILD_ONLY" = true ] && echo 'Build only' || echo 'Full suite'))"
hr
echo ""

# ── Promise Lint steps ───────────────────────────────────────────────────────
if [[ "$BUILD_ONLY" == false ]]; then
  run_step "privacy"     "Privacy Lint (External Host Whitelist)" \
    bash "${SCRIPT_DIR}/check-privacy.sh" "$SOURCE_ROOT"

  run_step "sovereignty" "Data Sovereignty Lint (Encodable + VersionedSchema)" \
    bash "${SCRIPT_DIR}/check-data-sovereignty.sh" "$SOURCE_ROOT"

  run_step "no_sub"      "No-Subscription Lint (GOVERNANCE §5)" \
    bash "${SCRIPT_DIR}/check-no-subscription.sh" "$SOURCE_ROOT"

  run_step "i18n"        "i18n Lint (Axis A/B/J/M)" \
    bash "${SCRIPT_DIR}/check-i18n.sh" "$SOURCE_ROOT"

  run_step "sfsymbols"   "SF Symbols Audit (WARN-only)" \
    bash "${SCRIPT_DIR}/check-sfsymbols.sh" "$SOURCE_ROOT"
else
  skip_step "privacy"
  skip_step "sovereignty"
  skip_step "no_sub"
  skip_step "i18n"
  skip_step "sfsymbols"
fi

# ── SPM tests ────────────────────────────────────────────────────────────────
if [[ "$LINT_ONLY" == false ]]; then
  # Check if Package.swift exists
  if [[ -f "${SOURCE_ROOT}/Package.swift" ]]; then
    run_step "spm_test" "Swift Package Manager Tests (swift test)" \
      swift test --package-path "$SOURCE_ROOT"
  else
    warn "No Package.swift found — skipping 'swift test'."
    skip_step "spm_test"
  fi

  # ── Xcode build ────────────────────────────────────────────────────────────
  XCODE_ARG=$(detect_xcode_project "$SOURCE_ROOT")

  if [[ -z "$XCODE_ARG" ]]; then
    warn "No .xcworkspace or .xcodeproj found — skipping 'xcodebuild'."
    skip_step "xcode_build"
  else
    # Auto-detect scheme if not specified
    if [[ -z "$XCODE_SCHEME" ]]; then
      XCODE_SCHEME=$(detect_xcode_scheme "$XCODE_ARG")
    fi

    if [[ -z "$XCODE_SCHEME" ]]; then
      warn "Could not detect Xcode scheme — skipping 'xcodebuild'."
      warn "Specify with: ./scripts/test.sh --scheme YourSchemeName"
      skip_step "xcode_build"
    else
      step "Xcode project: $XCODE_ARG"
      step "Scheme       : $XCODE_SCHEME"
      step "Config       : $XCODE_CONFIG"
      run_step "xcode_build" "Xcode Build (xcodebuild)" \
        xcodebuild \
          $XCODE_ARG \
          -scheme "$XCODE_SCHEME" \
          -configuration "$XCODE_CONFIG" \
          -destination "generic/platform=iOS Simulator" \
          CODE_SIGNING_ALLOWED=NO \
          build \
          | grep -E "^(Build|error:|warning:|note:|\s*(error|warning):)" \
          | grep -v "^$" \
          || true
    fi
  fi
else
  skip_step "spm_test"
  skip_step "xcode_build"
fi

# ── Results table ─────────────────────────────────────────────────────────────
SUITE_END=$(date +%s)
SUITE_ELAPSED=$(( SUITE_END - SUITE_START ))

echo ""
hr
echo -e "  ${CYAN}Results${NC}"
hr
echo ""
printf "  %-40s %-8s %s\n" "Check" "Result" "Time"
printf "  %-40s %-8s %s\n" "─────────────────────────────────────" "──────" "────"

print_row() {
  local name="$1"
  local label="$2"
  local result; result=$(get_result "$name")
  local elapsed; elapsed=$(get_time "$name")

  local color="$NC"
  case "$result" in
    PASS) color="$GREEN" ;;
    FAIL) color="$RED"   ;;
    SKIP) color="$YELLOW";;
  esac
  printf "  %-40s ${color}%-8s${NC} %s\n" "$label" "$result" "$elapsed"
}

print_row "privacy"     "Privacy Lint"
print_row "sovereignty" "Data Sovereignty Lint"
print_row "no_sub"      "No-Subscription Lint"
print_row "i18n"        "i18n Lint (Axis A/B/J/M)"
print_row "sfsymbols"   "SF Symbols Audit"
print_row "spm_test"    "SPM Tests (swift test)"
print_row "xcode_build" "Xcode Build"

echo ""
echo -e "  Total time: ${SUITE_ELAPSED}s"
echo ""

if [[ $OVERALL -eq 0 ]]; then
  hr
  info "All checks PASSED — this codebase is shippable."
  hr
  exit 0
else
  hr
  fail "One or more checks FAILED — see output above."
  hr
  exit 1
fi
