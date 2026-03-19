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
For each system, describe purpose, key files, dependencies:
- Navigation & routing
- Data persistence
- Monetization (if enabled)
- UI / design system

### 6. Monetization Flow
If PRD §5 = monetization enabled:
- Paywall trigger points
- Free vs premium feature mapping
- RevenueCat entitlement structure

If PRD §5 = free: write "No monetization — free app"

### 7. Milestones
Break into 5 milestones with checklists:

**M1: Scaffold**
- [ ] Run `npx create-expo-app@latest --template blank-typescript /tmp/expo-check` to get current compatible versions
- [ ] Create package.json with versions from the template
- [ ] app.config.js
- [ ] TypeScript config
- [ ] NativeWind setup: metro.config.js, babel.config.js, global.css (fetch docs via mcpdoc first)
- [ ] Directory structure
- [ ] Verify: `npm install` succeeds (no `--legacy-peer-deps`)

**M2: Screens**
- [ ] Root layout + navigation
- [ ] All screens from PRD §6
- [ ] Verify: `npx expo start` boots

**M3: Features**
- [ ] Each feature from PRD §4
- [ ] Data persistence
- [ ] Verify: core loop works end-to-end

**M4: Monetization** (skip if free)
- [ ] RevenueCat SDK
- [ ] Paywall screen
- [ ] Premium gating
- [ ] Verify: subscription flow works

**M5: Polish + Launch Materials**
- [ ] Onboarding flow
- [ ] App icon + splash screen
- [ ] research/, aso/, marketing/ artifacts
- [ ] README, RUNBOOK, TESTING, LAUNCH_CHECKLIST, privacy_policy
- [ ] Verify: all deliverables present

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
