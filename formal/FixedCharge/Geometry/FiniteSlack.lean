import FixedCharge.Geometry.ExtremeDirection
import Mathlib.Order.Filter.Finite

namespace FixedCharge

open Set Filter

/-- A direction that annihilates every equality row and every inequality row
tight at `x` remains feasible for all sufficiently small scalar perturbations. -/
theorem eventually_mem_linearAmbient_along_direction
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (dEq : Fin mEq -> Real)
    {x v : Fin n -> Real}
    (hx : x ∈ linearAmbient A b E dEq)
    (hactive : ∀ i, dotProduct (A i) x = b i -> dotProduct (A i) v = 0)
    (heq : ∀ i, dotProduct (E i) v = 0) :
    ∀ᶠ t in nhds (0 : Real), x + t • v ∈ linearAmbient A b E dEq := by
  have hle : ∀ᶠ t in nhds (0 : Real),
      ∀ i, dotProduct (A i) (x + t • v) ≤ b i := by
    rw [Filter.eventually_all]
    intro i
    by_cases htight : dotProduct (A i) x = b i
    · filter_upwards [] with t
      simp [dotProduct_add, dotProduct_smul, htight, hactive i htight]
    · have hstrict : dotProduct (A i) x < b i :=
        lt_of_le_of_ne (hx.1 i) htight
      have hc : ContinuousAt
          (fun t : Real => dotProduct (A i) (x + t • v)) 0 := by
        fun_prop
      have hstrict0 :
          (fun t : Real => dotProduct (A i) (x + t • v)) 0 < b i := by
        simpa using hstrict
      exact Filter.Eventually.mono (hc (isOpen_Iio.mem_nhds hstrict0))
        fun _ ht => le_of_lt ht
  have hequal : ∀ᶠ t in nhds (0 : Real),
      ∀ i, dotProduct (E i) (x + t • v) = dEq i := by
    filter_upwards [] with t
    intro i
    simp [dotProduct_add, dotProduct_smul, hx.2 i, heq i]
  filter_upwards [hle, hequal] with t ht he
  exact ⟨ht, he⟩

/-- Eventual feasibility along a line supplies one positive, symmetric
perturbation radius. -/
theorem exists_symmetric_perturbation_of_eventually
    {n : Nat} {P : Set (Fin n -> Real)} {x v : Fin n -> Real}
    (hlocal : ∀ᶠ t in nhds (0 : Real), x + t • v ∈ P) :
    ∃ epsilon : Real, 0 < epsilon ∧
      x - epsilon • v ∈ P ∧ x + epsilon • v ∈ P := by
  change {t : Real | x + t • v ∈ P} ∈ nhds 0 at hlocal
  rw [Metric.mem_nhds_iff] at hlocal
  obtain ⟨r, hr, hball⟩ := hlocal
  refine ⟨r / 2, by positivity, ?_, ?_⟩
  · have hneg : -(r / 2) ∈ Metric.ball (0 : Real) r := by
      rw [Metric.mem_ball, Real.dist_eq, sub_zero, abs_neg,
        abs_of_pos (show 0 < r / 2 by positivity)]
      linarith
    simpa [neg_smul, sub_eq_add_neg] using hball hneg
  · have hpos : r / 2 ∈ Metric.ball (0 : Real) r := by
      rw [Metric.mem_ball, Real.dist_eq, sub_zero,
        abs_of_pos (show 0 < r / 2 by positivity)]
      linarith
    exact hball hpos

/-- If a direction changes only coordinates strictly inside their support-cell
bounds, all coordinate clauses remain true for sufficiently small scalars. -/
theorem eventually_mem_supportCell_along_direction
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (dEq : Fin mEq -> Real)
    (upper : Fin n -> Nat) (S : Finset (Fin n))
    {x v : Fin n -> Real}
    (hx : x ∈ supportCell (linearAmbient A b E dEq) upper S)
    (hactive : ∀ i, dotProduct (A i) x = b i -> dotProduct (A i) v = 0)
    (heq : ∀ i, dotProduct (E i) v = 0)
    (hvary : ∀ j, v j ≠ 0 ->
      j ∈ S ∧ (1 : Real) < x j ∧ x j < (upper j : Real)) :
    ∀ᶠ t in nhds (0 : Real),
      x + t • v ∈ supportCell (linearAmbient A b E dEq) upper S := by
  have hambient := eventually_mem_linearAmbient_along_direction
    A b E dEq hx.1 hactive heq
  have hbounds : ∀ᶠ t in nhds (0 : Real), ∀ j,
      if j ∈ S then
        (1 : Real) ≤ (x + t • v) j ∧ (x + t • v) j ≤ (upper j : Real)
      else (x + t • v) j = 0 := by
    rw [Filter.eventually_all]
    intro j
    by_cases hvzero : v j = 0
    · filter_upwards [] with t
      simp [hvzero, hx.2 j]
    · obtain ⟨hjS, hjlow, hjhigh⟩ := hvary j hvzero
      have hc : ContinuousAt (fun t : Real => (x + t • v) j) 0 := by
        fun_prop
      have hlow0 : (1 : Real) < (fun t : Real => (x + t • v) j) 0 := by
        simpa using hjlow
      have hhigh0 : (fun t : Real => (x + t • v) j) 0 < (upper j : Real) := by
        simpa using hjhigh
      have hlow := hc (isOpen_Ioi.mem_nhds hlow0)
      have hhigh := hc (isOpen_Iio.mem_nhds hhigh0)
      filter_upwards [hlow, hhigh] with t htlow hthigh
      simp only [hjS, if_pos]
      exact ⟨le_of_lt htlow, le_of_lt hthigh⟩
  filter_upwards [hambient, hbounds] with t htambient htbounds
  exact ⟨htambient, htbounds⟩

/-- At an extreme support-cell point, any direction satisfying the active-row,
equality-row, and strict-interior support conditions must vanish. -/
theorem supportCell_direction_eq_zero_of_extreme
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (dEq : Fin mEq -> Real)
    (upper : Fin n -> Nat) (S : Finset (Fin n))
    {x v : Fin n -> Real}
    (hx : x ∈ (supportCell (linearAmbient A b E dEq) upper S).extremePoints Real)
    (hactive : ∀ i, dotProduct (A i) x = b i -> dotProduct (A i) v = 0)
    (heq : ∀ i, dotProduct (E i) v = 0)
    (hvary : ∀ j, v j ≠ 0 ->
      j ∈ S ∧ (1 : Real) < x j ∧ x j < (upper j : Real)) :
    v = 0 := by
  have hlocal := eventually_mem_supportCell_along_direction
    A b E dEq upper S hx.1 hactive heq hvary
  obtain ⟨epsilon, hepsilon, hminus, hplus⟩ :=
    exists_symmetric_perturbation_of_eventually hlocal
  exact direction_eq_zero_of_extreme_smul hx hepsilon.ne' hminus hplus

end FixedCharge
