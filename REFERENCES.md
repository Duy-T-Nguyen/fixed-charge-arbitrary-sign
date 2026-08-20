# Reference audit — `paper/note.tex`

Ten entries, ten cited in the body, no orphans. Every DOI below was resolved against the
**Crossref API** on 2026-08-20 and the printed metadata matched, except where flagged.
Every claim the paper makes about a source is listed with the verbatim sentence that
supports it and where that sentence lives, so each row is checkable by hand.

**Read this first.** Six of these PDFs shipped with a text layer containing only the
INFORMS cover sheet — Florian–Klein was **10 bytes**. Claims about them had at one point
been "checked" by grepping a *title line*. They were OCR'd on 2026-08-20 into
`literature/papers/*.fulltext.txt`; the cover-only files are now `*.coverpage.txt`.
Full quotes: `literature/KEY_QUOTES.md`. OCR breaks lines mid-sentence — **grep with
`-A`/`-B`, never a single-line pattern.**

| key | DOI | Crossref | local full text |
|---|---|---|---|
| `apr15` | 10.1007/s10479-015-1816-6 | ✅ exact | ✅ `.txt` |
| `ak05` | 10.1287/opre.1050.0223 | ⚠️ see note | ✅ `.txt` |
| `fk71` | 10.1287/mnsc.18.1.12 | ✅ exact | ✅ **OCR** |
| `flr80` | 10.1287/mnsc.26.7.669 | ✅ exact | ✅ **OCR** |
| `kya14` | 10.1287/ijoc.2014.0597 | ✅ exact | ✅ `.txt` |
| `lcw01` | 10.1287/mnsc.47.10.1384 | ✅ from publisher's own citation block | ✅ `.txt` |
| `love73` | 10.1287/mnsc.20.3.313 | ✅ exact | ✅ **OCR** |
| `ou17` | 10.1016/j.ejor.2016.06.040 | ✅ exact | ✅ `.txt` |
| `seel21` | 10.1016/j.adapen.2021.100073 | ✅ exact | ❌ not held |
| `swoveland75` | 10.1287/mnsc.21.9.1007 | ✅ exact | ✅ **OCR** |
| `zangwill67` | 10.1287/mnsc.13.11.900 | ✅ exact | ✅ **OCR** |

⚠️ `ak05`: a bibliographic-title query returned **the wrong Atamturk** — Nurdan Atamturk,
*"Examining the Effectiveness of Lesson Study on EFL Instruction"*, DOI 10.15405/ejsbs.321.
The correct record was resolved by DOI lookup instead: Atamtürk, Alper; Küçükyavuz, Simge,
*Operations Research* 53(4) 711–730, 2005. **Author-name queries on Crossref are not
safe when the surname is common — resolve by DOI.**

---

## Claim-by-claim

### `fk71` — Florian & Klein 1971, *Management Science* 18(1) 12–20
**Paper says** (§1): assumes concavity. (§4): the fractional-period property.
**Source, p.13:** "we assume that the functions p_i and h_i are concave, hence so is F."
and "Since F is concave we know that it attains its minimum at an extreme point of this set."
**Source, p.14:** "A production sequence S̄_uv is *capacity constrained* if the production
level in at most one period d ... is positive but less than capacity, i.e. **0 < x_d < c_d**".
Production is **continuous** (their eq. 3: `0 ≤ x_i ≤ c_i`); regeneration points are
`I_i = 0` only, so this is the **one-sided** version. ✅ **verified from OCR**

### `love73` — Love 1973, *Management Science* 20(3) 313–318
**Paper says** (§1): assumes piecewise concavity; and that with `x^L = 1` his exception set
is exactly Corollary 2's conclusion.
**Source, abstract:** "for arbitrary bounds on production and inventory in each period
there is an optimal schedule such that if, for any two periods, production does not equal
zero **or its upper or lower bound**, then the inventory level in some intermediate period
equals zero or its upper or lower bound."
**Source, eq. (2) p.313:** `x_i^L ≤ x_i ≤ x_i^U` — the production bounds are already in his
model. He assumes `c_i(·)`, `h_i(·)` concave on `(−∞,0]` and on `[0,∞)`.
✅ **verified from OCR.** This is the closest prior art in the paper and §1 now says so.

### `swoveland75` — Swoveland 1975, *Management Science* 21(9) 1007–1013
**Paper says** (§1): assumes piecewise concavity; and that `ou17` inherits its hypothesis
through him. ⚠️ **The piecewise-concavity assumption is in the title and abstract; I have
not read his proof.** The inheritance claim rests on `ou17` attributing the property to him.

### `zangwill67` — Zangwill 1967, *Management Science* 13(11) 900–912
**Paper says** (§1, Prop. 4): canonical reference for results of this shape; his Theorem 6
covers a class of **discontinuous** piecewise concave functions; and **(1) with `s_j<0` is
proved to lie outside that class, the obstruction being exactly the sign of `s_j`.**
**Source p.902:** CPC = max of finitely many **continuous** concave functions.
**Source p.910:** "called **piecewise concave, or briefly PC** ... **A PC function can be
discontinuous** ... more general than simply the maximum of concave functions."
**Theorem 6, p.910:** "A PC function F( ) defined on a compact convex set X is minimized on
X at some point in its dominant set D."
✅ **verified from OCR**, and the question is now **settled by proof** (Proposition 4 in the
paper, Proposition 44 in `PROOFS.md`, F83): condition (2) of his PC definition forces the
shared terminal set away from the origin, a single concave piece is then active on
`(0,δ)`, and concavity through the origin forces `s ≥ 0`. Four positions were taken on this
in one session; only the fourth has an argument behind it.

### `kya14` — Koca, Yaman & Aktürk 2014, *INFORMS J. Computing* 26(4) 767–779
**Paper says** (§1): assume piecewise concavity + lower semicontinuity; their §3.4 already
anticipates the repair, solved in `O(n^6)`.
**Source line 693:** "we let pt (x) = ∞ if x ∈ (0, L) ∪ (C, ∞), so we assume that m = 2 ...
our DP algorithm can solve this special case of the problem in O(n^6) time"
**Source line 119:** "LS-PC is NP-hard unless the breakpoints are time-invariant and the
number of breakpoints is bounded above by a constant." ✅ **verified**

### `apr15` — Akbalik, Penz & Rapine 2015, *Ann. Oper. Res.* 229(1) 1–18
**Paper says** (§1, §5): `O(T^4)`, correct under the concavity it assumes; Property 1 is
Love's, stated as `0 < x_t < P`; its subplan state space cannot represent the optimum of the
§5 instance.
**Source line 291:** "a period t is fractional if its production is neither 0 nor at full
capacity (that is **0 < xt < P**)". **Line 300:** "Property 1 (Love 1973)".
**Line 544:** "to Property 1, we have exactly K = D̃u,v−1 /P periods in the subplan with a
production [at full capacity]". **Abstract:** `O(T^4)` general, `O(T^3)` only for
non-speculative costs. ✅ **verified**

### `ou17` — Ou 2017, *EJOR* 256(3) 777–784
**Paper says** (§1): no sign restriction in the model statement, but the structural
property is attributed to Swoveland. ⚠️ **Partly verified:** `ou_2017.txt` contains **zero**
occurrences of "semicontinu", which is why Remark 5's earlier claim that his framework
assumes the lsc hull was removed. The Swoveland attribution appears at line 217. **I have
not read his structural argument in full.**

### `ak05` — Atamtürk & Küçükyavuz 2005, *Operations Research* 53(4) 711–730
**Paper says** (§1): the same model has a polyhedral literature which does not use the
structural property.
⚠️ **An earlier draft claimed they "likewise assume non-negative fixed costs". That was
unsupported and has been removed.** Their four stated assumptions concern capacities and
demands only — `u_t > 0`, `u_{t−1} ≥ d_t`, `u_{t−1} ≤ d_t + u_t`, `d_t ≥ 0` — **none
restricts the sign of a cost.** The claim was invented while fixing an uncited-reference
defect. See FINDINGS F82.

### `lcw01` — Lee, Çetinkaya & Wagelmans 2001, *Management Science* 47(10) 1384–1395
**Paper says** (Remark 5, §8): writes `x_t ≤ M y_t` after *defining* `y_t` as the two-sided
indicator, so the definition is two-sided and the implemented constraint is one-sided.
**Source, notation block:** "• y_t = 1 if x_t > 0, and 0 otherwise."
**Source, objective (1):** "Min Σ_t [ p_t x_t + K_t y_t + h_t I_t^+ + b_t I_t^- ]"
**Source, constraint:** "x_t ≤ M y_t", with "x_t ≥ 0, I_t^+ ≥ 0, I_t^- ≥ 0, y_t ∈ {0,1}".
✅ **verified from the local full text.** Correct in their setting (non-negative K_t); cited
as the pattern that gets carried across, not as an error.
⚠️ **Crossref returned the WRONG paper** for a title query — Hwang & Jaruphongsa 2006,
*Operations Research Letters* 34(3) 251–256. The metadata above is taken from the
publisher's own citation block inside the PDF. **Second title/author mismatch this session;
resolve by DOI or by the PDF's own citation block.**

### `flr80` — Florian, Lenstra & Rinnooy Kan 1980, *Management Science* 26(7) 669–679
**Paper says** (§1): the concave case with arbitrary capacities is NP-hard.
**Source:** "We also establish NP-hardness for the problem, even for the special case in
which all demands are equal, all storage costs are zero, and the production cost functions
can be interpreted as being either concave with arbitrary capacity limits or convex with
additional unit set-up costs." ✅ **verified from OCR.** An earlier draft said the
complexity landscape was "settled" here; softened.

### `seel21` — Seel, Millstein, Mills, Bolinger & Wiser 2021, *Advances in Applied Energy* 4, 100073
**Paper says** (§1): wholesale electricity clears below zero, increasingly so as variable
renewable capacity grows.
⚠️ **Metadata verified via Crossref; the full text is not held locally and I have not read
it.** The claim is qualitative and matches the title and the paper's stated subject. An
earlier draft attached a specific figure ("3.4% of hourly nodal observations in 2019")
that I had **not** verified — removed. An earlier draft also carried a **fabricated**
reference here (`F. Sewalt, C. de Jong, Commodities Now`) which does not exist as far as I
can establish; it was replaced by this one. See FINDINGS F76.

---

## What is still weak, stated plainly

1. `swoveland75` and `ou17` — I have read their **statements**, not their **proofs**. The
   §1 sentence about inheritance is an inference from Ou's attribution, not from checking
   Swoveland's argument.
2. `seel21` — cited for a motivating empirical claim from metadata alone.
3. `zangwill67` — **settled**, but by my own proof rather than by a source. A referee will
   re-derive Proposition 4; the definitions it relies on are quoted verbatim in
   `literature/KEY_QUOTES.md` so that check is cheap.
