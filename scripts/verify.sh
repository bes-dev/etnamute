#!/bin/bash
# Verify an Etnamute app: build + tests + runtime.
# Usage: scripts/verify.sh apps/<slug>
# Exit 0 = all pass, exit 1 = failure

set -uo pipefail

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
PASSED_TESTS=""

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
TEST_EXIT=$?
if [ $TEST_EXIT -ne 0 ] || echo "$TEST_LOG" | grep -qE "Tests:.*failed|Test Suites:.*failed|FAIL"; then
  echo -e "${RED}FAIL${NC}"
  echo "$TEST_LOG" | grep -E "FAIL|✕|Tests:|Test Suites:|Cannot find module|failed to run" | head -20
  FAILED=1
else
  PASSED_TESTS=$(echo "$TEST_LOG" | grep -oE "[0-9]+ passed" | head -1)
  echo -e "${GREEN}PASS${NC} ($PASSED_TESTS)"
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
npx expo start --ios > "$RUNTIME_LOG" 2>&1 &
EXPO_PID=$!

echo "Waiting 45 seconds for runtime errors..."
sleep 45

echo -n "Checking runtime log... "
ERRORS=$(grep -iE -A 10 " ERROR |TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction|Invariant Violation" "$RUNTIME_LOG" 2>/dev/null || true)

# Kill expo and all child processes
kill -- -$EXPO_PID 2>/dev/null || kill $EXPO_PID 2>/dev/null || true
# Also kill any Metro process on port 8081
lsof -ti:8081 2>/dev/null | xargs kill -9 2>/dev/null || true

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
  echo "Level 2 (Tests):   PASS ($PASSED_TESTS)"
  echo "Level 3 (Runtime): PASS"
  exit 0
else
  echo -e "${RED}VERIFICATION FAILED${NC}"
  echo ""
  echo "Fix the errors above and re-run: scripts/verify.sh $1"
  exit 1
fi
