# Etnamute

Local AI-powered mobile app factory. Describe an idea → get a publishable Expo React Native app.

---

## Setup

```bash
./setup.sh
```

---

## Lifecycle

```
/build-app → /improve-app (iterate) → /prepare-launch → /optimize-aso → /release-app
```

| Command | What it does |
|---------|-------------|
| `/build-app <idea>` | Build a new app from an idea (interactive) |
| `/headless <path-to-prd>` | Build from a pre-written PRD (autonomous) |
| `/improve-app <change>` | Modify an existing app |
| `/prepare-launch <app>` | Generate research + marketing materials |
| `/optimize-aso <app>` | Generate platform-specific ASO metadata |
| `/release-app <app>` | Build + screenshots + submit to stores |

### Build from scratch

```
/build-app habit tracker for students
```

Interview → market research → PRD approval → autonomous build with QA.

```bash
cd apps/<app-slug> && npm install && npx expo start
```

### Iterate

```
/improve-app add dark mode to my water tracker
```

Repeat until satisfied. ASO is not generated during development — saves tokens.

### Prepare launch materials

```
/prepare-launch water-tracker
```

Market research, competitor analysis, positioning, Twitter thread, landing copy, press blurb. Based on actual built app, not original PRD.

### Optimize ASO

```
/optimize-aso water-tracker
```

Platform-specific: iOS (hidden keywords, conversion-focused description) and Android (keyword-optimized description) generated separately.

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

## Project Structure

```
├── CLAUDE.md                 # Pipeline constitution
├── .claude/
│   ├── skills/               # Code quality rules + slash commands
│   └── rules/                # Build standards (auto-discovered)
├── pipeline/                 # Phase instructions
├── scripts/                  # Utilities
├── .mcp.json                 # Docs MCP (Expo + RevenueCat)
└── apps/                     # Generated apps
```

Generates **Expo React Native** apps with TypeScript, NativeWind, Zustand, expo-sqlite, and optional RevenueCat monetization. SDK versions are resolved at build time from the latest stable Expo release.
