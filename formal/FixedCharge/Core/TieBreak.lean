import FixedCharge.Core.FiniteOpt

namespace FixedCharge

/-- The least optimizer under the state order. -/
def smallestArgmin {α R : Type*} [LinearOrder α] [LinearOrder R]
    (feasible : Finset α) (cost : α -> R) (hfeasible : feasible.Nonempty) : α :=
  (argminSet feasible cost).min' (argminSet_nonempty cost hfeasible)

/-- The greatest optimizer under the state order. -/
def largestArgmin {α R : Type*} [LinearOrder α] [LinearOrder R]
    (feasible : Finset α) (cost : α -> R) (hfeasible : feasible.Nonempty) : α :=
  (argminSet feasible cost).max' (argminSet_nonempty cost hfeasible)

theorem smallestArgmin_mem {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty) :
    smallestArgmin feasible cost hfeasible ∈ argminSet feasible cost := by
  exact Finset.min'_mem _ _

theorem largestArgmin_mem {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty) :
    largestArgmin feasible cost hfeasible ∈ argminSet feasible cost := by
  exact Finset.max'_mem _ _

theorem smallestArgmin_is_optimal {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {y : α} (hy : y ∈ feasible) :
    cost (smallestArgmin feasible cost hfeasible) ≤ cost y :=
  cost_le_of_mem_argminSet (smallestArgmin_mem hfeasible) hy

theorem largestArgmin_is_optimal {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {y : α} (hy : y ∈ feasible) :
    cost (largestArgmin feasible cost hfeasible) ≤ cost y :=
  cost_le_of_mem_argminSet (largestArgmin_mem hfeasible) hy

theorem smallestArgmin_le_of_mem {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {x : α} (hx : x ∈ argminSet feasible cost) :
    smallestArgmin feasible cost hfeasible ≤ x := by
  exact Finset.min'_le _ _ hx

theorem le_largestArgmin_of_mem {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {x : α} (hx : x ∈ argminSet feasible cost) :
    x ≤ largestArgmin feasible cost hfeasible := by
  exact Finset.le_max' _ _ hx

theorem smallestArgmin_le_largestArgmin
    {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty) :
    smallestArgmin feasible cost hfeasible ≤
      largestArgmin feasible cost hfeasible :=
  smallestArgmin_le_of_mem hfeasible (largestArgmin_mem hfeasible)

theorem selectors_eq_of_unique
    {α R : Type*} [LinearOrder α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    (hunique : HasUniqueArgmin feasible cost) :
    smallestArgmin feasible cost hfeasible =
      largestArgmin feasible cost hfeasible := by
  obtain ⟨x, hx⟩ := hunique
  have hsmall : smallestArgmin feasible cost hfeasible = x := by
    apply Finset.mem_singleton.mp
    rw [← hx]
    exact smallestArgmin_mem (cost := cost) hfeasible
  have hlarge : largestArgmin feasible cost hfeasible = x := by
    apply Finset.mem_singleton.mp
    rw [← hx]
    exact largestArgmin_mem (cost := cost) hfeasible
  exact hsmall.trans hlarge.symm

end FixedCharge
