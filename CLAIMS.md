# Paper 1 claim registry

No statement may enter the ORL manuscript unless it appears here with explicit
assumptions and evidence. `PROVED` means a complete mathematical argument exists;
`CITED` means the step is delegated to an identified primary theorem; `EXACT`
means a finite witness has a symbolic or exhaustive exact certificate; `OPEN`
and `WITHDRAWN` statements cannot be advertised.

| ID | Statement | Assumptions | Evidence required | Main/supplement | Status |
|---|---|---|---|---|---|
| C1 | Conditioning on a fixed support makes the fixed-charge objective affine. | Integer activity levels; positive use means at least one unit. | Direct identity on each support cell. | Main | PROVED |
| C2 | A feasible fixed-charge integer program has an optimum that is a vertex of its support cell when every nonempty support cell is bounded and integral. | Feasibility; bounded integral support cells. | C1 + affine minimisation at a vertex + cell integrality. | Main | PROVED, statement to replace the TU-first version |
| C3 | TU of the continuous matrix with integral right-hand side and integral bounds implies every support cell is integral. | TU matrix; integer RHS and bounds; mixed row senses oriented explicitly. | Hoffman--Kruskal plus signed identity rows. | Main | CITED/PROVED COROLLARY |
| C4 | For the selected vertex optimum, columns of active constraints indexed by coordinates strictly between 1 and their upper bounds are linearly independent. | C2 optimum; finite constraint system. | Two-sided feasible perturbation. | Main | PROVED |
| C5 | The one-dimensional charge-if-positive function is PC in Zangwill's exact sense iff the fixed charge is nonnegative. | Exact 1967 definitions of CPC, terminal set, defining sequence and extreme set. | Line-by-line primary-source audit plus both proof directions in `literature/ZANGWILL_AUDIT.md`. | Main | PROVED; SOURCE GATE PASSED |
| C6 | Negative fixed charges can make the unique lot-sizing optimum violate the classical fractional-period property. | Explicit three-period bounded-inventory instance and price coupling. | Symbolic enumeration of all relevant candidates. | Main | EXACT |
| C7 | Negative fixed charges can make the unique fixed-charge transportation optimum have cyclic positive support of size greater than m+n-1. | Explicit 2x2 balanced transportation instance. | Parameterisation by a in {0,1,2}. | Main | EXACT |
| C8 | The same transportation witness violates the positive-support tree bound when read as a network-flow instance. | Directed incidence interpretation of C7. | Explicit cycle and rank/tree count. | Main | EXACT |
| C9 | In the APR model with terminal inventory zero, the Love/APR Property-1 schedule class has optimum -5 on the corrected four-period witness while the unrestricted unique optimum is -8. | APR definitions of inventory points, subplans and fractional periods; `s_0=s_T=0`. | Primary-source mapping and symbolic certificate in `literature/APR_STATE_SPACE_AUDIT.md`. | Main | PROVED; old -12/-10 witness WITHDRAWN |
| C10 | Without support-cell integrality, the vertex conclusion can fail. | Explicit non-TU odd-cycle system. | Rational unique-optimum certificate and explicit two-sided segment through the optimum. | Main, compact | EXACT |
| C11 | The one-sided MIP link x_j <= u_j y_j permits artificial negative credit when s_j<0; y_j <= x_j repairs the integer model. | Integer x; binary y; charge incurred iff x>0. | Four-period exact certificate: guarded -20, unguarded -25. | Main, remark | EXACT |
| C12 | The theorem extends to arbitrary discontinuous piecewise-linear coordinate costs by conditioning on pieces. | Integral breakpoints and a precise endpoint convention. | Formal theorem, not random tests. | Supplement only | OPEN; not needed for submission |

## Statements barred from the manuscript

- TU is the weakest or exact boundary for the vertex conclusion.
- A published paper contains the signed-charge modelling error of C11.
- APR is representative of a "common case" without a systematic survey.
- Every polynomial lot-sizing algorithm rests on the fractional-period property.
- Relative-error percentages based on objectives that can be negative or near zero.
- A zero-violation computational sweep proves a general theorem.
- The Zangwill and APR claims before their primary-source gates close.
