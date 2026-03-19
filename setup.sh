#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✓${NC} $1"; }
fail() { echo -e "  ${RED}✗${NC} $1"; }
warn() { echo -e "  ${YELLOW}!${NC} $1"; }
info() { echo -e "  ${DIM}$1${NC}"; }

echo ""
echo "Etnamute — Setup"
echo "==================="
echo ""

MISSING=()

# --- Core (required) ---

echo "Core tools:"

if command -v node &>/dev/null; then
  ok "Node.js $(node -v)"
else
  fail "Node.js — install from https://nodejs.org"
  MISSING+=(node)
fi

if command -v npm &>/dev/null; then
  ok "npm $(npm -v)"
else
  fail "npm"
  MISSING+=(npm)
fi

if command -v claude &>/dev/null; then
  ok "Claude Code"
else
  fail "Claude Code — npm install -g @anthropic-ai/claude-code"
  MISSING+=(claude)
fi

echo ""

# --- Python + mcpdoc (required for docs MCP) ---

echo "Documentation MCP:"

if command -v python3 &>/dev/null; then
  ok "Python $(python3 --version 2>&1 | cut -d' ' -f2)"
else
  fail "Python 3 — brew install python3"
  MISSING+=(python3)
fi

if [ ! -d ".venv" ]; then
  info "Creating .venv..."
  python3 -m venv .venv
  ok "Virtual environment created"
else
  ok "Virtual environment exists"
fi

source .venv/bin/activate

if pip show mcpdoc &>/dev/null 2>&1; then
  ok "mcpdoc $(pip show mcpdoc 2>/dev/null | grep Version | cut -d' ' -f2)"
else
  info "Installing mcpdoc..."
  pip install -q -r requirements.txt
  if pip show mcpdoc &>/dev/null 2>&1; then
    ok "mcpdoc installed"
  else
    fail "mcpdoc — pip install mcpdoc"
    MISSING+=(mcpdoc)
  fi
fi

echo ""

# --- Build tools (optional, for Phase 5: Release) ---

echo "Build tools (optional, for release):"

if command -v fastlane &>/dev/null; then
  ok "fastlane $(fastlane --version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
else
  warn "fastlane — brew install fastlane"
fi

if command -v maestro &>/dev/null; then
  ok "maestro"
else
  warn "maestro — curl -fsSL https://get.maestro.mobile.dev | bash"
fi

if command -v xcrun &>/dev/null; then
  ok "Xcode CLI tools"
else
  warn "Xcode CLI tools — xcode-select --install"
fi

if [ -d "$HOME/Library/Android/sdk" ] || [ -n "${ANDROID_HOME:-}" ]; then
  ok "Android SDK"
else
  warn "Android SDK — install Android Studio"
fi

echo ""

# --- Result ---

if [ ${#MISSING[@]} -eq 0 ]; then
  echo -e "${GREEN}Ready.${NC} Run 'claude' to start building."
else
  echo -e "${RED}Missing required tools: ${MISSING[*]}${NC}"
  echo "Install them and run ./setup.sh again."
  exit 1
fi
