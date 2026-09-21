# M1 finite optimization report

Date: 2026-08-24. Status: **CORE PASS**.

## Machine-checked objects

- `argminSet`: all feasible global minimizers; no tie-break is hidden.
- `optimumValue`: minimum cost of a nonempty finite feasible set.
- `HasUniqueArgmin`: the argmin set is a singleton.
- `smallestArgmin` and `largestArgmin`: separate extremal selectors.

The proved interface includes:

1. argmin membership iff feasibility plus global optimality;
2. existence of an argmin for every nonempty finite feasible set;
3. argmin cost equals `optimumValue`, in both directions;
4. each selector belongs to the argmin set and is globally optimal;
5. smallest is below every optimizer and largest is above every optimizer;
6. both selectors coincide under a unique optimum.

## Positive and negative controls

All checks use exact integers and `native_decide`.

- Positive: on `{0,1,2}` with cost `x`, the unique optimum is `0`; both
  selectors return `0`.
- Negative: on `{0,1,2}` with constant cost, all points tie; smallest returns
  `0` and largest returns `2`.
- Sham claim: the statement that the two selectors always agree is formally
  refuted by the tied instance.

These controls matter for Paper 2 because a statement about an unnamed
optimizer cannot silently switch between the smallest and largest minimizer.

## Gate output

```text
proof-hole gate passed
Build completed successfully (712 jobs).
FixedCharge/Audit.lean: exit 0
FixedChargeCore.lean: exit 0
FixedCharge/Tests/FiniteOpt.lean: exit 0
make check: 27.008 s, USER=4.607, SYS=8.220
```

The finite optimization theorems report only Lean's standard `propext`,
`Classical.choice`, and `Quot.sound`. No project-defined axiom is present.

## Remaining M1 work

The reusable optimization/selector layer is complete. Domain objects—schedule,
capacity, conservation, and exact schedule cost—belong in `Model/` and are the
next slice. Paper-specific finite witnesses remain M2.

STATUS: FINAL
