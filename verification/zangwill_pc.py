"""The load-bearing step: a concave g on [0,u] with g(0)=0 satisfies g(lam*x) >= lam*g(x).
If g_k -> phi pointwise on (0,delta) with phi(x)=s+cx, that forces s>=0.
So s<0 makes it impossible for phi to be a single concave piece near the origin."""
import random
random.seed(3)
print("(1) superadditivity along the ray, for concave g with g(0)=0  [positive control]")
bad=0
for _ in range(200000):
    # random concave g on [0,u]: min of affine functions is concave
    u=random.uniform(1,10); n=random.randint(2,5)
    A=[(random.uniform(-5,5),random.uniform(-3,3)) for _ in range(n)]
    g=lambda t: min(a*t+b for a,b in A)
    shift=g(0.0)
    G=lambda t: g(t)-shift          # now G(0)=0, still concave
    x=random.uniform(0,u); lam=random.random()
    if G(lam*x) < lam*G(x)-1e-9: bad+=1
print(f"    violations of g(lam x) >= lam g(x): {bad}/200000")

print("\n(2) the forced conclusion  s(1-lam) >= 0  under the limit")
print("    s + c*lam*x >= lam*(s + c*x)  <=>  s*(1-lam) >= 0  <=>  s >= 0")
for s in (-2.0,-0.5,0.0,0.5,2.0):
    c=1.3; x=0.7; lam=0.4
    lhs=s+c*lam*x; rhs=lam*(s+c*x)
    print(f"    s={s:+.1f}: lhs={lhs:+.4f}  rhs={rhs:+.4f}  holds={lhs>=rhs-1e-12}   -> {'CONTRADICTION' if s<0 else 'no obstruction'}")

print("\n(3) negative control: the moving tie point, for the natural defining sequence")
print("    F_k(x) = max(-k x, s + c x),  s=-2, c=1.3   tie at x_k = -s/(k+c)")
s,c=-2.0,1.3
for k in (1,10,100,1000,10000):
    print(f"      k={k:>6}: tie x_k = {-s/(k+c):.6f}   (must be a point of the terminal set)")
print("    the terminal sets are therefore all different -> Zangwill condition (2) fails")
