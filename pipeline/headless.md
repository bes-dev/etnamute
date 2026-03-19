# Headless Build

Build an app from a pre-written PRD without interactive discovery. Designed for programmatic use by other AI agents or CI systems.

---

## INPUT

A path to a PRD file conforming to `pipeline/prd-schema.md`.

**Trigger patterns:**
- "Build from PRD: path/to/prd.md"
- "Headless build: apps/my-app/spec/prd.md"
- "Generate app from this spec: <path>"

---

## EXECUTION

### Step 1: Validate PRD

Read the PRD file and validate against `pipeline/prd-schema.md`:

1. All 12 sections present
2. App Name and Slug defined
3. Core Features have required fields (Purpose, Action, Response, Success)
4. Monetization model is valid
5. ASO fields within character limits

If validation fails → list all errors, stop. Do NOT attempt to fix or guess.

### Step 2: Create App Directory

```
apps/<slug>/
└── spec/
    ├── prd.md      ← copy the input PRD here
    └── plan.md     ← will be generated
```

### Step 3: Plan

Follow `pipeline/plan.md` — generate implementation plan from the PRD.

No user interaction. Plan is derived entirely from the PRD.

### Step 4: Build

Follow the standard build pipeline (CLAUDE.md Phase 2):

M1: Scaffold → M2: Screens → M3: Features → M4: Monetization (if enabled) → M5: Polish + Launch Materials

Ralph QA after each milestone (≥97% required).

### Step 5: Finalize

Final Ralph QA → `apps/<slug>/ralph/FINAL_VERDICT.md`.

Output build complete message.

---

## DIFFERENCES FROM INTERACTIVE BUILD

| Aspect | Interactive | Headless |
|--------|-----------|----------|
| Discovery interview | Yes (5-8 questions) | Skipped |
| Web research | Yes (WebSearch) | Skipped (PRD must include §9) |
| PRD approval | User confirms | PRD accepted as-is |
| Plan generation | From PRD | From PRD (same) |
| Build process | Identical | Identical |
| Ralph QA | Identical | Identical |

**Key rule**: headless mode trusts the PRD completely. It does not validate market research quality, pricing sanity, or feature feasibility — the PRD author is responsible for that.

---

## VALIDATION ERRORS

If the PRD is invalid, output:

```
PRD VALIDATION FAILED

Errors:
- [error 1: which section, what's wrong]
- [error 2]

Fix these errors in the PRD and retry.
Schema: pipeline/prd-schema.md
```

Do NOT proceed with an invalid PRD. Do NOT attempt to fix it.

---

## PROGRAMMATIC USAGE

Other AI agents can invoke headless builds by:

1. Generating a PRD conforming to `pipeline/prd-schema.md`
2. Saving it to a file
3. Starting Claude Code in the etnamute directory
4. Sending: "Headless build: <path-to-prd>"

The build runs autonomously from there — no interactive steps.
