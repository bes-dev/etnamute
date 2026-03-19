# Improve Mode

Make targeted changes to an existing app based on user requests.

---

## EXECUTION

### Step 1: Understand

1. Find the app in `apps/`
2. Read `apps/<slug>/spec/prd.md`
3. Scan the code — understand current implementation
4. Identify what files/systems the requested change affects

If PRD is missing, reconstruct a summary from package.json, app.config.js, and screen files.

### Step 2: Clarify (if needed)

Use `AskUserQuestion` only if the request is ambiguous. Generate options **specific to the app and the change requested** — not generic templates.

Skip clarification if the request is already specific.

### Step 3: Apply Changes

1. **Code** — modify only affected files, preserve existing style
2. **PRD** — update `spec/prd.md` if scope changed, mark with `[UPDATED: <date> — <reason>]`
3. **Docs** — update README, LAUNCH_CHECKLIST, RUNBOOK if affected

### Step 4: Verify & Report

1. `npx tsc --noEmit` — TypeScript compiles
2. Check that changes match the updated PRD
3. Show summary:

```
## Changes Applied

**Request**: [what the user asked]
**Files modified**: [list]
**PRD updated**: [yes/no]

What was done:
- [change 1]
- [change 2]

Хотите что-то ещё изменить?
```

4. Wait for user feedback:
   - "ок" → done
   - "ещё X" → loop back to Step 2
   - "откати" → revert changes

---

## RULES

- Read code before changing anything
- Minimal, targeted changes only
- Do NOT refactor unrelated code
- Do NOT add features the user didn't ask for
- Do NOT re-run the full discovery interview
- Respect monetization choice (can add or remove on request)

## SCOPE LIMITS

Improve Mode is for targeted changes. If the change would effectively rewrite the app, suggest starting a new build.
