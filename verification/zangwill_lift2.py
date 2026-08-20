"""General necessity: the SWITCHING-ON CHARGE plays the role of s.

At a vertex z0 of X and a feasible direction d, the set that switches on is
    S(z0,d) = { j : z0_j = 0 and d_j > 0 },      J = sum_{j in S} s_j.
Along the ray, Phi(z0+td) -> Phi(z0) + J as t -> 0+, while Phi(z0) itself is pinned
(z0 in E[X]).  Repeating Prop 4's argument on the ray: T avoids a neighbourhood of z0,
one concave piece g^k is active there with g^k(z0)=Phi(z0), concavity gives
   Phi(z0+lam t d) >= lam Phi(z0+t d) + (1-lam) Phi(z0),
and letting t->0 yields  J >= lam J,  i.e.  J(1-lam) >= 0,  i.e.  J >= 0.
So J < 0 for ANY vertex and feasible direction  =>  Phi is not PC.
The 1-D case is z0=0, d=+1, S={j}, J=s_j.
"""
import itertools, numpy as np

def verts(A,b,n,tol=1e-9):
    V=[]
    for idx in itertools.combinations(range(len(A)),n):
        M=A[list(idx)]
        if abs(np.linalg.det(M))<tol: continue
        x=np.linalg.solve(M,b[list(idx)])
        if np.all(A@x<=b+1e-7): V.append(np.round(x,9))
    out=[]
    for v in V:
        if not any(np.allclose(v,w,atol=1e-7) for w in out): out.append(v)
    return out

def phi(v,s,c): return 0.0 if abs(v)<1e-12 else s+c*v
def Phi(x,s,c): return sum(phi(x[j],s[j],c[j]) for j in range(len(x)))

def check(name,A,b,n,s,c):
    A=np.array(A,float); b=np.array(b,float); V=verts(A,b,n)
    print(f"\n{name}: {len(V)} vertices")
    best=None
    for z in V:
        for w in V:                                  # directions toward other vertices
            if np.allclose(z,w,atol=1e-7): continue
            d=w-z
            S=[j for j in range(n) if abs(z[j])<1e-9 and d[j]>1e-9]
            if not S: continue
            J=sum(s[j] for j in S)
            # numerical confirmation that Phi(z+td) -> Phi(z)+J
            t=1e-9; lim=Phi(z+t*d,s,c); pred=Phi(z,s,c)+J
            ok=abs(lim-pred)<1e-6
            if J<-1e-9 and (best is None or J<best[0]): best=(J,tuple(np.round(z,3)),tuple(np.round(d,3)),S,ok)
    if best:
        J,z,d,S,ok=best
        print(f"   vertex {z}  direction {d}")
        print(f"   switches on {S}, J = {J:+.2f} < 0   limit matches Phi(z)+J: {ok}")
        print(f"   => Phi is NOT piecewise concave")
        return True
    print("   no vertex/direction with J < 0 found")
    return False

# lot-sizing witness: T=3, C=3, zero demand, H=2, s=c=(-1,-1,+1)
A=[[-1,0,0],[0,-1,0],[0,0,-1],[1,0,0],[0,1,0],[0,0,1],[1,0,0],[1,1,0],[1,1,1]]
b=[0,0,0, 3,3,3, 2,2,2]
r1=check("lot-sizing witness",A,b,3,[-1,-1,1],[-1,-1,1])

# transportation witness AS IN THE PAPER: supplies/demands (2,2), u=2, s=c=-1
A=[[-1,0,0,0],[0,-1,0,0],[0,0,-1,0],[0,0,0,-1],
   [1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],
   [1,1,0,0],[-1,-1,0,0],[0,0,1,1],[0,0,-1,-1],
   [1,0,1,0],[-1,0,-1,0],[0,1,0,1],[0,-1,0,-1]]
b=[0,0,0,0, 2,2,2,2, 2,-2,2,-2, 2,-2,2,-2]
r2=check("transportation witness  <-- the case §8 called OPEN",A,b,4,[-1]*4,[-1]*4)

# NEGATIVE CONTROL: all charges non-negative -> no vertex/direction may give J<0
r3=check("NEGATIVE CONTROL: same transportation, s=c=+1",A,b,4,[1]*4,[1]*4)

print(f"\nlot-sizing: not PC = {r1}   transportation: not PC = {r2}   control found J<0 = {r3} (must be False)")
