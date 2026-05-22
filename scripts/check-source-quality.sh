#!/usr/bin/env bash
# check-source-quality.sh — Production source quality gates
# Catches TODO / HACK / FIXME markers that must be resolved before App Store submission.
# LINT-IGNORE markers are excluded from this check.
# Usage: bash scripts/check-source-quality.sh

set -euo pipefail

FAIL=0

# Paths to scan (production source only — no tests, no scripts)
SCAN_PATHS=(
  "App/Sources"
  "Packages/InventoryCore/Sources"
)

echo "=== Source Quality Lint ==="

# ── TODO / HACK / FIXME check ──────────────────────────────────────────────
echo "Checking for unresolved TODO / HACK / FIXME markers..."

set +o pipefail
violations=$(grep -rn \
  --include="*.swift" \
  -E "(//[[:space:]]*(TODO|HACK|FIXME)[^:]*:)" \
  "${SCAN_PATHS[@]}" \
  2>/dev/null \
  | grep -v "LINT-IGNORE" \
  | grep -v "LEGAL-PENDING" \
  | grep -v "^.*///.*TODO" \
  || true)
set -o pipefail

if [[ -n "$violations" ]]; then
  echo "FAIL: Unresolved TODO/HACK/FIXME in production source:"
  echo "$violations"
  FAIL=1
else
  echo "PASS: No unresolved TODO/HACK/FIXME markers"
fi

echo ""
if [[ $FAIL -ne 0 ]]; then
  echo "=== FAIL: Source quality check failed ==="
  exit 1
else
  echo "=== PASS: Source quality check passed ==="
fi
