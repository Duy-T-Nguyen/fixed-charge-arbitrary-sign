"""Exact certificate for Proposition 3; Python standard library only."""
from fractions import Fraction as F
from itertools import product

A = ((1, 1, 0), (0, 1, 1), (1, 0, 1))
b = (6, 7, 6)
u = (5, 5, 5)
s = (F(132, 100), F(251, 100), F(55, 100))
c = (F(-202, 100), F(-206, 100), F(-119, 100))

def dot(a, x):
    return sum(ai * xi for ai, xi in zip(a, x))

feasible = [x for x in product(range(6), repeat=3)
            if all(dot(row, x) <= rhs for row, rhs in zip(A, b))]
values = {x: sum(s[j] + c[j] * x[j] for j in range(3) if x[j] > 0)
          for x in feasible}
best = min(values.values())
optima = [x for x, value in values.items() if value == best]
runner_up = min(value for value in values.values() if value > best)

xhat = optima[0]
d = (1, -1, 1)
half = F(1, 2)
minus = tuple(F(x) - half * dj for x, dj in zip(xhat, d))
plus = tuple(F(x) + half * dj for x, dj in zip(xhat, d))
segment_ok = all(
    all(dot(row, point) <= rhs for row, rhs in zip(A, b))
    and all(1 <= point[j] <= u[j] for j in range(3))
    for point in (minus, plus)
)

assert len(feasible) == 113
assert optima == [(2, 4, 3)]
assert best == F(-1147, 100)
assert runner_up == F(-1143, 100)
assert segment_ok
assert all((minus[j] + plus[j]) / 2 == xhat[j] for j in range(3))

print("STATUS: FINAL")
print(f"feasible integer points: {len(feasible)}")
print(f"unique optimum: {optima[0]}; value={best}")
print(f"runner-up value: {runner_up}")
print(f"segment endpoints: {minus}, {plus}; feasible={segment_ok}")
