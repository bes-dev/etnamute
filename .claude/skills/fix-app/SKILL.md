---
name: fix-app
description: Run verify.sh, diagnose failures, fix code until the app passes all checks
disable-model-invocation: true
---

Verify and fix an existing app. Run the verify loop until all checks pass.

```
LOOP (max 5 attempts):
  1. Run: scripts/verify.sh apps/<slug>
  2. If exit 0 → DONE, report "all checks pass"
  3. If exit 1 → read the error output, diagnose the issue:
     - Build error → fix TypeScript or missing dependency
     - Test failure → fix code (not the test, unless test is wrong)
     - Runtime error → fetch docs via mcpdoc, fix the crash
  4. Apply fix, go to step 1
```

**Re-run verify.sh after EVERY fix. Do NOT assume one fix resolved everything.**

If still failing after 5 attempts → report remaining errors to user.

App: $ARGUMENTS
