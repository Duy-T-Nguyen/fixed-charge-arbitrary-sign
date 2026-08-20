import itertools, numpy as np
print("="*70); print("L1  APR15 Transfer failure — is the 564.5% real or a near-zero artefact?")
print("="*70)
def solve(T,C,H,d,s,c):
    D=list(itertools.accumulate(d)); out=[]
    for x in itertools.product(range(C+1),repeat=T):
        S=list(itertools.accumulate(x))
        if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
        out.append((x,S,sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)))
    return D,out
def love_prop1(x,S,D,H,C,T):
    # blocks end where inventory sits at a bound; at most one period per block with 0<x<C
    tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
    frac=[t for t in range(T) if 0<x[t]<C]
    return all(any(t in tight for t in range(i,k)) for i in frac for k in frac if i<k)
for label,(T,C,H,d,s,c) in {
 "agent case A (T=4,C=5)":(4,5,4,[0,0,0,4],[-1.]*4,[-1.]*4),
 "agent case B (T=5,C=4)":(5,4,2,[1,0,0,0,2],[2.21,2.74,-2.86,-2.81,1.98],[1.13,0.12,0.48,1.54,1.85]),
}.items():
    D,out=solve(T,C,H,d,s,c)
    true=min(v for _,_,v in out)
    rep=[v for x,S,v in out if love_prop1(x,S,D,H,C,T)]
    best_rep=min(rep) if rep else float('nan')
    print(f"{label}: TRUE={true:.4f}  best APR15 can represent={best_rep:.4f}")
    print(f"   absolute loss = {best_rep-true:.4f}   relative = {abs(best_rep-true)/abs(true)*100:.1f}%  <- denominator |{true:.2f}|")
print("\n"+"="*70); print("L2  does conditioning on the PIECE preserve TU / integrality?")
print("="*70)
# piecewise-linear per-coordinate cost, breakpoints 0 < b < u, integral.
# cell = {A x <=> b} plus rows  beta_k <= x_j <= beta_{k+1}  -> identity rows, integral rhs
T,C,H,b1=4,8,5,3
d=[0,2,0,3]; D=list(itertools.accumulate(d))
A=np.tril(np.ones((T,T)))           # prefix-sum interval matrix, TU
worst=0; frac_found=0; checked=0
rng=np.random.default_rng(0)
for _ in range(300):
    piece=rng.integers(0,2,T)        # which piece each coordinate sits in
    lo=[0 if p==0 else b1 for p in piece]; hi=[b1 if p==0 else C for p in piece]
    # vertices of {D_t <= (Ax)_t <= D_t+H, lo<=x<=hi} : enumerate integer pts, check any fractional vertex
    pts=[x for x in itertools.product(*[range(lo[j],hi[j]+1) for j in range(T)])
         if all(D[t]<=sum(x[:t+1])<=D[t]+H for t in range(T))]
    if not pts: continue
    checked+=1
    cobj=rng.uniform(-3,3,T)
    from scipy.optimize import linprog
    r=linprog(cobj,A_ub=np.vstack([A,-A]),b_ub=np.concatenate([[D[t]+H for t in range(T)],[-D[t] for t in range(T)]]),
              bounds=list(zip(lo,hi)),method="highs")
    if r.status==0 and any(abs(v-round(v))>1e-7 for v in r.x): frac_found+=1
print(f"piece-conditioned cells checked: {checked}   with a FRACTIONAL LP optimum: {frac_found}")
print("=> TU/integrality", "BROKEN" if frac_found else "PRESERVED (identity rows, integral breakpoints)")
