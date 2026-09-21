import FixedCharge.Core.TieBreak

namespace FixedCharge.Tests

private def three : Finset Nat := Finset.range 3

private theorem three_nonempty : three.Nonempty := by
  exact ⟨0, by simp [three]⟩

/-- Positive sanity test: a unique optimizer makes both selectors agree. -/
example :
    smallestArgmin three (fun x => (x : Int)) three_nonempty = 0 ∧
    largestArgmin three (fun x => (x : Int)) three_nonempty = 0 := by
  native_decide

/-- Negative sanity test: with three tied optimizers, the selectors disagree. -/
example :
    smallestArgmin three (fun _ => (0 : Int)) three_nonempty = 0 ∧
    largestArgmin three (fun _ => (0 : Int)) three_nonempty = 2 := by
  native_decide

/-- The deliberately false claim that all tie-breaking rules coincide is
refuted by an exact finite witness. -/
theorem sham_all_selectors_agree_is_false :
    ¬(smallestArgmin three (fun _ => (0 : Int)) three_nonempty =
      largestArgmin three (fun _ => (0 : Int)) three_nonempty) := by
  native_decide

end FixedCharge.Tests
