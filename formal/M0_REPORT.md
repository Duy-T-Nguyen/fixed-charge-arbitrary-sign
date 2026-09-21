# M0 reproducibility report

Date: 2026-08-24. Status: **PASS**.

## Locked environment

- Lean: `v4.29.0`, commit `98dc76e3c0a9b856c9b98726b713fb04fab16740`.
- Lake: `5.0.0-src+98dc76e`.
- Mathlib input tag: `v4.29.0`.
- Mathlib resolved commit: `8a178386ffc0f5fef0b77738bb5449d50efeea95`.
- Exact transitive revisions: `lake-manifest.json`.
- CPU cap: `LEAN_NUM_THREADS=4`.

## What changed

The former standalone `List`/`Int` proof is now a compatibility import. The
maintained theorem uses unordered `Finset` support and is generic over a
commutative ring. This single algebraic result therefore specializes to `Rat`
for exact finite games and `Real` for Paper 1 geometry.

## Checks and raw decisive output

Initial cached build:

```text
Built FixedCharge.Core.Charge
Built FixedCharge
Build completed successfully (680 jobs).
```

After dependencies were cached, a root-package clean build took 14.823 s
(`USER=2.751`, `SYS=4.569`), and the complete `make check` gate took 17.978 s
(`USER=2.904`, `SYS=5.614`). Both used `LEAN_NUM_THREADS=4`.

Full workspace clean-from-source build (run once to expose stale-artifact
failures):

```text
Built FixedCharge.Core.Charge
Built FixedCharge
Build completed successfully (687 jobs).
```

No-hole gate:

```text
proof-hole gate passed
```

Kernel-assumption report:

```text
charge_eq_zero: [propext]
charge_eq_affine_of_ne_zero: [propext]
mem_support_iff: [propext, Quot.sound]
support_objective_affine: [propext, Quot.sound]
support_charge_affine: [propext, Quot.sound]
charge_sum_over_support_affine: [propext, Quot.sound]
```

These are standard Lean kernel axioms. No project-defined axiom is present.
The compatibility command `lake env lean FixedChargeCore.lean` exits with code
0 and no output.

## Failures caught during M0

1. Lake 5 rejected the obsolete `lake build -j 4` syntax. The project now caps
   Lean runtime concurrency through `LEAN_NUM_THREADS=4`.
2. The first minimal import exposed that `Ring` was not in scope. The exact
   algebra import was added; the project does not hide this with `import Mathlib`.
3. The compatibility file placed its module comment before `import`; the
   independent compatibility command caught and fixed it.
4. Bare `lake clean` deletes dependency build outputs too. The maintained
   target is scoped to `lake clean fixed-charge` so normal release checks retain
   the pinned Mathlib cache.

## Claim boundary

M0 checks only the fixed-support affine identity and build reproducibility. It
does **not** machine-check the existence of an extreme minimizer, support-cell
integrality, the active-column corollary, or the full Paper 1 theorem. Those
remain M3--M5 in `LEAN_ROADMAP.md`.

STATUS: FINAL
