---
name: build-app
description: Generate a new mobile app — full pipeline or code-only if PRD already exists
disable-model-invocation: true
---

Build a new mobile app.

**If `apps/<slug>/spec/prd.md` already exists** (created by `/spec-app`):
- Skip interview and PRD generation
- Go straight to build

**If no PRD exists:**
1. Read `pipeline/discovery.md` — adaptive interview
2. Read `pipeline/spec.md` — web research + PRD + name + design + approval

**Then follow `pipeline/build.md`** — plan → milestones → verify loop → verdict.

User's idea: $ARGUMENTS
