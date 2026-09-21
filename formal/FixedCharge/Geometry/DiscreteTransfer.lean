import FixedCharge.Geometry.ExtremeOptimizer

namespace FixedCharge

open Set

/-- Transfer an extreme minimizer of a compact affine cell back to a discrete
optimization problem. `offset` represents the fixed charges frozen by
conditioning on one support. -/
theorem exists_extreme_discrete_optimizer
    {D E : Type*} [AddCommGroup E] [Module Real E] [TopologicalSpace E]
    [T2Space E] [IsTopologicalAddGroup E] [ContinuousSMul Real E]
    [LocallyConvexSpace Real E]
    (feasible : D -> Prop) (cost : D -> Real) (embed : D -> E)
    (cell : Set E) (linear : StrongDual Real E) (offset : Real)
    (xstar : D)
    (hoptimal : ∀ y, feasible y -> cost xstar ≤ cost y)
    (hcompact : IsCompact cell) (hxcell : embed xstar ∈ cell)
    (hxvalue : cost xstar = offset + linear (embed xstar))
    (hreconstruct : ∀ z ∈ cell.extremePoints Real,
      ∃ y, feasible y ∧ embed y = z ∧ cost y = offset + linear z) :
    ∃ y, feasible y ∧ cost y = cost xstar ∧
      embed y ∈ cell.extremePoints Real := by
  obtain ⟨z, hzextreme, hzmin⟩ :=
    exists_extreme_isMinOn hcompact ⟨embed xstar, hxcell⟩ linear
  obtain ⟨y, hyfeasible, hyembed, hyvalue⟩ := hreconstruct z hzextreme
  have hcost_le : cost y ≤ cost xstar := by
    rw [hyvalue, hxvalue]
    simpa [add_comm] using add_le_add_left (hzmin hxcell) offset
  have hcost_eq : cost y = cost xstar :=
    le_antisymm hcost_le (hoptimal y hyfeasible)
  exact ⟨y, hyfeasible, hcost_eq, hyembed.symm ▸ hzextreme⟩

end FixedCharge
