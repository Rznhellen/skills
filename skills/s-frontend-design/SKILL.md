---
name: s-frontend-design
description: >-
  Use when making frontend architecture decisions, building UI components,
  choosing design patterns, or verifying visual/accessibility quality.
---

# Frontend Architecture & Design System

## Decision framework: component architecture

Choose a pattern based on the component's responsibility:

| Responsibility | Pattern | Example |
|---|---|---|
| Pure display, no state | Presentational component | `Badge`, `Card`, `Avatar` |
| Local UI state (open/closed, hover) | Stateful component with internal state | `Dropdown`, `Accordion` |
| Shared state across siblings | Lift state to nearest common parent | Form with dependent fields |
| Complex state logic | Reducer pattern or state machine | Multi-step wizard |
| Cross-cutting data (auth, theme) | Context/provider | `AuthProvider`, `ThemeProvider` |
| Server data with cache/sync | Data-fetching hook or query layer | `useQuery`, SWR pattern |

## Design system rubric

Good UI in this project means:

1. **Consistent** — uses existing tokens (spacing, color, typography) before inventing new ones
2. **Composable** — components accept children/slots rather than growing prop APIs
3. **Responsive** — works at mobile, tablet, desktop without separate implementations
4. **Feedback-rich** — loading states, error states, empty states are first-class
5. **Predictable** — similar things look similar; different things look different

## When to create a new component vs. extend an existing one

Create new when: the thing has a distinct name in the domain, or combining responsibilities would violate single-responsibility.

Extend existing when: the variation is purely visual (size, color) or the behavior is a strict superset.

## Accessibility requirements

Every component must satisfy the accessibility rubric in `reference/accessibility-rubric.md`. The short version:

- Keyboard navigable (Tab, Enter, Escape, Arrow keys where expected)
- Screen reader announces purpose and state
- Color is never the only differentiator
- Touch targets >= 44x44px
- Focus is visible and managed through interactions

## Visual verification approach

When a UI change is complete:

1. Screenshot the component in all meaningful states (default, hover, active, disabled, error, loading, empty)
2. Compare against the rubric above — does it pass all five criteria?
3. Check at mobile and desktop breakpoints
4. Verify dark/light mode if the project supports both
5. Confirm the component degrades gracefully when content overflows or is missing

## Anti-patterns to avoid

- **Prop drilling through 3+ levels** — use context or composition instead
- **God components** (>300 lines) — decompose into focused sub-components
- **Inline styles for structural layout** — use the design system's spacing/layout primitives
- **Suppressing accessibility warnings** — fix the underlying issue
- **Conditional rendering spaghetti** — extract into named sub-components or early returns
