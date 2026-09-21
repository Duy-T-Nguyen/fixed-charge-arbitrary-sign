import FixedCharge.Model.Feasibility
import FixedCharge.Model.Cost
import Mathlib.Data.Fin.VecNotation

namespace FixedCharge.Tests

private def arrivals11 : Fin 2 -> Nat := ![1, 1]
private def arrivals01 : Fin 2 -> Nat := ![0, 1]
private def arrivals10 : Fin 2 -> Nat := ![1, 0]

private def serve11 : Schedule 2 1 := ![1, 1]
private def serve10 : Schedule 2 1 := ![1, 0]
private def serve01 : Schedule 2 1 := ![0, 1]

/-- Positive control: immediate service is feasible at zero slack. -/
example : Feasible arrivals11 0 serve11 := by
  native_decide

/-- The zero-slack feasible set is exactly the immediate-service schedule. -/
example : feasibleSet 2 1 arrivals11 0 = {serve11} := by
  native_decide

/-- Negative causality control: front-loading serves work before arrival even
though total service is conserved. -/
example : Conserves arrivals01 serve10 ∧ ¬Causal arrivals01 serve10 := by
  native_decide

/-- Negative deadline control: delayed service is causal and conserving, but
misses a zero-slack deadline. -/
example :
    Causal arrivals10 serve01 ∧ Conserves arrivals10 serve01 ∧
      ¬MeetsDeadline arrivals10 0 serve01 := by
  native_decide

/-- Signed exact-cost control: opening the negative-price period costs -3. -/
example :
    scheduleCost (![(-2 : Rat), 3]) (![(-1 : Rat), 1]) serve10 = -3 := by
  native_decide

end FixedCharge.Tests
