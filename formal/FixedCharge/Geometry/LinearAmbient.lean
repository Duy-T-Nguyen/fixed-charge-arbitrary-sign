import FixedCharge.Geometry.SupportCell
import Mathlib.Topology.Instances.Matrix

namespace FixedCharge

open Set

/-- A finite system of linear inequalities and equalities.  Rows in `leRows`
are interpreted as `A x <= b`; rows in `eqRows` as `E x = d`. -/
def linearAmbient {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (d : Fin mEq -> Real) :
    Set (Fin n -> Real) :=
  {x | (∀ i, dotProduct (A i) x ≤ b i) ∧
       (∀ i, dotProduct (E i) x = d i)}

theorem isClosed_linearAmbient {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (d : Fin mEq -> Real) :
    IsClosed (linearAmbient A b E d) := by
  change IsClosed ({x | ∀ i, dotProduct (A i) x ≤ b i} ∩
    {x | ∀ i, dotProduct (E i) x = d i})
  apply IsClosed.inter
  · rw [show {x : Fin n -> Real | ∀ i, dotProduct (A i) x ≤ b i} =
        ⋂ i, {x | dotProduct (A i) x ≤ b i} by ext; simp]
    exact isClosed_iInter fun i => isClosed_le (by fun_prop) continuous_const
  · rw [show {x : Fin n -> Real | ∀ i, dotProduct (E i) x = d i} =
        ⋂ i, {x | dotProduct (E i) x = d i} by ext; simp]
    exact isClosed_iInter fun i => isClosed_eq (by fun_prop) continuous_const

theorem isClosed_supportCell {n : Nat} {ambient : Set (Fin n -> Real)}
    (hclosed : IsClosed ambient) (upper : Fin n -> Nat) (S : Finset (Fin n)) :
    IsClosed (supportCell ambient upper S) := by
  change IsClosed (ambient ∩
    {z | ∀ j, if j ∈ S then
      (1 : Real) ≤ z j ∧ z j ≤ upper j else z j = 0})
  apply hclosed.inter
  rw [show {z : Fin n -> Real | ∀ j, if j ∈ S then
        (1 : Real) ≤ z j ∧ z j ≤ (upper j : Real) else z j = 0} =
      ⋂ j, {z | if j ∈ S then
        (1 : Real) ≤ z j ∧ z j ≤ (upper j : Real) else z j = 0} by ext; simp]
  apply isClosed_iInter
  intro j
  by_cases hj : j ∈ S
  · simp only [hj, if_pos]
    exact (isClosed_le continuous_const (continuous_apply j)).inter
      (isClosed_le (continuous_apply j) continuous_const)
  · simp only [hj]
    exact isClosed_eq (continuous_apply j) continuous_const

theorem supportCell_subset_box {n : Nat} (ambient : Set (Fin n -> Real))
    (upper : Fin n -> Nat) (S : Finset (Fin n)) :
    supportCell ambient upper S ⊆ Set.Icc (fun _ => (0 : Real))
      (fun j => (upper j : Real)) := by
  intro z hz
  constructor <;> intro j
  · have hj := hz.2 j
    by_cases hmem : j ∈ S
    · simp [hmem] at hj
      exact le_trans (by norm_num) hj.1
    · simp [hmem] at hj
      simp [hj]
  · have hj := hz.2 j
    by_cases hmem : j ∈ S
    · simp [hmem] at hj
      exact hj.2
    · simp [hmem] at hj
      simp [hj]

/-- Every support cell cut from a closed ambient set is compact because its
coordinate bounds place it inside a compact box. -/
theorem isCompact_supportCell_of_isClosed {n : Nat}
    {ambient : Set (Fin n -> Real)} (hclosed : IsClosed ambient)
    (upper : Fin n -> Nat) (S : Finset (Fin n)) :
    IsCompact (supportCell ambient upper S) := by
  apply IsCompact.of_isClosed_subset
    (isCompact_Icc : IsCompact (Set.Icc (fun _ => (0 : Real))
      (fun j => (upper j : Real))))
    (isClosed_supportCell hclosed upper S)
    (supportCell_subset_box ambient upper S)

theorem isCompact_supportCell_linearAmbient {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (d : Fin mEq -> Real)
    (upper : Fin n -> Nat) (S : Finset (Fin n)) :
    IsCompact (supportCell (linearAmbient A b E d) upper S) :=
  isCompact_supportCell_of_isClosed (isClosed_linearAmbient A b E d) upper S

end FixedCharge
