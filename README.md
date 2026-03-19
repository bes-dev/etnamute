# Etnamute

Local AI-powered mobile app factory. Describe an idea → get a publishable Expo React Native app.

---

## Setup

```bash
./setup.sh
```

---

## Commands

```
/build-app <idea>              Build a new app from an idea (interactive)
/headless <path-to-prd>        Build from a pre-written PRD (autonomous)
/improve-app <change request>  Modify an existing app
/release-app <app-slug>        Build + screenshots + deploy to stores
```

### Build from scratch

```
/build-app habit tracker for students
```

Interactive discovery interview → market research → PRD approval → autonomous build with QA.

Output: `apps/<app-slug>/`

```bash
cd apps/<app-slug>
npm install
npx expo start
```

### Improve existing app

```
/improve-app add dark mode to my water tracker
```

Reads existing PRD and code, clarifies if needed, applies targeted changes, verifies.

### Build from PRD (headless)

```
/headless path/to/my-prd.md
```

Skips the interview — builds directly from a pre-written PRD. No interactive steps. Designed for programmatic use by other AI agents.

PRD must conform to `pipeline/prd-schema.md`.

### Release to App Store

```
/release-app water-tracker
```

Generates fastlane config, captures screenshots via Maestro, builds locally. Asks confirmation before submitting.

Requires: Xcode, Android SDK, fastlane, maestro, Apple/Google developer accounts.

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
