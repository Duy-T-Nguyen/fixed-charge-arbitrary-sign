import Mathlib.LinearAlgebra.Matrix.Determinant.TotallyUnimodular
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Data.Real.Basic

namespace FixedCharge

open Matrix

/-- A square integer matrix with unit determinant solves every integral
right-hand side over the integers. -/
theorem exists_int_solution_of_isUnit_det {ι : Type*} [Fintype ι] [DecidableEq ι]
    (B : Matrix ι ι Int) (rhs : ι -> Int)
    (hdet : IsUnit B.det) :
    ∃ z : ι -> Int, B *ᵥ z = rhs := by
  refine ⟨B⁻¹ *ᵥ rhs, ?_⟩
  change B *ᵥ (B⁻¹ *ᵥ rhs) = rhs
  rw [mulVec_mulVec, B.mul_nonsing_inv hdet, one_mulVec]

/-- The integer solution supplied by a unimodular square basis is unique. -/
theorem int_solution_unique_of_isUnit_det {ι : Type*} [Fintype ι] [DecidableEq ι]
    (B : Matrix ι ι Int) (hdet : IsUnit B.det)
    {rhs z w : ι -> Int} (hz : B *ᵥ z = rhs) (hw : B *ᵥ w = rhs) :
    z = w := by
  have hleft : Function.LeftInverse (fun q => B⁻¹ *ᵥ q) (fun q => B *ᵥ q) := by
    intro q
    change B⁻¹ *ᵥ (B *ᵥ q) = q
    rw [mulVec_mulVec, B.nonsing_inv_mul hdet, one_mulVec]
  exact hleft.injective (hz.trans hw.symm)

/-- Every nonsingular square submatrix of an integer TU matrix has unit
determinant. -/
theorem isUnit_det_submatrix_of_tu_of_ne_zero
    {m n k : Nat} (A : Matrix (Fin m) (Fin n) Int)
    (hTU : A.IsTotallyUnimodular)
    (rows : Fin k -> Fin m) (cols : Fin k -> Fin n)
    (hrows : Function.Injective rows) (hcols : Function.Injective cols)
    (hne : (A.submatrix rows cols).det ≠ 0) :
    IsUnit (A.submatrix rows cols).det := by
  obtain ⟨s, hs⟩ := hTU k rows cols hrows hcols
  cases s
  · exact (hne (by simpa using hs.symm)).elim
  · simp [← hs]
  · simp [← hs]

/-- Consequently, every nonsingular square basis selected from an integer TU
matrix solves every integral right-hand side integrally. -/
theorem exists_int_solution_of_tu_basis
    {m n k : Nat} (A : Matrix (Fin m) (Fin n) Int)
    (hTU : A.IsTotallyUnimodular)
    (rows : Fin k -> Fin m) (cols : Fin k -> Fin n)
    (hrows : Function.Injective rows) (hcols : Function.Injective cols)
    (hne : (A.submatrix rows cols).det ≠ 0) (rhs : Fin k -> Int) :
    ∃ z : Fin k -> Int, (A.submatrix rows cols) *ᵥ z = rhs :=
  exists_int_solution_of_isUnit_det _ _
    (isUnit_det_submatrix_of_tu_of_ne_zero A hTU rows cols hrows hcols hne)

/-- A real solution of a square integer system with unit determinant is the
cast of its unique integer solution. -/
theorem real_solution_is_integral_of_isUnit_det {ι : Type*} [Fintype ι] [DecidableEq ι]
    (B : Matrix ι ι Int) (rhs : ι -> Int)
    (x : ι -> ℝ) (hdet : IsUnit B.det)
    (hx : B.map (Int.castRingHom ℝ) *ᵥ x = fun i => (rhs i : ℝ)) :
    ∃ z : ι -> Int, (∀ i, (z i : ℝ) = x i) ∧ B *ᵥ z = rhs := by
  obtain ⟨z, hz⟩ := exists_int_solution_of_isUnit_det B rhs hdet
  have hzReal : B.map (Int.castRingHom ℝ) *ᵥ (fun i => (z i : ℝ)) =
      fun i => (rhs i : ℝ) := by
    ext i
    refine (RingHom.map_mulVec (Int.castRingHom ℝ) B z i).symm.trans ?_
    rw [hz]
    rfl
  have hdetReal : IsUnit (B.map (Int.castRingHom ℝ)).det := by
    change IsUnit ((Int.castRingHom ℝ).mapMatrix B).det
    rw [← RingHom.map_det]
    exact hdet.map (Int.castRingHom ℝ)
  have hinj : Function.Injective
      (fun q : ι -> ℝ => B.map (Int.castRingHom ℝ) *ᵥ q) := by
    intro q₁ q₂ hq
    have hleft : Function.LeftInverse
        (fun q => (B.map (Int.castRingHom ℝ))⁻¹ *ᵥ q)
        (fun q => B.map (Int.castRingHom ℝ) *ᵥ q) := by
      intro q
      change (B.map (Int.castRingHom ℝ))⁻¹ *ᵥ
        (B.map (Int.castRingHom ℝ) *ᵥ q) = q
      rw [mulVec_mulVec, Matrix.nonsing_inv_mul _ hdetReal, one_mulVec]
    exact hleft.injective hq
  have hzx : (fun i => (z i : ℝ)) = x :=
    hinj (hzReal.trans hx.symm)
  exact ⟨z, fun i => congrFun hzx i, hz⟩

end FixedCharge
