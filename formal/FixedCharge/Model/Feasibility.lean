import FixedCharge.Model.Schedule

namespace FixedCharge

/-- Work that has arrived in the first `k` periods. -/
def arrivedPrefix {T : Nat} (arrivals : Fin T -> Nat) (k : Nat) : Nat :=
  prefixSum arrivals k

/-- A schedule never serves work before it arrives. -/
def Causal {T C : Nat} (arrivals : Fin T -> Nat) (x : Schedule T C) : Prop :=
  ∀ k : Fin (T + 1), servedPrefix x k.val ≤ arrivedPrefix arrivals k.val

/-- All work is served by the end of the horizon. -/
def Conserves {T C : Nat} (arrivals : Fin T -> Nat) (x : Schedule T C) : Prop :=
  totalServed x = ∑ t, arrivals t

/-- Constant-slack deadline: by the first `k` periods, everything arriving in
the first `k - slack` periods has been served. -/
def MeetsDeadline {T C : Nat} (arrivals : Fin T -> Nat) (slack : Nat)
    (x : Schedule T C) : Prop :=
  ∀ k : Fin (T + 1),
    arrivedPrefix arrivals (k.val - slack) ≤ servedPrefix x k.val

/-- Timing feasibility. Capacity is already guaranteed by `Schedule T C`. -/
def Feasible {T C : Nat} (arrivals : Fin T -> Nat) (slack : Nat)
    (x : Schedule T C) : Prop :=
  Causal arrivals x ∧ Conserves arrivals x ∧ MeetsDeadline arrivals slack x

instance instDecidableCausal {T C : Nat} (arrivals : Fin T -> Nat)
    (x : Schedule T C) : Decidable (Causal arrivals x) := by
  unfold Causal
  infer_instance

instance instDecidableConserves {T C : Nat} (arrivals : Fin T -> Nat)
    (x : Schedule T C) : Decidable (Conserves arrivals x) := by
  unfold Conserves
  infer_instance

instance instDecidableMeetsDeadline {T C : Nat} (arrivals : Fin T -> Nat)
    (slack : Nat) (x : Schedule T C) : Decidable (MeetsDeadline arrivals slack x) := by
  unfold MeetsDeadline
  infer_instance

instance instDecidableFeasible {T C : Nat} (arrivals : Fin T -> Nat)
    (slack : Nat) (x : Schedule T C) : Decidable (Feasible arrivals slack x) := by
  unfold Feasible
  infer_instance

theorem feasible_causal {T C : Nat} {arrivals : Fin T -> Nat} {slack : Nat}
    {x : Schedule T C} (hx : Feasible arrivals slack x) : Causal arrivals x := hx.1

theorem feasible_conserves {T C : Nat} {arrivals : Fin T -> Nat} {slack : Nat}
    {x : Schedule T C} (hx : Feasible arrivals slack x) : Conserves arrivals x := hx.2.1

theorem feasible_meetsDeadline {T C : Nat} {arrivals : Fin T -> Nat} {slack : Nat}
    {x : Schedule T C} (hx : Feasible arrivals slack x) :
    MeetsDeadline arrivals slack x := hx.2.2

/-- Exact finite feasible set, suitable for `argminSet`. -/
def feasibleSet (T C : Nat) (arrivals : Fin T -> Nat) (slack : Nat) :
    Finset (Schedule T C) :=
  Finset.univ.filter (Feasible arrivals slack)

@[simp] theorem mem_feasibleSet_iff {T C : Nat} {arrivals : Fin T -> Nat}
    {slack : Nat} {x : Schedule T C} :
    x ∈ feasibleSet T C arrivals slack ↔ Feasible arrivals slack x := by
  simp [feasibleSet]

end FixedCharge
