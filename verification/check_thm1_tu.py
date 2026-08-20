"""Theorem 1 on verified-TU matrices: interval matrices with mixed <=/>=/= rows."""
import itertools, numpy as np
rng=np.random.default_rng(2026)
def is_tu(A,maxk=3):
    m,n=A.shape
    for k in range(1,min(m,n,maxk)+1):
        for R in itertools.combinations(range(m),k):
            for Cc in itertools.combinations(range(n),k):
                if abs(round(np.linalg.det(A[np.ix_(R,Cc)])))>1: return False
    return True
ok=viol=0
while ok<1085:
    n=int(rng.integers(3,6)); m=int(rng.integers(2,5))
    A=np.zeros((m,n),int)
    for i in range(m):                      # interval (consecutive-ones) rows -> TU
        a=int(rng.integers(0,n)); b=int(rng.integers(a,n)); A[i,a:b+1]=1
    if not is_tu(A): continue
    u=rng.integers(1,4,n); sense=rng.integers(0,3,m); b=rng.integers(0,int(u.sum())+1,m)
    s=rng.uniform(-3,3,n); c=rng.uniform(-3,3,n)
    feas=[]
    for x in itertools.product(*[range(v+1) for v in u]):
        x=np.array(x); Ax=A@x
        if all((Ax[i]<=b[i]) if sense[i]==0 else (Ax[i]>=b[i]) if sense[i]==1 else (Ax[i]==b[i]) for i in range(m)):
            feas.append(x)
    if not feas: continue
    ok+=1
    vals=[sum(s[j]+c[j]*x[j] for j in range(n) if x[j]>0) for x in feas]
    best=min(vals)
    # does SOME optimum satisfy the vertex condition of Cor 2?
    good=False
    for x,v in zip(feas,vals):
        if v>best+1e-9: continue
        S=[j for j in range(n) if x[j]>0]; Q=[j for j in S if 1<x[j]<u[j]]
        tight=[i for i in range(m) if (A[i]@x==b[i])]
        M=A[np.ix_(tight,Q)] if tight and Q else np.zeros((len(tight),len(Q)))
        if not Q or np.linalg.matrix_rank(M)==len(Q): good=True; break
    if not good: viol+=1
print(f"verified-TU instances: {ok}   violations of Theorem 1 / Corollary 2: {viol}")
