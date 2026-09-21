# M5 TU-to-integrality decision

Date: 2026-08-24. Status: **DEFERRED AFTER API SPIKE**.

Mathlib v4.29.0 provides `Matrix.IsTotallyUnimodular` and closure results for
submatrices, transpose, reindexing, and adjoining signed unit rows. A source
search found no theorem connecting total unimodularity and an integral
right-hand side to integral vertices or integral polyhedra. In particular, the
library contains no Hoffman--Kruskal implication usable by Paper 1.

The missing result is not a small wrapper. A standalone proof needs a formal
polyhedron/vertex interface, extraction of a nonsingular active basis, Cramer's
rule or an equivalent inverse argument, and the determinant consequence of TU.
The project therefore keeps Corollary 1 as a written proof and does not add an
axiom or advertise it as machine-checked.

The reusable M3 theorem takes cell integrality as an explicit premise. This
keeps the machine-checked main argument independent of the deferred bridge.

STATUS: FINAL
