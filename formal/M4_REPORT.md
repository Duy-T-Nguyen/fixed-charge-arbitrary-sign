# M4 active-column report

Date: 2026-08-24. Status: **PASS**.

`direction_eq_zero_of_extreme` proves that an extreme point cannot admit a
nonzero direction whose positive and negative perturbations both remain in the
set. `direction_eq_zero_of_extreme_smul` proves the scaled form used after
choosing a nonzero perturbation radius.

`eventually_mem_linearAmbient_along_direction` proves that annihilating every
tight inequality row and every equality row preserves the linear system for
all sufficiently small perturbations. `eventually_mem_supportCell_along_direction`
adds the support-cell bounds. `exists_symmetric_perturbation_of_eventually`
selects one positive radius that works for both signs.

`linearIndependent_activeColumns` extends a coefficient vector on the strict
interior coordinates by zero. A relation among the restricted active columns
then becomes a two-sided feasible direction, which extremality forces to zero.
`interior_card_le_activeMatrixRank` derives the cardinality/rank inequality.
Equality rows are included among the always-tight rows, so the formal statement
covers mixed equality/inequality systems explicitly.

The axiom audit reports only `propext`, `Classical.choice`, and `Quot.sound`.
No native evaluator, proof hole, or project axiom enters this theorem.

STATUS: FINAL
