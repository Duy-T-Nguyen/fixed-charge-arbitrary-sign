# Fixed charges of arbitrary sign — verification scripts

Reproduction code for the preprint

> **Fixed charges of arbitrary sign: what survives and what fails**
> Duy T. Nguyen. Optimization Online, 2026. <https://optimization-online.org/?p=36306>

Fixed-charge models assume the charge is *paid*. Wholesale electricity clears at
negative prices, which turns an activation charge into a payment *received*. The
paper asks what survives that sign change. The vertex argument does; the
structural properties it is usually invoked to deliver do not.

**Every quantitative claim in the paper is produced by a script in
`verification/`.** This repository exists so that each one can be re-run
independently, and so that a reader who doubts a number can check it rather than
take it on trust.

## Running

Only the standard library and NumPy are needed. No script takes longer than
30 seconds; the whole suite runs in about 90 seconds on a laptop.

```bash
pip install -r requirements.txt
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
| `check_vacuity.py` | Corollary 2 is not vacuous under negative charges | vacuous on **11.5%** of mixed-sign instances vs **9.2%** of non-negative ones — a refutation of the author's own vacuity hypothesis |
| `sign_coupling.py` | The classical property fails under the paper's stated coupling | 3000 instances: FK/Love fails on *every* optimum in **215 (7.17%)** coupled, **257 (8.57%)** independent-sign |
| `L1_L2.py` | The APR15 transfer loss, reported honestly | absolute loss **16.7%**; the alternative 564.5% figure is shown to be a near-zero-denominator artefact and is **not** the number quoted |
| `check_spec.py` | The classical properties genuinely fail | lot-sizing witness with **unique** optimum (1,1,1): Corollary 2 vacuously true, FK/Love violated on all three pairs |
| `min_witness.py` | Minimal witness under coupled signs | T=3, C=3, H=2, unique optimum (1,1,0), classical property fails |
| `check_prop3.py` | Total unimodularity cannot be dropped | det = 2 (not TU), **unique** optimum (2,4,3), tight rank 2 < 3 — not a vertex |
| `check_remark5.py` | The modelling error of Remark 5 | no deadline: **25.0%** gap; with slack=1: 66.7% — the paper quotes the first |
| `zangwill_pc.py` | A fixed charge is not piecewise concave when `s < 0` | necessity direction, terminal-set obstruction |
| `zangwill_pc_converse.py` | …and is when `s ≥ 0` | sufficiency via `F_k = min{(k+K₀)x, s+cx}` |
| `zangwill_lift.py` | The vertex-pair criterion for the multivariate lift | passes lot-sizing and box, **fails** on the transportation witness |
| `zangwill_lift2.py` | The switching-on charge `J(z,d)` is the right invariant | closes the transportation case §8 left open (`J = -2`); negative control at `s=c=+1` finds no `J<0` |

## Paper source

`paper/` holds the LaTeX sources (`note_3p.tex` is the submitted 8-page version,
`note.tex` the double-spaced review version) and the submitted PDF.

## What is deliberately not here

The literature corpus used while writing the paper — 107 third-party PDFs, a
dozen of them INFORMS journal articles — is **not** redistributed here, and
neither is the text extracted from them. `REFERENCES.md` records every source
with its DOI so the corpus can be rebuilt from the originals.

## Citing

See `CITATION.cff`. Please cite the paper, not this repository.

## Licence

MIT — see `LICENSE`.
