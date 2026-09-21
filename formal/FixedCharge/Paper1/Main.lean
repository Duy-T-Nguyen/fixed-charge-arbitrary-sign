import FixedCharge.Core.Charge
import FixedCharge.Geometry.DiscreteTransfer
import Mathlib.Algebra.CharZero.Defs
import Mathlib.Data.Fintype.Fin
import Mathlib.Topology.Algebra.Module.LinearMapPiProd

namespace FixedCharge

open Set

/-- Embed a nonnegative integer activity vector into real space. -/
def activityEmbed {n : Nat} (x : Fin n -> Nat) : Fin n -> Real :=
  fun j => x j

/-- Positive support of an integer activity vector. -/
noncomputable def activitySupport {n : Nat} (x : Fin n -> Nat) : Finset (Fin n) :=
  support (activityEmbed x)

/-- Fixed-charge objective for nonnegative integer activities. -/
noncomputable def fixedChargeCost {n : Nat} (setup marginal : Fin n -> Real)
    (x : Fin n -> Nat) : Real :=
  ∑ j, charge (setup j) (marginal j) (activityEmbed x j)

def supportOffset {n : Nat} (setup : Fin n -> Real) (S : Finset (Fin n)) : Real :=
  ∑ j ∈ S, setup j

noncomputable def marginalCost {n : Nat} (marginal : Fin n -> Real)
    (x : Fin n -> Nat) : Real :=
  ∑ j ∈ activitySupport x, marginal j * activityEmbed x j

/-- Continuous linear functional corresponding to the marginal-rate vector. -/
noncomputable def marginalLinear {n : Nat} (marginal : Fin n -> Real) :
    StrongDual Real (Fin n -> Real) :=
  ∑ j, (ContinuousLinearMap.proj j).smulRight (marginal j)

theorem marginalLinear_correct {n : Nat} (marginal : Fin n -> Real)
    (x : Fin n -> Nat) :
    marginalLinear marginal (activityEmbed x) = marginalCost marginal x := by
  classical
  calc
    marginalLinear marginal (activityEmbed x) =
        ∑ j, activityEmbed x j * marginal j := by
      simp [marginalLinear, ContinuousLinearMap.sum_apply]
    _ = ∑ j, marginal j * activityEmbed x j := by
      apply Finset.sum_congr rfl
      intro j _
      exact mul_comm _ _
    _ = ∑ j ∈ activitySupport x, marginal j * activityEmbed x j := by
      symm
      apply Finset.sum_subset (Finset.subset_univ _)
      intro j _ hj
      have hzero : activityEmbed x j = 0 := by
        apply not_ne_iff.mp
        intro hne
        exact hj ((mem_support_iff (activityEmbed x) j).mpr hne)
      simp [hzero]
    _ = marginalCost marginal x := rfl

theorem fixedChargeCost_affine_on_support {n : Nat}
    (setup marginal : Fin n -> Real) (x : Fin n -> Nat) :
    fixedChargeCost setup marginal x =
      supportOffset setup (activitySupport x) + marginalCost marginal x := by
  classical
  unfold fixedChargeCost supportOffset marginalCost activitySupport
  calc
    ∑ j, charge (setup j) (marginal j) (activityEmbed x j) =
        ∑ j ∈ support (activityEmbed x),
          charge (setup j) (marginal j) (activityEmbed x j) := by
      symm
      apply Finset.sum_subset (Finset.subset_univ _)
      intro j _ hj
      have hzero : activityEmbed x j = 0 := by
        apply not_ne_iff.mp
        intro hne
        exact hj ((mem_support_iff (activityEmbed x) j).mpr hne)
      rw [hzero]
      exact charge_eq_zero _ _
    _ = (∑ j ∈ support (activityEmbed x), setup j) +
        ∑ j ∈ support (activityEmbed x), marginal j * activityEmbed x j :=
      charge_sum_over_support_affine setup marginal (activityEmbed x)

/-- Paper 1's support-cell argument in a form that separates geometry from the
source of integrality. `hreconstruct` is precisely the support-cell integrality
step: every extreme cell point is represented by a feasible integer vector
with the conditioned support. -/
theorem fixedCharge_vertex_theorem
    {n : Nat} (setup marginal : Fin n -> Real)
    (feasible : (Fin n -> Nat) -> Prop)
    (cell : Set (Fin n -> Real)) (linear : StrongDual Real (Fin n -> Real))
    (xstar : Fin n -> Nat)
    (hxstar : feasible xstar)
    (hoptimal : ∀ y, feasible y ->
      fixedChargeCost setup marginal xstar ≤ fixedChargeCost setup marginal y)
    (hcompact : IsCompact cell) (hxcell : activityEmbed xstar ∈ cell)
    (hlinear : ∀ y, feasible y -> linear (activityEmbed y) = marginalCost marginal y)
    (hreconstruct : ∀ z ∈ cell.extremePoints Real,
      ∃ y, feasible y ∧ activityEmbed y = z ∧
        activitySupport y = activitySupport xstar) :
    ∃ y, feasible y ∧
      fixedChargeCost setup marginal y = fixedChargeCost setup marginal xstar ∧
      activityEmbed y ∈ cell.extremePoints Real ∧
      activitySupport y = activitySupport xstar := by
  let offset := supportOffset setup (activitySupport xstar)
  have hxvalue : fixedChargeCost setup marginal xstar =
      offset + linear (activityEmbed xstar) := by
    rw [fixedChargeCost_affine_on_support, hlinear xstar hxstar]
  have hrec : ∀ z ∈ cell.extremePoints Real,
      ∃ y, feasible y ∧ activityEmbed y = z ∧
        fixedChargeCost setup marginal y = offset + linear z := by
    intro z hz
    obtain ⟨y, hyfeasible, hyembed, hysupport⟩ := hreconstruct z hz
    refine ⟨y, hyfeasible, hyembed, ?_⟩
    rw [fixedChargeCost_affine_on_support, hysupport]
    change offset + marginalCost marginal y = offset + linear z
    rw [← hlinear y hyfeasible, hyembed]
  obtain ⟨y, hyfeasible, hycost, hyextreme⟩ :=
    exists_extreme_discrete_optimizer feasible
      (fixedChargeCost setup marginal) activityEmbed cell linear offset xstar
      hoptimal hcompact hxcell hxvalue hrec
  -- Reconstruction at the selected embedded point has the required support;
  -- injectivity of the natural-to-real embedding identifies the vectors.
  obtain ⟨y', hy'feasible, hy'embed, hy'support⟩ :=
    hreconstruct (activityEmbed y) hyextreme
  have hyy' : y = y' := by
    funext j
    exact Nat.cast_injective (R := Real) (congrFun hy'embed.symm j)
  exact ⟨y, hyfeasible, hycost, hyextreme, hyy' ▸ hy'support⟩

end FixedCharge
