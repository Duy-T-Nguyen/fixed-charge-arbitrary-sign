import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Fin.Basic
import Mathlib.Data.Fintype.Fin
import Mathlib.Data.Fintype.Pi

namespace FixedCharge

/-- A horizon-`T` service schedule with the capacity bound encoded in its type. -/
abbrev Schedule (T C : Nat) := Fin T -> Fin (C + 1)

/-- Service volume in one period, viewed as a natural number. -/
def service {T C : Nat} (x : Schedule T C) (t : Fin T) : Nat := x t

theorem service_le_capacity {T C : Nat} (x : Schedule T C) (t : Fin T) :
    service x t ≤ C := by
  exact Nat.le_of_lt_succ (x t).isLt

/-- Sum the first `k` entries. Values `k ≥ T` include the whole horizon. -/
def prefixSum {T : Nat} (v : Fin T -> Nat) (k : Nat) : Nat :=
  ∑ t ∈ Finset.univ.filter (fun t : Fin T => t.val < k), v t

@[simp] theorem prefixSum_zero {T : Nat} (v : Fin T -> Nat) :
    prefixSum v 0 = 0 := by
  simp [prefixSum]

theorem prefixSum_eq_total_of_horizon_le {T : Nat} (v : Fin T -> Nat)
    {k : Nat} (hk : T ≤ k) :
    prefixSum v k = ∑ t, v t := by
  have hfilter :
      Finset.univ.filter (fun t : Fin T => t.val < k) = Finset.univ := by
    apply Finset.filter_eq_self.mpr
    intro t _
    exact lt_of_lt_of_le t.isLt hk
  simp [prefixSum, hfilter]

/-- Cumulative service through the first `k` periods. -/
def servedPrefix {T C : Nat} (x : Schedule T C) (k : Nat) : Nat :=
  prefixSum (fun t => service x t) k

/-- Total service over the finite horizon. -/
def totalServed {T C : Nat} (x : Schedule T C) : Nat :=
  ∑ t, service x t

theorem servedPrefix_horizon {T C : Nat} (x : Schedule T C) :
    servedPrefix x T = totalServed x := by
  exact prefixSum_eq_total_of_horizon_le _ (Nat.le_refl T)

end FixedCharge
