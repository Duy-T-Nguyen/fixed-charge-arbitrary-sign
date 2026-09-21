import FixedCharge.Geometry.ActiveColumns

namespace FixedCharge

open Set

/-- Every coordinate outside the strict-interior index set of a support cell is
already at an integral value: zero, one, or its integral upper bound. -/
theorem supportCell_coordinate_integral_outside_interior
    {n : Nat} {ambient : Set (Fin n -> Real)}
    (upper : Fin n -> Nat) (S : Finset (Fin n))
    {x : Fin n -> Real} (hx : x ∈ supportCell ambient upper S)
    (j : Fin n) (hj : j ∉ interiorIndexSet upper S x) :
    ∃ z : Nat, (z : Real) = x j := by
  by_cases hjS : j ∈ S
  · have hbounds := hx.2 j
    simp only [hjS, if_pos] at hbounds
    have hboundary : x j = 1 ∨ x j = (upper j : Real) := by
      by_contra hne
      push Not at hne
      have hlow : (1 : Real) < x j := lt_of_le_of_ne hbounds.1 hne.1.symm
      have hhigh : x j < (upper j : Real) := lt_of_le_of_ne hbounds.2 hne.2
      exact hj ⟨hjS, hlow, hhigh⟩
    rcases hboundary with hlow | hhigh
    · exact ⟨1, by simpa using hlow.symm⟩
    · exact ⟨upper j, hhigh.symm⟩
  · have hzero := hx.2 j
    simp only [hjS] at hzero
    exact ⟨0, by simpa using hzero.symm⟩

end FixedCharge
