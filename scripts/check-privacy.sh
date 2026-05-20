#!/usr/bin/env bash
# =============================================================================
# check-privacy.sh — External Host Whitelist Lint
#
# Purpose : Scan Swift source for outbound HTTP connections. Any host not on
#           the approved whitelist causes a lint FAIL.
#
# Promise : GOVERNANCE §Privacy — "No undisclosed data transmission."
#           Only approved external services may be contacted at runtime.
#
# Approved hosts:
#   openlibrary.org       – Open Library books API
#   googleapis.com        – Google Books API
#   musicbrainz.org       – MusicBrainz audio metadata
#   themoviedb.org        – TMDB movie/TV metadata
#   wikipedia.org         – Wikipedia article summaries
#   api.itunes.apple.com  – Apple Music search (Apple infra)
#
# Opt-out : Add `// LINT-IGNORE: Privacy` on the line or immediately above
#           the URL literal to suppress this check for that occurrence.
#
# Usage   : ./scripts/check-privacy.sh [source-root]
#           source-root defaults to the directory containing this script's
#           parent (project root heuristic).
#
# Exit    : 0 = all clear, 1 = violations found
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

ALLOWED_HOSTS=(
  "openlibrary.org"
  "googleapis.com"
  "musicbrainz.org"
  "themoviedb.org"
  "wikipedia.org"
  "api.itunes.apple.com"
)

# Patterns that suggest an outbound URL is being constructed or used
URL_PATTERNS=(
  'URL(string:'
  'URLRequest('
  'URLSession'
  'AF.request'
  'Alamofire'
  'dataTask'
  'uploadTask'
  'downloadTask'
  'URLComponents'
  'https://'
  'http://'
)

IGNORE_MARKER='LINT-IGNORE: Privacy'

# ── Helpers ─────────────────────────────────────────────────────────────────
is_allowed() {
  local url="$1"
  for host in "${ALLOWED_HOSTS[@]}"; do
    if echo "$url" | grep -qi "$host"; then
      return 0
    fi
  done
  return 1
}

# Returns true (0) if the given file:linenum has a LINT-IGNORE comment
# on the same line or the immediately preceding line.
has_ignore_comment() {
  local file="$1"
  local linenum="$2"
  local above=$(( linenum - 1 ))

  # Same line
  if sed -n "${linenum}p" "$file" | grep -q "$IGNORE_MARKER"; then
    return 0
  fi
  # Previous line
  if [[ $above -ge 1 ]]; then
    if sed -n "${above}p" "$file" | grep -q "$IGNORE_MARKER"; then
      return 0
    fi
  fi
  return 1
}

# ── Main ────────────────────────────────────────────────────────────────────

# ── Step 0 — Verify PrivacyInfo.xcprivacy ──────────────────────────────────
header "Privacy Manifest — PrivacyInfo.xcprivacy Verification"

PRIVACY_MANIFEST="${SOURCE_ROOT}/App/Resources/PrivacyInfo.xcprivacy"

if [[ ! -f "$PRIVACY_MANIFEST" ]]; then
  fail "PrivacyInfo.xcprivacy not found at: $PRIVACY_MANIFEST"
  echo "       Fix: Create App/Resources/PrivacyInfo.xcprivacy (required for iOS 17+ App Store submission)."
  echo "            See Apple documentation: https://developer.apple.com/documentation/bundleresources/privacy_manifest_files"
  exit 1
fi
info "PrivacyInfo.xcprivacy exists."

# Verify NSPrivacyTracking is false (Promise §5.3: No advertising · No data sale)
# We use grep for portability (plutil -p is macOS-only and may not be available in CI)
if grep -q "<key>NSPrivacyTracking</key>" "$PRIVACY_MANIFEST"; then
  # The line immediately after the key should contain <false/>
  TRACKING_VALUE=$(grep -A1 "<key>NSPrivacyTracking</key>" "$PRIVACY_MANIFEST" | tail -1 | tr -d '[:space:]')
  if [[ "$TRACKING_VALUE" == "<false/>" ]]; then
    info "NSPrivacyTracking = false (Promise §5.3 compliant)."
  else
    fail "NSPrivacyTracking is NOT false in PrivacyInfo.xcprivacy."
    echo "       Found: $TRACKING_VALUE"
    echo "       Promise §5.3 (No advertising · No data sale) forbids tracking permanently."
    echo "       Fix: Set <key>NSPrivacyTracking</key><false/> in PrivacyInfo.xcprivacy."
    echo "            Any change to true requires an explicit Promise amendment decision — not a routine code change."
    exit 1
  fi
else
  fail "NSPrivacyTracking key is missing from PrivacyInfo.xcprivacy."
  echo "       Fix: Add <key>NSPrivacyTracking</key><false/> to PrivacyInfo.xcprivacy."
  exit 1
fi

echo ""

header "Privacy Lint — External Host Whitelist"
echo "Source root : $SOURCE_ROOT"
echo "Allowed hosts: ${ALLOWED_HOSTS[*]}"
echo ""

violations=0
checked_files=0

# Build a combined grep pattern for URL indicators (BSD-compatible join)
combined_pattern=$(printf '%s|' "${URL_PATTERNS[@]}" | sed 's/|$//')

while IFS= read -r -d '' swift_file; do
  (( checked_files++ )) || true

  # Quick pre-filter: does this file mention any URL-like construct?
  if ! grep -qE "(https?://|URL\(string:|URLSession|URLRequest)" "$swift_file" 2>/dev/null; then
    continue
  fi

  # Extract lines with URL patterns including line numbers
  while IFS=: read -r linenum line; do
    [[ -z "$line" ]] && continue

    # Extract URL literal candidates: https://... or http://...
    # We capture everything after http(s):// until whitespace / quote / paren
    while IFS= read -r raw_url; do
      [[ -z "$raw_url" ]] && continue

      # Strip trailing punctuation
      url=$(echo "$raw_url" | sed 's/["\047)>].*$//' | sed 's/[[:space:]].*$//')
      [[ -z "$url" ]] && continue

      # Skip localhost / 127.0.0.1 / Apple system URLs (non-external)
      if echo "$url" | grep -qiE "(localhost|127\.0\.0\.1|0\.0\.0\.0|\.local|apple\.com/)" 2>/dev/null; then
        # Only skip apple.com sub-paths that are NOT the whitelisted one
        if ! echo "$url" | grep -qi "api.itunes.apple.com"; then
          continue
        fi
      fi

      # Check if URL is on the whitelist
      if ! is_allowed "$url"; then
        # Check for ignore comment
        if has_ignore_comment "$swift_file" "$linenum"; then
          warn "Suppressed (LINT-IGNORE): $swift_file:$linenum — $url"
          continue
        fi
        fail "Unapproved host in $swift_file:$linenum"
        echo "       URL: $url"
        echo "       Fix: Add host to ALLOWED_HOSTS in check-privacy.sh after security review,"
        echo "            or add '// LINT-IGNORE: Privacy' above the line if intentional."
        (( violations++ )) || true
      fi
    done < <(echo "$line" | grep -oE 'https?://[^[:space:]"'\'')<>]+' || true)

  done < <(grep -nE "(https?://|URL\(string:|URLSession|URLRequest)" "$swift_file" 2>/dev/null || true)

done < <(find "$SOURCE_ROOT" -name "*.swift" -not -path "*/\.*" -not -path "*/.build/*" -not -path "*/DerivedData/*" -print0)

echo ""
echo "Files scanned : $checked_files Swift files"
echo "Violations    : $violations"
echo ""

if [[ $violations -eq 0 ]]; then
  info "Privacy lint PASSED — all external hosts are approved."
  exit 0
else
  fail "Privacy lint FAILED — $violations unapproved host(s) found."
  echo ""
  echo "  Remediation options:"
  echo "  1. Remove the unapproved host from the code."
  echo "  2. Add the host to ALLOWED_HOSTS in this script after security review."
  echo "  3. Add '// LINT-IGNORE: Privacy' above the line if intentional."
  exit 1
fi
