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
/build-app → /improve-app (iterate) → /market-app → /release-app
```

| Command | What it does |
|---------|-------------|
| `/build-app <idea>` | Build a new app from an idea (interactive) |
| `/headless <path-to-prd>` | Build from a pre-written PRD (autonomous) |
| `/improve-app <change>` | Modify an existing app |
| `/market-app <app>` | Generate ASO, research, and marketing materials |
| `/fix-app <app>` | Run all checks, auto-fix until app passes |
| `/build-native <app>` | Build IPA/AAB/APK locally without publishing |
| `/release-app <app>` | Build + screenshots + submit to stores |

### Build

```
/build-app habit tracker for students
```

Interview → PRD approval → optional Stitch UI design → autonomous build.

Every milestone verified: TypeScript compiles, app bundles, tests pass, runs on simulator without runtime errors. Code only — no marketing or ASO at this stage.

```bash
cd apps/<app-slug> && npm install && npx expo start
```

### Iterate

```
/improve-app add dark mode to my water tracker
```

Repeat until satisfied. Each change verified: build + tests + runtime check on simulator. Versioning, dead code cleanup, artifact sync handled automatically.

### Market

```
/market-app water-tracker
```

Platform-specific ASO (iOS keywords + Android description optimization), market research, competitor analysis, launch thread, landing copy, press blurb. Run after code is finalized.

### Release

```
/release-app water-tracker
```

Prebuild → Maestro screenshots → fastlane build → sign → submit for review. Fully automated after one-time setup.

### Headless (for other AI agents)

```
/headless path/to/my-prd.md
```

No interview. PRD in, app out.

---

## Integrations

| Tool | Purpose | Setup |
|------|---------|-------|
| [mcpdoc](https://github.com/langchain-ai/mcpdoc) | Live Expo + RevenueCat docs | `pip install mcpdoc` (via setup.sh) |
| [Google Stitch](https://stitch.withgoogle.com) | AI UI design generation | `export STITCH_API_KEY=<key>` |
| [Maestro](https://maestro.mobile.dev) | Smoke tests, visual verification, screenshots | `curl -fsSL "https://get.maestro.mobile.dev" \| bash` |
| [fastlane](https://fastlane.tools) | Build + sign + submit to stores | `brew install fastlane` |

---

## Project Structure

```
├── CLAUDE.md                 # Pipeline constitution
├── .claude/
│   ├── skills/               # Code quality rules + slash commands
│   ├── rules/                # Build standards (auto-discovered)
│   └── hooks/                # Post-edit TypeScript checks
├── pipeline/                 # Phase instructions
├── scripts/                  # Utilities
├── .mcp.json                 # MCP servers (mcpdoc + Stitch)
└── apps/                     # Generated apps
```

Generates **Expo React Native** apps with TypeScript, NativeWind, Zustand, expo-sqlite, and optional RevenueCat monetization. SDK versions are resolved at build time from the latest stable Expo release.
