# Etnamute

Local AI-powered mobile app factory. Describe an idea → get a publishable Expo React Native app.

---

## Setup

```bash
./setup.sh
```

Optional: set `STITCH_API_KEY` env var for [Google Stitch](https://stitch.withgoogle.com) UI design generation.

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
| `/release-app <app>` | Build + screenshots + submit to stores |

### Build

```
/build-app habit tracker for students
```

Interview → PRD approval → optional Stitch UI design → autonomous build with QA.

Code only — no marketing or ASO generated at this stage.

```bash
cd apps/<app-slug> && npm install && npx expo start
```

### Iterate

```
/improve-app add dark mode to my water tracker
```

Repeat until satisfied. Versioning, dead code cleanup, artifact sync handled automatically.

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

- **[mcpdoc](https://github.com/langchain-ai/mcpdoc)** — live Expo + RevenueCat documentation on demand
- **[Google Stitch](https://stitch.withgoogle.com)** — AI UI design generation, strict visual reproduction in code

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
