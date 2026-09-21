# M5 TU-to-integrality progress

Date: 2026-08-24. Status: **COMPLETE**.

## Completed in Lean

The M5 modules prove seven algebraic steps without native evaluation or project
axioms:

1. A square integer matrix with unit determinant solves every integral
   right-hand side over the integers.
2. That integral solution is unique.
3. Every nonsingular square submatrix of an integer TU matrix has unit
   determinant, because its determinant lies in `{0,-1,1}`.
4. Every nonsingular square TU basis therefore has an integral solution for
   every integral right-hand side.
5. Every real solution of a square integer system with unit determinant is the
   cast of its unique integer solution.
6. Every support-cell coordinate outside the strict-interior set is already
   integral: it equals zero, one, or its integral upper bound.
7. A finite rectangular matrix over a field with linearly independent columns
   contains an injectively selected square row minor with nonzero determinant.

## Completed bridge

`TUCompletion.lean` selects the nonsingular active minor, derives a unit
integer determinant from total unimodularity, and proves that the remaining
real coordinates equal an integer solution. `TUCellIntegral.lean` moves the
integral boundary coordinates to an integral right-hand side and proves
`CellIntegral` for every support cell. `Paper1/Theorem.lean` then derives the
paper's optimal extreme-point conclusion directly from TU and integral data.

No placeholder axiom has been introduced. The full gate reports only
`propext`, `Classical.choice`, and `Quot.sound` for the general theorem chain.

STATUS: FINAL
