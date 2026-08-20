"""Does the iff lift from phi_j to Phi = sum_j phi_j on the polytope X?

RESTRICTION LEMMA.  Let Phi be PC on X with defining sequence {F_k}, common terminal
set T.  Let L = [z0,z1] be a segment with BOTH endpoints vertices of X.  Each F_k|L is
a max of the restricted continuous concave g_i, hence CPC on L; the restricted basic
sets are B_i ∩ L, so the restricted terminal set is T ∩ L -- the SAME for every k; and
E[L] = {z0,z1} ⊆ E[X], so F_k = F_1 there.  Hence Phi|L is PC on L.

COROLLARY.  If X has two vertices differing in exactly coordinate j, one of them with
x_j = 0, then Phi|L = phi_j + const, which is not PC when s_j < 0.  So Phi is not PC.

This script checks the geometric hypothesis on the paper's three witnesses.
"""
import itertools, numpy as np

def vertices(A,b,n,tol=1e-9):
    """vertices of {x : A x <= b} by enumerating n tight rows"""
    V=[]
    for idx in itertools.combinations(range(len(A)),n):
        M=A[list(idx)]; 
        if abs(np.linalg.det(M))<tol: continue
        x=np.linalg.solve(M,b[list(idx)])
        if np.all(A@x<=b+1e-7): V.append(np.round(x,9))
    out=[]
    for v in V:
        if not any(np.allclose(v,w,atol=1e-7) for w in out): out.append(v)
    return out

def check(name,A,b,n,neg):
    V=vertices(np.array(A,float),np.array(b,float),n)
    print(f"\n{name}: {len(V)} vertices")
    hits=[]
    for v,w in itertools.combinations(V,2):
        d=np.abs(v-w)>1e-7
        if d.sum()!=1: continue
        j=int(np.argmax(d))
        if j not in neg: continue
        z=v if abs(v[j])<1e-9 else (w if abs(w[j])<1e-9 else None)
        if z is None: continue
        hits.append((j,tuple(np.round(v,3)),tuple(np.round(w,3))))
    if hits:
        for j,v,w in hits[:3]:
            print(f"   HYPOTHESIS HOLDS  coord j={j} (s_j<0):  {v}  and  {w}")
        print(f"   ({len(hits)} such vertex pairs)  ->  Phi is NOT PC")
    else:
        print("   hypothesis FAILS: no two vertices differ in exactly one negative-charge coord with one at 0")
    return len(hits)

# 1. lot-sizing witness: T=3, C=3, zero demand, storage bound H=2, all s_t<0
A=[[-1,0,0],[0,-1,0],[0,0,-1],[1,0,0],[0,1,0],[0,0,1],[1,0,0],[1,1,0],[1,1,1]]
b=[0,0,0, 3,3,3, 2,2,2]
h1=check("lot-sizing witness (T=3, C=3, H=2)",A,b,3,{0,1,2})

# 2. transportation witness, AS IN THE PAPER: supplies and demands (2,2), u_ij = 2
#    arcs x11,x12,x21,x22 ; equalities written as two inequalities each
A=[[-1,0,0,0],[0,-1,0,0],[0,0,-1,0],[0,0,0,-1],
   [1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1],
   [1,1,0,0],[-1,-1,0,0],[0,0,1,1],[0,0,-1,-1],
   [1,0,1,0],[-1,0,-1,0],[0,1,0,1],[0,-1,0,-1]]
b=[0,0,0,0, 2,2,2,2, 2,-2,2,-2, 2,-2,2,-2]
h2=check("transportation witness (2x2, supplies/demands (2,2), u=2)",A,b,4,{0,1,2,3})

# 3. a plain box, the case the paper's Theorem 1 allows when A is vacuous
A=[[-1,0],[0,-1],[1,0],[0,1]]; b=[0,0,2,2]
h3=check("box [0,2]^2",A,b,2,{0,1})

print(f"\nSUMMARY: hypothesis holds on {sum(1 for h in (h1,h2,h3) if h)}/3 test polytopes")
