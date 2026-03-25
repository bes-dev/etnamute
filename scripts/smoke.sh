#!/bin/bash
# Run Maestro smoke tests for an Etnamute app.
# Usage: scripts/smoke.sh apps/<slug>
# Exit 0 = all pass, exit 1 = failure
#
# Prerequisites:
# - Maestro installed (curl -fsSL "https://get.maestro.mobile.dev" | bash)
# - iOS Simulator (macOS) or Android Emulator (Linux) available
# - .maestro/ directory with yaml flows in the app directory

set -uo pipefail

APP_DIR="${1:?Usage: scripts/smoke.sh apps/<slug>}"

# Detect platform
case "$(uname -s)" in
  Darwin) PLATFORM="ios" ;;
  *)      PLATFORM="android" ;;
esac

# Cleanup on any exit (success, failure, or signal)
METRO_PID=""
BUILD_PID=""
cleanup() {
  [ -n "$METRO_PID" ] && kill $METRO_PID 2>/dev/null || true
  [ -n "$BUILD_PID" ] && kill $BUILD_PID 2>/dev/null || true
  lsof -ti:8081 2>/dev/null | xargs kill -9 2>/dev/null || true
  if [ "$PLATFORM" = "ios" ]; then
    xcrun simctl shutdown all 2>/dev/null || true
    osascript -e 'quit app "Simulator"' 2>/dev/null || true
  fi
}
trap cleanup EXIT

if [ ! -d "$APP_DIR" ]; then
  echo "FAIL: Directory $APP_DIR does not exist"
  exit 1
fi

cd "$APP_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Maestro
if ! command -v maestro &>/dev/null; then
  echo -e "${RED}Maestro not installed${NC}"
  echo "Install: curl -fsSL \"https://get.maestro.mobile.dev\" | bash"
  exit 1
fi

# Check .maestro directory
if [ ! -d ".maestro" ]; then
  echo -e "${RED}No .maestro/ directory found${NC}"
  echo "Generate Maestro flows first"
  exit 1
fi

# Check for yaml flows
FLOW_COUNT=$(find .maestro -maxdepth 1 -name "*.yaml" | wc -l | tr -d ' ')
if [ "$FLOW_COUNT" -eq 0 ]; then
  echo -e "${RED}No .yaml flows in .maestro/${NC}"
  exit 1
fi

echo ""
echo "=== Maestro Smoke Test: $(basename $APP_DIR) [${PLATFORM}] ==="
echo ""

if [ "$PLATFORM" = "ios" ]; then
  # --- macOS: iOS ---

  # Ensure prebuild exists
  if [ ! -d "ios" ]; then
    echo "Running expo prebuild..."
    npx expo prebuild --platform ios --clean 2>&1 | tail -3
  fi

  # Kill Simulator.app to prevent GUI windows
  osascript -e 'quit app "Simulator"' 2>/dev/null || true
  sleep 1

  # Boot simulator headless (no GUI window)
  BOOTED=$(xcrun simctl list devices booted | grep -c "Booted" || true)
  if [ "$BOOTED" -eq 0 ]; then
    echo "Booting simulator (headless)..."
    DEVICE_ID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -oE '[A-F0-9-]{36}')
    xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true
    sleep 5
  fi

  # Build and install app
  echo "Building app..."
  npx expo run:ios --no-bundler 2>&1 > /tmp/etnamute-smoke-build.log &
  BUILD_PID=$!

else
  # --- Linux: Android ---

  # Ensure prebuild exists
  if [ ! -d "android" ]; then
    echo "Running expo prebuild..."
    npx expo prebuild --platform android --clean 2>&1 | tail -3
  fi

  # Check if emulator is running, start if not
  if ! adb devices 2>/dev/null | grep -q "emulator"; then
    echo "Starting Android emulator..."
    AVD_NAME=$(emulator -list-avds 2>/dev/null | head -1)
    if [ -z "$AVD_NAME" ]; then
      echo -e "${RED}No Android AVD found. Create one with Android Studio.${NC}"
      exit 1
    fi
    emulator -avd "$AVD_NAME" -no-window -no-audio -no-boot-anim &
    adb wait-for-device
    sleep 10
  fi

  # Build and install app
  echo "Building app..."
  npx expo run:android --no-bundler 2>&1 > /tmp/etnamute-smoke-build.log &
  BUILD_PID=$!
fi

# Wait for build to complete
echo "Waiting for build (this may take a few minutes on first run)..."
for i in $(seq 1 120); do
  if grep -q "Build Succeeded\|Installing.*app\|Installed\|BUILD SUCCESSFUL" /tmp/etnamute-smoke-build.log 2>/dev/null; then
    break
  fi
  if ! kill -0 $BUILD_PID 2>/dev/null; then
    break
  fi
  sleep 2
done

# Start Metro separately in background (no dev tools)
REACT_NATIVE_DEVTOOLS_PORT=0 npx expo start --no-dev > /tmp/etnamute-smoke-metro.log 2>&1 &
METRO_PID=$!
sleep 10

# Run Maestro
echo ""
echo "Running Maestro flows ($FLOW_COUNT flows)..."
echo ""

MAESTRO_OUTPUT=$(maestro test \
  --no-ansi \
  --include-tags smoke \
  --test-output-dir ./screenshots \
  .maestro/ 2>&1)
MAESTRO_EXIT=$?

echo "$MAESTRO_OUTPUT"

# Cleanup handled by trap EXIT

echo ""
echo "=== Summary ==="

if [ $MAESTRO_EXIT -eq 0 ]; then
  echo -e "${GREEN}ALL SMOKE TESTS PASSED${NC}"
  echo "Screenshots saved to ./screenshots/"
  exit 0
else
  echo -e "${RED}SMOKE TESTS FAILED${NC}"
  echo "Check output above for details"
  exit 1
fi
