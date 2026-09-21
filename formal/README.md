# Lean scope

The Lake project machine-checks the algebraic kernel of the paper: once the
nonzero support is fixed, each charge agrees with its affine branch and the
objective splits into a support-dependent constant plus a linear term.

The maintained implementation is `FixedCharge/Core/Charge.lean`. It is generic
over a commutative ring and uses `Finset`, so the same theorem applies to exact
rational computations in Paper 2 and real-valued geometry in Paper 1.
`FixedChargeCore.lean` remains as a compatibility import.

`FixedCharge/Core/FiniteOpt.lean` defines the finite argmin set and optimum
value. `FixedCharge/Core/TieBreak.lean` defines smallest and largest argmin
separately; `FixedCharge/Tests/FiniteOpt.lean` contains exact positive and
negative tie-breaking controls.

The `FixedCharge/Model/` modules specialize this core to finite timing
schedules. Capacity is encoded in the schedule type; causality, conservation,
deadlines, finite enumeration, and exact rational cost remain separate named
objects. See `MODEL_REPORT.md` for the model boundary and controls.

`FixedCharge/Geometry/` and `FixedCharge/Paper1/` contain the support-cell
proof. Lean checks that finite linear constraints make every support cell
compact, a TU integer constraint matrix makes every cell integral, and the
fixed-charge problem has an optimal extreme point with the same support. This
general chain uses only Lean's standard axioms and does not use the native
evaluator.

M4 checks the full active-column corollary: finite slack supplies a common
two-sided perturbation radius, extremality forces every active-column relation
to vanish, and the interior-coordinate count is bounded by active-matrix rank.
M5 supplies the TU-to-integrality bridge from Mathlib's determinant-level TU
definition. There are no `sorry`, `admit`, project-added `axiom`, or
`set_option autoImplicit true`.

Check with:

```sh
cd formal
lake update                 # first checkout only
make check                  # scan, build, axiom report, compatibility
```

Pinned versions:

- Lean `v4.29.0`;
- Mathlib tag `v4.29.0`, resolved exactly in `lake-manifest.json`.

Build concurrency is capped with `LEAN_NUM_THREADS=4` for the target laptop.
