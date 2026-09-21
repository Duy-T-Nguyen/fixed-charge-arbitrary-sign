import FixedCharge.Core.Charge
import FixedCharge.Core.FiniteOpt
import FixedCharge.Core.TieBreak
import FixedCharge.Model.Schedule
import FixedCharge.Model.Feasibility
import FixedCharge.Model.Cost
import FixedCharge.Paper1.Witnesses
import FixedCharge.Geometry.ExtremeOptimizer
import FixedCharge.Geometry.DiscreteTransfer
import FixedCharge.Paper1.Main
import FixedCharge.Geometry.SupportCell
import FixedCharge.Geometry.LinearAmbient
import FixedCharge.Geometry.ExtremeDirection
import FixedCharge.Geometry.FiniteSlack
import FixedCharge.Geometry.ActiveColumns
import FixedCharge.Geometry.UnimodularBasis
import FixedCharge.Geometry.RowMinor
import FixedCharge.Geometry.TUCompletion
import FixedCharge.Geometry.TUCellIntegral
import FixedCharge.Geometry.IntegralBounds
import FixedCharge.Paper1.Theorem

/-!
Public import surface for the reusable fixed-charge formalization.

Modules are added here only after they pass the no-hole gate.
-/
