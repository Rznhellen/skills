# Accessibility Rubric

Score each component against these criteria. All must pass before shipping.

## 1. Keyboard navigation

- [ ] All interactive elements reachable via Tab (in logical order)
- [ ] Enter/Space activates buttons and links
- [ ] Escape closes modals, dropdowns, popovers
- [ ] Arrow keys navigate within composite widgets (tabs, menus, listboxes)
- [ ] No keyboard traps — focus can always leave the component
- [ ] Skip links available for repeated navigation blocks

## 2. Screen reader semantics

- [ ] Correct ARIA role (or native HTML element that implies it)
- [ ] Accessible name via label, aria-label, or aria-labelledby
- [ ] State communicated: expanded/collapsed, selected, checked, disabled
- [ ] Live regions (aria-live) for dynamic content updates
- [ ] Headings form a logical hierarchy (no skipped levels)
- [ ] Lists use `<ul>`/`<ol>`/`<dl>` — not divs styled as lists

## 3. Visual design

- [ ] Color contrast >= 4.5:1 for normal text, >= 3:1 for large text (WCAG AA)
- [ ] Color is never the sole indicator (always paired with icon, text, or pattern)
- [ ] Focus indicator visible with >= 3:1 contrast against adjacent colors
- [ ] Text resizable to 200% without loss of content or function
- [ ] No content conveyed only through CSS (::before/::after with meaningful text)

## 4. Touch and pointer

- [ ] Touch targets >= 44x44px (iOS) / 48x48dp (Android)
- [ ] Adequate spacing between targets (>= 8px)
- [ ] Hover-only information also available via focus or tap
- [ ] Drag operations have a non-drag alternative

## 5. Motion and timing

- [ ] Animations respect prefers-reduced-motion
- [ ] No content that auto-advances without user control
- [ ] Timeouts are generous or adjustable
- [ ] No flashing content (>3 flashes/second)

## 6. Forms and errors

- [ ] Every input has a visible, associated label
- [ ] Required fields indicated in label (not just by color)
- [ ] Error messages reference the field and describe how to fix
- [ ] Error summary available at form level for multi-field validation
- [ ] Autocomplete attributes on personal data fields

## 7. Images and media

- [ ] Informative images have descriptive alt text
- [ ] Decorative images have alt="" or are CSS backgrounds
- [ ] Complex images (charts, diagrams) have long descriptions
- [ ] Video has captions; audio has transcripts

## Testing approach

1. **Automated**: axe-core or similar on every component story/test
2. **Keyboard**: Tab through the entire flow without a mouse
3. **Screen reader**: Test with VoiceOver (macOS) or NVDA (Windows) at least once per new pattern
4. **Zoom**: Browser zoom to 200%, verify no overflow or hidden content
5. **Reduced motion**: Enable prefers-reduced-motion, confirm animations are suppressed
