import Mathlib.Analysis.Convex.Exposed
import Mathlib.Analysis.Convex.KreinMilman
import Mathlib.Topology.Order.Compact

namespace FixedCharge

open Set

/-- A continuous linear functional on a nonempty compact set has a minimizer
that is an extreme point of that set. Convexity is not required: the minimizer
set is exposed, hence extreme, and Krein--Milman supplies an extreme point of
that compact exposed subset. -/
theorem exists_extreme_isMinOn
    {E : Type*} [AddCommGroup E] [Module Real E] [TopologicalSpace E]
    [T2Space E] [IsTopologicalAddGroup E] [ContinuousSMul Real E]
    [LocallyConvexSpace Real E] {s : Set E}
    (hs : IsCompact s) (hne : s.Nonempty) (l : StrongDual Real E) :
    ∃ x ∈ s.extremePoints Real, IsMinOn l s x := by
  let minimizers : Set E := (-l).toExposed s
  obtain ⟨x₀, hx₀s, hx₀min⟩ := hs.exists_isMinOn hne l.continuous.continuousOn
  have hminimizers : minimizers.Nonempty := by
    refine ⟨x₀, hx₀s, ?_⟩
    intro y hy
    simpa using hx₀min hy
  have hexposed : IsExposed Real s minimizers :=
    ContinuousLinearMap.toExposed.isExposed
  have hcompact : IsCompact minimizers := hexposed.isCompact hs
  obtain ⟨x, hxext⟩ := hcompact.extremePoints_nonempty hminimizers
  have hxexts : x ∈ s.extremePoints Real := by
    apply isExtreme_singleton.mp
    exact hexposed.isExtreme.trans (isExtreme_singleton.mpr hxext)
  refine ⟨x, hxexts, ?_⟩
  intro y hy
  have hxmin : x ∈ minimizers := hxext.1
  simpa using hxmin.2 y hy

end FixedCharge
