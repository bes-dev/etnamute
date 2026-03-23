# QA Pipeline

Verify the app actually works — not just compiles.

---

## THREE MANDATORY LEVELS

Every milestone must pass all three levels before proceeding. No exceptions.

### Level 1: Build Verification

```bash
# 1. Dependencies install cleanly
npm install

# 2. TypeScript compiles
npx tsc --noEmit

# 3. App bundles without errors (catches missing deps, broken imports, invalid JSX)
npx expo export 2>&1
```

**`npx expo export` is the critical check.** It does a full production bundle. If the `main` field is wrong, a dependency is missing, an import path is broken, or JSX is invalid — it fails here, not when the user tries to run the app.

If any of these fail → fix before proceeding. Do NOT declare milestone complete.

### Level 2: Automated Tests

Write and run tests for every milestone. Tests live in `__tests__/` alongside the code they test.

**What to test per milestone:**

**M1 (Scaffold):**
- No tests needed — Level 1 is sufficient

**M2 (Screens):**
- Each screen renders without crash: `render(<Screen />)` doesn't throw
- Navigation structure is correct: expected screens exist in the layout

**M3 (Features):**
- Store logic: each Zustand store action produces correct state
- Utility functions: pure functions with known inputs/outputs
- Data persistence: SQLite operations (insert, query, update, delete)
- Core user flow: create item → verify in store → verify persistence

**M4 (Monetization, if enabled):**
- RevenueCat mock: paywall renders, premium gate works with mock entitlements

**M5 (Polish):**
- Onboarding flow renders all steps
- Settings screen renders with correct defaults

**Test framework:** Jest + jest-expo (installed via `npx expo install jest-expo jest`).

**Minimal test structure:**

```typescript
// __tests__/stores/timer-store.test.ts
import { useTimerStore } from '../../src/stores/timer-store';

describe('TimerStore', () => {
  beforeEach(() => useTimerStore.getState().reset());

  it('starts timer', () => {
    useTimerStore.getState().start();
    expect(useTimerStore.getState().isRunning).toBe(true);
  });

  it('increments completed sessions', () => {
    useTimerStore.getState().completeSession();
    expect(useTimerStore.getState().completedSessions).toBe(1);
  });
});
```

```typescript
// __tests__/screens/home.test.tsx
import { render } from '@testing-library/react-native';
import HomeScreen from '../../app/(tabs)/home';

describe('HomeScreen', () => {
  it('renders without crash', () => {
    expect(() => render(<HomeScreen />)).not.toThrow();
  });
});
```

**Run tests:**
```bash
npx jest --passWithNoTests
```

If tests fail → fix before proceeding.

### Level 3: Runtime Verification (MANDATORY)

After Level 1 and Level 2 pass, verify the app actually runs without runtime errors.

**`npx expo export` catches bundle errors but NOT runtime errors.** APIs that bundle correctly but crash at runtime (e.g., `SplashModule.internalPreventAutoHideAsync is not a function`) are only caught by actually running the app.

**Step 1: Start the app on simulator and capture log:**

```bash
npx expo start --ios 2>&1 | tee /tmp/expo-runtime.log &
```

**Step 2: WAIT 45-60 seconds.** Runtime errors appear AFTER "Bundled Xms" — not before. Do NOT check immediately after seeing "Bundled".

**Step 3: Check the FULL log for errors:**

```bash
cat /tmp/expo-runtime.log | grep -iE "ERROR|TypeError|ReferenceError|Invariant Violation|is not a function|is undefined|Cannot read|Cannot find|Exception in HostFunction"
```

**Step 4: Kill the process:**
```bash
kill %1 2>/dev/null
```

**CRITICAL: "Bundled successfully" does NOT mean the app works.** Reanimated, SplashScreen, expo-av, and other native modules can bundle fine but crash at runtime. The ERROR lines appear AFTER the "Bundled" line in the log.

**If runtime errors found:**
1. Read the error message — identify which module/function is broken
2. Fetch docs via mcpdoc for the problematic module — API may have changed
3. Fix the code
4. Re-run Level 3

**Step 2: Maestro smoke test (if available):**

Generate a smoke test flow from PRD key screens:

```yaml
appId: <bundle-id>
---
- launchApp:
    clearState: true
- waitForAnimationToEnd:
    timeout: 10000
- extendedWaitUntil:
    visible: ".*"
    timeout: 15000
- assertNotVisible: "Invariant Violation"
- assertNotVisible: "TypeError"
- takeScreenshot: smoke_home
```

Run: `maestro test --include-tags smoke .maestro/`

**Common runtime errors and fixes:**

| Error pattern | Likely cause | Fix |
|---|---|---|
| `X is not a function (it is undefined)` | API changed between SDK versions | Fetch current docs via mcpdoc |
| `Cannot find module` | Missing dependency | `npx expo install <package>` |
| `Invariant Violation` | React component error | Check component props and imports |
| `TypeError: Cannot read property` | Null/undefined access | Add null checks or fix data flow |

If runtime smoke fails → fix before proceeding. Max 3 iterations.

---

## WHEN TO RUN

| Milestone | Level 1 | Level 2 | Level 3 |
|-----------|---------|---------|---------|
| M1: Scaffold | YES | No | YES (bundle only) |
| M2: Screens | YES | Screen render tests | YES |
| M3: Features | YES | Store + util + persistence tests | YES |
| M4: Monetization | YES | PayWall mock tests | YES |
| M5: Polish | YES | Onboarding + settings tests | YES |
| Final QA | YES | Full test suite | YES + visual verification |

---

## WRITING TESTS

Claude MUST write tests as part of each milestone, not as an afterthought.

**Rules:**
- Tests are written ALONGSIDE the code, in the same milestone
- Each store gets tests for its actions
- Each utility function gets tests for known inputs/outputs
- Each screen gets at minimum a "renders without crash" test
- Tests must actually pass before milestone is complete

**Setup (during M1 scaffold):**

Add to package.json:
```json
{
  "scripts": {
    "test": "jest"
  },
  "jest": {
    "preset": "jest-expo",
    "transformIgnorePatterns": [
      "node_modules/(?!((jest-)?react-native|@react-native(-community)?)|expo(nent)?|@expo(nent)?/.*|@expo-google-fonts/.*|react-navigation|@react-navigation/.*|@sentry/react-native|native-base|react-native-svg)"
    ]
  }
}
```

Install: `npx expo install jest-expo jest @testing-library/react-native -- --save-dev`

**Do NOT skip this during scaffold.** Missing test infrastructure is why tests never get written.

---

## PRD-AWARE REVIEW (formerly "Ralph")

After all three levels pass, review the code against the PRD:

1. Read `spec/prd.md`
2. For each feature in §4 — verify it's implemented and has tests
3. For each non-goal in §2 — verify no scope creep
4. If DESIGN.md exists — verify visual decisions match (use Maestro screenshots if available)
5. Check code quality against auto-discovered rules (`.claude/rules/`)

**This is the LAST step**, not the first. Code review is pointless if the app doesn't run.

---

## FAILURE HANDLING

| Failure | Action |
|---------|--------|
| `npm install` fails | Fix dependency conflicts. Never use `--legacy-peer-deps` or `--force`. |
| `npx tsc --noEmit` fails | Fix TypeScript errors. |
| `npx expo export` fails | Fix the bundle error — this is what would crash the app at runtime. |
| Tests fail | Fix the code, not the test (unless test is wrong). |
| Maestro smoke fails | Check Metro logs, check for runtime errors, fix crash. |
| PRD review finds gaps | Implement missing features before proceeding. |

**Max 3 fix-and-retest iterations per milestone.** If still failing after 3 — document blockers, inform user.

---

## FINAL QA (before BUILD COMPLETE)

Run the full suite across the entire app:

```bash
# Level 1
npm install && npx tsc --noEmit && npx expo export

# Level 2
npx jest

# Level 3 (if Maestro available)
maestro test --include-tags smoke .maestro/
```

ALL must pass. Then write `apps/<slug>/ralph/FINAL_VERDICT.md`:

```
PIPELINE: etnamute
RALPH_VERDICT: PASS
TIMESTAMP: <ISO-8601>

VERIFIED:
- npm install: PASS
- tsc --noEmit: PASS
- expo export (bundle): PASS
- jest (X tests): PASS
- maestro smoke: PASS / SKIPPED (not available)
- PRD compliance: all features implemented
- Code quality: rules checked
```

Only THEN output BUILD COMPLETE.
