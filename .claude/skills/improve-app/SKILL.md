---
name: improve-app
description: Add/remove features, fix bugs, redesign — keeping code clean and artifacts in sync
disable-model-invocation: true
---

Improve an existing app.

Change request: $ARGUMENTS

---

## EXECUTION

### Step 1: Understand the codebase

Read files in this order:

1. `apps/<slug>/spec/prd.md` — what was supposed to be built
2. `package.json` — dependencies, SDK versions
3. `app.config.js` — Expo config, plugins, permissions
4. `app/_layout.tsx` — root layout: providers, fonts, wrappers
5. `app/` directory tree — file-based routing = navigation map
6. `src/` structure — flat (`components/`, `hooks/`) or feature-based (`features/auth/`)

Identify state management: Zustand (`useStore`), Context (`Provider`), or other.

### Step 2: Clarify (if needed)

Use `AskUserQuestion` only if ambiguous. Generate options specific to the app. Skip if already specific.

### Step 3: Plan the change

Before writing code:

1. **PRD impact** — which sections change (§4 features, §5 monetization, §6 UX, §2 non-goals)
2. **Files to modify/create/delete**
3. **Dead code** — what becomes unused after this change
4. **Tests to write** — new feature needs tests; changed feature needs updated tests
5. **Refactoring** — if a component being modified exceeds 250 lines or has 3+ useState, split it
6. **Artifacts to update**: `spec/prd.md`, `README.md`, `privacy_policy.md` if affected
7. **Version bump** — patch (bugfix), minor (feature/UX), major (redesign/breaking)

Do NOT update `aso/` or `marketing/` — managed separately via `/market-app`.

### Step 4: Apply changes

Execute in this order:

**1. Update PRD first** — source of truth:
```
> [UPDATED <date>]: Added/removed/changed <what> — <why>
```

**2. Modify code** — follow existing patterns:
- Match the project's architecture
- Reuse existing components/hooks — don't duplicate
- Fetch docs via mcpdoc before using any new SDK module
- Use `npx expo install <package>` for new dependencies — not `npm install`

**3. Write/update tests:**
- New feature → write store tests, screen render test
- Changed feature → update affected tests
- Bug fix → write regression test that catches the bug
- **New gesture interaction (swipe, long-press, drag) → MUST add a Maestro flow** that physically executes the gesture. Unit tests and runtime log checks cannot catch gesture-related crashes (missing GestureHandlerRootView, Reanimated babel plugin, etc.)

**4. When removing a feature:**
- Remove from PRD §4
- Delete screen, components, hooks, services, types
- Clean all imports and navigation entries
- Remove unused dependencies from package.json
- If feature had persisted Zustand state → add migration to remove fields
- If feature's screen was a deep link target → add redirect from old route

**5. When renaming or removing routes:**
- Grep codebase for old route path string before renaming
- Add `<Redirect>` at old path after renaming
- Flag to user if push notifications target this route

**6. When changing UX/design:**
- Update PRD §6
- Apply consistently across ALL affected screens
- Verify accessibility labels survived — component replacement drops them silently

**7. When modifying data models:**
- SQLite: add migration with incremented `user_version`
- Zustand persisted stores: bump `version` + add `migrate` function

**8. Clean up:**
- Delete unused files — never comment out code
- Remove orphaned imports, dependencies, navigation routes, assets

**9. Update artifacts:**
- `app.config.js` — bump version
- `README.md` — update if features changed
- `privacy_policy.md` — update if data handling changed

### Step 5: Verify

Run the verify loop from `pipeline/qa.md` (reads testing level from `apps/<slug>/spec/testing-level.txt`).

If the change affects UI: also read `.claude/skills/visual-review/SKILL.md` and review screenshots of affected screens.
If the change adds/removes interactive elements: read `.claude/skills/interaction-map/SKILL.md` to verify no broken promises were introduced.

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

### Tests
- Added/updated: <test file list>
- Result: <X> tests passing

### QA
- tsc: PASS
- expo export: PASS
- jest: PASS (<X> tests)
- runtime: PASS (no errors on simulator)

Anything else to change?
```

Wait for feedback:
- More changes → loop back to Step 2
- Done → complete
- Revert → undo changes

---

## RULES

- **PRD first** — update spec before code
- **Understand before changing** — read codebase structure before writing
- **Follow existing patterns** — match architecture, naming, style
- **Write tests** — every change includes tests
- **No dead code** — delete what's unused, never comment out
- **Runtime verified** — app must run on simulator without errors
- **Scope discipline** — one change per request, don't refactor unrelated code
- **Version bump** on every change
- **Fetch docs** before using new SDK modules
