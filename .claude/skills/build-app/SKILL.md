---
name: build-app
description: Generate a new mobile app from an idea through interactive discovery
disable-model-invocation: true
---

Build a new mobile app. Follow the full pipeline:

1. Read `pipeline/discovery.md` — analyze idea, run adaptive interview via AskUserQuestion
2. Read `pipeline/spec.md` — web research + PRD generation + Stitch design (if available) + user approval
3. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
4. Build all milestones. After EACH milestone run QA (`pipeline/qa.md`):
   - Level 1: `npx tsc --noEmit` + `npx expo export` (bundle check)
   - Level 2: `npx jest` (write tests as part of each milestone)
   - Level 3: start on simulator, check logs for runtime errors
   ALL three must pass before next milestone.
5. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

Do NOT declare BUILD COMPLETE until the app runs on simulator without errors.

User's idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
