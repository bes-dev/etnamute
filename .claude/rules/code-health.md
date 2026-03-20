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

## State

- Zustand selectors returning objects must use `useShallow` to prevent infinite re-render loops
- Don't `const store = useStore()` without a selector — subscribes to everything

## Effects

- Every useEffect with timers, subscriptions, or listeners must have a cleanup function
- No console.log in production code

## Navigation

- Route files in `app/` should be thin — business logic lives in `src/` or `features/`
- Renaming route files changes URLs — check deep links, push notifications, saved links

## Platform

- Safe areas: use `useSafeAreaInsets()` from `react-native-safe-area-context` — not the deprecated `SafeAreaView` from React Native core
- KeyboardAvoidingView: `behavior="padding"` on iOS, `undefined` on Android
- Use `Platform.select()` for small style differences, `.ios.tsx`/`.android.tsx` for fundamentally different implementations
