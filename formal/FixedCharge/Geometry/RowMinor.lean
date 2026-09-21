import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.LinearAlgebra.Dimension.StrongRankCondition

namespace FixedCharge

open Matrix Set Submodule

/-- A finite rectangular matrix with independent columns contains a square
row minor with nonzero determinant. -/
theorem exists_nonsingular_row_minor_fintype
    {K rows cols : Type*} [Field K]
    [Fintype rows] [DecidableEq rows] [Fintype cols] [DecidableEq cols]
    (M : Matrix rows cols K)
    (hcols : LinearIndependent K M.col) :
    ∃ select : cols → rows, Function.Injective select ∧
      (M.submatrix select id).det ≠ 0 := by
  classical
  have hrank : M.rank = Fintype.card cols := by
    rw [M.rank_eq_finrank_span_cols, finrank_span_eq_card hcols]
  have hrowdim : Module.finrank K (span K (Set.range M.row)) =
      Fintype.card cols := by
    rw [← M.rank_eq_finrank_span_row, hrank]
  have hrowtop : span K (Set.range M.row) = ⊤ := by
    apply Submodule.eq_top_of_finrank_eq
    rw [hrowdim, Module.finrank_fintype_fun_eq_card]
  obtain ⟨f, hf_range, hf_span, hf_ind⟩ :=
    Submodule.exists_fun_fin_finrank_span_eq K (Set.range M.row)
  let e : cols ≃ Fin (Module.finrank K (span K (Set.range M.row))) :=
    (Fintype.equivFin cols).trans (finCongr hrowdim.symm)
  have hf_ind' : LinearIndependent K (fun j : cols => f (e j)) :=
    hf_ind.comp _ e.injective
  choose select hselect using fun j : cols => hf_range (e j)
  have hroweq : ∀ j, f (e j) = M.row (select j) := fun j => (hselect j).symm
  have hselect_inj : Function.Injective select := by
    intro i j hij
    apply e.injective
    apply hf_ind.injective
    rw [hroweq i, hroweq j, hij]
  refine ⟨select, hselect_inj, ?_⟩
  let B : Matrix cols cols K := M.submatrix select id
  have hBrow : B.row = fun j => f (e j) := by
    funext i j
    simp [B, hroweq]
  have hBrows : LinearIndependent K B.row := by
    rw [hBrow]
    exact hf_ind'
  have hunit : IsUnit B := Matrix.linearIndependent_rows_iff_isUnit.mp hBrows
  have hdetUnit : IsUnit B.det := (Matrix.isUnit_iff_isUnit_det B).1 hunit
  exact hdetUnit.ne_zero

/-- `Fin`-indexed specialization used by the manuscript-facing development. -/
theorem exists_nonsingular_row_minor
    {K : Type*} [Field K] {m n : Nat} (M : Matrix (Fin m) (Fin n) K)
    (hcols : LinearIndependent K M.col) :
    ∃ rows : Fin n → Fin m, Function.Injective rows ∧
      (M.submatrix rows id).det ≠ 0 :=
  exists_nonsingular_row_minor_fintype M hcols

end FixedCharge
