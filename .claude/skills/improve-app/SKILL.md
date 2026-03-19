---
name: improve-app
description: Make targeted changes to an existing app
disable-model-invocation: true
---

Improve an existing app. Read `pipeline/improve.md` and follow the steps:

1. Locate the app in `apps/`
2. Read `apps/<slug>/spec/prd.md` and the current code
3. Clarify the change via AskUserQuestion if needed
4. Apply targeted changes
5. Update PRD if scope changed
6. Verify with `npx tsc --noEmit`
7. Show summary and wait for feedback

Change request: $ARGUMENTS
