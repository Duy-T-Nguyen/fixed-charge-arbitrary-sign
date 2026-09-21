# Artifact: what is machine-checked, and what is not

Companion to `formal/README.md` (scope and build) and `M0`–`M5` reports (per-milestone
detail). This file exists to answer one question a referee asks first: **which
statement of the paper does which Lean theorem discharge, and on what trust
base.**

**This artifact does not verify the paper. It verifies ten of its twelve
registered claims, four of them on Lean's kernel alone.** The rest of this file
says exactly which.

**Path convention.** Lean module paths below are written relative to
`formal/FixedCharge/`, the way the imports read; report and registry files are
relative to the repository root.

## Measured state

Every number here was recomputed from the sources in this directory, not copied
from a previous report.

| | |
|---|---|
| Lean source files (excluding `.lake/`) | **26** |
| lines of Lean | **2 022** |
| declarations | **93 theorem**, 68 `def`, 12 `instance`, 3 `abbrev`, 7 `example` |
| `sorry` | **0** |
| `admit` | **0** |
| project-added `axiom` | **0** |
| `native_decide` | **33** — 25 in `FixedCharge/Paper1/Witnesses.lean`, 3 in `Tests/FiniteOpt.lean`, 5 in `Tests/Model.lean` |
| `lake build` | **succeeds, 2 233 jobs** |

Pins, all exact in `lake-manifest.json`: Lean `v4.29.0`; Mathlib rev
`8a178386ffc0` at tag `v4.29.0`; and eight further dependencies
(`batteries`, `aesop`, `Qq`, `proofwidgets`, `importGraph`, `plausible`,
`LeanSearchClient`, `Cli`) each at a fixed revision. Reproducing this artifact
means checking out those revisions, which is why `lake update` must not be run;
see `formal/README.md`.

## Two trust bases, and they are not the same

Three instruments, not two: Lean on the kernel (tier 1), Lean through the native
evaluator (tier 2), and exact enumeration scripts (tier 3, C5 only).

**Tier 1 — Lean kernel only.** The structural chain in `FixedCharge/Core/`,
`FixedCharge/Geometry/` and `FixedCharge/Paper1/{Main,Theorem}.lean` uses no
native evaluation. Its axiom report contains only Lean's standard axioms
(`propext`, `Classical.choice`, `Quot.sound`); no project-defined axiom appears.

**Tier 2 — kernel plus the compilers.** The finite witnesses use
`native_decide`, which evaluates a decidable proposition through compiled code.
This trusts the Lean compiler and the C toolchain in addition to the kernel, and
Lean's axiom report lists a generated theorem-specific `native_decide` axiom for
each such certificate. `M2_REPORT.md` records why: an attempted replacement by
kernel `decide` failed because reduction stops at opaque finite-set definitions
— **not because a counterexample was found.**

A reader who declines to trust the native evaluator still has Tier 1 intact.
They do not have the counterexamples.

## Claim registry to Lean theorem

Claim IDs and statuses are `CLAIMS.md`; that file, not this one, is the
authority on what the paper may assert.

| claim | what it says (abbreviated) | Lean | tier |
|---|---|---|---|
| **C1** | fixing the support makes the objective affine | `Core/Charge.lean`: `charge_eq_affine_of_ne_zero`, `support_objective_affine`, `support_charge_affine`, `charge_sum_over_support_affine`; `Paper1/Main.lean`: `fixedChargeCost_affine_on_support`; `Model/Cost.lean`: `scheduleCost_eq_affine_on_positive_support` | **1** |
| **C2** | an optimum is a vertex of its support cell when cells are bounded and integral | `Paper1/Theorem.lean`: `support_cell_vertex_theorem`, `exists_optimal_extreme_support_cell`, `exists_optimal_extreme_support_cell_for_fixed_charges`; `Paper1/Main.lean`: `fixedCharge_vertex_theorem`; compactness from `Geometry/LinearAmbient.lean`, transfer from `Geometry/{ExtremeOptimizer,DiscreteTransfer}.lean` | **1** |
| **C3** | TU with integral RHS and bounds makes every support cell integral | `Geometry/TUCellIntegral.lean`: `supportCell_integral_of_tu`; `Geometry/TUCompletion.lean`: `integral_coordinates_of_tu`; `Geometry/UnimodularBasis.lean`: `isUnit_det_submatrix_of_tu_of_ne_zero`, `exists_int_solution_of_tu_basis`, `real_solution_is_integral_of_isUnit_det`; `Paper1/Theorem.lean`: `exists_optimal_extreme_support_cell_of_tu` | **1** |
| **C4** | active columns at interior coordinates are linearly independent | `Geometry/ActiveColumns.lean`: `linearIndependent_activeColumns`, `interior_card_le_activeMatrixRank`; two-sided perturbation from `Geometry/FiniteSlack.lean`, vanishing from `Geometry/ExtremeDirection.lean` | **1** |
| **C5** | charge-if-positive is PC in Zangwill's sense **iff** the fixed charge is nonnegative | **no Lean.** A search of all 26 files for `Zangwill`, `concave`, `definingSeq`, `terminalSet`, `extremeSet` returns zero hits. Checked instead by four scripts — `verification/zangwill_pc.py` (necessity, terminal-set obstruction), `zangwill_pc_converse.py` (sufficiency via `F_k = min{(k+K0)x, s+cx}`), `zangwill_lift.py` (vertex-pair criterion for the multivariate lift), `zangwill_lift2.py` (the switching-on charge `J(z,d)`, with a negative control at `s=c=+1` that finds no `J<0`) — plus the primary-source audit in `literature/ZANGWILL_AUDIT.md` | **3** |
| **C6** | negative charges break the lot-sizing fractional-period property | `Paper1/Witnesses.lean`: `unique_optimum`, `optimum_value`, `candidate_prefixes`, `lot_old_value_breaks` | 2 |
| **C7** | negative charges give cyclic positive support above `m+n-1` in transportation | `Paper1/Witnesses.lean`: `unique_optimum`, `optimum_value`, `positive_support_has_four_arcs`, `feasible_count`, `transport_old_value_breaks` | 2 |
| **C8** | the same witness breaks the tree bound read as network flow | `Paper1/Witnesses.lean`: `positive_support_has_four_arcs` (the arc count is the flow reading of C7's support) | 2 |
| **C9** | APR restricted class attains −5 where the unrestricted optimum is −8 | `Paper1/Witnesses.lean`: `unique_unrestricted_optimum`, `unrestricted_value`, `restricted_lower_bound`, `restricted_bound_attained`, `apr_unique_optimum_breaks_without_setup_reward`; source mapping in `literature/APR_STATE_SPACE_AUDIT.md` | 2 |
| **C10** | without cell integrality the vertex conclusion fails | `Paper1/Witnesses.lean`: `nontrivial_segment_certificate`, `runner_up_value`, `runner_up_is_second`, `sharp_old_value_breaks` | 2 |
| **C11** | the one-sided MIP link permits negative credit; `y_j ≤ x_j` repairs it | `Paper1/Witnesses.lean`: `guarded_lower_bound`, `guarded_attained`, `unguarded_lower_bound`, `unguarded_attained` | 2 |
| **C12** | extension to discontinuous piecewise-linear coordinate costs | **none.** `CLAIMS.md` marks C12 `OPEN; not needed for submission` | **—** |

**The row to read is C5.** It is the one Main-paper claim with **no Lean
counterpart**. It is not unchecked — four scripts cover both directions and the
multivariate lift, one of them with a negative control — but a reader who meets
"Lean 4 formalization" a paragraph earlier will assume Lean covers it, and it does
not. Say which instrument checked it.

An earlier draft of this file recorded C5 as having no machine-checked counterpart
at all. That was wrong: the four scripts existed and had not been looked at.

## Negative controls in the development itself

`Tests/FiniteOpt.lean` proves `sham_all_selectors_agree_is_false` — a theorem
whose content is that a plausible-sounding statement is **false**. A test suite
that can only confirm proves nothing, and this one can fail. `Tests/Model.lean`
carries the model-boundary controls described in `MODEL_REPORT.md`.

## What this artifact is not

- not a verification of the paper's prose, its literature positioning, or its
  numerical tables;
- not a proof that TU is necessary — `CLAIMS.md` explicitly bars that claim;
- not independent of Mathlib: C3 rests on Mathlib's determinant-level TU
  development, so Mathlib's own correctness is part of the trust base;
- not a replacement for the primary-source audits, which carry C5 and C9 and
  are prose, not code.
