---
name: headless
description: Build an app from a pre-written PRD file without interactive discovery
disable-model-invocation: true
---

Build an app from a ready PRD. No interview.

1. Read `pipeline/headless.md` — validate PRD against `pipeline/prd-schema.md`
2. If invalid — list errors and stop
3. Copy PRD to `apps/<slug>/spec/prd.md`
4. Follow `pipeline/build.md` — plan → milestones → verify loop → verdict

PRD path: $ARGUMENTS
