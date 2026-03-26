---
name: interaction-map
description: Analyze every interactive UI element — classify effects, detect broken promises, map cross-screen dependencies
---

Build an interaction map for every interactive element in the app.

For EVERY interactive element in the codebase — `onPress`, `onValueChange`, `onSubmit`, AND gesture-based interactions (`Swipeable`, `LongPressGestureHandler`, `PanGestureHandler`, `Draggable`, swipe-to-delete, pull-to-refresh):

1. **Determine what a USER expects** from the element's label, type, and context — NOT from reading the handler code. Infer expected behavior from what the control promises visually.

2. Read the handler code and trace the effect chain: handler → state change → re-render → UI change

3. **Compare user expectation vs actual effect.** If the UI promises something the code doesn't deliver — that's a bug, not a "design gap".

4. Classify the effect type:

| Type | Example | How to test |
|------|---------|-------------|
| **Visual on current screen** | "Save" → success message appears | Maestro: tap → `assertVisible` |
| **Visual on another screen** | Setting that affects other screens | Maestro: tap → navigate → `takeScreenshot` → Claude reviews |
| **Navigation** | "View Details" → detail screen opens | Maestro: tap → `assertVisible` destination |
| **State without immediate visual** | Store update, preference save | Unit test: `fireEvent.press` → `expect(store.field).toBe(value)` |
| **Side effect without visual** | Analytics event, prefetch, log | Unit test: `expect(mockFn).toHaveBeenCalled()` |
| **Gesture** | Swipe to delete, pull to refresh, long-press menu | Maestro: `swipe` → verify effect. **Gestures MUST be tested via Maestro** — they require native modules (GestureHandler, Reanimated) that can crash at runtime without any signal from tsc/bundler/unit tests |
| **Broken promise** | Control's label implies an effect that doesn't happen | **Report as BUG** |

5. For state/visual effects that span multiple screens — list ALL screens that depend on the changed state

**CRITICAL RULE: "stores preference but has no visible effect" is a BUG if the user would expect a visible effect from the control's label and context. Do NOT classify unimplemented functionality as "design gaps" — if the UI shows the control, the feature must work.**

Output: a table with columns: Element | testID | Screen | Effect Type | Details | Bug?
