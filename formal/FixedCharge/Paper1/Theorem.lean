import FixedCharge.Geometry.TUCellIntegral
import Mathlib.Data.Fintype.Lattice
import Mathlib.Data.Fintype.Pi

namespace FixedCharge

open Set

/-- Feasibility plus finite integral upper bounds guarantees existence of an
optimal integer activity vector. -/
theorem exists_fixedCharge_optimum
    {n : Nat} (ambient : Set (Fin n -> Real)) (upper : Fin n -> Nat)
    (setup marginal : Fin n -> Real)
    (hne : ∃ x, integerFeasible ambient upper x) :
    ∃ xstar, integerFeasible ambient upper xstar ∧
      ∀ y, integerFeasible ambient upper y ->
        fixedChargeCost setup marginal xstar ≤ fixedChargeCost setup marginal y := by
  let B := {x : Fin n -> Nat // ∀ j, x j ≤ upper j}
  let encode : B -> (∀ j, Fin (upper j + 1)) := fun x j =>
    ⟨x.1 j, Nat.lt_succ_of_le (x.2 j)⟩
  have hencode : Function.Injective encode := by
    intro x y hxy
    apply Subtype.ext
    funext j
    exact congrArg Fin.val (congrFun hxy j)
  let F := {x : Fin n -> Nat // integerFeasible ambient upper x}
  let toBounded : F -> B := fun x => ⟨x.1, x.2.2⟩
  have htoBounded : Function.Injective toBounded := by
    intro x y hxy
    apply Subtype.ext
    exact congrArg (fun z : B => z.1) hxy
  letI : Finite B := Finite.of_injective encode hencode
  letI : Finite F := Finite.of_injective toBounded htoBounded
  haveI : Nonempty F := by
    obtain ⟨x, hx⟩ := hne
    exact ⟨⟨x, hx⟩⟩
  obtain ⟨xstar, hxoptimal⟩ :=
    Finite.exists_min (fun x : F => fixedChargeCost setup marginal x.1)
  exact ⟨xstar.1, xstar.2, fun y hy => hxoptimal ⟨y, hy⟩⟩

/-- Formal version of Paper 1's main vertex theorem, conditional on an optimal
integer point. Existence of such a point follows separately from feasibility
and the finite integer box. The common constraints are represented by
`ambient`; their matrix syntax is irrelevant to the support-cell argument. -/
theorem support_cell_vertex_theorem
    {n : Nat} (ambient : Set (Fin n -> Real)) (upper : Fin n -> Nat)
    (setup marginal : Fin n -> Real)
    (linear : StrongDual Real (Fin n -> Real))
    (hlinear : ∀ y, integerFeasible ambient upper y ->
      linear (activityEmbed y) = marginalCost marginal y)
    (hcompact : ∀ S, (supportCell ambient upper S).Nonempty ->
      IsCompact (supportCell ambient upper S))
    (hintegral : ∀ S, CellIntegral (supportCell ambient upper S))
    (xstar : Fin n -> Nat) (hxstar : integerFeasible ambient upper xstar)
    (hoptimal : ∀ y, integerFeasible ambient upper y ->
      fixedChargeCost setup marginal xstar ≤ fixedChargeCost setup marginal y) :
    ∃ y, integerFeasible ambient upper y ∧
      fixedChargeCost setup marginal y = fixedChargeCost setup marginal xstar ∧
      activityEmbed y ∈
        (supportCell ambient upper (activitySupport y)).extremePoints Real := by
  let S := activitySupport xstar
  have hxcell : activityEmbed xstar ∈ supportCell ambient upper S :=
    embed_mem_own_supportCell hxstar
  have hcellcompact : IsCompact (supportCell ambient upper S) :=
    hcompact S ⟨activityEmbed xstar, hxcell⟩
  have hrec : ∀ z ∈ (supportCell ambient upper S).extremePoints Real,
      ∃ y, integerFeasible ambient upper y ∧ activityEmbed y = z ∧
        activitySupport y = activitySupport xstar := by
    intro z hz
    exact integral_extreme_reconstruct (hintegral S) hz
  obtain ⟨y, hyfeasible, hycost, hyextreme, hysupport⟩ :=
    fixedCharge_vertex_theorem setup marginal (integerFeasible ambient upper)
      (supportCell ambient upper S) linear xstar hxstar hoptimal hcellcompact
      hxcell hlinear hrec
  refine ⟨y, hyfeasible, hycost, ?_⟩
  simpa [S, hysupport] using hyextreme

/-- Full existence form matching the manuscript: a nonempty bounded integer
problem whose nonempty support cells are compact and integral has an optimal
solution that is an extreme point of its own support cell. -/
theorem exists_optimal_extreme_support_cell
    {n : Nat} (ambient : Set (Fin n -> Real)) (upper : Fin n -> Nat)
    (setup marginal : Fin n -> Real)
    (linear : StrongDual Real (Fin n -> Real))
    (hlinear : ∀ y, integerFeasible ambient upper y ->
      linear (activityEmbed y) = marginalCost marginal y)
    (hcompact : ∀ S, (supportCell ambient upper S).Nonempty ->
      IsCompact (supportCell ambient upper S))
    (hintegral : ∀ S, CellIntegral (supportCell ambient upper S))
    (hne : ∃ x, integerFeasible ambient upper x) :
    ∃ y, integerFeasible ambient upper y ∧
      (∀ q, integerFeasible ambient upper q ->
        fixedChargeCost setup marginal y ≤ fixedChargeCost setup marginal q) ∧
      activityEmbed y ∈
        (supportCell ambient upper (activitySupport y)).extremePoints Real := by
  obtain ⟨xstar, hxstar, hxoptimal⟩ :=
    exists_fixedCharge_optimum ambient upper setup marginal hne
  obtain ⟨y, hyfeasible, hycost, hyextreme⟩ :=
    support_cell_vertex_theorem ambient upper setup marginal linear hlinear
      hcompact hintegral xstar hxstar hxoptimal
  refine ⟨y, hyfeasible, ?_, hyextreme⟩
  intro q hq
  rw [hycost]
  exact hxoptimal q hq

/-- Manuscript-facing form: the marginal continuous linear functional is
constructed from the supplied marginal rates rather than assumed as data. -/
theorem exists_optimal_extreme_support_cell_for_fixed_charges
    {n : Nat} (ambient : Set (Fin n -> Real)) (upper : Fin n -> Nat)
    (setup marginal : Fin n -> Real)
    (hcompact : ∀ S, (supportCell ambient upper S).Nonempty ->
      IsCompact (supportCell ambient upper S))
    (hintegral : ∀ S, CellIntegral (supportCell ambient upper S))
    (hne : ∃ x, integerFeasible ambient upper x) :
    ∃ y, integerFeasible ambient upper y ∧
      (∀ q, integerFeasible ambient upper q ->
        fixedChargeCost setup marginal y ≤ fixedChargeCost setup marginal q) ∧
      activityEmbed y ∈
        (supportCell ambient upper (activitySupport y)).extremePoints Real := by
  exact exists_optimal_extreme_support_cell ambient upper setup marginal
    (marginalLinear marginal) (fun y _ => marginalLinear_correct marginal y)
    hcompact hintegral hne

/-- Matrix-facing form of the manuscript theorem. Compactness is discharged
from the finite linear system and the integral coordinate bounds. -/
theorem exists_optimal_extreme_support_cell_for_linear_system
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Real) (b : Fin mLe -> Real)
    (E : Matrix (Fin mEq) (Fin n) Real) (d : Fin mEq -> Real)
    (upper : Fin n -> Nat) (setup marginal : Fin n -> Real)
    (hintegral : ∀ S,
      CellIntegral (supportCell (linearAmbient A b E d) upper S))
    (hne : ∃ x, integerFeasible (linearAmbient A b E d) upper x) :
    ∃ y, integerFeasible (linearAmbient A b E d) upper y ∧
      (∀ q, integerFeasible (linearAmbient A b E d) upper q ->
        fixedChargeCost setup marginal y ≤ fixedChargeCost setup marginal q) ∧
      activityEmbed y ∈
        (supportCell (linearAmbient A b E d) upper
          (activitySupport y)).extremePoints Real := by
  apply exists_optimal_extreme_support_cell_for_fixed_charges
    (linearAmbient A b E d) upper setup marginal
  · intro S _
    exact isCompact_supportCell_linearAmbient A b E d upper S
  · exact hintegral
  · exact hne

/-- Fully discharged TU specialization of Paper 1's main theorem. Unlike the
preceding matrix-facing theorem, this statement does not assume support-cell
integrality: it derives it from an integer TU constraint matrix and integral
right-hand sides. -/
theorem exists_optimal_extreme_support_cell_of_tu
    {n mLe mEq : Nat}
    (A : Matrix (Fin mLe) (Fin n) Int) (b : Fin mLe → Int)
    (E : Matrix (Fin mEq) (Fin n) Int) (d : Fin mEq → Int)
    (upper : Fin n → Nat) (setup marginal : Fin n → Real)
    (hTU : (integerConstraintMatrix A E).IsTotallyUnimodular)
    (hne : ∃ x, integerFeasible
      (linearAmbient (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
        (E.map (Int.castRingHom Real)) (fun i => (d i : Real))) upper x) :
    ∃ y, integerFeasible
        (linearAmbient (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
          (E.map (Int.castRingHom Real)) (fun i => (d i : Real))) upper y ∧
      (∀ q, integerFeasible
          (linearAmbient (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
            (E.map (Int.castRingHom Real)) (fun i => (d i : Real))) upper q →
        fixedChargeCost setup marginal y ≤ fixedChargeCost setup marginal q) ∧
      activityEmbed y ∈
        (supportCell
          (linearAmbient (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
            (E.map (Int.castRingHom Real)) (fun i => (d i : Real))) upper
          (activitySupport y)).extremePoints Real := by
  apply exists_optimal_extreme_support_cell_for_linear_system
    (A.map (Int.castRingHom Real)) (fun i => (b i : Real))
    (E.map (Int.castRingHom Real)) (fun i => (d i : Real))
    upper setup marginal
  · exact supportCell_integral_of_tu A b E d upper hTU
  · exact hne

end FixedCharge
