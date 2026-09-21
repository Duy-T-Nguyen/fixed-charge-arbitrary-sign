"""Exact certificate for the APR state-space witness in APR's s_0=s_T=0 model."""

from fractions import Fraction
from itertools import product


T, P, H = 4, 5, 4
demand = (0, 0, 0, 4)


def feasible(x):
    stock = 0
    stocks = []
    for t in range(T):
        stock += x[t] - demand[t]
        stocks.append(stock)
        if not 0 <= stock <= H:
            return None
    return tuple(stocks) if stock == 0 else None


def cost(x):
    return sum((Fraction(-1) - q) for q in x if q > 0)


def apr_property_one(x, stocks):
    # Period u is an inventory period when entering stock s_{u-1} is 0 or H.
    entering = (0,) + stocks[:-1]
    boundaries = [t for t, level in enumerate(entering) if level in (0, H)] + [T]
    # Keep consecutive distinct boundary positions; each [u,v) is a subplan.
    boundaries = sorted(set(boundaries))
    return all(
        sum(0 < x[t] < P for t in range(u, v)) <= 1
        for u, v in zip(boundaries, boundaries[1:])
    )


feasible_plans = []
for x in product(range(P + 1), repeat=T):
    stocks = feasible(x)
    if stocks is not None:
        feasible_plans.append((x, stocks, cost(x), apr_property_one(x, stocks)))

true_value = min(row[2] for row in feasible_plans)
true_optima = [row[0] for row in feasible_plans if row[2] == true_value]
restricted_value = min(row[2] for row in feasible_plans if row[3])
restricted_optima = [row[0] for row in feasible_plans if row[3] and row[2] == restricted_value]

print("STATUS: FINAL")
print(f"feasible plans: {len(feasible_plans)}")
print(f"unrestricted optimum: {true_value}; optima={true_optima}")
print(f"APR Property-1 optimum: {restricted_value}; optima={restricted_optima}")
print(f"absolute gap: {restricted_value - true_value}")

assert true_value == -8
assert true_optima == [(1, 1, 1, 1)]
assert restricted_value == -5
assert restricted_value - true_value == 3

