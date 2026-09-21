# Supplement to “Fixed charges of arbitrary sign”

This supplement separates three kinds of evidence.

1. General claims are proved in `../paper/note.tex` and restated independently
   in `../FORMAL_PROOFS.md`.
2. Primary-source mappings are documented in
   `literature/ZANGWILL_AUDIT.md` and
   `literature/APR_STATE_SPACE_AUDIT.md`, both included in this repository.
3. Lean checks the support-conditioning identity, TU support-cell integrality,
   the resulting vertex theorem, and the full active-column cardinality/rank
   corollary.
4. Finite witnesses and controls are reproducible with the scripts below.

Run from the project root with Python 3:

```sh
python paper/verification/check_apr_corrected.py
python paper/verification/check_prop3.py
python paper/verification/check_remark5.py
python paper/verification/check_affine.py
python paper/verification/check_thm1_tu.py
cd formal && make check
```

The first three scripts use exact integer or rational arithmetic. The random TU
check uses seed 2026, integer objective coefficients, exact rational rank, and
all-minor determinant certification. The affinity control uses seed 5 and
floating-point interpolation only as a negative/implementation control; it is
not evidence for the general theorem.

Expected final markers and decisive values:

```text
APR: STATUS: FINAL; unrestricted -8; restricted -5; gap 3
Sharpness: STATUS: FINAL; 113 points; unique optimum -1147/100
TU: STATUS: FINAL; 1085 certified instances; 0 violations
Affinity: 1269 same-support pairs; worst error 3.55e-15;
          varying-support negative control 217/220
Lean: full gate passes; no sorry, admit, or added axiom
```

The exact finite certificates use `native_decide`; the general support-cell,
TU-integrality, vertex, and active-column theorems do not.
