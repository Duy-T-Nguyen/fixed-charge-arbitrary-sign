import FixedCharge.Paper1.Main

namespace FixedCharge

open Set

/-- The support-conditioned cell from Paper 1. `ambient` represents the common
linear constraints; the remaining clauses freeze zero coordinates and impose
the integer lower bound one on active coordinates. -/
def supportCell {n : Nat} (ambient : Set (Fin n -> Real))
    (upper : Fin n -> Nat) (S : Finset (Fin n)) : Set (Fin n -> Real) :=
  {z | z ∈ ambient ∧ ∀ j, if j ∈ S then
      (1 : Real) ≤ z j ∧ z j ≤ upper j else z j = 0}

/-- Nonnegative integer feasibility for a common ambient constraint set and
coordinatewise integral upper bounds. -/
def integerFeasible {n : Nat} (ambient : Set (Fin n -> Real))
    (upper : Fin n -> Nat) (x : Fin n -> Nat) : Prop :=
  activityEmbed x ∈ ambient ∧ ∀ j, x j ≤ upper j

/-- A cell is integral in the exact sense needed by the vertex theorem: every
extreme point has an integer representative. -/
def CellIntegral {n : Nat} (cell : Set (Fin n -> Real)) : Prop :=
  ∀ z ∈ cell.extremePoints Real, ∃ x : Fin n -> Nat, activityEmbed x = z

theorem embed_mem_own_supportCell {n : Nat} {ambient : Set (Fin n -> Real)}
    {upper : Fin n -> Nat} {x : Fin n -> Nat}
    (hx : integerFeasible ambient upper x) :
    activityEmbed x ∈ supportCell ambient upper (activitySupport x) := by
  refine ⟨hx.1, fun j => ?_⟩
  split_ifs with hj
  · have hneReal : activityEmbed x j ≠ 0 :=
      (mem_support_iff (activityEmbed x) j).mp hj
    have hneNat : x j ≠ 0 := by
      intro hzero
      exact hneReal (by simp [activityEmbed, hzero])
    constructor
    · change (1 : Real) ≤ (x j : Real)
      exact_mod_cast (Nat.one_le_iff_ne_zero.mpr hneNat)
    · change (x j : Real) ≤ (upper j : Real)
      exact_mod_cast hx.2 j
  · have hzeroReal : activityEmbed x j = 0 := by
      apply not_ne_iff.mp
      intro hne
      exact hj ((mem_support_iff (activityEmbed x) j).mpr hne)
    exact hzeroReal

theorem integral_extreme_reconstruct {n : Nat}
    {ambient : Set (Fin n -> Real)} {upper : Fin n -> Nat}
    {S : Finset (Fin n)}
    (hint : CellIntegral (supportCell ambient upper S))
    {z : Fin n -> Real} (hz : z ∈ (supportCell ambient upper S).extremePoints Real) :
    ∃ x, integerFeasible ambient upper x ∧ activityEmbed x = z ∧
      activitySupport x = S := by
  obtain ⟨x, hxembed⟩ := hint z hz
  have hzcell := hz.1
  have hxambient : activityEmbed x ∈ ambient := hxembed.symm ▸ hzcell.1
  have hxupper : ∀ j, x j ≤ upper j := by
    intro j
    have hjcell := hzcell.2 j
    have hxj : (x j : Real) = z j := congrFun hxembed j
    split_ifs at hjcell with hj
    · have hbound : (x j : Real) ≤ (upper j : Real) := hxj.trans_le hjcell.2
      exact_mod_cast hbound
    · have hxzeroReal : (x j : Real) = 0 := hxj.trans hjcell
      have hxzero : x j = 0 := by
        apply Nat.cast_injective (R := Real)
        simpa using hxzeroReal
      simp [hxzero]
  refine ⟨x, ⟨hxambient, hxupper⟩, hxembed, ?_⟩
  ext j
  unfold activitySupport
  rw [mem_support_iff]
  constructor
  · intro hxne
    by_contra hj
    have hjcell := hzcell.2 j
    have hxj : activityEmbed x j = z j := congrFun hxembed j
    simp [hj] at hjcell
    exact hxne (hxj.trans hjcell)
  · intro hj
    have hjcell := hzcell.2 j
    have hxj : activityEmbed x j = z j := congrFun hxembed j
    simp [hj] at hjcell
    intro hxzero
    have hzzero : z j = 0 := by
      rw [← hxj, hxzero]
    rw [hzzero] at hjcell
    exact one_ne_zero (le_antisymm hjcell.1 (by norm_num))

end FixedCharge
