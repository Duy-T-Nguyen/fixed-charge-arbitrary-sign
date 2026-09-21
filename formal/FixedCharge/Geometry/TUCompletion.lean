import FixedCharge.Geometry.RowMinor
import FixedCharge.Geometry.UnimodularBasis

namespace FixedCharge

open Matrix

/-- If the columns of an integer TU system that correspond to the remaining
unknowns are independent, and every row evaluates to an integer, then all
remaining unknowns are integral. -/
theorem integral_coordinates_of_tu
    {rows cols : Type*}
    [Fintype rows] [DecidableEq rows] [Fintype cols] [DecidableEq cols]
    (M : Matrix rows cols Int) (hTU : M.IsTotallyUnimodular)
    (x : cols → Real)
    (hcols : LinearIndependent Real
      (M.map (Int.castRingHom Real)).col)
    (hrhs : ∀ i : rows, ∃ z : Int,
      dotProduct ((M.map (Int.castRingHom Real)) i) x = (z : Real)) :
    ∃ z : cols → Int, ∀ j, (z j : Real) = x j := by
  classical
  let MR : Matrix rows cols Real := M.map (Int.castRingHom Real)
  obtain ⟨select, hselect, hdetReal⟩ :=
    exists_nonsingular_row_minor_fintype MR hcols
  choose rhs hrhs_eq using fun j : cols => hrhs (select j)
  let B : Matrix cols cols Int := M.submatrix select id
  have hdetMap : (B.map (Int.castRingHom Real)).det = (B.det : Real) := by
    change ((Int.castRingHom Real).mapMatrix B).det = _
    rw [← RingHom.map_det]
    rfl
  have hdet : B.det ≠ 0 := by
    intro hz
    apply hdetReal
    have hmap : B.map (Int.castRingHom Real) = MR.submatrix select id := by
      ext i j
      rfl
    rw [← hmap, hdetMap, hz]
    norm_num
  have hTU_B : B.IsTotallyUnimodular := hTU.submatrix select id
  have hunit : IsUnit B.det := by
    have hminor :=
      (Matrix.isTotallyUnimodular_iff_fintype B).1 hTU_B cols id id
    have hsign : B.det ∈ Set.range SignType.cast := by
      simpa using hminor
    obtain ⟨s, hs⟩ := hsign
    cases s
    · exact (hdet (by simpa using hs.symm)).elim
    · simp [← hs]
    · simp [← hs]
  have hxB : B.map (Int.castRingHom Real) *ᵥ x = fun j => (rhs j : Real) := by
    ext j
    simpa [B, MR, Matrix.mulVec] using hrhs_eq j
  obtain ⟨z, hz, _⟩ :=
    real_solution_is_integral_of_isUnit_det B rhs x hunit hxB
  exact ⟨z, hz⟩

end FixedCharge
