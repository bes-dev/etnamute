---
name: spec-app
description: Generate PRD through discovery interview and market research — no code
disable-model-invocation: true
---

Generate a Product Requirements Document for a new app. No code — just the spec.

1. Read `pipeline/discovery.md` — analyze idea, run adaptive interview via AskUserQuestion
2. Read `pipeline/spec.md` — web research + PRD generation + name + Stitch + approval preferences
3. Save PRD to `apps/<slug>/spec/prd.md`

Output: a ready PRD that can be passed to `/design-app`, `/build-app`, or `/headless`.

App idea: $ARGUMENTS

Start with Phase 0a — analyze the idea and ask the first question.
