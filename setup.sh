#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; return 1; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
info() { echo -e "  ${DIM}$1${NC}"; }

echo ""
echo "Etnamute — Setup"
echo "==================="
echo ""

FAILED=0

# --- Core ---

echo "Core:"

if command -v node &>/dev/null; then
  ok "Node.js $(node -v)"
else
  echo ""
  fail "Node.js not found. Install from https://nodejs.org" || FAILED=1
fi

if command -v npm &>/dev/null; then
  ok "npm $(npm -v)"
else
  fail "npm not found" || FAILED=1
fi

if command -v claude &>/dev/null; then
  ok "Claude Code"
else
  info "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code
  if command -v claude &>/dev/null; then
    ok "Claude Code installed"
  else
    fail "Claude Code install failed — npm install -g @anthropic-ai/claude-code" || FAILED=1
  fi
fi

echo ""

# --- Python + mcpdoc ---

echo "Documentation (mcpdoc):"

if command -v python3 &>/dev/null; then
  ok "Python $(python3 --version 2>&1 | cut -d' ' -f2)"
else
  fail "Python 3 not found — brew install python3 / apt install python3" || FAILED=1
fi

if [ ! -d ".venv" ]; then
  info "Creating .venv..."
  python3 -m venv .venv
fi
ok "Virtual environment"

source .venv/bin/activate

if pip show mcpdoc &>/dev/null 2>&1; then
  ok "mcpdoc $(pip show mcpdoc 2>/dev/null | grep Version | cut -d' ' -f2)"
else
  info "Installing mcpdoc..."
  pip install -q -r requirements.txt
  if pip show mcpdoc &>/dev/null 2>&1; then
    ok "mcpdoc installed"
  else
    fail "mcpdoc install failed" || FAILED=1
  fi
fi

echo ""

# --- Maestro (required for Full testing level) ---

echo "Testing (Maestro):"

MAESTRO_BIN="$HOME/.maestro/bin/maestro"

if [ -x "$MAESTRO_BIN" ] || command -v maestro &>/dev/null; then
  ok "Maestro $($MAESTRO_BIN --version 2>/dev/null || maestro --version 2>/dev/null)"
else
  info "Installing Maestro..."
  curl -fsSL "https://get.maestro.mobile.dev" | bash
  if [ -x "$MAESTRO_BIN" ]; then
    ok "Maestro installed"
  else
    fail "Maestro install failed — curl -fsSL https://get.maestro.mobile.dev | bash" || FAILED=1
  fi
fi

echo ""

# --- Platform tools ---

echo "Platform:"

case "$(uname -s)" in
  Darwin)
    if command -v xcrun &>/dev/null; then
      ok "Xcode CLI tools"
    else
      info "Installing Xcode CLI tools..."
      xcode-select --install 2>/dev/null || true
      warn "Xcode CLI tools — follow the dialog to install, then re-run setup.sh"
    fi
    ;;
  *)
    if [ -d "$HOME/Android/Sdk" ] || [ -d "$HOME/Library/Android/sdk" ] || [ -n "${ANDROID_HOME:-}" ]; then
      ok "Android SDK"
    else
      warn "Android SDK — install Android Studio from https://developer.android.com/studio"
    fi
    if command -v adb &>/dev/null; then
      ok "adb"
    else
      warn "adb not in PATH — add Android SDK platform-tools to PATH"
    fi
    if command -v emulator &>/dev/null; then
      ok "Android emulator"
    else
      warn "emulator not in PATH — add Android SDK emulator to PATH"
    fi
    ;;
esac

echo ""

# --- Optional ---

echo "Optional:"

if command -v fastlane &>/dev/null; then
  ok "fastlane $(fastlane --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
else
  warn "fastlane (for /release-app) — brew install fastlane"
fi

if [ -n "${STITCH_API_KEY:-}" ]; then
  ok "Google Stitch API key set"
else
  warn "STITCH_API_KEY not set (for /design-app) — export STITCH_API_KEY=<key from stitch.withgoogle.com/settings>"
fi

echo ""

# --- Result ---

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}Ready.${NC} Run 'claude' to start building."
  echo ""
  echo "Quick start:"
  echo "  claude"
  echo "  > /build-app habit tracker for students"
else
  echo -e "${RED}Some required tools could not be installed. Fix the errors above and re-run ./setup.sh${NC}"
  exit 1
fi
