---
name: headless
description: Build an app from a pre-written PRD file without interactive discovery
disable-model-invocation: true
---

Build an app from a ready PRD. No interview, no interaction.

1. Read `pipeline/headless.md` — validate the PRD against `pipeline/prd-schema.md`
2. If invalid — list errors and stop
3. If valid — copy PRD to `apps/<slug>/spec/prd.md`
4. Read `pipeline/plan.md` — generate implementation plan
5. Build all milestones with Ralph QA after each (read `pipeline/qa.md`)
6. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

PRD path: $ARGUMENTS
