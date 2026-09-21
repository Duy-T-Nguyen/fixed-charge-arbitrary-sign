# Akbalik--Penz--Rapine (2015) state-space audit

Primary source: A. Akbalik, B. Penz and C. Rapine, *Capacitated lot sizing
problems with inventory bounds*, Annals of Operations Research 229 (2015),
1--18. Local PDF and text are in `literature/papers/`.

## Model gate

The source model imposes `s_0=s_T=0` (text lines 219--245). This invalidates the
manuscript's old `-12/-10` witness: that computation allowed terminal inventory
equal to the storage upper bound and therefore overproduced eight units against
total demand four. It is not an instance of the APR model.

## State-space mapping

- Lines 255--289: period `u` is an inventory period when entering stock is zero
  or its upper bound.
- Lines 290--296: a fractional period has `0<x_t<P`; a subplan is the interval
  between consecutive inventory periods and contains at most one fractional
  period.
- Lines 297--306: under the concavity assumptions, Property 1 states that an
  optimum decomposable into such subplans exists.
- Lines 336--365: the shortest-path algorithm combines subplans; inside each
  subplan its cumulative-production states are generated from quantities zero,
  full capacity, and at most one fractional amount.

Thus the published graph searches the Property-1 schedule class. Outside the
source assumptions, a schedule with two or more fractional production periods
between consecutive inventory periods is absent from that graph.

## Corrected witness in the source model

Use `T=4`, stationary capacity `P=5`, inventory bound `H_t=4`, demand
`d=(0,0,0,4)`, `s_0=s_4=0`, and charge-if-positive production costs

```text
phi_t(0)=0,  phi_t(x)=-1-x for x>0.
```

Flow conservation fixes total production at four. Hence every feasible plan has

```text
Phi(x) = -4 - |supp(x)|.
```

The support has at most four periods, and `(1,1,1,1)` is feasible, so it is the
unique optimum and has value `-8`.

Because demand is zero before the final period, inventory cannot return to zero
after positive production. Reaching the upper bound four also consumes all total
production and prevents any later positive production. Therefore a decomposable
Property-1 plan can contain at most one positive production period. Its production
quantity must be four, giving value `-5`. Such plans exist, so the restricted
optimum is exactly `-5`.

The actual APR graph therefore omits the unique optimum on this out-of-assumption
instance; the absolute gap is three cost units.

## Verdict

The old numerical claim `-12/-10` is withdrawn. The algorithmic state-space
claim survives with the corrected source-compatible certificate `-8/-5`.

An independent Gemini 3.7 Flash audit found the terminal-inventory mismatch. The
source equations and the corrected certificate above were then checked locally.

