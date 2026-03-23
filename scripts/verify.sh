#!/bin/bash
# Verify an Etnamute app: build + tests + runtime.
# Usage: scripts/verify.sh apps/<slug>
# Exit 0 = all pass, exit 1 = failure

set -euo pipefail

APP_DIR="${1:?Usage: scripts/verify.sh apps/<slug>}"

if [ ! -d "$APP_DIR" ]; then
  echo "FAIL: Directory $APP_DIR does not exist"
  exit 1
fi

cd "$APP_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

FAILED=0

echo ""
echo "=== Etnamute Verify: $(basename $APP_DIR) ==="
echo ""

# --- Level 1: Build ---

echo "--- Level 1: Build ---"

echo -n "TypeScript... "
if npx tsc --noEmit 2>&1 > /dev/null; then
  echo -e "${GREEN}PASS${NC}"
else
  echo -e "${RED}FAIL${NC}"
  npx tsc --noEmit 2>&1 | head -20
  FAILED=1
fi

echo -n "Bundle (expo export)... "
EXPORT_LOG=$(npx expo export --platform ios 2>&1)
if echo "$EXPORT_LOG" | grep -q "Exported:"; then
  echo -e "${GREEN}PASS${NC}"
else
  echo -e "${RED}FAIL${NC}"
  echo "$EXPORT_LOG" | tail -10
  FAILED=1
fi

if [ $FAILED -eq 1 ]; then
  echo ""
  echo -e "${RED}Level 1 FAILED — fix build errors before continuing${NC}"
  exit 1
fi

# --- Level 2: Tests ---

echo ""
echo "--- Level 2: Tests ---"

echo -n "Jest... "
TEST_LOG=$(npx jest --passWithNoTests --verbose 2>&1)
if echo "$TEST_LOG" | grep -q "Tests:.*failed"; then
  echo -e "${RED}FAIL${NC}"
  echo "$TEST_LOG" | grep -E "FAIL|✕|Tests:" | head -20
  FAILED=1
else
  PASSED=$(echo "$TEST_LOG" | grep -oE "[0-9]+ passed" | head -1)
  echo -e "${GREEN}PASS${NC} ($PASSED)"
fi

if [ $FAILED -eq 1 ]; then
  echo ""
  echo -e "${RED}Level 2 FAILED — fix test failures before continuing${NC}"
  exit 1
fi

# --- Level 3: Runtime ---

echo ""
echo "--- Level 3: Runtime ---"

RUNTIME_LOG="/tmp/etnamute-runtime-$(basename $APP_DIR).log"
rm -f "$RUNTIME_LOG"

echo "Starting app on simulator..."
npx expo start --ios 2>&1 | tee "$RUNTIME_LOG" &
EXPO_PID=$!

echo "Waiting 45 seconds for runtime errors..."
sleep 45

echo -n "Checking runtime log... "
ERRORS=$(grep -iE "ERROR|TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction|Invariant Violation" "$RUNTIME_LOG" 2>/dev/null || true)

kill $EXPO_PID 2>/dev/null
wait $EXPO_PID 2>/dev/null

if [ -n "$ERRORS" ]; then
  echo -e "${RED}FAIL${NC}"
  echo ""
  echo "Runtime errors found:"
  echo "$ERRORS"
  FAILED=1
else
  echo -e "${GREEN}PASS${NC}"
fi

# --- Summary ---

echo ""
echo "=== Summary ==="

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}ALL LEVELS PASSED${NC}"
  echo ""
  echo "Level 1 (Build):   PASS"
  echo "Level 2 (Tests):   PASS ($PASSED)"
  echo "Level 3 (Runtime): PASS"
  exit 0
else
  echo -e "${RED}VERIFICATION FAILED${NC}"
  echo ""
  echo "Fix the errors above and re-run: scripts/verify.sh $1"
  exit 1
fi
