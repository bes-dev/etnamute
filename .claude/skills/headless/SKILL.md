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
5. Build all milestones. After EACH milestone, write tests then run:
   ```bash
   ../../scripts/verify.sh .
   ```
   If fails → fix and re-run. Max 3 attempts per milestone.
6. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

**verify.sh must exit 0 before declaring BUILD COMPLETE.**

PRD path: $ARGUMENTS
