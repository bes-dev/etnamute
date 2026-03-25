# Etnamute

Local AI-powered mobile app factory. Describe an idea → get a publishable Expo React Native app.

---

## Setup

```bash
./setup.sh
```

### Optional tools

**Google Stitch** (AI UI design):
```bash
export STITCH_API_KEY=<key from stitch.withgoogle.com/settings>
```

**Maestro** (smoke testing, visual verification, App Store screenshots):
```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```
Requires a dev build (`npx expo run:ios` or `npx expo run:android`), not Expo Go.

---

## Lifecycle

```
/spec-app → /design-app → /build-app → /improve-app (iterate) → /fix-app → /test-app → /market-app → /release-app
```

| Command | What it does |
|---------|-------------|
| `/spec-app <idea>` | Discovery interview + web research → PRD (no code) |
| `/design-app <app>` | Generate design system (DESIGN.md + reference screenshots) from PRD |
| `/build-app <idea or app>` | Full pipeline: interview → PRD → plan → build → QA. Skips to build if PRD exists |
| `/headless <prd> [level]` | Build from a pre-written PRD without interview (for agents/CI) |
| `/improve-app <change>` | Modify an existing app: PRD update → code → tests → verify |
| `/fix-app <app>` | Run verify.sh in a loop, auto-fix until all checks pass |
| `/test-app <app>` | Interaction map → Maestro UI tests → visual verification via Claude vision |
| `/market-app <app>` | Platform-specific ASO + market research + marketing content |
| `/build-native <app>` | Build IPA/AAB/APK locally without publishing |
| `/release-app <app>` | Fastlane: build → sign → screenshots → submit to stores |

### Build

```
/build-app habit tracker for students
```

Interview → PRD → optional Stitch UI design → autonomous build with 3 testing levels:
- **Fast** — build + runtime check, you test manually
- **Standard** — build + unit tests + runtime (recommended)
- **Full** — Standard + Maestro UI tests + visual verification

Every milestone verified before proceeding. Code only — marketing generated separately via `/market-app`.

```bash
cd apps/<app-slug> && npm install && npx expo start
```

### Design

```
/design-app my-app
```

If Stitch MCP is available: generates screen mockups, saves reference screenshots to `spec/design-screens/`, extracts design tokens into `DESIGN.md`. Without Stitch: generates design system from PRD. `/build-app` follows DESIGN.md; `/test-app` compares actual UI against reference screenshots.

### Iterate

```
/improve-app add dark mode to my water tracker
```

Each change: PRD update → code → tests → verify.sh loop. Versioning, dead code cleanup, artifact sync handled automatically.

### Test

```
/test-app my-app
```

Builds an interaction map of every UI element, generates Maestro flows + unit tests, runs them, then Claude reads screenshots to verify visual correctness against DESIGN.md and reference mockups.

### Market

```
/market-app my-app
```

Platform-specific ASO (iOS hidden keywords vs Android description density), competitor analysis, launch content. Run after code is finalized.

### Release

```
/release-app my-app
```

Prebuild → Maestro screenshots → fastlane build → sign → submit for review. One-time setup required (certs, API keys).

### Headless (for agents/CI)

```
/headless path/to/my-prd.md
/headless path/to/my-prd.md full
```

Validates PRD against schema, then builds autonomously. No interview, no user interaction. Optional second argument: testing level (`fast`, `standard`, `full`; default: `standard`).

---

## Architecture

```
├── CLAUDE.md                 # System constitution
├── .claude/
│   ├── skills/               # Commands + knowledge skills
│   │   ├── build-app/        # Command: full build pipeline
│   │   ├── test-app/         # Command: run full QA
│   │   ├── testing/          # Knowledge: QA orchestration (interaction map → Maestro → visual review)
│   │   ├── interaction-map/  # Knowledge: analyze UI elements, detect broken promises
│   │   ├── visual-review/    # Knowledge: compare screenshots to design specs
│   │   ├── maestro/          # Knowledge: Maestro patterns, flow templates, Expo Router gotchas
│   │   └── ...               # spec-app, design-app, improve-app, release-app, etc.
│   ├── rules/                # Build standards, design consistency, ASO quality, Expo Go compatibility
│   └── hooks/                # Post-edit syntax checks
├── pipeline/                 # Shared references
│   ├── qa.md                 # QA verify loop (Fast / Standard / Full)
│   ├── plan.md               # Implementation plan template
│   └── prd-schema.md         # PRD format specification
├── scripts/
│   ├── verify.sh             # 3-level QA: tsc + bundle + jest + runtime (cross-platform)
│   ├── smoke.sh              # Maestro: Release build + headless simulator + cleanup (cross-platform)
│   ├── greenlight.sh         # App Store compliance check
│   └── clean.sh              # Cleanup utility
├── .mcp.json                 # MCP servers (mcpdoc + Stitch)
└── apps/                     # Generated apps
    └── <slug>/
        ├── spec/             # PRD, research, plan, DESIGN.md, design-screens/, testing-level.txt
        ├── ralph/            # QA verdicts
        ├── app/, src/        # Expo app code
        ├── __tests__/        # Jest tests
        ├── .maestro/         # Maestro UI test flows
        ├── research/, aso/, marketing/  # Generated by /market-app
        └── fastlane/         # Generated by /release-app
```

Skills are split into **commands** (user-invoked via `/command`, protected by `disable-model-invocation`) and **knowledge** (agent-accessible, composable). Commands are thin wrappers; knowledge skills contain the actual procedures.

Scripts auto-detect platform: macOS → iOS simulator, Linux → Android emulator.

## Integrations

| Tool | Purpose | Setup |
|------|---------|-------|
| [mcpdoc](https://github.com/langchain-ai/mcpdoc) | Live Expo + RevenueCat + Maestro docs | `pip install mcpdoc` (via setup.sh) |
| [Google Stitch](https://stitch.withgoogle.com) | AI UI design → reference screenshots + design tokens | `export STITCH_API_KEY=<key>` |
| [Maestro](https://maestro.mobile.dev) | Smoke tests, functional tests, visual verification, screenshots | `curl -fsSL "https://get.maestro.mobile.dev" \| bash` |
| [fastlane](https://fastlane.tools) | Build + sign + submit to App Store / Google Play | `brew install fastlane` |

## Stack

Expo (latest stable SDK), Expo Router, TypeScript, NativeWind, Zustand, expo-sqlite, React Native Reanimated. Optional RevenueCat monetization. SDK versions resolved at build time — never hardcoded.

All dependencies must work in Expo Go (`npx expo start`). No packages requiring native builds, TurboModules, or New Architecture.
