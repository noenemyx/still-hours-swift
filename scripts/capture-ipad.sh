#!/usr/bin/env bash
# =============================================================================
# capture-ipad.sh — iPad Post-Onboarding Visual Verification
#
# Purpose : Capture the post-onboarding app state (LibraryListView + DemoSeeder
#           items) on an iPad Pro simulator in light + dark × ko locale.
#
#           Mirrors the structure of capture-post-onboarding.sh (iPhone variant)
#           but targets iPad Pro 13-inch (M4/M5) by default. Use --device to
#           select a specific iPad model.
#
# Axes honoured:
#   Axis E  — pipefail + grep -v chains wrapped in set +o pipefail guards
#   Axis K  — SpringBoard kickstart -k restart after defaults write
#   Axis L  — -AppleLanguages / -AppleLocale launch args for guaranteed locale
#
# Usage   : ./scripts/capture-ipad.sh [options]
#
# Options :
#   --device NAME      Simulator device name
#                      (default: "iPad Pro 13-inch (M4)")
#   --bundle ID        App bundle identifier
#                      (default: com.ownlifelab.stillhours)
#   --app-path PATH    Path to .app bundle
#                      (default: /tmp/StillHours-iPad-DD/Build/Products/
#                               Debug-iphonesimulator/StillHours.app)
#   --output-dir DIR   Directory for screenshots (default: /tmp)
#   --skip-build       Install + screenshot only; assume .app already exists
#   -h|--help          Show this help and exit
#
# Output filenames:
#   <output-dir>/stillhours-R13-ipad-light-ko-library.png
#   <output-dir>/stillhours-R13-ipad-dark-ko-library.png
#
# SpringBoard restart pattern (Axis K):
#   After `xcrun simctl spawn <udid> defaults write`, SpringBoard must be
#   restarted for the change to take effect. Command:
#     xcrun simctl spawn <UDID> launchctl kickstart -k system/com.apple.SpringBoard
#   Wait 4 seconds after kickstart before attempting launch.
#   Do NOT use `simctl reboot` (too slow) or `simctl shutdown` + `simctl boot`
#   (loses installed app state).
#
# Axis E — pipefail guard:
#   Any grep -v chain that may produce 0 output lines is wrapped in
#   `set +o pipefail` ... `set -o pipefail`.
#
# Axis L — locale launch args:
#   `-AppleLanguages "(ko)"` / `-AppleLocale ko_KR` are passed as launch
#   arguments at process start to guarantee the correct locale regardless of
#   cached bundle state.
#
# Created : 2026-05-21 (R13.2)
# Exit    : 0 = both screenshots captured, 1 = any failure
# =============================================================================
set -euo pipefail

# ── Colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()   { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()   { echo -e "${YELLOW}[WARN]${NC} $*"; }
fail()   { echo -e "${RED}[FAIL]${NC} $*"; }
step()   { echo -e "${CYAN}[STEP]${NC} $*"; }
header() { echo -e "\n${YELLOW}==> $*${NC}"; }
hr()     { echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"; }

# ── Defaults ────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DEVICE_NAME="iPad Pro 13-inch (M4)"
BUNDLE_ID="com.ownlifelab.stillhours"
APP_PATH="/tmp/StillHours-iPad-DD/Build/Products/Debug-iphonesimulator/StillHours.app"
OUTPUT_DIR="/tmp"
SKIP_BUILD=false

# ── Arg parsing ─────────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --device)
      DEVICE_NAME="$2"; shift 2 ;;
    --bundle)
      BUNDLE_ID="$2"; shift 2 ;;
    --app-path)
      APP_PATH="$2"; shift 2 ;;
    --output-dir)
      OUTPUT_DIR="$2"; shift 2 ;;
    --skip-build)
      SKIP_BUILD=true; shift ;;
    -h|--help)
      awk 'NR>1 && /^[^#]/{exit} NR>1{sub(/^# ?/,""); print}' "$0"
      exit 0 ;;
    *)
      fail "Unknown option: $1"
      echo "Run with -h for usage." >&2
      exit 1 ;;
  esac
done

# ── Derived paths ─────────────────────────────────────────────────────────────
DERIVED_DATA_PATH="/tmp/StillHours-iPad-DD"
PROJECT_YML="${SOURCE_ROOT}/project.yml"

# ── Step 1 — Discover + boot simulator ───────────────────────────────────────
header "Step 1 — Simulator: ${DEVICE_NAME}"

set +o pipefail
SIM_UDID=$(xcrun simctl list devices available --json 2>/dev/null \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
name = '${DEVICE_NAME}'
for runtime, devices in data.get('devices', {}).items():
    for d in devices:
        if d.get('name') == name and d.get('isAvailable', False):
            print(d['udid'])
            sys.exit(0)
" 2>/dev/null || true)
set -o pipefail

if [[ -z "$SIM_UDID" ]]; then
  fail "iPad simulator not found: '${DEVICE_NAME}'"
  echo ""
  echo "  Diagnostic — available iPad devices:"
  set +o pipefail
  xcrun simctl list devices available 2>/dev/null | grep -i "ipad" | head -10 || true
  set -o pipefail
  echo ""
  echo "  Tip: pass a different model with --device, e.g.:"
  echo "       --device 'iPad Pro 13-inch (M5)'"
  echo "       --device 'iPad Pro 11-inch (M4)'"
  exit 1
fi

info "Device UDID: ${SIM_UDID}"

# Check current state
set +o pipefail
SIM_STATE=$(xcrun simctl list devices --json 2>/dev/null \
  | python3 -c "
import json, sys
data = json.load(sys.stdin)
for runtime, devices in data.get('devices', {}).items():
    for d in devices:
        if d.get('udid') == '${SIM_UDID}':
            print(d.get('state', 'Unknown'))
            sys.exit(0)
print('Unknown')
" 2>/dev/null || echo "Unknown")
set -o pipefail

if [[ "$SIM_STATE" == "Booted" ]]; then
  info "Simulator already booted — continuing."
else
  step "Booting simulator..."
  xcrun simctl boot "${SIM_UDID}"
  local_wait=0
  while [[ $local_wait -lt 30 ]]; do
    set +o pipefail
    CURRENT_STATE=$(xcrun simctl list devices --json 2>/dev/null \
      | python3 -c "
import json, sys
data = json.load(sys.stdin)
for runtime, devices in data.get('devices', {}).items():
    for d in devices:
        if d.get('udid') == '${SIM_UDID}':
            print(d.get('state', 'Unknown'))
            sys.exit(0)
print('Unknown')
" 2>/dev/null || echo "Unknown")
    set -o pipefail
    if [[ "$CURRENT_STATE" == "Booted" ]]; then
      break
    fi
    sleep 1
    (( local_wait++ )) || true
  done
  info "Simulator booted."
fi

open -a Simulator 2>/dev/null || warn "Could not open Simulator.app (continuing)."

# ── Step 2 — Build (unless --skip-build) ────────────────────────────────────
if [[ "$SKIP_BUILD" == false ]]; then
  header "Step 2 — Build"

  if [[ ! -f "$PROJECT_YML" ]]; then
    fail "project.yml not found at: ${PROJECT_YML}"
    exit 1
  fi

  step "Running xcodegen generate..."
  xcodegen generate --spec "${PROJECT_YML}" --project "${SOURCE_ROOT}" 2>&1 \
    || { fail "xcodegen generate failed."; exit 1; }

  XCODE_PROJECT_ARG=""
  set +o pipefail
  WS=$(find "${SOURCE_ROOT}" -maxdepth 2 -name "*.xcworkspace" \
         -not -path "*/\.build/*" -not -path "*/DerivedData/*" \
         -not -name "*.xcodeproj" 2>/dev/null | head -1 || true)
  set -o pipefail

  if [[ -n "$WS" ]]; then
    XCODE_PROJECT_ARG="-workspace ${WS}"
  else
    set +o pipefail
    PROJ=$(find "${SOURCE_ROOT}" -maxdepth 2 -name "*.xcodeproj" \
               -not -path "*/\.build/*" -not -path "*/DerivedData/*" \
               2>/dev/null | head -1 || true)
    set -o pipefail
    if [[ -n "$PROJ" ]]; then
      XCODE_PROJECT_ARG="-project ${PROJ}"
    else
      fail "No .xcworkspace or .xcodeproj found in ${SOURCE_ROOT}"
      exit 1
    fi
  fi

  set +o pipefail
  XCODE_SCHEME=$(xcodebuild ${XCODE_PROJECT_ARG} -list 2>/dev/null \
    | awk '/Schemes:/,0' \
    | grep -v "Schemes:" \
    | grep -v "^$" \
    | head -1 \
    | sed 's/^[[:space:]]*//' || true)
  set -o pipefail

  if [[ -z "$XCODE_SCHEME" ]]; then
    fail "Could not detect Xcode scheme."
    exit 1
  fi

  step "Building scheme: ${XCODE_SCHEME} for iPad (${SIM_UDID})"

  xcodebuild \
    ${XCODE_PROJECT_ARG} \
    -scheme "${XCODE_SCHEME}" \
    -configuration Debug \
    -destination "platform=iOS Simulator,id=${SIM_UDID}" \
    -derivedDataPath "${DERIVED_DATA_PATH}" \
    CODE_SIGNING_ALLOWED=NO \
    build \
    | grep -E "^(Build|error:|warning:|note:|.*FAILED|.*BUILD SUCCEEDED)" \
    | grep -v "^$" \
    || true

  if [[ ! -d "$APP_PATH" ]]; then
    fail ".app not found after build: ${APP_PATH}"
    echo "       Tip: check DerivedData at ${DERIVED_DATA_PATH}"
    exit 1
  fi
  info "Build succeeded: ${APP_PATH}"
else
  header "Step 2 — Build (SKIPPED via --skip-build)"
  if [[ ! -d "$APP_PATH" ]]; then
    fail ".app not found at: ${APP_PATH}"
    echo "       Either run without --skip-build, or supply the correct path with --app-path."
    exit 1
  fi
  info "Using existing .app: ${APP_PATH}"
fi

# ── Step 3 — Install ──────────────────────────────────────────────────────────
header "Step 3 — Install"
step "Installing ${APP_PATH} to ${SIM_UDID}..."
xcrun simctl install "${SIM_UDID}" "${APP_PATH}"
info "App installed."

# ── Helpers ──────────────────────────────────────────────────────────────────

# Write hasCompletedOnboarding = true for the given UDID.
# Must be called BEFORE launch so ContentView skips OnboardingFlow.
set_onboarding_complete() {
  step "Setting hasCompletedOnboarding = true..."
  xcrun simctl spawn "${SIM_UDID}" defaults write "${BUNDLE_ID}" hasCompletedOnboarding -bool true
  info "Onboarding gate bypassed."
}

# Restart SpringBoard (Axis K pattern).
# Required after appearance or locale defaults writes to take effect without
# a full device reboot. 4-second post-kickstart wait is mandatory.
restart_springboard() {
  step "Restarting SpringBoard (Axis K)..."
  xcrun simctl spawn "${SIM_UDID}" launchctl kickstart -k system/com.apple.SpringBoard 2>/dev/null || true
  sleep 4
  info "SpringBoard ready."
}

# Terminate app if running.
terminate_app() {
  step "Terminating ${BUNDLE_ID} (if running)..."
  xcrun simctl terminate "${SIM_UDID}" "${BUNDLE_ID}" 2>/dev/null || true
}

# Capture one appearance variant: light-ko or dark-ko.
capture_variant() {
  local appearance="$1"   # light | dark
  local label="ipad-${appearance}-ko"
  local out_file="${OUTPUT_DIR}/stillhours-R13-${label}-library.png"

  header "Variant: ${label}"

  # 1. Set appearance
  step "Setting appearance: ${appearance}"
  if xcrun simctl ui "${SIM_UDID}" appearance "${appearance}" 2>/dev/null; then
    info "Appearance set to ${appearance} via simctl ui."
  else
    warn "simctl ui appearance not supported — using defaults write fallback."
    if [[ "$appearance" == "dark" ]]; then
      xcrun simctl spawn "${SIM_UDID}" defaults write -g AppleInterfaceStyle Dark 2>/dev/null || true
    else
      xcrun simctl spawn "${SIM_UDID}" defaults delete -g AppleInterfaceStyle 2>/dev/null || true
    fi
  fi

  # 2. Terminate + SpringBoard restart so appearance change lands cleanly.
  terminate_app
  restart_springboard

  # 3. Set hasCompletedOnboarding AFTER SpringBoard restart, BEFORE launch.
  set_onboarding_complete

  # 4. Launch with explicit ko locale (Axis L).
  step "Launching ${BUNDLE_ID} (ko, ${appearance})..."
  xcrun simctl launch "${SIM_UDID}" "${BUNDLE_ID}" \
    -AppleLanguages "(ko)" \
    -AppleLocale ko_KR

  # 5. Wait for first frame + DemoSeeder hydration.
  step "Waiting 5s for first frame + DemoSeeder..."
  sleep 5

  # 6. Capture.
  step "Capturing screenshot -> ${out_file}"
  xcrun simctl io "${SIM_UDID}" screenshot "${out_file}"

  if [[ -f "$out_file" ]]; then
    info "Captured: ${out_file}"
  else
    fail "Screenshot not found after capture: ${out_file}"
    exit 1
  fi
}

# ── Step 4 — Capture light + dark ─────────────────────────────────────────────
header "Step 4 — Capture (LibraryListView, ko)"
capture_variant "light"
capture_variant "dark"

# ── Step 5 — Summary ──────────────────────────────────────────────────────────
header "Step 5 — Summary"
hr
echo ""
echo "  R13.2 — iPad Screenshots (LibraryListView, ko):"
echo ""

for mode in light dark; do
  path="${OUTPUT_DIR}/stillhours-R13-ipad-${mode}-ko-library.png"
  if [[ -f "$path" ]]; then
    set +o pipefail
    SIZE_BYTES=$(stat -f%z "$path" 2>/dev/null || stat -c%s "$path" 2>/dev/null || echo "0")
    set -o pipefail
    SIZE_KB=$(( SIZE_BYTES / 1024 ))
    printf "    %-60s (%s KB)\n" "$path" "$SIZE_KB"
  fi
done

echo ""
echo "  Open in Preview: open ${OUTPUT_DIR}/stillhours-R13-ipad-*-library.png"
echo ""
hr
info "iPad visual verification complete. (R13.2)"
hr
