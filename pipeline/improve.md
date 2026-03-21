# Improve Mode

Add features, remove features, optimize UX, fix bugs — while keeping the codebase clean and all artifacts in sync.

---

## EXECUTION

### Step 1: Understand the codebase

Read files in this order — each answers a specific question:

1. `apps/<slug>/spec/prd.md` — what was supposed to be built
2. `package.json` — dependencies, SDK versions, scripts
3. `app.config.js` / `app.json` — Expo config, plugins, permissions
4. `app/_layout.tsx` — root layout: providers, fonts, global wrappers
5. `app/` directory tree — file-based routing IS the navigation map
6. `tsconfig.json` — path aliases, strict mode
7. `src/` structure — determine pattern:
   - **Flat**: `components/`, `hooks/`, `services/` at top level
   - **Feature-based**: `features/auth/`, `features/feed/` with co-located code

Identify state management: Zustand (`create()`, `useStore`), Context (`createContext`, `Provider`), or other.

### Step 2: Assess code health

Before adding code on top, check existing quality:

- [ ] Lists use FlatList/FlashList (not ScrollView + .map for dynamic data)
- [ ] No barrel exports (index.ts re-exporting everything)
- [ ] No inline styles (should use StyleSheet.create or styling library)
- [ ] useEffect cleanups present for timers/subscriptions
- [ ] No console.log in production code
- [ ] Components under 250-300 lines
- [ ] No `renderThing()` functions masquerading as components

If critical issues found in the area being modified — fix them as part of the change. Don't fix unrelated areas.

### Step 3: Clarify (if needed)

Use `AskUserQuestion` only if the request is ambiguous. Generate options specific to the app. Skip if already specific.

### Step 4: Plan the change

Before writing code:

1. **PRD impact** — which sections change (§4 features, §5 monetization, §6 UX, §2 non-goals)
2. **Files to modify** — list specific files
3. **Files to create** — new screens, components, hooks, services
4. **Files to delete** — screens, components becoming unused
5. **Dead code** — imports, types, dependencies that become orphaned
6. **Refactoring needed** — if a component you're modifying exceeds 250 lines or has 3+ useState, split it as part of this change
7. **Artifacts to update**:
   - `spec/prd.md`
   - `marketing/` — if core value prop changed
   - `README.md` — if features or setup changed
   - `privacy_policy.md` — if data collection changed
   - Do NOT update `aso/` — ASO is managed separately via `/optimize-aso` after code is finalized
8. **Version bump** — patch (bugfix), minor (feature/UX), major (redesign/breaking)

### Step 5: Apply changes

Execute in this order:

**1. Update PRD first** — source of truth:
```
> [UPDATED <date>]: Added/removed/changed <what> — <why>
```

**2. Modify code** — follow existing patterns:
- Match the project's architecture (flat vs feature-based)
- Reuse existing components/hooks — don't create duplicates
- Route files in `app/` should be thin re-exports: `export { Screen as default } from '@/features/...'`
- Extract a custom hook when 3+ useState/useEffect are logically related
- Replace `renderThing()` functions with proper `<Thing />` components
- Use StyleSheet.create or the project's styling approach — no inline styles
- Fetch docs via mcpdoc before using any new SDK module

**3. When adding a feature:**
- Add to PRD §4 with Purpose/Action/Response/Success
- Create files following existing structure
- Add navigation entry in the appropriate layout
- Add to ASO description if user-facing

**4. When removing a feature:**
- Remove from PRD §4
- Delete screen file(s) and navigation entry
- Delete related components, hooks, services, types
- Clean all imports referencing deleted code
- Note: ASO will need updating via `/optimize-aso` after code changes are done
- Remove unused dependencies from package.json
- If feature used fonts: search for font family name strings in ALL style objects, remove from config plugin
- If feature had Zustand persisted state: add migration to remove fields (don't just delete from store definition — orphaned data persists)
- If feature's screen was a deep link target: add redirect from old route (see "Renaming/removing routes" below)

**5. When renaming or removing routes:**
- Renaming a file in `app/` changes URLs — deep links, push notification payloads, saved bookmarks all break silently
- Before renaming: grep codebase for the old route path string
- After renaming: add `<Redirect>` in a stub file at the old path, or add static redirect in app.json
- If push notifications target this route: the backend payload must be updated too — flag this to the user

**6. When changing UX/design:**
- Update PRD §6
- Apply consistently across ALL affected screens — not just one
- Keep design tokens (colors, spacing) in theme — no hardcoded values in components
- Verify touch targets remain above platform minimums
- Verify accessibility labels and roles survived the change — component replacement drops them silently
- If changing component hierarchy: check that `accessible={true}` groupings still make sense

**7. When modifying data models:**
- SQLite: add migration block with incremented `user_version` — existing user data must survive
- Zustand persisted stores: bump `version` and add `migrate` function — shallow merge loses nested fields
- Never rename or change type of a persisted field without migration — causes data loss or runtime crashes

**8. When adding new dependencies:**
- Use `npx expo install <package>` — not `npm install` (Expo resolves compatible versions)
- Run `npx expo install --check` after adding — exits non-zero if incompatible
- Fetch docs via mcpdoc before using the new library

**9. Clean up dead code:**
- Delete unused files — never comment out code
- Remove orphaned imports
- Remove unused dependencies from package.json
- Remove orphaned navigation routes
- Remove orphaned assets (images, fonts, sounds no longer referenced)

**7. Update artifacts:**
- `app.config.js` — bump version
- `marketing/` — update if value prop changed
- `README.md` — update feature list
- `privacy_policy.md` — update if data handling changed

### Step 6: Verify

1. `npx tsc --noEmit` — no TypeScript errors (with Typed Routes enabled, also catches broken route references)
2. `npx expo install --check` — all dependencies compatible with current SDK
3. PRD matches code — every feature in PRD exists, nothing in code that's not in PRD
4. No dead code — no unused imports, files, dependencies, assets
5. Artifacts in sync — marketing and docs match actual features (ASO updated separately)
6. If routes changed — old routes have redirects or stubs
7. If data model changed — migrations added for SQLite and/or Zustand persisted stores
8. If UX changed — styles consistent across all affected screens, accessibility intact

### Step 7: Report

Show summary (in user's language):

```
## v<new-version>

**Change**: <what was requested>
**Type**: feature / removal / fix / redesign

### Code
- Modified: <file list>
- Created: <file list>
- Deleted: <file list>

### Code health
- <any refactoring done as part of this change>

### Artifacts updated
- <list>

### Dead code removed
- <list>

Anything else to change?
```

Wait for feedback:
- More changes → loop back to Step 3
- Done → complete
- Revert → undo changes

---

## RULES

- **PRD first** — update spec before code
- **Understand before changing** — read codebase structure before writing
- **Follow existing patterns** — match architecture, naming, style
- **No dead code** — delete what's unused, never comment out
- **No duplicates** — reuse existing components/hooks
- **Scope discipline** — one change per request, don't refactor unrelated code
- **Artifacts in sync** — ASO, marketing, docs reflect current state
- **Version bump** on every change
- **Fetch docs** before using new SDK modules
- **Fix what you touch** — if code you're modifying has quality issues, fix them; leave the rest alone
