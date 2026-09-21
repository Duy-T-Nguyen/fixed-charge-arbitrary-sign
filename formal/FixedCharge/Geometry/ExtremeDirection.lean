import FixedCharge.Geometry.LinearAmbient
import Mathlib.Analysis.Convex.Extreme

namespace FixedCharge

open Set

/-- An extreme point admits no nonzero two-sided feasible direction.  This is
the geometric contradiction used by Paper 1's active-column corollary. -/
theorem direction_eq_zero_of_extreme
    {n : Nat} {P : Set (Fin n -> Real)} {x d : Fin n -> Real}
    (hx : x ∈ P.extremePoints Real)
    (hminus : x - d ∈ P) (hplus : x + d ∈ P) : d = 0 := by
  letI : Invertible (2 : Real) := invertibleOfNonzero (by norm_num)
  have hendpoints := (mem_extremePoints.mp hx).2
    (x - d) hminus (x + d) hplus (mem_openSegment_sub_add x d)
  have hsub : x - d = x := hendpoints.1
  exact sub_eq_self.mp hsub

/-- Scaled form used after the finite-slack argument chooses `epsilon > 0`. -/
theorem direction_eq_zero_of_extreme_smul
    {n : Nat} {P : Set (Fin n -> Real)} {x d : Fin n -> Real} {epsilon : Real}
    (hx : x ∈ P.extremePoints Real) (hepsilon : epsilon ≠ 0)
    (hminus : x - epsilon • d ∈ P) (hplus : x + epsilon • d ∈ P) : d = 0 := by
  have hscaled : epsilon • d = 0 :=
    direction_eq_zero_of_extreme hx hminus hplus
  exact (smul_eq_zero.mp hscaled).resolve_left hepsilon

end FixedCharge
