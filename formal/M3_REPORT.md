# M3 vertex-theorem report

Date: 2026-08-24. Status: **PASS, INCLUDING MATRIX WRAPPER**.

## Machine-checked proof chain

1. `exists_extreme_isMinOn`: a continuous linear functional on a nonempty
   compact set has a minimizing extreme point. The minimizer set is exposed,
   hence extreme; Krein--Milman supplies an extreme point inside it.
2. `exists_extreme_discrete_optimizer`: an integral/reconstructible extreme
   minimizer transfers back to an optimal discrete point after adding the
   support-dependent fixed-charge offset.
3. `fixedChargeCost_affine_on_support`: conditioning on positive support turns
   the fixed-charge objective into offset plus marginal linear cost.
4. `embed_mem_own_supportCell`: a feasible integer vector lies in its own
   support cell.
5. `integral_extreme_reconstruct`: an integral extreme cell point reconstructs
   a feasible nonnegative integer vector with exactly the conditioned support.
6. `exists_fixedCharge_optimum`: feasibility and integral upper bounds make the
   discrete feasible set finite, so an optimum exists.
7. `exists_optimal_extreme_support_cell_for_fixed_charges`: for setup and
   marginal coefficients of arbitrary sign, nonempty compact integral support
   cells imply an optimum that is an extreme point of its own support cell.
8. `isClosed_linearAmbient`: a finite system of linear inequalities and
   equalities defines a closed set.
9. `isCompact_supportCell_linearAmbient`: each support cell lies in the compact
   coordinate box `[0,u]`, hence is compact.
10. `exists_optimal_extreme_support_cell_for_linear_system`: the matrix-facing
    theorem discharges compactness internally and retains arbitrary signs.

The marginal continuous linear functional is constructed internally from
coordinate projections. It is not an input assumption.

## Stronger point discovered during formalization

The extreme-minimizer lemma does not need convexity. Compactness suffices under
Mathlib's definition of extreme points because the minimizing exposed subset is
extreme in the original set. Paper 1 only applies the result to polyhedral
cells, so the manuscript need not advertise this stronger abstraction unless
it improves exposition.

## Axiom audit

Every M3 theorem reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

No `native_decide.ax_*`, `sorry`, `admit`, or project-defined axiom occurs in
the general proof chain.

## Full gate

```text
proof-hole gate passed
Build completed successfully (2216 jobs).
M2 witnesses: PASS
M1/model controls: PASS
make check: 41.049 s, USER=11.775, SYS=12.329
```

## Exact remaining boundary

The theorem is machine-checked conditional on `CellIntegral` for every support
cell. The TU-to-integrality implication in Corollary 1 remains M5 and is not
claimed here. The active-column corollary remains M4.

STATUS: FINAL
