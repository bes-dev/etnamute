---
name: headless
description: Build an app from a pre-written PRD file without interactive discovery
disable-model-invocation: true
---

Build an app from a ready PRD. No interview. Designed for programmatic use by other AI agents or CI systems.

PRD path: $ARGUMENTS

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

Read `pipeline/plan.md` — generate 9-section implementation plan from the PRD.

No user interaction. Plan is derived entirely from the PRD.

### Step 4: Build

5 milestones sequentially: M1 (Scaffold) → M2 (Screens) → M3 (Features) → M4 (Monetization, if enabled) → M5 (Polish)

After EACH milestone, verify using Standard testing level:
```
LOOP (max 3 attempts):
  1. Run: ../../scripts/verify.sh .
     (tsc + bundle + jest + runtime on simulator)
  2. If exit 0 → PASS
  3. If exit 1 → fix → go to 1
```

Write unit tests for every handler alongside the code.

For test writing guidelines, see `pipeline/qa.md`.

### Step 5: Finalize

Final QA → `apps/<slug>/ralph/FINAL_VERDICT.md`.

Output build complete message.

---

## DIFFERENCES FROM INTERACTIVE BUILD

| Aspect | Interactive (`/build-app`) | Headless |
|--------|---------------------------|----------|
| Discovery interview | Yes (5-8 questions) | Skipped |
| Web research | Yes (WebSearch) | Skipped (PRD must include §9) |
| PRD approval | User confirms | PRD accepted as-is |
| Testing level | User chooses | Always Standard |
| Build process | Identical | Identical |
| QA | Identical | Identical |

**Key rule**: headless mode trusts the PRD completely. It does not validate market research quality, pricing sanity, or feature feasibility.

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
