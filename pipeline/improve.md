# Improve Mode

Add features, remove features, optimize UX, fix bugs — while keeping the codebase clean and all artifacts in sync.

---

## EXECUTION

### Step 1: Understand

1. Find the app in `apps/`
2. Read `apps/<slug>/spec/prd.md` — current spec is the source of truth
3. Scan the code — understand architecture, patterns, dependencies
4. Identify what the requested change touches: which files, which PRD sections, which artifacts

If PRD is missing, reconstruct from package.json, app.config.js, and screen files before proceeding.

### Step 2: Clarify (if needed)

Use `AskUserQuestion` only if the request is ambiguous. Generate options specific to the app — not generic.

Skip if the request is already specific.

### Step 3: Plan the change

Before writing any code, determine:

1. **PRD impact** — which sections change (features added/removed, monetization, screens)
2. **Files to modify** — list specific files
3. **Files to create/delete** — new screens, services, components
4. **Dead code** — what becomes unused after this change (remove it, don't comment out)
5. **Artifacts to update** — which of these need changes:
   - `spec/prd.md` — feature list, non-goals, screens
   - `aso/description.md`, `aso/keywords.txt` — if user-facing functionality changed
   - `research/positioning.md` — if competitive positioning shifted
   - `marketing/` — if launch messaging needs refresh
   - `README.md` — if features or setup changed
   - `LAUNCH_CHECKLIST.md` — if new setup steps needed
   - `privacy_policy.md` — if data collection changed
6. **Version bump** — determine semver:
   - Bug fix → patch (1.0.0 → 1.0.1)
   - New feature / UX change → minor (1.0.0 → 1.1.0)
   - Breaking change / redesign → major (1.0.0 → 2.0.0)

### Step 4: Apply changes

Execute in this order:

1. **Update PRD first** — `spec/prd.md` is the source of truth. Mark changes:
   ```
   > [UPDATED <date>]: Added/removed/changed <what> — <why>
   ```

2. **Modify code** — only affected files, preserve existing patterns:
   - Follow the same code style (indentation, naming, file structure)
   - Reuse existing components/hooks/services — don't create duplicates
   - When removing a feature: delete all related files, imports, navigation entries, types
   - When adding a feature: place files consistent with existing structure
   - Fetch docs via mcpdoc before using any new SDK module

3. **Clean up dead code** — after any removal:
   - Delete unused components, hooks, services, types
   - Remove unused imports
   - Remove orphaned navigation routes
   - Remove unused dependencies from package.json

4. **Update artifacts**:
   - `app.config.js` — bump version
   - `aso/` — update description/keywords if functionality changed
   - `marketing/` — update if core value prop changed
   - `README.md` — update feature list if changed
   - `privacy_policy.md` — update if data handling changed

### Step 5: Verify

1. `npx tsc --noEmit` — no TypeScript errors
2. Check PRD matches the code — every feature in PRD exists in code, nothing in code that's not in PRD
3. Check no dead code left — no unused imports, files, dependencies
4. Check artifacts are in sync — ASO description matches actual features

### Step 6: Report

Show summary (in user's language):

```
## v<new-version>

**Change**: <what was requested>
**Type**: feature / removal / fix / redesign

### Code
- Modified: <file list>
- Created: <file list>
- Deleted: <file list>

### Artifacts updated
- <list of updated artifacts>

### Dead code removed
- <list of cleaned up files/imports>

Anything else to change?
```

Wait for feedback:
- More changes → loop back to Step 2
- Done → complete
- Revert → undo changes

---

## REMOVING FEATURES

When removing a feature:

1. Remove from `spec/prd.md` §4 (Core Features)
2. Delete the screen file(s)
3. Remove navigation entry from layout
4. Delete related components, hooks, services
5. Remove related types
6. Clean imports across all files that referenced removed code
7. Remove from ASO description/keywords if it was mentioned
8. Remove unused dependencies from package.json
9. Run `npx tsc --noEmit` to verify nothing is broken

**Never** leave commented-out code, unused imports, or orphaned files.

---

## ADDING FEATURES

When adding a feature:

1. Add to `spec/prd.md` §4 with Purpose/Action/Response/Success
2. Fetch relevant API docs via mcpdoc
3. Create files following existing project structure and patterns
4. Reuse existing components/hooks — don't duplicate
5. Add navigation entry
6. Add to ASO description if user-facing
7. Run `npx tsc --noEmit` to verify

---

## REDESIGN / UX CHANGES

When changing visual style or UX:

1. Update `spec/prd.md` §6 (UX Philosophy)
2. Identify all affected screens and components
3. Apply changes consistently across the entire app — not just one screen
4. Check touch targets remain ≥44pt
5. Check accessibility labels still present
6. Update screenshots reference in ASO if layout changed significantly

---

## RULES

- PRD is the source of truth — update it first, then code
- Minimal changes — don't refactor unrelated code
- No dead code — delete what's unused
- No duplicates — reuse existing patterns
- Artifacts in sync — ASO, marketing, docs reflect current state
- Version bump on every change
- Fetch docs before using new SDK modules
