# M2 Paper 1 witness report

Date: 2026-08-24. Status: **PASS**.

## Manuscript-to-Lean map

- Lot sizing: unique `(1,1,0)`, value `-4`, prefixes `(1,2,2)`.
- Transportation/flow: unique all-ones plan, value `-8`, support cardinality 4.
- APR state space: 35 feasible schedules; unique unrestricted `(1,1,1,1)`
  at `-8`; every restricted plan costs at least `-5`, attained by `(4,0,0,0)`.
- Sharpness: 113 feasible integer points; unique `(2,4,3)` at `-1147/100`;
  every other point costs at least `-1143/100`, attained by `(3,3,3)`; two
  distinct rational cell points have midpoint `(2,4,3)`.
- Modelling guard: guarded lower bound `-20` and unguarded lower bound `-25`,
  both with explicit attaining plans.

All statements are named theorems in `FixedCharge/Paper1/Witnesses.lean`.

## Perturbation controls

Four controls alter one datum each. They prove that the old lot-sizing,
transportation, and sharpness values fail, and that removing the APR setup
reward destroys the old singleton argmin. Thus the certificates consume the
instance data rather than merely restating constants.

## Trust boundary

Finite exhaustive claims use `native_decide`. An attempted replacement by
kernel `decide` failed because reduction stops at opaque finite-set definitions,
not because a counterexample was found. Lean's axiom report therefore lists a
generated theorem-specific `native_decide.ax_1_1` for these certificates.

This is an explicit extension of the trust base to Lean's native evaluator. It
is not a user-declared mathematical axiom, but it is also not described as a
pure kernel proof. M3's general theorem is forbidden from using
`native_decide`; it must be an ordinary term proof with only standard Lean
axioms reported.

## Gate

```text
proof-hole gate passed
FixedCharge.Paper1.Witnesses: PASS
full make check: PASS
```

STATUS: FINAL
