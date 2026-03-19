# Etnamute

Local AI-powered mobile app factory. Describe an idea → get a publishable Expo React Native app.

---

## Setup

```bash
./setup.sh
```

---

## Pipelines

### 1. Build from scratch

```
claude
> I want an app for tracking daily water intake
```

Interactive discovery interview → market research → PRD approval → autonomous build with QA.

Output: `apps/<app-slug>/`

```bash
cd apps/<app-slug>
npm install
npx expo start
```

### 2. Improve existing app

```
claude
> Add dark mode to my water tracker
> Fix the crash on the settings screen
> Add subscription monetization
```

Reads existing PRD and code, clarifies if needed, applies targeted changes, verifies.

### 3. Build from PRD (headless)

```
claude
> Headless build: path/to/my-prd.md
```

Skips the interview — builds directly from a pre-written PRD. No interactive steps. Designed for programmatic use by other AI agents.

PRD must conform to `pipeline/prd-schema.md`.

### 4. Release to App Store

```
claude
> Prepare this app for App Store submission
```

Generates fastlane config, captures screenshots via Maestro, builds locally. Asks confirmation before submitting.

Requires: Xcode, Android SDK, fastlane, maestro, Apple/Google developer accounts.

---

## Project Structure

```
├── CLAUDE.md                 # Pipeline constitution
├── .claude/
│   ├── skills/               # Code quality rules (auto-discovered)
│   └── rules/                # Build standards (auto-discovered)
├── pipeline/
│   ├── discovery.md          # Interview
│   ├── spec.md               # PRD generation
│   ├── prd-schema.md         # PRD format specification
│   ├── headless.md           # Build from pre-written PRD
│   ├── plan.md               # Implementation plan
│   ├── qa.md                 # Ralph QA
│   ├── release.md            # Build + deploy
│   └── improve.md            # Modify existing app
├── scripts/                  # Utilities
├── .mcp.json                 # Docs MCP (Expo + RevenueCat)
└── apps/                     # Generated apps
```

---

## Tech Stack

| Component    | Technology              |
| ------------ | ----------------------- |
| Framework    | Expo SDK 53+            |
| Language     | TypeScript              |
| Navigation   | Expo Router v4          |
| Styling      | NativeWind 4            |
| Monetization | RevenueCat (if enabled) |
| Storage      | expo-sqlite             |
| State        | Zustand                 |
