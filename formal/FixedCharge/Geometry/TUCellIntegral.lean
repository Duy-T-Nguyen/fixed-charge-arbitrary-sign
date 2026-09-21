import FixedCharge.Geometry.TUCompletion
import FixedCharge.Geometry.IntegralBounds

namespace FixedCharge

open Matrix Set

def integerConstraintMatrix {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Int)
    (E : Matrix (Fin mEq) (Fin n) Int) :
    Matrix (Fin mLe ⊕ Fin mEq) (Fin n) Int
  | Sum.inl i, j => A i j
  | Sum.inr i, j => E i j

private theorem restricted_dot_is_integer
    {n : Nat} (a : Fin n → Int) (rhs : Int) (x : Fin n → Real)
    (Q : Set (Fin n)) [DecidablePred (fun j : Fin n => j ∈ Q)]
    (hboundary : ∀ j, j ∉ Q → ∃ z : Int, (z : Real) = x j)
    (htotal : dotProduct (fun j => (a j : Real)) x = (rhs : Real)) :
    ∃ z : Int, (∑ j ∈ Finset.univ.filter (fun j => j ∈ Q),
      (a j : Real) * x j) = (z : Real) := by
  classical
  choose zboundary hzboundary using fun j => hboundary j
  let zfull : Fin n → Int := fun j => if hj : j ∉ Q then zboundary j hj else 0
  let outside : Int := ∑ j ∈ Finset.univ.filter (fun j => j ∉ Q),
    a j * zfull j
  refine ⟨rhs - outside, ?_⟩
  have hsplit := Finset.sum_filter_add_sum_filter_not Finset.univ
    (fun j : Fin n => j ∈ Q) (fun j => (a j : Real) * x j)
  have houtside : (∑ j ∈ Finset.univ.filter (fun j => j ∉ Q),
      (a j : Real) * x j) = (outside : Real) := by
    simp only [outside, Int.cast_sum, Int.cast_mul]
    apply Finset.sum_congr rfl
    intro j hj
    have hjQ : j ∉ Q := (Finset.mem_filter.mp hj).2
    simp [zfull, hjQ, hzboundary j hjQ]
  change (∑ j : Fin n, (a j : Real) * x j) = (rhs : Real) at htotal
  calc
    _ = (∑ j : Fin n, (a j : Real) * x j) -
        (∑ j ∈ Finset.univ.filter (fun j => j ∉ Q),
          (a j : Real) * x j) := by linarith [hsplit]
    _ = _ := by rw [htotal, houtside]; push_cast; ring

/-- Integral data and a TU combined constraint matrix make every support cell
integral. -/
theorem supportCell_integral_of_tu
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Int) (b : Fin mLe → Int)
    (E : Matrix (Fin mEq) (Fin n) Int) (d : Fin mEq → Int)
    (upper : Fin n → Nat)
    (hTU : (integerConstraintMatrix A E).IsTotallyUnimodular)
    (S : Finset (Fin n)) :
    CellIntegral (supportCell
      (linearAmbient (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
        (E.map (Int.castRingHom Real)) (fun i => (d i : Real))) upper S) := by
  classical
  intro x hxext
  let Q := interiorIndexSet upper S x
  letI : Fintype Q := Subtype.fintype (fun j : Fin n => j ∈ Q)
  letI : Fintype {j : Fin n // j ∉ Q} :=
    Subtype.fintype (fun j : Fin n => j ∉ Q)
  let rows := tightRowSet (A.map (Int.castRingHom Real))
      (fun i => (b i : Real)) x ⊕ Fin mEq
  let M : Matrix rows Q Int := fun r q =>
    match r with
    | Sum.inl i => A i.1 q.1
    | Sum.inr i => E i q.1
  have hTU_M : M.IsTotallyUnimodular := by
    let rf : rows → (Fin mLe ⊕ Fin mEq) := fun r =>
      match r with
      | Sum.inl i => Sum.inl i.1
      | Sum.inr i => Sum.inr i
    have hM : M = (integerConstraintMatrix A E).submatrix rf
        (fun q : Q => q.1) := by
      ext r q
      cases r <;> rfl
    rw [hM]
    exact hTU.submatrix _ _
  have hcols : LinearIndependent Real
      (M.map (Int.castRingHom Real)).col := by
    have hactive := linearIndependent_activeColumns
      (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
      (E.map (Int.castRingHom Real)) (fun i => (d i : Real))
      upper S hxext
    have hfun : (M.map (Int.castRingHom Real)).col =
        fun j : Q => activeColumn
          (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
          (E.map (Int.castRingHom Real)) x j.1 := by
      funext j r
      cases r <;> rfl
    rw [hfun]
    exact hactive
  have hboundary : ∀ j : Fin n, j ∉ Q →
      ∃ z : Int, (z : Real) = x j := by
    intro j hj
    obtain ⟨z, hz⟩ := supportCell_coordinate_integral_outside_interior
      upper S hxext.1 j hj
    exact ⟨z, by exact_mod_cast hz⟩
  have hrhs : ∀ i : rows, ∃ z : Int,
      dotProduct ((M.map (Int.castRingHom Real)) i) (fun q : Q => x q.1) =
        (z : Real) := by
    intro i
    cases i with
    | inl r =>
        have h := restricted_dot_is_integer (A r.1) (b r.1) x Q
          hboundary r.2
        simpa [M, dotProduct, ← Finset.sum_subtype_eq_sum_filter] using h
    | inr r =>
        have heq : dotProduct (fun j => (E r j : Real)) x = (d r : Real) :=
          hxext.1.1.2 r
        have h := restricted_dot_is_integer (E r) (d r) x Q
          hboundary heq
        simpa [M, dotProduct, ← Finset.sum_subtype_eq_sum_filter] using h
  obtain ⟨zQ, hzQ⟩ := integral_coordinates_of_tu M hTU_M
    (fun q : Q => x q.1) hcols hrhs
  have hzall : ∀ j : Fin n, ∃ z : Int, (z : Real) = x j := by
    intro j
    by_cases hj : j ∈ Q
    · exact ⟨zQ ⟨j, hj⟩, hzQ ⟨j, hj⟩⟩
    · obtain ⟨z, hz⟩ := supportCell_coordinate_integral_outside_interior
        upper S hxext.1 j hj
      exact ⟨z, by exact_mod_cast hz⟩
  choose z hz using hzall
  have hznonneg : ∀ j, 0 ≤ z j := by
    intro j
    have hxnonneg : (0 : Real) ≤ x j :=
      supportCell_subset_box _ upper S hxext.1 |>.1 j
    exact_mod_cast (hz j ▸ hxnonneg)
  refine ⟨fun j => (z j).toNat, ?_⟩
  funext j
  change (((z j).toNat : Nat) : Real) = x j
  have hnat : ((z j).toNat : Int) = z j := Int.toNat_of_nonneg (hznonneg j)
  calc
    (((z j).toNat : Nat) : Real) = (((z j).toNat : Int) : Real) := by
      exact_mod_cast rfl
    _ = (z j : Real) := by rw [hnat]
    _ = x j := hz j

end FixedCharge
