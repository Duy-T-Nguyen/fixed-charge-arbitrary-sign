import FixedCharge.Geometry.FiniteSlack
import Mathlib.LinearAlgebra.LinearIndependent.Lemmas
import Mathlib.LinearAlgebra.Dimension.Constructions

namespace FixedCharge

open Set

def interiorIndexSet {n : Nat} (upper : Fin n -> Nat) (S : Finset (Fin n))
    (x : Fin n -> Real) : Set (Fin n) :=
  {j | j ∈ S ∧ (1 : Real) < x j ∧ x j < (upper j : Real)}

def tightRowSet {n m : Nat} (A : Matrix (Fin m) (Fin n) Real)
    (b : Fin m -> Real) (x : Fin n -> Real) : Set (Fin m) :=
  {i | dotProduct (A i) x = b i}

/-- A column restricted to the tight inequality rows and all equality rows. -/
def activeColumn {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (x : Fin n -> Real)
    (j : Fin n) : tightRowSet A b x ⊕ Fin mEq -> Real
  | Sum.inl i => A i.1 j
  | Sum.inr i => E i j

noncomputable def activeMatrixRank {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (x : Fin n -> Real) : Nat :=
  Module.finrank Real
    (Submodule.span Real (Set.range (fun j : Fin n => activeColumn A b E x j)))

/-- The active columns indexed by coordinates strictly inside their cell bounds
are linearly independent. This is Paper 1's active-column corollary, with
equality rows included among the always-tight rows. -/
theorem linearIndependent_activeColumns
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (dEq : Fin mEq -> Real)
    (upper : Fin n -> Nat) (S : Finset (Fin n))
    {x : Fin n -> Real}
    (hx : x ∈ (supportCell (linearAmbient A b E dEq) upper S).extremePoints Real) :
    LinearIndependent Real
      (fun j : interiorIndexSet upper S x => activeColumn A b E x j.1) := by
  classical
  rw [Fintype.linearIndependent_iff]
  intro g hrelation q
  let v : Fin n -> Real := fun j =>
    if hj : j ∈ interiorIndexSet upper S x then g ⟨j, hj⟩ else 0
  have hvary : ∀ j, v j ≠ 0 ->
      j ∈ S ∧ (1 : Real) < x j ∧ x j < (upper j : Real) := by
    intro j hj
    by_cases hmem : j ∈ interiorIndexSet upper S x
    · exact hmem
    · simp [v, hmem] at hj
  have hactive : ∀ i, dotProduct (A i) x = b i -> dotProduct (A i) v = 0 := by
    intro i hi
    have hrow := congrFun hrelation (Sum.inl ⟨i, hi⟩)
    simp only [Finset.sum_apply, Pi.smul_apply, activeColumn] at hrow
    rw [dotProduct]
    calc
      ∑ j, A i j * v j =
          ∑ j ∈ Finset.univ.filter (fun j => j ∈ interiorIndexSet upper S x),
            A i j * v j := by
        symm
        apply Finset.sum_subset (Finset.filter_subset _ _)
        intro j _ hj
        have hnot : j ∉ interiorIndexSet upper S x := by simpa using hj
        simp [v, hnot]
      _ = ∑ j : interiorIndexSet upper S x, A i j.1 * g j := by
        rw [← Finset.sum_subtype_eq_sum_filter]
        simp [v]
      _ = 0 := by simpa [mul_comm] using hrow
  have heq : ∀ i, dotProduct (E i) v = 0 := by
    intro i
    have hrow := congrFun hrelation (Sum.inr i)
    simp only [Finset.sum_apply, Pi.smul_apply, activeColumn] at hrow
    rw [dotProduct]
    calc
      ∑ j, E i j * v j =
          ∑ j ∈ Finset.univ.filter (fun j => j ∈ interiorIndexSet upper S x),
            E i j * v j := by
        symm
        apply Finset.sum_subset (Finset.filter_subset _ _)
        intro j _ hj
        have hnot : j ∉ interiorIndexSet upper S x := by simpa using hj
        simp [v, hnot]
      _ = ∑ j : interiorIndexSet upper S x, E i j.1 * g j := by
        rw [← Finset.sum_subtype_eq_sum_filter]
        simp [v]
      _ = 0 := by simpa [mul_comm] using hrow
  have hvzero : v = 0 := supportCell_direction_eq_zero_of_extreme
    A b E dEq upper S hx hactive heq hvary
  have hq := congrFun hvzero q.1
  simpa [v, q.2] using hq

theorem interior_card_le_activeMatrixRank
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (dEq : Fin mEq -> Real)
    (upper : Fin n -> Nat) (S : Finset (Fin n))
    {x : Fin n -> Real}
    (hx : x ∈ (supportCell (linearAmbient A b E dEq) upper S).extremePoints Real) :
    Nat.card (interiorIndexSet upper S x) ≤ activeMatrixRank A b E x := by
  classical
  letI : Fintype (interiorIndexSet upper S x) := Fintype.ofFinite _
  rw [Nat.card_eq_fintype_card]
  let restricted := fun j : interiorIndexSet upper S x => activeColumn A b E x j.1
  have hli : LinearIndependent Real restricted :=
    linearIndependent_activeColumns A b E dEq upper S hx
  have hrank : Module.finrank Real (Submodule.span Real (Set.range restricted)) =
      Fintype.card (interiorIndexSet upper S x) :=
    finrank_span_eq_card hli
  rw [← hrank]
  apply Submodule.finrank_mono
  apply Submodule.span_mono
  rintro y ⟨j, rfl⟩
  exact ⟨j.1, rfl⟩

end FixedCharge
