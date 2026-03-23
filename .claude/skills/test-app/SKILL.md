---
name: test-app
description: Generate and run Maestro UI smoke tests for an existing app
disable-model-invocation: true
---

Generate Maestro smoke tests and run them. Requires Maestro + simulator.

**Step 1: Generate .maestro/ flows**

Read PRD §6 (Key Screens) and actual code in `app/` — extract testIDs, screen names, navigation.

Generate `apps/<slug>/.maestro/` flows:

- Tag all flows with `smoke`
- One smoke flow that: launches app → asserts no crash → navigates all tabs → takes screenshots
- Use `id` selector (testID) — most stable
- `waitForAnimationToEnd` after every navigation
- `assertNotVisible: "Invariant Violation"` for crash detection
- See `.claude/skills/maestro/SKILL.md` for patterns

**Step 2: Run smoke tests**

```bash
../../scripts/smoke.sh .
```

This handles: prebuild, simulator, Metro, Maestro execution, cleanup.

**Step 3: Fix if failures**

If smoke.sh fails:
1. Read the Maestro output — which screen/assertion failed
2. Fix the code (not the test, unless testID changed)
3. Re-run `../../scripts/smoke.sh .`
4. Max 3 attempts

App: $ARGUMENTS
