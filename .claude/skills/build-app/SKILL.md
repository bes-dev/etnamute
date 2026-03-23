---
name: build-app
description: Generate a new mobile app from an idea through interactive discovery
disable-model-invocation: true
---

Build a new mobile app. Follow the full pipeline:

1. Read `pipeline/discovery.md` — analyze idea, run adaptive interview via AskUserQuestion
2. Read `pipeline/spec.md` — web research + PRD generation + Stitch design (if available) + user approval
3. Read `pipeline/plan.md` — generate implementation plan with jest setup in M1
4. Build all milestones. After EACH milestone, write tests then run:
   ```bash
   ../../scripts/verify.sh .
   ```
   This checks TypeScript, bundle, tests, AND runtime on simulator.
   If it fails → read the output, fix the error, re-run. Max 3 attempts per milestone.
5. Write final verdict to `apps/<slug>/ralph/FINAL_VERDICT.md`

**verify.sh must exit 0 before declaring BUILD COMPLETE. No exceptions.**

User's idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
