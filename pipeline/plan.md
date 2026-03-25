# Phase 1: Implementation Plan

Generate a comprehensive implementation plan from the approved PRD.

---

## INPUT

Read `apps/<slug>/spec/prd.md` — the user-approved PRD.

## OUTPUT

Write to `apps/<slug>/spec/plan.md`.

---

## REQUIRED SECTIONS

### 1. Project Overview
- App name, one-line pitch, value proposition
- From PRD §1

### 2. Core User Loop
- Trigger → Action → Reward → Retention
- From PRD §4 features

### 3. Tech Stack (committed, no alternatives)
- Framework, navigation, state, storage, monetization
- Locked choices: Expo (latest SDK), Expo Router, TypeScript, NativeWind, Zustand, expo-sqlite
- RevenueCat only if PRD §5 specifies monetization
- **Do NOT hardcode version numbers** — M1 will resolve actual versions from `npx create-expo-app@latest`

### 4. Project Structure
- Exact file tree for `apps/<slug>/`
- Every file that will be created, with purpose

### 5. Key Systems
For each system used by the app, describe purpose, key files, dependencies.
Refer to `.claude/rules/app-patterns.md` for library choices. Include only systems the app needs:

- **Navigation** — route structure, auth guards, deep linking (if applicable)
- **Data persistence** — SQLite schema with migrations, key-value storage strategy
- **Forms** — if the app has user input: form library, validation schemas, keyboard handling
- **Images** — if the app displays images: caching, placeholders, optimization
- **Error handling** — error boundary placement (root + per-screen), offline state handling
- **Monetization** — if enabled: RevenueCat setup, entitlement mapping, paywall triggers
- **Design system** — spacing scale, color tokens, typography, icon library

### 6. Monetization Flow
If PRD §5 = monetization enabled:
- Paywall trigger points
- Free vs premium feature mapping
- RevenueCat entitlement structure

If PRD §5 = free: write "No monetization — free app"

### 7. Milestones
Break into 5 milestones with checklists:

**M1: Scaffold**
- [ ] Resolve versions via `npx create-expo-app@latest`
- [ ] package.json with correct `"main": "expo-router/entry"`
- [ ] app.config.js — MUST use `module.exports = { ... }` (CommonJS), NOT `export default` (ESM). Scripts use `require()` to read config.
- [ ] TypeScript config
- [ ] NativeWind setup: metro.config.js, babel.config.js, global.css (fetch docs first)
- [ ] **Jest + jest-expo + @testing-library/react-native setup**
- [ ] Directory structure
- [ ] Verify: `npm install` + `npx tsc --noEmit` + `npx expo export` all pass

**M2: Screens**
- [ ] Root layout + navigation
- [ ] All screens from PRD §6
- [ ] **Tests: each screen renders without crash**
- [ ] Verify: build + bundle + tests pass

**M3: Features**
- [ ] Each feature from PRD §4
- [ ] Data persistence
- [ ] **Tests: store actions, utility functions, persistence operations**
- [ ] Verify: build + bundle + tests + smoke test pass

**M4: Monetization** (skip if free)
- [ ] RevenueCat SDK
- [ ] Paywall screen
- [ ] Premium gating
- [ ] **Tests: paywall renders, premium gate works with mock**
- [ ] Verify: build + bundle + tests pass

**M5: Polish**
- [ ] Onboarding flow
- [ ] App icon + splash screen
- [ ] README, RUNBOOK, TESTING, LAUNCH_CHECKLIST, privacy_policy
- [ ] Verify: all deliverables present
- [ ] Note: research/, marketing/, aso/ are NOT generated during build — run `/market-app` after code is finalized

### 8. Verification Strategy
For each milestone: what commands to run, what to check manually.

### 9. Risks & Mitigations
- Potential blockers and fallback strategies
- From PRD §7 constraints

---

## RULES

- Every item must be implementable without ambiguity
- Commit to specific choices (no "option A or B")
- Reference PRD sections for traceability
- Fetch API documentation via mcpdoc before committing to specific SDK patterns
