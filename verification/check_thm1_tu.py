"""Random theorem checks with exact all-minor TU certification; stdlib only."""
import itertools
import random
from fractions import Fraction

rng = random.Random(2026)

def det(matrix):
    """Exact determinant by fraction-preserving elimination."""
    n = len(matrix)
    a = [[Fraction(v) for v in row] for row in matrix]
    out = Fraction(1)
    for col in range(n):
        pivot = next((r for r in range(col, n) if a[r][col]), None)
        if pivot is None:
            return 0
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            out = -out
        p = a[col][col]
        out *= p
        for j in range(col, n):
            a[col][j] /= p
        for r in range(col + 1, n):
            q = a[r][col]
            for j in range(col, n):
                a[r][j] -= q * a[col][j]
    return out

def rank(matrix):
    if not matrix:
        return 0
    a = [[Fraction(v) for v in row] for row in matrix]
    rows, cols, r = len(a), len(a[0]), 0
    for col in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][col]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        p = a[r][col]
        a[r] = [v / p for v in a[r]]
        for i in range(rows):
            if i != r:
                q = a[i][col]
                a[i] = [v - q * w for v, w in zip(a[i], a[r])]
        r += 1
        if r == rows:
            break
    return r

def is_tu(a):
    m, n = len(a), len(a[0])
    for k in range(1, min(m, n) + 1):
        for rr in itertools.combinations(range(m), k):
            for cc in itertools.combinations(range(n), k):
                minor = [[a[i][j] for j in cc] for i in rr]
                if det(minor) not in (-1, 0, 1):
                    return False
    return True

checked = violations = rejected_non_tu = 0
while checked < 1085:
    n, m = rng.randint(3, 5), rng.randint(2, 4)
    a = [[0] * n for _ in range(m)]
    for i in range(m):
        left = rng.randrange(n)
        right = rng.randrange(left, n)
        for j in range(left, right + 1):
            a[i][j] = 1
    if not is_tu(a):
        rejected_non_tu += 1
        continue
    u = [rng.randint(1, 3) for _ in range(n)]
    sense = [rng.randrange(3) for _ in range(m)]
    rhs = [rng.randint(0, sum(u)) for _ in range(m)]
    s = [rng.randint(-300, 300) for _ in range(n)]
    c = [rng.randint(-300, 300) for _ in range(n)]
    feasible = []
    for x in itertools.product(*[range(v + 1) for v in u]):
        ax = [sum(a[i][j] * x[j] for j in range(n)) for i in range(m)]
        if all(ax[i] <= rhs[i] if sense[i] == 0 else
               ax[i] >= rhs[i] if sense[i] == 1 else ax[i] == rhs[i]
               for i in range(m)):
            feasible.append(x)
    if not feasible:
        continue
    checked += 1
    values = [sum(s[j] + c[j] * x[j] for j in range(n) if x[j] > 0)
              for x in feasible]
    best = min(values)
    good = False
    for x, value in zip(feasible, values):
        if value != best:
            continue
        qcols = [j for j in range(n) if 1 < x[j] < u[j]]
        tight = [i for i in range(m)
                 if sum(a[i][j] * x[j] for j in range(n)) == rhs[i]]
        active = [[a[i][j] for j in qcols] for i in tight]
        if not qcols or rank(active) == len(qcols):
            good = True
            break
    if not good:
        violations += 1

assert violations == 0
print("STATUS: FINAL")
print(f"all-minor TU-certified feasible instances: {checked}")
print(f"rejected non-TU matrices: {rejected_non_tu}")
print(f"theorem/rank-corollary violations: {violations}")
