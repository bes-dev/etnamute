---
paths:
  - "apps/**/*.tsx"
  - "apps/**/*.ts"
---

# App Patterns

Library choices and architectural patterns. When implementing any of these areas, fetch current docs via mcpdoc first.

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
- **Key-value storage**: prefer MMKV (synchronous, fast) over AsyncStorage (deprecated in newer SDKs)
- **Auth tokens/secrets**: expo-secure-store (encrypted)
- SQLite migrations: use `PRAGMA user_version` to track schema version
- Wrap database initialization with `<SQLiteProvider onInit={migrate}>` — prevents race conditions
- For offline-first: each entity should have a `syncStatus` field for future cloud sync readiness

## Accessibility

- All interactive elements must have `accessibilityLabel` or `aria-label`
- Use `accessibilityRole` (or `role` prop) on all semantic elements
- Respect `isReduceMotionEnabled()` from AccessibilityInfo — disable/simplify animations
- Support text scaling (`allowFontScaling` — don't disable it)
- Minimum touch target: follow platform guidelines (check via accessibility audit tools)
- Test with screen readers periodically — automated tools catch ~30% of issues, manual testing catches the rest
