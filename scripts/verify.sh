#!/bin/bash
# Verify an Etnamute app: build + tests + runtime.
# Usage: scripts/verify.sh apps/<slug>
# Exit 0 = all pass, exit 1 = failure

set -uo pipefail

# Add common tool paths not available in non-interactive shells
export PATH="$HOME/.maestro/bin:$HOME/.local/bin:/opt/homebrew/bin:$PATH"

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

# Detect platform
case "$(uname -s)" in
  Darwin) PLATFORM="ios" ;;
  *)      PLATFORM="android" ;;
esac

echo ""
echo "=== Etnamute Verify: $(basename $APP_DIR) [${PLATFORM}] ==="
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
EXPORT_LOG=$(npx expo export --platform "$PLATFORM" 2>&1)
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
EXPO_PID=""

cleanup_runtime() {
  [ -n "$EXPO_PID" ] && kill $EXPO_PID 2>/dev/null || true
  lsof -ti:8081 2>/dev/null | xargs kill -9 2>/dev/null || true
  if [ "$PLATFORM" = "ios" ]; then
    xcrun simctl shutdown all 2>/dev/null || true
    osascript -e 'quit app "Simulator"' 2>/dev/null || true
  fi
}
trap cleanup_runtime EXIT

if [ "$PLATFORM" = "ios" ]; then
  # macOS: iOS Simulator (headless — no Simulator.app GUI)
  osascript -e 'quit app "Simulator"' 2>/dev/null || true
  sleep 1

  DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE '[A-F0-9-]{36}')
  xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true

  # Start Metro only (no --ios flag which opens Simulator.app)
  echo "Starting Metro bundler..."
  REACT_NATIVE_DEVTOOLS_PORT=0 npx expo start --no-dev > "$RUNTIME_LOG" 2>&1 &
  EXPO_PID=$!
  sleep 10

  # Open app in simulator via URL (headless — no GUI)
  IP=$(hostname -I 2>/dev/null | awk '{print $1}' || ipconfig getifaddr en0 2>/dev/null || echo "localhost")
  xcrun simctl openurl "$DEVICE_ID" "exp://${IP}:8081" 2>/dev/null || true
else
  # Linux: Android Emulator
  # Check if emulator is running
  if ! adb devices 2>/dev/null | grep -q "emulator"; then
    echo "Starting Android emulator..."
    AVD_NAME=$(emulator -list-avds 2>/dev/null | head -1)
    if [ -z "$AVD_NAME" ]; then
      echo -e "${RED}FAIL${NC} — no Android AVD found. Create one with Android Studio."
      exit 1
    fi
    emulator -avd "$AVD_NAME" -no-window -no-audio -no-boot-anim &
    adb wait-for-device
    sleep 10
  fi

  # Start Metro only
  echo "Starting Metro bundler..."
  REACT_NATIVE_DEVTOOLS_PORT=0 npx expo start --no-dev > "$RUNTIME_LOG" 2>&1 &
  EXPO_PID=$!
  sleep 10

  # Open app on emulator via adb
  adb shell am start -a android.intent.action.VIEW -d "exp://localhost:8081" 2>/dev/null || true
fi

echo "Waiting 45 seconds for runtime errors..."
sleep 45

echo -n "Checking runtime log... "
ERRORS=$(grep -iE -A 10 " ERROR |TypeError|ReferenceError|is not a function|is undefined|Exception in HostFunction|Invariant Violation" "$RUNTIME_LOG" 2>/dev/null || true)

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
