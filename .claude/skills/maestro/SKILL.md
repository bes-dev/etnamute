# Maestro Skill

Maestro automates mobile UI on simulators. Used for functional testing, smoke testing, visual verification, and screenshots.

**Always fetch Maestro docs via mcpdoc before writing flows** — API evolves between versions.

## Setup

- **Dev builds required** — Expo Go doesn't support `launchApp`, `clearState`, `killApp`
- Build with `npx expo run:ios` or `eas build --profile development-simulator`
- App's `appId` = `ios.bundleIdentifier` / `android.package` from app.json

## Core Principle

**Every `tapOn` must be followed by an assertion proving something VISIBLY changed.**

```yaml
# BAD — proves nothing:
- tapOn: "Save"
- takeScreenshot: "after-save"    # Screenshot is NOT verification!

# GOOD — proves the tap worked:
- tapOn: "Save"
- assertVisible: "Saved successfully"
- assertNotVisible: "Unsaved changes"
```

**`takeScreenshot` is documentation, NOT verification.** A test that only takes screenshots after taps will PASS even if every button is broken. Always pair with `assertVisible`/`assertNotVisible`/`assertWithAI`.

## Functional Testing Patterns

### Button → verify effect
```yaml
- tapOn: "Add to Cart"
- assertVisible: "Cart (1)"
```

### Toggle → verify state through companion text
```yaml
- tapOn:
    id: "dark-mode-toggle"
- assertVisible: "Dark Mode: On"
```

### Form → verify success
```yaml
- tapOn: { id: "email-input" }
- inputText: "test@example.com"
- hideKeyboard
- tapOn: "Submit"
- assertVisible: "Welcome"
```

### Persistence → kill and relaunch
```yaml
- tapOn: "Save Item"
- assertVisible: "My Item"
- killApp
- launchApp            # WITHOUT clearState
- assertVisible: "My Item"
```

### Settings → verify across screens
```yaml
- tapOn: "Settings"
- tapOn: { id: "theme-dark" }
- tapOn: "Home"        # Navigate away
- tapOn: "Settings"    # Come back
- assertVisible: "Theme: Dark"   # Still set
```

### Delete → verify removed
```yaml
- swipe:
    from: { id: "item-row" }
    direction: LEFT
- tapOn: "Delete"
- assertNotVisible: "Item Name"
- assertVisible: "No items yet"
```

### Error path → fix → success
```yaml
- tapOn: "Submit"
- assertVisible: "Email is required"
- tapOn: { id: "email-input" }
- inputText: "valid@email.com"
- tapOn: "Submit"
- assertVisible: "Success"
```

### Counter → verify increment
```yaml
- copyTextFrom: { id: "counter" }
- evalScript: ${output.before = parseInt(maestro.copiedText)}
- tapOn: { id: "increment" }
- copyTextFrom: { id: "counter" }
- evalScript: ${output.after = parseInt(maestro.copiedText)}
- assertTrue:
    condition: ${output.after === output.before + 1}
```

## Expo Router Gotchas

### Tab bar — use point-based tapping
```yaml
- tapOn:
    point: "50%,93%"   # Use maestro hierarchy to find exact coordinates
```

### accessibilityLabel hides children
Assert on `id` (testID) instead of inner text.

### Reanimated views invisible
Don't assert on text inside animated views. Use `id` or nearby static elements.

### Flows must run sequentially
Use `config.yaml` with `continueOnFailure: false`.

### waitForAnimationToEnd ≠ sleep
Use `extendedWaitUntil` with a visible condition instead.

### hideKeyboard unreliable on iOS
Use `tapOn: { point: "50%,10%" }` as fallback.

## Flow Organization

```
.maestro/
├── config.yaml
├── smoke/              # Navigation + crash detection
│   └── all-screens.yaml
├── functional/         # Every interactive element
│   ├── home-interactions.yaml
│   ├── settings-toggles.yaml
│   └── form-submission.yaml
├── persistence/        # killApp → relaunch → verify
│   └── data-survives.yaml
├── errors/             # Error paths
│   └── form-validation.yaml
└── subflows/           # Reusable (login, navigate-to)
    └── login.yaml
```

Tag flows: `tags: [smoke]`, `tags: [functional]`, `tags: [persistence]`, `tags: [errors]`

## Scripts

- `scripts/smoke.sh apps/<slug>` — prebuild, simulator, Metro, Maestro, cleanup
- `scripts/verify.sh apps/<slug>` — unit tests + build + runtime (no Maestro)
