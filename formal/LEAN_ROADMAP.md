# Lean roadmap for Papers 1, 2A, 2B, and 3

Status: reviewed plan. This file is the controlling roadmap;
`ANTIGRAVITY_ROADMAP.md` is an independent input, not an authority.

## 1. Objective

Build one Lean 4 library whose first deliverable checks the load-bearing claims
of Paper 1 and whose finite optimization layer is reused unchanged by Paper 2A.
Paper 2B adds real analysis on top. Paper 3 may import the core but must not
force speculative abstractions before its model is fixed.

The project does not use `sorry`, `admit`, `axiom`, or an unproved local
Hoffman--Kruskal declaration. Imported standard Mathlib axioms are reported with
`#print axioms`; they are not silently represented as constructive proofs.

## 2. Corrections to the independent Antigravity plan

Antigravity Pro correctly separated discrete computation from continuous
geometry and isolated TU as a risk. Four recommendations are rejected:

1. A local Hoffman--Kruskal `axiom` violates the no-hole policy.
2. Paper 1 proves that **some** optimum is a support-cell vertex, not that every
   optimum is one.
3. A generic lexicographic selector does not capture Paper 2's smallest and
   largest argmin. The argmin set is primary; both selectors are explicit.
4. FIFO, sandwich feasibility, and the time-reversal theorem are useful later,
   but they are not on Paper 1's submission-critical path.

## 3. Type and arithmetic policy

- Time and activity indices: `Fin T`, never bare list positions in theorem
  statements.
- Volumes: `Nat`; feasibility carries the upper bound and conservation laws.
- Exact finite costs and prices: `Rat` (`ℚ`). No floating-point theorem input.
- Continuous geometry: `Real` (`ℝ`) with explicit cast lemmas from `ℚ`.
- Support: `Finset (Fin n)`, not `List Nat`; order must not affect a support.
- Optimization: `argminSet` first. A selected optimizer is never introduced
  before membership and tie assumptions are stated.

## 4. Module tree

```text
formal/
  lakefile.toml
  lean-toolchain
  FixedCharge.lean
  FixedCharge/
    Core/
      Charge.lean          charge-if-positive, support, exact cost
      FiniteOpt.lean       argminSet, optimum value, uniqueness
      TieBreak.lean        smallestArgmin, largestArgmin, selector lemmas
      Witness.lean         certificate interface and negative controls
    Model/
      Schedule.lean        paths, volumes, capacity, conservation
      Feasibility.lean     arrivals/deadlines and common-deadline specialization
      Regret.lean          cost - offline optimum, ratio pathology
    Online/
      History.lean         information available before each action
      Policy.lean          causal policy plus legality proof
      FiniteGame.lean      exact finite minimax recursion
      Restriction.lean     restricted actions and value monotonicity
    Geometry/
      SupportCell.lean     P(S), support preservation, compactness/convexity
      ExtremeOptimizer.lean compact-convex affine extreme minimizer
      IntegralCell.lean    integrality stated on extreme points
      ActiveColumns.lean   two-sided perturbation/rank corollary
      TU.lean              isolated TU-to-integrality theorem
    Paper1/
      Main.lean            support-cell vertex theorem
      LotSizing.lean       (1,1,0), unique value -4
      Transport.lean       2x2 cyclic unique optimum
      APR.lean             unrestricted -8, Property-1 optimum -5
      Sharpness.lean       odd-cycle nonvertex certificate
      Modelling.lean       guarded -20, unguarded -25
      Zangwill.lean        final, low-reuse analytic module
    Paper2A/
      AdditiveRegret.lean
      FiniteAdversary.lean
      RestrictedActions.lean
      Counterexamples.lean
    Paper2B/
      CellPolicy.lean
      VertexReduction.lean
      GridBounds.lean
    Paper3/
      README.md            no code until the paper's model is frozen
```

## 5. Dependency graph

```text
Charge + FiniteOpt + Schedule
        |             |
        +------ Cost/Feasibility ------+
        |                              |
        v                              v
Paper 1 exact witnesses          Online finite game
        |                              |
        |                         Paper 2A claims
        v                              |
SupportCell -> ExtremeOptimizer        v
        |                         Cell policies
        v                              |
IntegralCell -> Paper 1 Main -> Paper 2B vertex reduction
        |
        +-> ActiveColumns
        +-> TU (separate hard gate)

Zangwill is independent and last.
```

## 6. Key proof design for Paper 1

Do not wait for a full polytope library. Prove a reusable theorem for a nonempty
compact convex subset of `Fin n -> ℝ`:

> An affine functional has a minimizer that is an extreme point.

The proposed proof selects, among objective minimizers, successive coordinate
maxima. Compactness gives each selection. After all `n` coordinates are fixed,
the selected point is unique in the nested minimizer set. If it were a nontrivial
midpoint of two feasible points, affinity makes both endpoints objective
minimizers, and the coordinate selections force both endpoints to equal the
selected point.

This route uses Mathlib compactness, continuity, finite coordinates, convexity,
and `Set.extremePoints`. It avoids assuming a missing general LP theorem and is
stronger than Paper 1 needs. Cell integrality then converts that extreme point to
an integer point; the lower bound `1` preserves its support.

TU is a corollary, not a dependency of the main theorem. A three-day API spike
decides whether Mathlib already proves TU plus integral right-hand side implies
integrality. If not, TU becomes its own contribution-sized library task. The
Paper 1 main theorem still completes without it; the manuscript's TU corollary
is marked as written-proof-only until that module is finished.

## 7. Milestones and gates

### M0. Reproducible project (1--2 days)

- Pin one Lean and matching Mathlib revision in `lean-toolchain` and
  `lake-manifest.json`.
- Convert `FixedChargeCore.lean` from `List`/`Int` to `Finset`/generic ordered
  ring, retaining a compatibility theorem.
- Add `lake build`, formatting, and proof-hole scans.

Gate: clean clone builds; exact versions are logged; no network resolution is
needed after dependency fetch.

### M1. Finite reusable core (3--5 days)

- Implement exact charge, schedule cost, support, feasible set, optimum value,
  and `argminSet` over finite types.
- Implement smallest/largest argmin as separate functions with explicit linear
  order assumptions.
- Prove selector membership, optimality, and equality under unique optimum.
- Add a sham selector that should fail a monotonicity test.

Gate: `lake build`; `#print axioms` report; all selectors have membership proofs;
the sham control fires.

### M2. Paper 1 finite certificates (3--5 days)

Formalize with `native_decide` or proofs by normalization:

- lot sizing: unique `(1,1,0)`, value `-4`;
- transportation/flow: unique all-ones plan, value `-8`, cyclic support;
- APR: 35 feasible plans, unique unrestricted `(1,1,1,1)` at `-8`, restricted
  optimum `-5`;
- sharpness: unique integer optimum `-1147/100` and the two rational segment
  endpoints;
- modelling: guarded `-20`, unguarded `-25`.

Gate: each manuscript number is generated from a named Lean theorem. Altering
one instance datum must break at least one expected-value test.

### M3. Paper 1 main theorem (2--4 weeks)

- Define support cells over `Fin n -> ℝ`.
- Prove closedness, boundedness, compactness, and convexity.
- Prove the compact-convex affine extreme-minimizer theorem.
- Define cell integrality through extreme points.
- Prove existence of an optimal support-cell vertex with arbitrary coefficient
  signs and exact support preservation.

Gate: theorem statement matches `paper/note.tex` quantifier by quantifier;
`#print axioms` contains no project-local axiom; an independently written
negative example fails when cell integrality is removed.

### M4. Active-column corollary (1--2 weeks)

- Formalize tight rows and `Q = {j | 1 < x j ∧ x j < u j}`.
- Convert column dependence into a nonzero perturbation direction.
- Choose one radius satisfying interior bounds and all inactive slacks.
- Contradict extremality.

Gate: proves column independence, not merely the rank inequality; the odd-cycle
example confirms why the theorem's assumptions matter.

### M5. TU decision gate (3-day spike, then 3--8 weeks if pursued)

- Reuse Mathlib's `Matrix.IsTotallyUnimodular` API.
- Search for, prototype, and document the exact missing implication.
- If available, instantiate it for signed identity rows and support cells.
- If unavailable, estimate a standalone Hoffman--Kruskal formalization before
  approving it. Never insert a placeholder axiom.

Gate: either a complete TU corollary or an explicit `DEFERRED.md` that leaves no
false machine-checked claim in the paper or supplement.

### M6. Paper 2A finite online game (2--4 weeks)

- Histories and policies encode causality in their types.
- Define exact additive regret and prove nonnegativity.
- Define unrestricted/restricted action games.
- Prove restriction monotonicity in the correct direction.
- Import Paper 1 costs and formalize finite adversarial witnesses.
- State every monotonicity result for `argminSet`, smallest selector, or largest
  selector explicitly; never use an unnamed optimizer.

Gate: reproduce the decisive finite witnesses exactly; swapping the selector
must change the appropriate counterexample; no finite alphabet claim is promoted
to a continuum theorem.

### M7. Paper 2B continuum bridge (2--5 weeks)

- Formalize cell-constant causal policies.
- Prove regret is convex and continuous on each price cell.
- Prove supremum over the half-open cell equals maximum over its closure.
- Prove the box-vertex reduction and the finite-grid upper bound.

Gate: each arm of every difference carries a direction (`LowerBound` or
`UpperBound`) in its theorem name/type; a test rejects subtraction of two lower
bounds as a claimed lower bound on their difference.

### M8. Low-reuse Paper 1 remainder (optional, 3--6 weeks)

- Formalize Zangwill's CPC/PC definitions, common terminal set, and both
  directions of the `s >= 0` characterization.
- Do this only after Papers 2A/2B reuse the core successfully.

## 8. What not to formalize

- Runtime complexity and NP-hardness citations.
- Ethereum/CAISO statistics, bootstrap intervals, or performance benchmarks.
- Withdrawn, refuted, or subsumed statements in `PROOFS.md`.
- A generic RL training pipeline.
- Paper 3 abstractions before its model and theorem registry are frozen.
- Full APR or Koca--Yaman--Akturk algorithms; formalize only the state-space
  predicate and certificates used by our claims.

## 9. Process controls

- Maintain `formal/CLAIMS.yaml`: manuscript claim, Lean theorem, assumptions,
  status (`planned`, `proved`, `deferred`, `withdrawn`).
- CI rejects `sorry`, `admit`, `axiom`, `set_option autoImplicit true`, and stale
  theorem names.
- Every computational theorem has a positive witness and a sham/negative
  control.
- Antigravity may search APIs, scaffold modules, and attempt proofs. Its output
  enters the library only after local `lake build` and independent statement
  comparison.
- Use at most four local workers. Lean file builds should be parallel only at the
  module level.

## 10. Decision and expected payoff

Approve M0--M4 and M6. Treat M5 (TU) and M8 (Zangwill) as explicit go/no-go
gates. This gives Paper 1 a machine-checked main theorem and certificates while
delivering the exact finite-game machinery Paper 2A needs. Paper 2B then adds one
focused analytic bridge instead of rebuilding optimization definitions. Paper 3
inherits a tested core without dictating its research question.

Expected calendar effort for M0--M4: 4--7 weeks for one learner working
carefully. Adding M6: another 2--4 weeks. M5 and M8 can double the total and
should not block either submission.

STATUS: FINAL
