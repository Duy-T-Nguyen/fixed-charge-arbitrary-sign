import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.Ring.Basic

namespace FixedCharge

/-- A fixed charge is paid exactly when the activity is nonzero. -/
def charge {R : Type*} [Ring R] [DecidableEq R] (s c x : R) : R :=
  if x = 0 then 0 else s + c * x

@[simp] theorem charge_eq_zero {R : Type*} [Ring R] [DecidableEq R]
    (s c : R) : charge s c 0 = 0 := by
  simp [charge]

theorem charge_eq_affine_of_ne_zero {R : Type*} [Ring R] [DecidableEq R]
    (s c x : R) (hx : x ≠ 0) : charge s c x = s + c * x := by
  simp [charge, hx]

/-- The indices at which an activity vector is nonzero. -/
def support {ι R : Type*} [Fintype ι] [DecidableEq ι] [Zero R] [DecidableEq R]
    (x : ι -> R) : Finset ι :=
  Finset.univ.filter (fun j => x j ≠ 0)

@[simp] theorem mem_support_iff {ι R : Type*} [Fintype ι] [DecidableEq ι]
    [Zero R] [DecidableEq R] (x : ι -> R) (j : ι) :
    j ∈ support x ↔ x j ≠ 0 := by
  simp [support]

/-- On any fixed finite support, the fixed-charge objective is affine. -/
theorem support_objective_affine {ι R : Type*} [DecidableEq ι] [CommRing R]
    (S : Finset ι) (s c x : ι -> R) :
    ∑ j ∈ S, (s j + c j * x j) =
      (∑ j ∈ S, s j) + ∑ j ∈ S, c j * x j := by
  simp only [Finset.sum_add_distrib]

/-- Actual fixed charges agree with the affine branch on a fixed nonzero support. -/
theorem support_charge_affine {ι R : Type*} [DecidableEq ι] [CommRing R]
    [DecidableEq R] (S : Finset ι) (s c x : ι -> R)
    (nonzero : ∀ j ∈ S, x j ≠ 0) :
    ∑ j ∈ S, charge (s j) (c j) (x j) =
      (∑ j ∈ S, s j) + ∑ j ∈ S, c j * x j := by
  calc
    ∑ j ∈ S, charge (s j) (c j) (x j) =
        ∑ j ∈ S, (s j + c j * x j) := by
          apply Finset.sum_congr rfl
          intro j hj
          exact charge_eq_affine_of_ne_zero _ _ _ (nonzero j hj)
    _ = (∑ j ∈ S, s j) + ∑ j ∈ S, c j * x j :=
      support_objective_affine S s c x

/-- Specialization to the support induced by an activity vector. -/
theorem charge_sum_over_support_affine {ι R : Type*} [Fintype ι]
    [DecidableEq ι] [CommRing R] [DecidableEq R] (s c x : ι -> R) :
    ∑ j ∈ support x, charge (s j) (c j) (x j) =
      (∑ j ∈ support x, s j) + ∑ j ∈ support x, c j * x j := by
  apply support_charge_affine
  intro j hj
  exact (mem_support_iff x j).mp hj

end FixedCharge
