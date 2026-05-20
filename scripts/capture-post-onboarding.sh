#!/usr/bin/env bash
# =============================================================================
# capture-post-onboarding.sh — Post-Onboarding 4-Quadrant Visual Verification
#
# Purpose : Capture the post-onboarding app state (LibraryListView + DemoSeeder
#           items) in the full 4-quadrant matrix: light/dark × ko/en.
#
#           WHY this script exists separately from capture-screenshots.sh:
#           ContentView gates the main TabView behind an @AppStorage flag
#           ("hasCompletedOnboarding"). capture-screenshots.sh captures the
#           ONBOARDING screens (screen 1/2/3). This script sets the flag to
#           true BEFORE launch so the app starts directly in LibraryListView,
#           letting us verify that the post-R11 Cool Blue palette propagated
#           into the entire app — not just the onboarding flow.
#
# Quadrants:
#   light-ko  — light mode, Korean locale
#   light-en  — light mode, English locale
#   dark-ko   — dark mode, Korean locale
#   dark-en   — dark mode, English locale
#
# Usage   : ./scripts/capture-post-onboarding.sh [options]
#
# Options :
#   --device NAME      Simulator device name (default: "iPhone 17 Pro")
#   --bundle ID        App bundle identifier (default: com.ownlifelab.stillhours)
#   --app-path PATH    Path to .app bundle (default: /tmp/StillHours-MS-DD/Build/Products/Debug-iphonesimulator/StillHours.app)
#   --output-dir DIR   Directory for screenshots (default: /tmp)
#   --skip-build       Install + screenshot only; assume .app already exists
#   --single MODE      Capture only one quadrant: light-en|light-ko|dark-en|dark-ko
#   -h|--help          Show this help and exit
#
# Output filenames: /tmp/stillhours-R12-{light|dark}-{en|ko}-library.png
#
# SpringBoard restart pattern (Axis K):
#   After changing locale/appearance via `xcrun simctl spawn booted defaults write`,
#   SpringBoard must be restarted for the change to take effect. The correct
#   command is `xcrun simctl spawn booted launchctl kickstart -k
#   system/com.apple.SpringBoard`. Do NOT use `simctl reboot` (too slow) or
#   `simctl shutdown` + `simctl boot` (loses installed app state). A 4-second
#   wait after the kickstart is required for SpringBoard to finish loading before
#   the app can be launched cleanly.
#
# Axis E — pipefail + grep -v pattern:
#   Any grep -v chain that may produce 0 output lines is wrapped in
#   `set +o pipefail` ... `set -o pipefail` per lessons-learned Axis E.
#
# Axis L — locale launch args:
#   `-AppleLanguages "(ko)"` / `-AppleLocale ko_KR` are passed as launch
#   arguments at process start to guarantee the correct locale regardless of
#   cached bundle state.
#
# Created : 2026-05-21 (R12.1)
# Exit    : 0 = all quadrants captured successfully, 1 = any failure
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

DEVICE_NAME="iPhone 17 Pro"
BUNDLE_ID="com.ownlifelab.stillhours"
APP_PATH="/tmp/StillHours-MS-DD/Build/Products/Debug-iphonesimulator/StillHours.app"
OUTPUT_DIR="/tmp"
SKIP_BUILD=false
SINGLE_MODE=""

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
    --single)
      SINGLE_MODE="$2"
      case "$SINGLE_MODE" in
        light-en|light-ko|dark-en|dark-ko) ;;
        *)
          fail "--single must be one of: light-en, light-ko, dark-en, dark-ko"
          exit 1 ;;
      esac
      shift 2 ;;
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
DERIVED_DATA_PATH="/tmp/StillHours-MS-DD"
PROJECT_YML="${SOURCE_ROOT}/project.yml"

# ── Step 1 — Boot / verify simulator ─────────────────────────────────────────
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
  fail "Device not found: '${DEVICE_NAME}'"
  echo "       Available devices:"
  xcrun simctl list devices available 2>/dev/null | grep -E "iPhone|iPad" | head -10 || true
  exit 1
fi

info "Device UDID: ${SIM_UDID}"

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
    fail "Could not detect Xcode scheme. Specify with: xcodebuild -list"
    exit 1
  fi

  step "Building scheme: ${XCODE_SCHEME}"
  step "DerivedData: ${DERIVED_DATA_PATH}"

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
step "Installing ${APP_PATH} to booted simulator..."
xcrun simctl install booted "${APP_PATH}"
info "App installed."

# ── Helper: set hasCompletedOnboarding = true ─────────────────────────────────
set_onboarding_complete() {
  # Write the UserDefaults flag that ContentView's @AppStorage("hasCompletedOnboarding")
  # reads on launch. Setting this before each launch bypasses the OnboardingFlow
  # and drops us directly into the LibraryListView + TabView.
  step "Setting hasCompletedOnboarding = true (bypass onboarding gate)..."
  xcrun simctl spawn booted defaults write "${BUNDLE_ID}" hasCompletedOnboarding -bool true
  info "Onboarding gate bypassed."
}

# ── Helper: restart SpringBoard (Axis K pattern) ─────────────────────────────
restart_springboard() {
  step "Restarting SpringBoard..."
  xcrun simctl spawn booted launchctl kickstart -k system/com.apple.SpringBoard 2>/dev/null || true
  sleep 4
  info "SpringBoard ready."
}

# ── Helper: set appearance ────────────────────────────────────────────────────
set_appearance() {
  local mode="$1"   # "light" or "dark"
  step "Setting appearance: ${mode}"

  if xcrun simctl ui booted appearance "${mode}" 2>/dev/null; then
    info "Appearance set to ${mode} via simctl ui."
  else
    warn "simctl ui appearance not supported — using defaults write fallback."
    if [[ "$mode" == "dark" ]]; then
      xcrun simctl spawn booted defaults write -g AppleInterfaceStyle Dark 2>/dev/null || true
    else
      xcrun simctl spawn booted defaults delete -g AppleInterfaceStyle 2>/dev/null || true
    fi
  fi
}

# ── Helper: set locale ────────────────────────────────────────────────────────
set_locale() {
  local lang_tag="$1"   # "ko" or "en"

  if [[ "$lang_tag" == "ko" ]]; then
    local apple_locale="ko_KR"
    local apple_languages="ko"
  else
    local apple_locale="en_US"
    local apple_languages="en"
  fi

  step "Setting locale: ${apple_locale} / language: ${apple_languages}"

  if xcrun simctl spawn booted defaults write -g AppleLocale "${apple_locale}" 2>/dev/null \
     && xcrun simctl spawn booted defaults write -g AppleLanguages -array "${apple_languages}" 2>/dev/null; then
    info "Locale set: ${apple_locale}."
  else
    warn "Locale setting failed or partially applied — continuing."
  fi
}

# ── Helper: terminate app ─────────────────────────────────────────────────────
terminate_app() {
  step "Terminating ${BUNDLE_ID} (if running)..."
  xcrun simctl terminate booted "${BUNDLE_ID}" 2>/dev/null || true
}

# ── Helper: capture one quadrant ─────────────────────────────────────────────
capture_quadrant() {
  local appearance="$1"   # light | dark
  local lang="$2"         # en | ko
  local label="${appearance}-${lang}"
  local out_file="${OUTPUT_DIR}/stillhours-R12-${label}-library.png"

  header "Quadrant: ${label}"

  # 1. Set appearance
  set_appearance "${appearance}"

  # 2. Set locale
  set_locale "${lang}"

  # 3. Terminate + restart SpringBoard (Axis K pattern)
  terminate_app
  restart_springboard

  # 4. Set hasCompletedOnboarding AFTER SpringBoard restart but BEFORE launch.
  #    The flag must be written while the simulator is settled so the app
  #    process reads the correct value on cold start.
  set_onboarding_complete

  # 5. Launch app with explicit locale override at process start (Axis L pattern).
  step "Launching ${BUNDLE_ID} (locale: ${lang})..."
  if [[ "$lang" == "ko" ]]; then
    xcrun simctl launch booted "${BUNDLE_ID}" \
      -AppleLanguages "(ko)" \
      -AppleLocale ko_KR
  else
    xcrun simctl launch booted "${BUNDLE_ID}" \
      -AppleLanguages "(en)" \
      -AppleLocale en_US
  fi

  # 6. Wait for first frame + DemoSeeder hydration
  step "Waiting 5s for first frame + DemoSeeder hydration..."
  sleep 5

  # 7. Screenshot
  step "Capturing screenshot -> ${out_file}"
  xcrun simctl io booted screenshot "${out_file}"

  if [[ -f "$out_file" ]]; then
    info "Captured: ${out_file}"
  else
    fail "Screenshot not found after capture: ${out_file}"
    exit 1
  fi
}

# ── Step 4 — Capture quadrants ────────────────────────────────────────────────
header "Step 4 — Capture (post-onboarding: LibraryListView)"

QUAD_APPEARANCES=("light" "light" "dark" "dark")
QUAD_LANGS=("ko"    "en"   "ko"   "en")

if [[ -n "$SINGLE_MODE" ]]; then
  SINGLE_APPEARANCE="${SINGLE_MODE%%-*}"
  SINGLE_LANG="${SINGLE_MODE##*-}"
  info "Single mode: ${SINGLE_MODE}"
  capture_quadrant "${SINGLE_APPEARANCE}" "${SINGLE_LANG}"
else
  for i in 0 1 2 3; do
    capture_quadrant "${QUAD_APPEARANCES[$i]}" "${QUAD_LANGS[$i]}"
  done
fi

# ── Step 5 — Summary ──────────────────────────────────────────────────────────
header "Step 5 — Summary"
hr
echo ""
echo "  R12.1 — Post-Onboarding Screenshots (LibraryListView):"
echo ""

print_screenshot_row() {
  local appearance="$1"
  local lang="$2"
  local label="${appearance}-${lang}"
  local path="${OUTPUT_DIR}/stillhours-R12-${label}-library.png"

  if [[ -f "$path" ]]; then
    set +o pipefail
    SIZE_BYTES=$(stat -f%z "$path" 2>/dev/null || stat -c%s "$path" 2>/dev/null || echo "0")
    set -o pipefail
    SIZE_KB=$(( SIZE_BYTES / 1024 ))
    printf "    %-60s (%s KB)\n" "$path" "$SIZE_KB"
  fi
}

if [[ -n "$SINGLE_MODE" ]]; then
  SINGLE_APPEARANCE="${SINGLE_MODE%%-*}"
  SINGLE_LANG="${SINGLE_MODE##*-}"
  print_screenshot_row "${SINGLE_APPEARANCE}" "${SINGLE_LANG}"
else
  print_screenshot_row "light" "ko"
  print_screenshot_row "light" "en"
  print_screenshot_row "dark"  "ko"
  print_screenshot_row "dark"  "en"
fi

echo ""

if [[ -z "$SINGLE_MODE" ]]; then
  echo "  Open in Preview: open ${OUTPUT_DIR}/stillhours-R12-*-library.png"
else
  echo "  Open in Preview: open ${OUTPUT_DIR}/stillhours-R12-${SINGLE_MODE}-library.png"
fi

echo ""
hr
info "Visual verification complete. (R12.1 — Cool Blue post-onboarding)"
hr
