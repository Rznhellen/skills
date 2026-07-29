# Test Quality Rubric

Concrete thresholds for evaluating test quality. Use as calibration, not as rigid gates.

## Coverage Thresholds

| Area | Target | Rationale |
|------|--------|-----------|
| Business logic (pure functions) | 90%+ branch | This is where bugs cost the most |
| API handlers / controllers | 80%+ line | Integration seams need confidence |
| Infrastructure / glue code | 60%+ line | Diminishing returns below this |
| Generated code / config | Skip | Test the generator, not the output |

## Test Quality Signals

### Green Flags
- Test names read as behavior specifications
- Failures point directly to what broke (no detective work)
- Tests are independent — run in any order, pass in isolation
- Setup is minimal and intent is visible in the first 3 lines
- Assertions are specific (not `toBeTruthy()` on complex objects)

### Red Flags
- Test mirrors implementation line-by-line (fragile coupling)
- Dozens of mocks to test one function (wrong boundary)
- Test passes when the feature is broken (false confidence)
- Shared mutable state between tests (order-dependent)
- `sleep()` or timing-dependent assertions (flaky)

## Severity of Missing Tests

| Risk | What's missing | Action |
|------|---------------|--------|
| Critical | No tests for payment/auth/data-loss paths | Block merge |
| High | Business rule untested, integration seam uncovered | Request before merge |
| Medium | Edge case uncovered, error path untested | Note, don't block |
| Low | Utility function without dedicated test (covered transitively) | Accept |

## Test Maintenance Cost

A test is worth keeping when:
```
(probability of catching a real bug) * (cost of that bug in production)
  > (maintenance cost of the test over its lifetime)
```

Delete tests that:
- Test deleted features
- Duplicate coverage without adding signal
- Break on every refactor but have never caught a bug
- Test framework/library behavior rather than your code
