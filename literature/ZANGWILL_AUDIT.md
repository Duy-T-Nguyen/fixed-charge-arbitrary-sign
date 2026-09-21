# Zangwill (1967) source audit

Primary source: W. I. Zangwill, *The Piecewise Concave Function*, Management
Science 13(11), 900--912 (1967). Local files:
`literature/papers/zangwill_1967.pdf` and
`literature/papers/zangwill_1967.fulltext.txt`.

## Definitions checked against the source

- Page 902, full-text lines 130--146: a CPC function is the maximum of a finite
  family of continuous concave functions defined on the common domain. A basic
  set is where one member attains that maximum. The terminal set is the union of
  pairwise intersections of distinct basic sets.
- Page 910, full-text lines 498--506: a PC function on a compact convex set is a
  pointwise limit of CPC functions whose terminal set is common to the whole
  sequence and whose values agree on `E[X]` union that terminal set.
- Page 910, Theorem 6, full-text lines 509--518: a PC function attains a minimum
  in its dominant set.

These clauses match the definitions reproduced in Proposition `prop:zangwill`
of `paper/note.tex`.

## Necessity audit

Assume a defining sequence exists for the charge-if-positive function on
`X=[0,u]` and suppose `s<0`.

1. **SOURCE:** the sequence agrees on `E[X] union T`; **DERIVED:** pointwise
   convergence therefore gives `F_1=phi` on that set.
2. **DERIVED:** `0 in E[X]`, so `F_1(0)=0`.
3. **SOURCE:** every CPC member is continuous. Continuity of `F_1` at zero and
   the nonzero right limit `s` exclude the common terminal set from some
   interval `(0,delta)`.
4. The finitely many basic sets, restricted to `(0,delta)`, are closed relative
   to that interval, pairwise disjoint and cover it. A finite disjoint closed
   cover of a connected space has exactly one nonempty member. Thus one
   continuous concave piece represents each `F_k` throughout the interval.
5. Continuity anchors that piece at zero. Concavity gives
   `g_k(lambda*x) >= lambda*g_k(x)`. Pointwise convergence gives
   `s+c*lambda*x >= lambda*(s+c*x)`, hence `s(1-lambda)>=0`, a contradiction.

No invalid step was found. The connectedness step should be stated as a finite
disjoint relatively closed cover, rather than only saying that the interval is
connected.

## Sufficiency audit

For `s>=0`, set `K0=s/u+|c|+1` and

```text
F_k(x) = min{(k+K0)x, s+cx}.
```

Each `F_k` is continuous and concave, hence CPC using itself as the single
concave member; its terminal set is empty. All members agree at the two extreme
points `0,u`, and converge pointwise to `phi`. This is a defining sequence under
the page-910 definition.

## Adversarial control

The tempting construction for `s<0` uses a moving tie point approaching zero.
It fails the source definition because the terminal set changes with `k`. This
is a useful negative control: dropping the common-terminal-set clause would
invalidate the necessity argument.

## Verdict

The proposition survives the primary-source audit:

```text
phi is PC in Zangwill's sense on [0,u] if and only if s >= 0.
```

An independent Gemini 3.7 Flash audit reached the same conclusion. Its output
was treated as a lead; all decisive definitions and lines above were checked
against the local full text.

