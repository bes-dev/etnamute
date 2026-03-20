---
paths:
  - "apps/**/*.tsx"
  - "apps/**/*.ts"
---

# Code Health Rules

## Components

- Components must not exceed 250-300 lines — split if larger
- No `renderThing()` functions — extract to proper `<Thing />` components with their own props
- No calling components as functions `{Card(data)}` — always use JSX `<Card data={data} />`
- 3+ logically related `useState` → extract to a custom hook

## Lists

- Dynamic data lists must use FlatList or FlashList — never ScrollView + .map()
- FlatList must have `keyExtractor`
- `renderItem` should be wrapped in `useCallback`
- No FlatList inside ScrollView — it disables virtualization entirely. Use `ListHeaderComponent`/`ListFooterComponent` instead

## Styles

- All styles via StyleSheet.create or the project's styling library — no inline style objects
- No hardcoded hex colors in components — use theme/design tokens
- `useWindowDimensions()` for responsive layout — not `Dimensions.get()` (doesn't update on rotation)

## Imports

- No barrel exports (index.ts re-exporting everything) — breaks Fast Refresh and tree shaking
- Direct imports only: `import { Button } from '@/components/Button'` not `from '@/components'`

## Async & Error Handling

- No floating Promises — every Promise must be awaited, caught, or explicitly voided
- No async functions passed directly to event handlers (onPress, onChangeText) without try/catch
- Use `showBoundary(error)` from error boundary hook to propagate async/event errors to the nearest Error Boundary
- Every useEffect with async code must have try/catch inside

## State

- Zustand selectors returning objects must use `useShallow` to prevent infinite re-render loops
- Don't `const store = useStore()` without a selector — subscribes to everything
- Zustand persisted stores MUST have `version` + `migrate` function — adding/removing/renaming fields without migration breaks user data
- Never use `switch` in Zustand migrations — use sequential `if (version < N)` to handle multi-version jumps

## Effects

- Every useEffect with timers, subscriptions, or listeners must have a cleanup function
- No console.log in production code

## Navigation

- Route files in `app/` should be thin — business logic lives in `src/` or `features/`
- Renaming route files changes URLs — all deep links, push notification targets, and saved links break silently
- Use `router.dismissTo()` to unwind to existing route — `router.navigate()` pushes a new instance in Expo Router v4+

## Fonts

- Always handle both `loaded` and `error` states from `useFonts` — returning null forever freezes the app on splash screen
- After removing a font: search entire codebase for the font family name string in all style objects
- Font removal requires a new native build — OTA updates alone won't work if font was in config plugin

## Platform

- Safe areas: use `useSafeAreaInsets()` from `react-native-safe-area-context` — not the deprecated `SafeAreaView` from React Native core
- Use `Platform.select()` for small style differences, `.ios.tsx`/`.android.tsx` for fundamentally different implementations
