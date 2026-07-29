# Component Architecture Patterns

## Presentational (stateless display)

```tsx
interface BadgeProps {
  label: string;
  variant: 'info' | 'success' | 'warning' | 'error';
}

function Badge({ label, variant }: BadgeProps) {
  return <span className={`badge badge--${variant}`}>{label}</span>;
}
```

**When:** Pure mapping from props to markup. No effects, no internal state.

## Compound component (nested composition)

```tsx
function Select({ children, value, onChange }) {
  return (
    <SelectContext.Provider value={{ value, onChange }}>
      <div role="listbox">{children}</div>
    </SelectContext.Provider>
  );
}

Select.Option = function Option({ value, children }) {
  const ctx = useContext(SelectContext);
  return (
    <div role="option" aria-selected={ctx.value === value}
         onClick={() => ctx.onChange(value)}>
      {children}
    </div>
  );
};
```

**When:** The component has multiple sub-parts that need to share implicit state but the consumer controls composition.

## Render prop / headless hook

```tsx
function useToggle(initial = false) {
  const [on, setOn] = useState(initial);
  const toggle = useCallback(() => setOn(v => !v), []);
  return { on, toggle, setOn };
}
```

**When:** Behavior is reusable across visually different components. Separate logic from presentation entirely.

## Container / view split

```tsx
// Container: owns data fetching and state
function UserProfileContainer({ userId }) {
  const { data, isLoading, error } = useQuery(['user', userId], fetchUser);
  if (isLoading) return <ProfileSkeleton />;
  if (error) return <ErrorCard message={error.message} />;
  return <UserProfileView user={data} />;
}

// View: pure presentation
function UserProfileView({ user }) {
  return (
    <Card>
      <Avatar src={user.avatar} alt={user.name} />
      <h2>{user.name}</h2>
      <p>{user.bio}</p>
    </Card>
  );
}
```

**When:** Data fetching logic should be testable separately from rendering.

## State machine (complex UI states)

```tsx
type WizardState = 'info' | 'confirm' | 'processing' | 'done' | 'error';

function useWizard() {
  const [state, setState] = useState<WizardState>('info');

  const transitions: Record<WizardState, Partial<Record<string, WizardState>>> = {
    info:       { next: 'confirm' },
    confirm:    { submit: 'processing', back: 'info' },
    processing: { success: 'done', failure: 'error' },
    error:      { retry: 'confirm' },
    done:       { reset: 'info' },
  };

  const send = (event: string) => {
    const next = transitions[state]?.[event];
    if (next) setState(next);
  };

  return { state, send };
}
```

**When:** More than 3 states with non-trivial transitions. Prevents impossible state combinations.

## Layout component

```tsx
function Stack({ gap = 'md', direction = 'vertical', children }) {
  return (
    <div className={`stack stack--${direction} stack--gap-${gap}`}>
      {children}
    </div>
  );
}
```

**When:** Spacing and alignment are the component's only job. Keeps layout concerns out of content components.

## Choosing between patterns

```
Is it purely visual with no behavior?
  → Presentational

Does it have sub-parts the consumer arranges?
  → Compound component

Is the behavior reusable but the visuals vary?
  → Headless hook

Does it fetch or manage async data?
  → Container/view split

Are there 3+ states with conditional transitions?
  → State machine

Does it only control spacing/alignment?
  → Layout component
```
