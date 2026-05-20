#!/usr/bin/env bash
# =============================================================================
# check-no-subscription.sh — StoreKit Subscription Keyword Block (PERMANENT)
#
# Purpose : Scan Swift source and Info.plist for any StoreKit subscription
#           or recurring-payment keywords. ANY match causes a lint FAIL.
#
# Promise : GOVERNANCE §5 — "No subscription. No recurring charges.
#           The user pays once and owns the app forever."
#           This lint is a CODE-LEVEL ENFORCEMENT of that promise.
#           It is PERMANENT and must never be removed or weakened without
#           an explicit, documented decision by the product owner.
#
# History : Introduced in Pre-flight Week 1-3 (2026-05-20).
#           Maps to Promise 5조항 #5 (No subscription).
#           If you are reading this while tempted to remove this check:
#           the promise is to your users. They paid for lifetime access.
#
# Forbidden keywords (case-insensitive):
#   Product.SubscriptionInfo      – SwiftUI StoreKit subscription type
#   Product.SubscriptionPeriod    – subscription duration model
#   StoreKit.Subscription         – any StoreKit subscription namespace
#   recurring                     – recurring payment descriptor
#   autoRenewable                 – auto-renewing product type
#   Auto-Renewable                – App Store Connect product type string
#   consumable                    – consumable IAP (not a subscription but
#                                   signals IAP complexity; WARN only)
#   nonRenewable                  – non-renewing subscription
#   App Store Subscription        – App Store submission type string
#
# Note    : 'consumable' triggers a WARN (not FAIL) — consumable IAP is not
#           a subscription but its presence warrants review.
#
# Opt-out : Add `// LINT-IGNORE: NoSubscription` on the same line or the
#           immediately preceding line. Use only for test mocks, stub code
#           that is never shipped, or compile-time checks against the
#           existence of these APIs. Document WHY in the comment.
#
# Usage   : ./scripts/check-no-subscription.sh [source-root]
#           source-root defaults to project root (parent of scripts/).
#
# Exit    : 0 = all clear, 1 = one or more FAIL violations found
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

IGNORE_MARKER='LINT-IGNORE: NoSubscription'

# Keywords that are FAIL-level (subscription contracts)
declare -a FAIL_KEYWORDS=(
  "Product\.SubscriptionInfo"
  "Product\.SubscriptionPeriod"
  "StoreKit\.Subscription"
  "autoRenewable"
  "Auto-Renewable"
  "nonRenewable"
  "App Store Subscription"
)

# Regex union of all FAIL keywords for efficient search
FAIL_PATTERN="Product\.SubscriptionInfo|Product\.SubscriptionPeriod|StoreKit\.Subscription|autoRenewable|Auto-Renewable|nonRenewable|App Store Subscription"

# Keywords that are FAIL-level but need case-insensitive match
declare -a FAIL_KEYWORDS_CI=(
  "recurring"
)
FAIL_PATTERN_CI="recurring"

# Keywords that are WARN-level (IAP complexity; not a subscription but review)
WARN_PATTERN="consumable"

# ── Helpers ─────────────────────────────────────────────────────────────────
has_ignore_comment() {
  local file="$1"
  local linenum="$2"
  local above=$(( linenum - 1 ))
  if sed -n "${linenum}p" "$file" | grep -q "$IGNORE_MARKER"; then return 0; fi
  if [[ $above -ge 1 ]] && sed -n "${above}p" "$file" | grep -q "$IGNORE_MARKER"; then return 0; fi
  return 1
}

scan_file() {
  local file="$1"
  local pattern="$2"
  local level="$3"     # FAIL or WARN
  local ci_flag="$4"   # "" or "-i"
  local violations_ref="$5"  # name of caller's counter variable

  local grep_flags="-nE"
  [[ "$ci_flag" == "-i" ]] && grep_flags="-niE"

  while IFS=: read -r linenum line; do
    [[ -z "$linenum" ]] && continue
    # Skip pure comment lines (the ignore comment itself should pass)
    if echo "$line" | grep -qE '^\s*//'; then continue; fi

    if has_ignore_comment "$file" "$linenum"; then
      warn "Suppressed (LINT-IGNORE): $(basename "$file"):$linenum — matched '$pattern'"
      continue
    fi

    matched_term=$(echo "$line" | grep -oE $ci_flag "$pattern" | head -1 || true)

    if [[ "$level" == "FAIL" ]]; then
      fail "Forbidden subscription keyword in $file:$linenum"
      echo "       Matched  : '$matched_term'"
      echo "       Line     : $(echo "$line" | sed 's/^[[:space:]]*//')"
      echo "       Promise  : GOVERNANCE §5 — No subscription. This keyword is banned."
      echo "       Opt-out  : Add '// LINT-IGNORE: NoSubscription' above this line ONLY"
      echo "                  for test stubs or compile-time availability checks."
      eval "(( ${violations_ref}++ )) || true"
    else
      warn "IAP keyword review needed: $file:$linenum"
      echo "       Matched  : '$matched_term'"
      echo "       Line     : $(echo "$line" | sed 's/^[[:space:]]*//')"
      echo "       Action   : Confirm this is NOT a recurring/subscription product."
    fi
  done < <(grep $grep_flags "$pattern" "$file" 2>/dev/null || true)
}

# ── Main ────────────────────────────────────────────────────────────────────
header "No-Subscription Lint (PERMANENT — GOVERNANCE §5)"
echo ""
echo "  This lint enforces a permanent product promise:"
echo "  'Users pay once. No recurring charges. No subscriptions. Ever.'"
echo ""
echo "Source root : $SOURCE_ROOT"
echo ""

violations=0
scanned=0

# Gather all files to scan: Swift + plist
while IFS= read -r -d '' f; do
  (( scanned++ )) || true

  # ── FAIL-level patterns (case-sensitive) ─────────────────────────────────
  scan_file "$f" "$FAIL_PATTERN" "FAIL" "" "violations"

  # ── FAIL-level patterns (case-insensitive: "recurring") ──────────────────
  scan_file "$f" "$FAIL_PATTERN_CI" "FAIL" "-i" "violations"

  # ── WARN-level patterns ───────────────────────────────────────────────────
  # Only warn if not suppressed — no violation counter bump
  dummy=0
  scan_file "$f" "$WARN_PATTERN" "WARN" "-i" "dummy"

done < <(find "$SOURCE_ROOT" \
           \( -name "*.swift" -o -name "*.plist" -o -name "*.storekit" \) \
           -not -path "*/\.*" \
           -not -path "*/.build/*" \
           -not -path "*/DerivedData/*" \
           -not -path "*/\*.xcarchive/*" \
           -print0)

echo ""
echo "Files scanned : $scanned"
echo "Violations    : $violations"
echo ""

if [[ $violations -eq 0 ]]; then
  info "No-subscription lint PASSED — no forbidden keywords found."
  echo ""
  echo "  Promise §5 is intact: this codebase contains no subscription logic."
  exit 0
else
  fail "No-subscription lint FAILED — $violations forbidden keyword(s) found."
  echo ""
  echo "  ┌──────────────────────────────────────────────────────────────────┐"
  echo "  │  GOVERNANCE §5 VIOLATION                                        │"
  echo "  │                                                                  │"
  echo "  │  This project promises users a one-time purchase with no        │"
  echo "  │  recurring charges. Subscription APIs must not appear in the    │"
  echo "  │  shipped codebase.                                               │"
  echo "  │                                                                  │"
  echo "  │  To resolve:                                                     │"
  echo "  │  1. Remove the subscription code entirely (preferred).          │"
  echo "  │  2. Add // LINT-IGNORE: NoSubscription if this is a test stub  │"
  echo "  │     or compile-time availability guard (document why).          │"
  echo "  │  3. If the promise itself must change, this requires an         │"
  echo "  │     explicit product decision documented in GOVERNANCE.md.      │"
  echo "  └──────────────────────────────────────────────────────────────────┘"
  exit 1
fi
