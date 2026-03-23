---
name: test-app
description: Generate and run Maestro UI smoke tests for an existing app
disable-model-invocation: true
---

Generate Maestro smoke tests from actual code and run them. Requires Maestro + simulator.

1. Check Maestro installed (`which maestro`). If not → tell user to install and stop.
2. Read `apps/<slug>/spec/prd.md` §6 (Key Screens) — what screens exist
3. Read actual code in `app/` — extract testIDs, screen names, navigation structure
4. Generate `.maestro/` flows:
   - `m-smoke.yaml` — launch, crash detection, all tabs navigable
   - One flow per key screen — navigate there, assert key content visible, take screenshot
   - Use `testID` selectors (most stable), `waitForAnimationToEnd` after every navigation
5. Run: `maestro test --include-tags smoke .maestro/`
6. If failures:
   - Read Maestro output — identify which screen/assertion failed
   - Fix the code (not the test, unless testID changed)
   - Re-run. Max 3 attempts.
7. Report results + screenshots captured

See `.claude/skills/maestro/SKILL.md` for Maestro patterns and known limitations.

App: $ARGUMENTS
