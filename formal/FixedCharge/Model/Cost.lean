import FixedCharge.Core.Charge
import FixedCharge.Model.Schedule
import Mathlib.Algebra.Order.Ring.Rat

namespace FixedCharge

/-- Exact fixed-charge schedule cost. Rational arithmetic prevents floating
point comparisons from entering finite certificates. -/
def scheduleCost {T C : Nat} (setup marginal : Fin T -> Rat)
    (x : Schedule T C) : Rat :=
  ∑ t, charge (setup t) (marginal t) (service x t : Rat)

theorem scheduleCost_eq_affine_on_positive_support {T C : Nat}
    (setup marginal : Fin T -> Rat) (x : Schedule T C) :
    scheduleCost setup marginal x =
      (∑ t ∈ support (fun t => (service x t : Rat)), setup t) +
      ∑ t ∈ support (fun t => (service x t : Rat)),
        marginal t * (service x t : Rat) := by
  rw [scheduleCost]
  classical
  calc
    ∑ t, charge (setup t) (marginal t) (service x t : Rat) =
        ∑ t ∈ support (fun q => (service x q : Rat)),
          charge (setup t) (marginal t) (service x t : Rat) := by
      symm
      apply Finset.sum_subset (Finset.subset_univ _)
      intro t _ ht
      have hzero : (service x t : Rat) = 0 := by
        apply not_ne_iff.mp
        intro hne
        exact ht ((mem_support_iff (fun q => (service x q : Rat)) t).mpr hne)
      rw [hzero]
      exact charge_eq_zero _ _
    _ = (∑ t ∈ support (fun t => (service x t : Rat)), setup t) +
        ∑ t ∈ support (fun t => (service x t : Rat)),
          marginal t * (service x t : Rat) :=
      charge_sum_over_support_affine setup marginal
        (fun t => (service x t : Rat))

end FixedCharge
