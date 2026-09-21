# Shared timing-model report

Date: 2026-08-24. Status: **PASS**.

## Boundary between papers

`Core/Charge.lean` remains the domain-free fixed-charge layer used by Paper 1's
general integer program. The new `Model/` layer is the timing specialization
needed by Paper 2 and by Paper 1's lot-sizing certificates. The two are not
presented as the same theorem.

## Machine-checked model

- `Schedule T C := Fin T -> Fin (C + 1)`: capacity is encoded in the type.
- `prefixSum`, `servedPrefix`, and `totalServed`: exact natural-number paths.
- `Causal`: cumulative service never exceeds cumulative arrivals.
- `Conserves`: total service equals total arrivals.
- `MeetsDeadline`: `A(k-slack) <= E(k)` for every `k = 0,...,T`.
- `Feasible`: conjunction of the three predicates; capacity is automatic.
- `feasibleSet`: computable finite enumeration of all feasible schedules.
- `scheduleCost`: exact rational fixed-charge cost.

The model proves that per-period service cannot exceed capacity, that the
horizon prefix equals total service, and that fixed-charge schedule cost is
affine after conditioning on positive support.

## Exact controls

All controls compile through `native_decide`:

1. arrivals `(1,1)`, service `(1,1)`, capacity 1, slack 0: feasible;
2. the corresponding feasible set is the singleton `{(1,1)}`;
3. arrivals `(0,1)`, service `(1,0)`: conserves total but violates causality;
4. arrivals `(1,0)`, service `(0,1)`: causal and conserving but violates the
   zero-slack deadline;
5. setup `(-2,3)`, marginal `(-1,1)`, service `(1,0)`: exact cost `-3`.

Controls 3 and 4 ensure conservation alone cannot accidentally stand in for
timing feasibility.

## Gate output

```text
proof-hole gate passed
Build completed successfully (809 jobs).
FixedCharge.Tests.FiniteOpt: PASS
FixedCharge.Tests.Model: PASS
make check: 26.483 s, USER=5.209, SYS=8.292
```

`service_le_capacity` is axiom-free. The other reported assumptions are only
Lean's standard `propext`, `Classical.choice`, and `Quot.sound`; no project
axiom is present.

## Next gate

M2 may now encode manuscript witnesses as named exact instances. Every number
printed in Paper 1 must come from a named theorem, and perturbing one datum must
break at least one expected-value test.

STATUS: FINAL
