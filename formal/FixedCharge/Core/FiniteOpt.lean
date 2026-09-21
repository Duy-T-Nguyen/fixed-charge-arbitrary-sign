import Mathlib.Data.Finset.Max

namespace FixedCharge

/-- All feasible points attaining the minimum cost.  The set, not a selector,
is the primary optimization object. -/
def argminSet {α R : Type*} [DecidableEq α] [LinearOrder R]
    (feasible : Finset α) (cost : α -> R) : Finset α :=
  feasible.filter fun x => ∀ y ∈ feasible, cost x ≤ cost y

@[simp] theorem mem_argminSet_iff {α R : Type*} [DecidableEq α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} {x : α} :
    x ∈ argminSet feasible cost ↔
      x ∈ feasible ∧ ∀ y ∈ feasible, cost x ≤ cost y := by
  simp [argminSet]

theorem argminSet_subset {α R : Type*} [DecidableEq α] [LinearOrder R]
    (feasible : Finset α) (cost : α -> R) :
    argminSet feasible cost ⊆ feasible := by
  intro x hx
  exact (mem_argminSet_iff.mp hx).1

theorem cost_le_of_mem_argminSet {α R : Type*} [DecidableEq α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} {x y : α}
    (hx : x ∈ argminSet feasible cost) (hy : y ∈ feasible) :
    cost x ≤ cost y :=
  (mem_argminSet_iff.mp hx).2 y hy

theorem argminSet_nonempty {α R : Type*} [DecidableEq α] [LinearOrder R]
    {feasible : Finset α} (cost : α -> R) (hfeasible : feasible.Nonempty) :
    (argminSet feasible cost).Nonempty := by
  obtain ⟨x, hx, hmin⟩ := feasible.exists_min_image cost hfeasible
  exact ⟨x, mem_argminSet_iff.mpr ⟨hx, hmin⟩⟩

/-- The minimum cost of a nonempty finite feasible set. -/
def optimumValue {α R : Type*} [DecidableEq R] [LinearOrder R]
    (feasible : Finset α) (cost : α -> R) (hfeasible : feasible.Nonempty) : R :=
  (feasible.image cost).min' (hfeasible.image cost)

theorem optimumValue_le {α R : Type*} [DecidableEq R] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {x : α} (hx : x ∈ feasible) :
    optimumValue feasible cost hfeasible ≤ cost x := by
  exact Finset.min'_le _ _ (Finset.mem_image.mpr ⟨x, hx, rfl⟩)

theorem cost_eq_optimumValue_of_mem_argminSet
    {α R : Type*} [DecidableEq α] [DecidableEq R] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {x : α} (hx : x ∈ argminSet feasible cost) :
    cost x = optimumValue feasible cost hfeasible := by
  apply le_antisymm
  · obtain ⟨y, hy, hyval⟩ := Finset.mem_image.mp
      (Finset.min'_mem (feasible.image cost) (hfeasible.image cost))
    rw [optimumValue, ← hyval]
    exact cost_le_of_mem_argminSet hx hy
  · exact optimumValue_le hfeasible (argminSet_subset feasible cost hx)

theorem mem_argminSet_of_cost_eq_optimumValue
    {α R : Type*} [DecidableEq α] [DecidableEq R] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} (hfeasible : feasible.Nonempty)
    {x : α} (hx : x ∈ feasible)
    (hcost : cost x = optimumValue feasible cost hfeasible) :
    x ∈ argminSet feasible cost := by
  apply mem_argminSet_iff.mpr
  refine ⟨hx, fun y hy => ?_⟩
  rw [hcost]
  exact optimumValue_le hfeasible hy

/-- A finite optimization problem has a unique optimizer exactly when its
argmin set is a singleton. -/
def HasUniqueArgmin {α R : Type*} [DecidableEq α] [LinearOrder R]
    (feasible : Finset α) (cost : α -> R) : Prop :=
  ∃ x, argminSet feasible cost = {x}

theorem hasUniqueArgmin_iff_exists_unique
    {α R : Type*} [DecidableEq α] [LinearOrder R]
    {feasible : Finset α} {cost : α -> R} :
    HasUniqueArgmin feasible cost ↔
      ∃! x, x ∈ feasible ∧ ∀ y ∈ feasible, cost x ≤ cost y := by
  constructor
  · rintro ⟨x, hsingleton⟩
    have hxarg : x ∈ argminSet feasible cost := by simp [hsingleton]
    refine ⟨x, mem_argminSet_iff.mp hxarg, ?_⟩
    intro y hy
    have hyarg : y ∈ argminSet feasible cost := mem_argminSet_iff.mpr hy
    have : y ∈ ({x} : Finset α) := by simpa [hsingleton] using hyarg
    simpa using this
  · rintro ⟨x, hx, hunique⟩
    refine ⟨x, Finset.eq_singleton_iff_unique_mem.mpr ?_⟩
    refine ⟨mem_argminSet_iff.mpr hx, ?_⟩
    intro y hy
    exact hunique y (mem_argminSet_iff.mp hy)

end FixedCharge
