#!/usr/bin/env bash
# launch-sim.sh — dev-time simulator launch helper for Own Your Curation
#
# Usage:
#   ./scripts/launch-sim.sh
#   DEVICE_NAME="iPad Pro 11-inch" ./scripts/launch-sim.sh
#
# What it does:
#   1. Sources .env from repo root (NAVER_CLIENT_ID, NAVER_CLIENT_SECRET, KOBIS_API_KEY)
#   2. Locates StillHours.app in DerivedData via xcodebuild -showBuildSettings
#   3. Boots the target simulator if needed
#   4. Uninstalls + installs the app (clean state)
#   5. Launches with API keys injected into NSUserDefaults via simctl -KEY VALUE flags
#   6. Always injects Korean locale (-AppleLanguages / -AppleLocale)
#
# Requires: xcodebuild, xcrun (Xcode Command Line Tools)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUNDLE_ID="com.ownlifelab.stillhours"
DEVICE_NAME="${DEVICE_NAME:-iPhone 17 Pro}"

# ── 1. Source .env ──────────────────────────────────────────────────────────
ENV_FILE="${REPO_ROOT}/.env"
if [[ -f "${ENV_FILE}" ]]; then
    echo "[launch-sim] Sourcing ${ENV_FILE}"
    # shellcheck disable=SC1090
    set -a
    source "${ENV_FILE}"
    set +a
else
    echo "[launch-sim] Warning: no .env found at ${ENV_FILE} — will use mock providers"
fi

# ── 2. Find StillHours.app in DerivedData ───────────────────────────────────
echo "[launch-sim] Resolving BUILT_PRODUCTS_DIR..."
BUILD_SETTINGS="$(
    xcodebuild \
        -project "${REPO_ROOT}/StillHours.xcodeproj" \
        -scheme StillHours \
        -configuration Debug \
        -sdk iphonesimulator \
        -showBuildSettings 2>/dev/null
)"

BUILT_DIR="$(echo "${BUILD_SETTINGS}" | grep -m1 'BUILT_PRODUCTS_DIR' | awk -F' = ' '{print $2}' | xargs)"
APP_PATH="${BUILT_DIR}/StillHours.app"

if [[ ! -d "${APP_PATH}" ]]; then
    echo "[launch-sim] App not found at: ${APP_PATH}"
    echo "[launch-sim] Run: xcodebuild -project StillHours.xcodeproj -scheme StillHours -configuration Debug -sdk iphonesimulator -destination 'platform=iOS Simulator,name=${DEVICE_NAME}' build"
    exit 1
fi
echo "[launch-sim] Found app: ${APP_PATH}"

# ── 3. Pick simulator UDID ──────────────────────────────────────────────────
echo "[launch-sim] Looking for simulator: ${DEVICE_NAME}"
DEVICE_UDID="$(
    xcrun simctl list devices available -j \
    | python3 -c "
import json, sys
data = json.load(sys.stdin)
target = '${DEVICE_NAME}'.lower()
for runtime, devices in data.get('devices', {}).items():
    for d in devices:
        if d.get('isAvailable') and target in d.get('name','').lower():
            print(d['udid'])
            sys.exit(0)
" 2>/dev/null || true
)"

if [[ -z "${DEVICE_UDID}" ]]; then
    echo "[launch-sim] Error: no available simulator matching '${DEVICE_NAME}'"
    echo "[launch-sim] Available simulators:"
    xcrun simctl list devices available | grep -v "^==" | grep -v "^--" | grep "(" | head -20
    exit 1
fi
echo "[launch-sim] Using UDID: ${DEVICE_UDID}"

# ── 4. Boot if needed ───────────────────────────────────────────────────────
DEVICE_STATE="$(xcrun simctl list devices -j | python3 -c "
import json, sys
data = json.load(sys.stdin)
for runtime, devices in data.get('devices', {}).items():
    for d in devices:
        if d['udid'] == '${DEVICE_UDID}':
            print(d['state'])
            sys.exit(0)
" 2>/dev/null || echo "Shutdown")"

if [[ "${DEVICE_STATE}" != "Booted" ]]; then
    echo "[launch-sim] Booting simulator..."
    xcrun simctl boot "${DEVICE_UDID}"
    open -a Simulator
    sleep 3
else
    echo "[launch-sim] Simulator already booted"
fi

# ── 5. Uninstall + install (clean state) ────────────────────────────────────
echo "[launch-sim] Uninstalling previous build..."
xcrun simctl uninstall "${DEVICE_UDID}" "${BUNDLE_ID}" 2>/dev/null || true

echo "[launch-sim] Installing ${APP_PATH}..."
xcrun simctl install "${DEVICE_UDID}" "${APP_PATH}"

# ── 6. Build launch args ────────────────────────────────────────────────────
LAUNCH_ARGS=()

# Naver: needs both ID + Secret
if [[ -n "${NAVER_CLIENT_ID:-}" && -n "${NAVER_CLIENT_SECRET:-}" ]]; then
    echo "[launch-sim] Injecting NAVER keys"
    LAUNCH_ARGS+=(-NAVER_CLIENT_ID "${NAVER_CLIENT_ID}" -NAVER_CLIENT_SECRET "${NAVER_CLIENT_SECRET}")
else
    echo "[launch-sim] NAVER keys not set — Naver providers will use mock"
fi

# KOBIS: standalone OK
if [[ -n "${KOBIS_API_KEY:-}" ]]; then
    echo "[launch-sim] Injecting KOBIS_API_KEY"
    LAUNCH_ARGS+=(-KOBIS_API_KEY "${KOBIS_API_KEY}")
else
    echo "[launch-sim] KOBIS_API_KEY not set — film provider will use mock"
fi

# TMDB: skip (user decision — not wired in makeDefault)

# Always inject Korean locale
LAUNCH_ARGS+=(-AppleLanguages "(ko)" -AppleLocale "ko_KR")

# ── 7. Launch ───────────────────────────────────────────────────────────────
echo "[launch-sim] Launching ${BUNDLE_ID}..."
xcrun simctl launch "${DEVICE_UDID}" "${BUNDLE_ID}" "${LAUNCH_ARGS[@]}"

echo "[launch-sim] Done. Real providers active where keys were injected."
