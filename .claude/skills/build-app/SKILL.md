---
name: build-app
description: Generate a new mobile app from an idea through interactive discovery
disable-model-invocation: true
---

Build a new mobile app. Follow the full pipeline:

1. Read `pipeline/discovery.md` — run adaptive interview via AskUserQuestion
2. Read `pipeline/spec.md` — web research + PRD generation + user approval
3. Read `pipeline/plan.md` — generate implementation plan
4. Build all milestones with Ralph QA after each (read `pipeline/qa.md`)
5. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

User's idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
