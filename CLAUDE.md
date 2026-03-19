# Etnamute

**Version**: 1.0.0

---

## LANGUAGE

Detect the user's language from their first message. All communication — interview questions, summaries, confirmations, error messages — MUST be in that language. Pipeline files and code comments stay in English.

---

## PURPOSE

Etnamute transforms **raw app ideas** into **publishable mobile products**. Not demos. Not toys. Not half-products.

| In Scope                           | Out of Scope        |
| ---------------------------------- | ------------------- |
| iOS + Android mobile apps          | Websites            |
| Expo React Native                  | Backend APIs        |
| RevenueCat monetization (optional) | User authentication |
| Offline-first / local storage      | Cloud databases     |

Monetization is **user's choice** — decided during the discovery interview. Free apps get zero monetization code.

---

## USER FLOW

```
USER: describes app idea
  ↓
PHASE 0: Discovery (INTERACTIVE)
  0a: Adaptive interview (5-8 questions via AskUserQuestion)     → pipeline/discovery.md
  0b: Web research (competitors, pricing, market)                → apps/<slug>/spec/research.md
  0c: PRD generation → user approves                             → apps/<slug>/spec/prd.md
  ↓
PHASE 1: Plan (AUTONOMOUS)                                       → pipeline/plan.md
  9-section implementation plan                                  → apps/<slug>/spec/plan.md
  ↓
PHASE 2: Build (AUTONOMOUS, milestone-driven)
  M1: Scaffold → M2: Screens → M3: Features
  M4: Monetization (skip if free) → M5: Polish + Research/Marketing
  Ralph QA after each milestone (≥97% required)                  → pipeline/qa.md
  ↓
PHASE 3: Finalization
  Final Ralph QA → FINAL_VERDICT.md                              → apps/<slug>/ralph/
  ↓
BUILD COMPLETE
  ↓ (on user request)
PHASE 4: Release (OPTIONAL)                                      → pipeline/release.md
  Fastlane config + Maestro screenshots + local build + submit
```

**Improve Mode**: user requests changes to an existing app → `pipeline/improve.md`
**Headless Mode**: build from a pre-written PRD without interview → `pipeline/headless.md`

---

## DIRECTORY STRUCTURE

```
etnamute/
├── CLAUDE.md
├── .claude/
│   ├── skills/                      # Auto-discovered code quality rules
│   │   ├── react-native/
│   │   ├── mobile-ui/
│   │   ├── mobile-interface/
│   │   └── expo/
│   └── rules/                       # Auto-discovered build standards
│       ├── build-standards.md
│       └── research-policy.md
├── pipeline/                        # Phase instructions
│   ├── discovery.md                 # Adaptive interview
│   ├── spec.md                      # PRD generation
│   ├── prd-schema.md                # PRD format specification
│   ├── headless.md                  # Build from pre-written PRD
│   ├── plan.md                      # Implementation plan
│   ├── qa.md                        # Ralph QA
│   ├── release.md                   # Build + deploy
│   └── improve.md                   # Modify existing app
├── scripts/
│   ├── generate-assets.mjs
│   ├── greenlight.sh
│   └── clean.sh
├── .mcp.json                        # mcpdoc (Expo + RevenueCat docs)
└── apps/                            # One directory per app
    └── <app-slug>/
        ├── spec/                    # PRD, research, plan
        │   ├── prd.md
        │   ├── research.md
        │   └── plan.md
        ├── ralph/FINAL_VERDICT.md
        ├── package.json
        ├── app/, src/, assets/
        ├── research/, aso/, marketing/
        └── fastlane/, .maestro/     # Phase 4 (release)
```

### Output Contract

Every app in `apps/<slug>/` MUST have:
- `package.json`, `app.config.js`, `tsconfig.json`
- `app/` with `_layout.tsx`, `index.tsx`, `home.tsx`, `settings.tsx`
- `app/paywall.tsx` + `src/services/purchases.ts` — only if monetization enabled
- `assets/icon.png` (1024x1024), `assets/splash.png`
- `research/market_research.md`, `research/competitor_analysis.md`, `research/positioning.md`
- `aso/app_title.txt`, `aso/subtitle.txt`, `aso/description.md`, `aso/keywords.txt`
- `marketing/launch_thread.md`, `marketing/landing_copy.md`, `marketing/press_blurb.md`, `marketing/social_assets.md`
- `README.md`, `RUNBOOK.md`, `TESTING.md`, `LAUNCH_CHECKLIST.md`, `privacy_policy.md`

---

## MODES

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Discovery** | User describes an app | Interactive interview → research → PRD approval |
| **Build** | User approves PRD | Autonomous: plan → milestones → QA. No stops, no questions. |
| **QA (Ralph)** | After each milestone | Adversarial review from PRD. Fix until ≥97%. Max 3 iterations. |
| **Improve** | User requests change to existing app | Read PRD + code → clarify → apply → verify |
| **Headless** | User provides a PRD file path | Validate PRD → plan → build → QA. No interview. |
| **Release** | User asks to deploy | Fastlane config → Maestro screenshots → build → submit |

```
Discovery ──[PRD approved]──▶ Build ──[milestone]──▶ QA ──[≥97%]──▶ Build (next)
Headless  ──[PRD validated]──▶ Build (same as above)
Build ──[all milestones + final QA]──▶ Complete ──[user request]──▶ Release
Improve ──[changes + verify]──▶ Done ──[more changes]──▶ Improve (loop)
```

---

## PHASE DETAILS

### Phase 0: Discovery (INTERACTIVE)

**Template**: `pipeline/discovery.md` + `pipeline/spec.md`

1. **Analyze** user's initial idea — extract what's already known
2. **Interview** — 5-8 adaptive questions via `AskUserQuestion`, domain-specific options
3. **Research** — WebSearch for competitors, pricing, market demand → `spec/research.md`
4. **Generate PRD** — 12-section spec with source attribution (`[USER]`, `[RESEARCH]`, `[DEFAULT]`, `[INFERRED]`)
5. **User approves** — show summary, wait for explicit approval. No building until approved.

### Phase 1: Plan (AUTONOMOUS)

**Template**: `pipeline/plan.md`
**Output**: `apps/<slug>/spec/plan.md`

9 required sections:
1. Project Overview
2. Core User Loop
3. Tech Stack (committed choices)
4. Project Structure (exact file tree)
5. Key Systems (navigation, data, UI)
6. Monetization Flow (or "none" for free apps)
7. Milestones (numbered, with verification checklists)
8. Verification Strategy
9. Risks & Mitigations

### Phase 2: Build (AUTONOMOUS)

| Milestone | Deliverables | Ralph QA |
|-----------|-------------|----------|
| M1: Scaffold | resolve versions via create-expo-app, package.json, NativeWind config, directory structure | ≥97% |
| M2: Screens | navigation, core UI screens | ≥97% |
| M3: Features | core functionality, data persistence | ≥97% |
| M4: Monetization | RevenueCat, paywall, gating — **skip if free** | ≥97% |
| M5: Polish + Launch | onboarding, assets, research, ASO, marketing | ≥97% |

After each milestone: implement → verify → Ralph QA → proceed only after ≥97%.

### Phase 3: Finalization

Final Ralph QA across entire app → `apps/<slug>/ralph/FINAL_VERDICT.md` → BUILD COMPLETE.

### Phase 4: Release (OPTIONAL, on user request)

**Template**: `pipeline/release.md`

1. Pre-flight checks (`.env.deploy`, tools installed)
2. Generate fastlane config + metadata from `aso/`
3. Generate Maestro screenshot flows from PRD key screens
4. `npx expo prebuild --clean` → `maestro test` → `fastlane build`
5. Ask user confirmation before submitting to stores

---

## GUARDRAILS

Claude MUST:
- Run discovery interview before building
- Perform web research before generating PRD
- Get explicit user approval on PRD before Phase 1
- Resolve dependency versions from `npx create-expo-app@latest` during M1 (never hardcode)
- Fetch API docs via mcpdoc before using ANY Expo module, NativeWind, Reanimated, or RevenueCat
- Run Ralph QA after every milestone (≥97%)
- Respect user's monetization choice

Claude MUST NOT:
- Skip the interview or web research
- Start building without PRD approval
- Stop or ask questions during build (Phase 1+)
- Add monetization to a free app
- Hallucinate market data without web search
- Use `--legacy-peer-deps`, `--force`, or `--ignore-engines`
- Write outside `apps/`

---

## TECHNOLOGY STACK

Core choices (do NOT change):
- **Expo** (latest stable SDK) with **Expo Router**
- **NativeWind** for styling
- **React Native Reanimated** for animations
- **RevenueCat** for monetization (if enabled)
- **expo-sqlite** + **AsyncStorage** for data
- **Zustand** for state management
- **TypeScript**

**CRITICAL: Do NOT hardcode SDK versions.** During M1 (Scaffold), run:
```bash
npx create-expo-app@latest --template blank-typescript /tmp/expo-version-check
```
Extract exact compatible versions from its `package.json`, then delete it. Use those versions as the baseline for the app. This ensures all dependencies are compatible with the current Expo SDK.

**NativeWind setup requires** (fetch docs via mcpdoc for current instructions):
- `metro.config.js` with `withNativeWind` wrapper
- `babel.config.js` with `nativewind/babel` preset
- `global.css` imported in root layout

**Peer dependency conflicts**: use `"overrides"` in package.json to pin conflicting transitive deps. This is preferred over `--legacy-peer-deps` (which is forbidden).

---

## API DOCUMENTATION

**MANDATORY**: Before writing ANY code that uses an Expo module or RevenueCat, fetch its documentation via `mcpdoc`. APIs change between SDK versions — your training data is likely outdated.

Fetch docs for:
- Every Expo SDK module before first use (expo-sqlite, expo-file-system, expo-notifications, etc.)
- Expo Router before setting up navigation
- NativeWind before configuring styling
- RevenueCat before implementing monetization
- React Native Reanimated before writing animations

Available via mcpdoc (`.mcp.json`):
- **Expo** (docs.expo.dev)
- **RevenueCat** (revenuecat.com/docs)

**Do NOT rely on memory for API signatures, config patterns, or import paths.** They change between versions. Always fetch.

---

## DEFAULTS

| Aspect         | Default                                  |
| -------------- | ---------------------------------------- |
| Platform       | iOS + Android (Expo)                     |
| Monetization   | Ask user (no default forced)             |
| Data storage   | Local-only, offline-first (SQLite)       |
| Backend        | None                                     |
| Authentication | Guest-first (no login)                   |

---

## BUILD VERIFICATION

Before declaring BUILD COMPLETE:
1. `npm install` completes without errors
2. `npx tsc --noEmit` passes
3. No bypass flags used

---

## COMPLETION

When build is complete, write to `apps/<slug>/ralph/FINAL_VERDICT.md`:

```
PIPELINE: etnamute v1.0.0
OUTPUT: apps/<slug>/
RALPH_VERDICT: PASS (≥97%)
TIMESTAMP: <ISO-8601>

VERIFIED:
- [ ] Discovery interview conducted
- [ ] Web research performed
- [ ] PRD approved by user
- [ ] All milestones complete
- [ ] Ralph PASS achieved
- [ ] npm install succeeds
- [ ] npx expo start works
- [ ] RevenueCat integrated (if monetization enabled)
- [ ] All research/ASO/marketing artifacts present
```

Then output:
```
BUILD COMPLETE

App: <app-name>
Location: apps/<slug>/

To run:
  cd apps/<slug>
  npm install
  npx expo start
```

---

## ERROR RECOVERY

| Error | Recovery |
|-------|----------|
| WebSearch unavailable | Mark PRD sections `[UNVALIDATED]`, inform user |
| Ralph fails after 3 iterations | Document blockers, inform user |
| npm install / expo start fails | Fix root cause, retry |
| User abandons interview | Resume from last answered question |

### Drift Detection

Halt and reassess if:
- About to write outside `apps/`
- About to add monetization to a free app
- About to skip interview or research
- Quality stays below 97% after 3 Ralph iterations

---

## APPLE APP STORE COMPLIANCE

Run `scripts/greenlight.sh apps/<slug>/` after build verification.

CRITICAL and HIGH findings must be fixed before shipping.
