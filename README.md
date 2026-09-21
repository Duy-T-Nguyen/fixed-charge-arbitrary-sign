# Fixed charges of arbitrary sign: proofs and verification

How should a reader trust a structural claim that began with a failed reinforcement-learning
experiment? The paper does not ask the reader to trust that experiment. It separates the
evidence into a machine-checked theorem, exact finite certificates, and literature claims
that remain arguments about prior work.

This repository accompanies the preprint:

> **Fixed charges of arbitrary sign: what survives and what fails**
> Duy T. Nguyen. Optimization Online, 2026. <https://optimization-online.org/?p=36306>

Fixed-charge models assume the charge is *paid*. Wholesale electricity clears at negative
prices, which turns an activation charge into a payment *received*. The paper asks what
survives that sign change. Conditioning on the support freezes every fixed charge into a
constant. The objective is then affine on one support cell, whatever the signs of the
fixed and marginal coefficients.

## What Lean proves

The `formal/` directory contains a Lean 4 and Mathlib proof of the mathematical core:

1. the fixed-charge objective is affine after conditioning on the support;
2. a bounded support cell contains an extreme minimizer;
3. strict-interior active columns are linearly independent;
4. an integer totally unimodular constraint matrix makes every support cell integral;
5. a feasible problem has an optimal integer solution that is a vertex of its own support cell.

The manuscript-facing endpoint is
`FixedCharge.exists_optimal_extreme_support_cell_of_tu` in
`formal/FixedCharge/Paper1/Theorem.lean`. It takes an integer TU constraint matrix,
integral right-hand sides and upper bounds, arbitrary real fixed and marginal
coefficients, and feasibility. It produces the optimal support-cell vertex stated in
the paper. The proof derives `CellIntegral` instead of taking it as an assumption.

The general theorem chain contains no `sorry`, `admit`, project-added axiom, or native
evaluation. Its kernel audit reports only Lean's standard `propext`,
`Classical.choice`, and `Quot.sound`. Separate finite witness theorems use
`native_decide` and carry explicit labels.

### Rechecking the formal proof

Install [elan](https://lean-lang.org/lean4/doc/quickstart.html), then run:

```bash
cd formal
lake exe cache get
make check
```

**Do not run `lake update`.** Six of the nine entries in `formal/lake-manifest.json` track a moving branch (`batteries`, `aesop`, `Qq`, `importGraph`, `plausible`, `LeanSearchClient` on `main`/`master`), so `lake update` re-resolves them to whatever those branches point at today and rewrites the manifest. `lake exe cache get` reads the manifest instead of replacing it.

The project pins Lean and Mathlib to version `v4.29.0`. `make check` scans for proof holes,
builds the full library, prints the axiom dependencies, builds the compatibility entry
point, and reruns the finite model and witness controls. The Makefile caps Lean at four
threads so the check remains usable on a laptop.

The decisive formal files are:

| File | Role |
|---|---|
| `Geometry/ActiveColumns.lean` | Active-column independence at an extreme point |
| `Geometry/RowMinor.lean` | Extraction of a nonsingular square row minor |
| `Geometry/UnimodularBasis.lean` | Integral solutions for unit-determinant systems |
| `Geometry/TUCompletion.lean` | Completion of partially integral TU solutions |
| `Geometry/TUCellIntegral.lean` | Integrality of every support cell |
| `Paper1/Theorem.lean` | Optimal extreme-point theorem derived directly from TU |
| `Audit.lean` | Kernel-assumption report |

## What the Python scripts check

The scripts in `verification/` reproduce the finite witnesses, randomized controls, and
numerical counts reported in the paper. They corroborate the proof and catch implementation
or transcription errors; a finite sweep does not prove the general theorem.

Install NumPy and run any check independently:

```bash
python -m pip install -r requirements.txt
python verification/check_thm1_tu.py
```

## What each script establishes

Figures below are the actual output of the run recorded in this commit.

| Script | Claim it supports | Result |
|---|---|---|
| `check_thm1_tu.py` | Theorem 1 and Corollary 2 hold under arbitrary signs | 1085 verified-TU instances, **0 violations** |
| `check_affine.py` | Conditioning on the support leaves an affine function | 1269 same-support pairs, worst error **3.55e-15**; negative control breaks affinity on **217/220** |
| `check_vertex_rank.py` | The vertex condition and the rank test agree | 120 instances, 6088 plans, **0 disagreements** |
| `check_piecewise.py` | The piece-conditioning argument survives every sign regime | **0/200** violations in each of three regimes (bites on 158, 172, 191 of 200) |
| `redo_sec7.py` | Independent re-run of the lot-sizing evidence | 399 instances: **0/399** rank-bound violations, **0/399** arrangement violations; bound could bite on 219 |
| `check_vacuity.py` | Corollary 2 is not vacuous under negative charges | vacuous on **11.5%** of mixed-sign instances vs **9.2%** of non-negative ones; this refutes the author's own vacuity hypothesis |
| `sign_coupling.py` | The classical property fails under the paper's stated coupling | 3000 instances: FK/Love fails on *every* optimum in **215 (7.17%)** coupled, **257 (8.57%)** independent-sign |
| `L1_L2.py` | The APR15 transfer loss, reported honestly | absolute loss **16.7%**; the alternative 564.5% figure is shown to be a near-zero-denominator artefact and is **not** the number quoted |
| `check_spec.py` | The classical properties genuinely fail | lot-sizing witness with **unique** optimum (1,1,1): Corollary 2 vacuously true, FK/Love violated on all three pairs |
| `min_witness.py` | Minimal witness under coupled signs | T=3, C=3, H=2, unique optimum (1,1,0), classical property fails |
| `check_prop3.py` | Total unimodularity cannot be dropped | det = 2 (not TU), **unique** optimum (2,4,3), tight rank 2 < 3; the optimum is not a vertex |
| `check_remark5.py` | The modelling error of Remark 5 | no deadline: **25.0%** gap; with slack=1: 66.7%; the paper quotes the first |
| `zangwill_pc.py` | A fixed charge is not piecewise concave when `s < 0` | necessity direction, terminal-set obstruction |
| `zangwill_pc_converse.py` | …and is when `s ≥ 0` | sufficiency via `F_k = min{(k+K₀)x, s+cx}` |
| `zangwill_lift.py` | The vertex-pair criterion for the multivariate lift | passes lot-sizing and box, **fails** on the transportation witness |
| `zangwill_lift2.py` | The switching-on charge `J(z,d)` is the right invariant | closes the transportation case §8 left open (`J = -2`); negative control at `s=c=+1` finds no `J<0` |

## Paper source

`paper/` holds the LaTeX sources (`note_3p.tex` is the submitted 8-page version,
`note.tex` the double-spaced review version) and both compiled PDFs. This lets a reader
compare the formal endpoint and finite outputs with the exact submitted text.

## What this artifact does not prove

Lean checks the formal model and its deductions. It does not decide whether the model
captures every application, whether a literature comparison is complete, or whether a
claim is new. `REFERENCES.md` records each cited source and DOI so those claims can be
audited against the primary papers.

## What is deliberately not here

The literature corpus used while writing the paper contains 107 third-party PDFs,
including a dozen INFORMS journal articles. This repository does not redistribute those
files or their extracted text. `REFERENCES.md` provides the reconstruction path through
the original sources.

## Citing

See `CITATION.cff`. Please cite the paper, not this repository.

## Licence

MIT. See `LICENSE`.
