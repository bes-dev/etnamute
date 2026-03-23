---
paths:
  - "apps/**/.maestro/**"
  - "apps/**/*.yaml"
---

# Maestro Flow Rules

## Reliability

- `waitForAnimationToEnd` after EVERY navigation action — no exceptions
- `extendedWaitUntil` for async content — never use arbitrary delays
- `retryTapIfNoChange: true` on buttons that may not register first tap
- Use `id` selector (testID) over text or label — most stable across updates
- `continueOnFailure: false` in config.yaml for smoke tests — fail fast

## iOS Workarounds

- Do NOT use `hideKeyboard` — unreliable on iOS. Use `tapOn: { point: "50%,10%" }` instead
- `clearState` on iOS reinstalls the entire app — may not clear UserDefaults. Double-clear: `clearState` then `launchApp: { clearState: true }`

## Screenshots

- `takeScreenshot` captures visible viewport only — not full scroll
- For scrollable content: capture multiple viewports and note in output
- Always `waitForAnimationToEnd` before `takeScreenshot`
- Use environment variables in screenshot paths for multi-device runs

## Flow Structure

- One flow per screen/feature, tagged by milestone: `tags: [smoke, m2]`
- Subflows in `subflows/` directory — not auto-executed by `maestro test`
- Login/setup flows as reusable subflows referenced via `runFlow`

## Crash Detection

- `assertNotVisible: "Invariant Violation"` after launch
- `assertNotVisible: "TypeError"` after launch
- `extendedWaitUntil: { visible: ".*", timeout: 15000 }` catches white screen and crash

## Expo Requirements

- Dev builds only — Expo Go is unreliable with Maestro
- App's `appId` must match `ios.bundleIdentifier` / `android.package` from app.json
