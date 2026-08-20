"""Converse of Proposition 4: for s >= 0 the fixed charge IS piecewise concave (Zangwill 1967).

Construction.  F_k(x) = min( (k+K0) x ,  s + c x ),  K0 = s/u + |c| + 1.
  * min of two affine functions  -> continuous and CONCAVE, so each F_k is CPC
    with a SINGLE piece; its family has one member, so no two basic sets meet
    and the terminal set is EMPTY for every k.
  * F_k(0) = min(0, s) = 0 = phi(0)          (uses s >= 0)
  * for x > 0 and k large, (k+K0)x > s+cx, so F_k(x) = s+cx = phi(x)
  * E[X] u T = {0,u}: F_k(0)=0 and F_k(u)=s+cu for every k>=1 by choice of K0.
Hence conditions (1) and (2) of the PC definition both hold.
"""
import random
random.seed(11)

def Fk(x,k,s,c,u):
    K0 = s/u + abs(c) + 1.0
    return min((k+K0)*x, s+c*x)
def phi(x,s,c):
    return 0.0 if x==0 else s+c*x

print("(1) each F_k is concave  [min of two affine]")
bad=0
for _ in range(200000):
    s=random.uniform(0,10); c=random.uniform(-5,5); u=random.uniform(0.5,10)
    k=random.randint(1,50); x1=random.uniform(0,u); x2=random.uniform(0,u); lam=random.random()
    lhs=Fk(lam*x1+(1-lam)*x2,k,s,c,u); rhs=lam*Fk(x1,k,s,c,u)+(1-lam)*Fk(x2,k,s,c,u)
    if lhs < rhs-1e-9: bad+=1
print(f"    concavity violations: {bad}/200000")

print("\n(2) F_k(0) = 0 = phi(0)   and   F_k(u) = s+cu = F_1(u)  for every k")
bad0=badu=0
for _ in range(200000):
    s=random.uniform(0,10); c=random.uniform(-5,5); u=random.uniform(0.5,10); k=random.randint(1,500)
    if abs(Fk(0,k,s,c,u)-0.0)>1e-12: bad0+=1
    if abs(Fk(u,k,s,c,u)-(s+c*u))>1e-9: badu+=1
print(f"    F_k(0)!=0 : {bad0}/200000     F_k(u)!=s+cu : {badu}/200000")

print("\n(3) pointwise convergence F_k -> phi")
worst=0.0
for _ in range(20000):
    s=random.uniform(0,10); c=random.uniform(-5,5); u=random.uniform(0.5,10)
    x=random.choice([0.0, random.uniform(1e-6,u)])
    err=abs(Fk(x,10**7,s,c,u)-phi(x,s,c)); worst=max(worst,err)
print(f"    worst |F_k(x)-phi(x)| at k=1e7: {worst:.3e}")

print("\n(4) NEGATIVE CONTROL: the same construction must FAIL for s < 0")
print("    F_k(0) = min(0, s) = s != 0 = phi(0) whenever s < 0")
for s in (-3.0,-1.0,-0.1,0.0,0.1,3.0):
    v=Fk(0,5,s,-1.0,4.0)
    print(f"      s={s:+.1f}: F_k(0)={v:+.4f}  phi(0)=0.0000  -> {'FAILS (as it must)' if abs(v)>1e-12 else 'ok'}")
