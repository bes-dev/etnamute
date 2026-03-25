---
paths:
  - "apps/**/*.tsx"
  - "apps/**/*.ts"
---

# App Patterns

Library choices and architectural patterns. When implementing any of these areas, fetch current docs via mcpdoc first.

## Expo Go Compatibility (MANDATORY)

Apps MUST work in Expo Go (`npx expo start`). This means:

- **Only use packages from the Expo SDK** (`expo-*`) or pure JS packages
- **Before adding ANY non-Expo package**: check if it requires native code, TurboModules, New Architecture, or a custom dev build. If it does — **do not use it**
- **Install via `npx expo install`** — not `npm install`. Expo install resolves compatible versions and warns about incompatible packages
- **If no Expo equivalent exists**: use a pure-JS alternative, or implement the feature without the package

Packages that do NOT work in Expo Go (do NOT use):
- `react-native-mmkv` (requires TurboModules) → use `@react-native-async-storage/async-storage`
- `react-native-keyboard-controller` (requires native build) → use `KeyboardAvoidingView`
- Any package with `pod install` / native linking requirements not covered by Expo prebuild

## Images

- Use `expo-image` — not react-native-fast-image (unmaintained, no Fabric support)
- Always set `cachePolicy`, `placeholder` (blurhash or thumbhash), and `transition`
- In FlatList/FlashList: set `recyclingKey` to prevent stale images in recycled cells
- For user-uploaded images: resize/compress before storing locally (expo-image-manipulator)
- Prefetch critical images with `Image.prefetch()`

## Forms

- Use `react-hook-form` + Zod — not Formik (abandoned, re-renders entire form on every keystroke)
- Validation mode: `onBlur` for mobile (not `onChange` — too aggressive on touch keyboards)
- Never define Controller render functions inline as named functions — causes keyboard dismissal on re-render
- Extract Zod schemas to separate files — they're independently testable
- Multi-step forms: separate `useForm` per step, shared state in Zustand or Context

## Keyboard

- Use `react-native-keyboard-controller` — not KeyboardAvoidingView (platform-inconsistent, breaks in modals)
- Wrap root layout with `<KeyboardProvider>`
- Use `KeyboardAwareScrollView` for forms — auto-scrolls focused input into view
- Use `KeyboardToolbar` for Previous/Next/Done navigation between inputs
- Use `KeyboardStickyView` for chat-style floating inputs

## Navigation (Expo Router)

- Route files in `app/` should be thin re-exports — logic lives in `src/` or `features/`
- Auth flow: use route groups `(app)/` with `<Redirect>` guard in the group layout
- Store auth tokens in `expo-secure-store` (encrypted), not AsyncStorage
- `router.navigate()` pushes a new instance — use `router.dismissTo()` to unwind to existing route
- Deep links work automatically from file structure — configure `scheme` in app.json
- For modals: prefer Expo Router's `presentation: 'formSheet'` over @gorhom/bottom-sheet for critical modals
- Generate typed routes with `experiments.typedRoutes: true` in app.json

## Error Handling

- Wrap the app root with an Error Boundary — uncaught render errors produce a blank screen on mobile
- Add screen-level Error Boundaries for graceful per-screen recovery (user can navigate away)
- Error Boundaries catch render errors only — NOT event handlers, async errors, or native crashes
- Implement a fallback UI with "retry" action, not just an error message
- Track connectivity with `@react-native-community/netinfo` — show offline banner, not error screens
- For crash reporting: use `@sentry/react-native` with `useNativeInit: true` (captures pre-JS errors)

## Data Persistence

- **Relational data**: expo-sqlite with WAL mode enabled (`PRAGMA journal_mode = WAL`)
- **Key-value storage**: `@react-native-async-storage/async-storage`
- **Auth tokens/secrets**: expo-secure-store (encrypted)
- SQLite migrations: use `PRAGMA user_version` to track schema version, sequential `if (version < N)` blocks
- Set `PRAGMA user_version` only at the END of all migrations — if app crashes mid-migration, it reruns safely
- Wrap database initialization with `<SQLiteProvider onInit={migrate}>` — prevents race conditions
- For offline-first: each entity should have a `syncStatus` field for future cloud sync readiness
- Zustand persisted stores: always provide `version` + `migrate` — shallow merge loses nested object fields and leaves orphaned data

## Accessibility

- All interactive elements must have `accessibilityLabel` or `aria-label`
- Use `accessibilityRole` (or `role` prop) on all semantic elements
- Respect `isReduceMotionEnabled()` from AccessibilityInfo — disable/simplify animations
- Support text scaling (`allowFontScaling` — don't disable it)
- Minimum touch target: follow platform guidelines
- Setting `accessible={true}` on a parent View groups all children into one accessible element — changing hierarchy silently breaks this
- When replacing components (e.g. TouchableOpacity → Pressable), transfer ALL accessibility props — they don't carry over automatically
- Dynamic content changes (mount/unmount) need explicit announcements — `accessibilityLiveRegion` on Android, `AccessibilityInfo.announceForAccessibility()` on iOS

## Testability

- Add `testID` to all interactive elements (buttons, inputs, tabs, navigation targets) — required for Maestro automation
- Naming convention: `testID="btn-submit"`, `testID="input-email"`, `testID="tab-home"`
- `testID` is separate from `accessibilityLabel` — both should be set
