---
name: headless
description: Build an app from a pre-written PRD file without interactive discovery
disable-model-invocation: true
---

Build an app from a ready PRD. No interview, no interaction.

1. Read `pipeline/headless.md` — validate PRD against `pipeline/prd-schema.md`
2. If invalid — list errors and stop
3. Copy PRD to `apps/<slug>/spec/prd.md`
4. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
5. Build all milestones. After EACH milestone run QA (`pipeline/qa.md`):
   - Level 1: `npx tsc --noEmit` + `npx expo export`
   - Level 2: `npx jest`
   - Level 3: start on simulator, check for runtime errors
6. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

Do NOT declare BUILD COMPLETE until the app runs on simulator without errors.

PRD path: $ARGUMENTS
