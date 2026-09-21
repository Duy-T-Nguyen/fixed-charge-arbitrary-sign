import FixedCharge.Core.FiniteOpt
import FixedCharge.Model.Cost
import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.Fintype.Prod

namespace FixedCharge.Paper1

namespace LotSizing

def prices : Fin 3 -> Rat := ![-1, -1, 1]
def candidate : Schedule 3 3 := ![1, 1, 0]

def feasible (x : Schedule 3 3) : Prop :=
  servedPrefix x 1 ≤ 2 ∧ servedPrefix x 2 ≤ 2 ∧ servedPrefix x 3 ≤ 2

instance (x : Schedule 3 3) : Decidable (feasible x) := by
  unfold feasible
  infer_instance

def feasibleSet : Finset (Schedule 3 3) := Finset.univ.filter feasible
def cost (x : Schedule 3 3) : Rat := scheduleCost prices prices x

theorem unique_optimum : argminSet feasibleSet cost = {candidate} := by
  native_decide

theorem optimum_value : cost candidate = -4 := by
  native_decide

theorem candidate_prefixes :
    servedPrefix candidate 1 = 1 ∧ servedPrefix candidate 2 = 2 ∧
      servedPrefix candidate 3 = 2 := by
  native_decide

end LotSizing

namespace Transportation

/-- Arc order: `(11,12,21,22)`. -/
def candidate : Schedule 4 2 := ![1, 1, 1, 1]

def feasible (x : Schedule 4 2) : Prop :=
  service x 0 + service x 1 = 2 ∧
  service x 2 + service x 3 = 2 ∧
  service x 0 + service x 2 = 2 ∧
  service x 1 + service x 3 = 2

instance (x : Schedule 4 2) : Decidable (feasible x) := by
  unfold feasible
  infer_instance

def feasibleSet : Finset (Schedule 4 2) := Finset.univ.filter feasible
def minusOne : Fin 4 -> Rat := ![-1, -1, -1, -1]
def cost (x : Schedule 4 2) : Rat := scheduleCost minusOne minusOne x

theorem unique_optimum : argminSet feasibleSet cost = {candidate} := by
  native_decide

theorem optimum_value : cost candidate = -8 := by
  native_decide

theorem positive_support_has_four_arcs :
    (support (fun t => (service candidate t : Rat))).card = 4 := by
  native_decide

end Transportation

namespace APR

def candidate : Schedule 4 5 := ![1, 1, 1, 1]
def concentrated : Schedule 4 5 := ![4, 0, 0, 0]

def feasible (x : Schedule 4 5) : Prop := totalServed x = 4

instance (x : Schedule 4 5) : Decidable (feasible x) := by
  unfold feasible
  infer_instance

def feasibleSet : Finset (Schedule 4 5) := Finset.univ.filter feasible
def minusOne : Fin 4 -> Rat := ![-1, -1, -1, -1]
def cost (x : Schedule 4 5) : Rat := scheduleCost minusOne minusOne x

/-- For this witness, APR's subplan structure implies at most one positive
production period; this is the resulting restricted finite state space. -/
def restricted (x : Schedule 4 5) : Prop :=
  feasible x ∧ (support (fun t => (service x t : Nat))).card ≤ 1

instance (x : Schedule 4 5) : Decidable (restricted x) := by
  unfold restricted
  infer_instance

def restrictedSet : Finset (Schedule 4 5) := Finset.univ.filter restricted

theorem feasible_count : feasibleSet.card = 35 := by
  native_decide

theorem unique_unrestricted_optimum : argminSet feasibleSet cost = {candidate} := by
  native_decide

theorem unrestricted_value : cost candidate = -8 := by
  native_decide

theorem restricted_lower_bound : ∀ x ∈ restrictedSet, (-5 : Rat) ≤ cost x := by
  native_decide

theorem restricted_bound_attained :
    concentrated ∈ restrictedSet ∧ cost concentrated = -5 := by
  native_decide

end APR

namespace Sharpness

def candidate : Schedule 3 5 := ![2, 4, 3]
def runnerUp : Schedule 3 5 := ![3, 3, 3]

def feasible (x : Schedule 3 5) : Prop :=
  service x 0 + service x 1 ≤ 6 ∧
  service x 1 + service x 2 ≤ 7 ∧
  service x 0 + service x 2 ≤ 6

instance (x : Schedule 3 5) : Decidable (feasible x) := by
  unfold feasible
  infer_instance

def feasibleSet : Finset (Schedule 3 5) := Finset.univ.filter feasible
def setup : Fin 3 -> Rat := ![132 / 100, 251 / 100, 55 / 100]
def marginal : Fin 3 -> Rat := ![-202 / 100, -206 / 100, -119 / 100]
def cost (x : Schedule 3 5) : Rat := scheduleCost setup marginal x

theorem feasible_count : feasibleSet.card = 113 := by
  native_decide

theorem unique_optimum : argminSet feasibleSet cost = {candidate} := by
  native_decide

theorem optimum_value : cost candidate = -1147 / 100 := by
  native_decide

theorem runner_up_value : cost runnerUp = -1143 / 100 := by
  native_decide

theorem runner_up_is_second :
    ∀ x ∈ feasibleSet, x ≠ candidate -> (-1143 / 100 : Rat) ≤ cost x := by
  native_decide

def cellFeasible (x : Fin 3 -> Rat) : Prop :=
  (∀ i, 1 ≤ x i ∧ x i ≤ 5) ∧
  x 0 + x 1 ≤ 6 ∧ x 1 + x 2 ≤ 7 ∧ x 0 + x 2 ≤ 6

instance (x : Fin 3 -> Rat) : Decidable (cellFeasible x) := by
  unfold cellFeasible
  infer_instance

def leftPoint : Fin 3 -> Rat := ![3 / 2, 9 / 2, 5 / 2]
def rightPoint : Fin 3 -> Rat := ![5 / 2, 7 / 2, 7 / 2]
def candidateRat : Fin 3 -> Rat := ![2, 4, 3]

theorem nontrivial_segment_certificate :
    cellFeasible leftPoint ∧ cellFeasible rightPoint ∧
    leftPoint ≠ rightPoint ∧
    (∀ i, candidateRat i = (leftPoint i + rightPoint i) / 2) := by
  native_decide

end Sharpness

namespace Modelling

def prices : Fin 4 -> Rat := ![1, -5, -5, -5]

def productionFeasible (x : Schedule 4 2) : Prop := totalServed x = 2

instance (x : Schedule 4 2) : Decidable (productionFeasible x) := by
  unfold productionFeasible
  infer_instance

def productionSet : Finset (Schedule 4 2) := Finset.univ.filter productionFeasible
def guardedCost (x : Schedule 4 2) : Rat := scheduleCost prices prices x

abbrev Activation := Fin 4 -> Fin 2
abbrev UnguardedPlan := Schedule 4 2 × Activation

def unguardedFeasible (z : UnguardedPlan) : Prop :=
  productionFeasible z.1 ∧ ∀ t, service z.1 t ≤ 2 * (z.2 t).val

instance (z : UnguardedPlan) : Decidable (unguardedFeasible z) := by
  unfold unguardedFeasible
  infer_instance

def unguardedSet : Finset UnguardedPlan := Finset.univ.filter unguardedFeasible

def unguardedCost (z : UnguardedPlan) : Rat :=
  ∑ t, (prices t * (z.2 t).val + prices t * service z.1 t)

theorem guarded_lower_bound : ∀ x ∈ productionSet, (-20 : Rat) ≤ guardedCost x := by
  native_decide

theorem guarded_attained :
    let x : Schedule 4 2 := ![0, 1, 1, 0]
    x ∈ productionSet ∧ guardedCost x = -20 := by
  native_decide

theorem unguarded_lower_bound : ∀ z ∈ unguardedSet, (-25 : Rat) ≤ unguardedCost z := by
  native_decide

theorem unguarded_attained :
    let x : Schedule 4 2 := ![0, 2, 0, 0]
    let y : Activation := ![0, 1, 1, 1]
    (x, y) ∈ unguardedSet ∧ unguardedCost (x, y) = -25 := by
  native_decide

end Modelling

namespace Perturbations

def lotPrices : Fin 3 -> Rat := ![0, -1, 1]
def transportSetup : Fin 4 -> Rat := ![0, -1, -1, -1]
def aprZeroSetup : Fin 4 -> Rat := ![0, 0, 0, 0]
def sharpSetup : Fin 3 -> Rat := ![133 / 100, 251 / 100, 55 / 100]

theorem lot_old_value_breaks :
    scheduleCost lotPrices lotPrices LotSizing.candidate ≠ -4 := by
  native_decide

theorem transport_old_value_breaks :
    scheduleCost transportSetup Transportation.minusOne
      Transportation.candidate ≠ -8 := by
  native_decide

theorem apr_unique_optimum_breaks_without_setup_reward :
    argminSet APR.feasibleSet
      (scheduleCost aprZeroSetup APR.minusOne) ≠ {APR.candidate} := by
  native_decide

theorem sharp_old_value_breaks :
    scheduleCost sharpSetup Sharpness.marginal Sharpness.candidate ≠
      -1147 / 100 := by
  native_decide

end Perturbations

end FixedCharge.Paper1
