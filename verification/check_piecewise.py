"""Beyond the fixed-charge class: per-period costs piecewise linear with two interior
breakpoints. Conditioning on the PIECE, is some optimum a vertex of its cell?"""
import itertools, random, numpy as np
def run(sign, bounded, n=200, seed=0):
    random.seed(seed); viol=0; bites=0; done=0
    lo,hi=(0,3) if sign=="nonneg" else (-3,3)
    while done<n:
        T=random.choice([4,5]); C=random.choice([6,7,8])
        B1=random.randint(1,C-2); B2=random.randint(B1+1,C-1); B=[0,B1,B2,C]
        H=random.randint(1,C) if bounded else 10**6
        d=[random.randint(0,C//2) for _ in range(T)]; D=list(itertools.accumulate(d))
        s=[[random.uniform(lo,hi) for _ in range(3)] for _ in range(T)]
        c=[[random.uniform(lo,hi) for _ in range(3)] for _ in range(T)]
        def piece(v):
            return 0 if v<=B1 else (1 if v<=B2 else 2)
        def cost(x):
            tot=0.0
            for t in range(T):
                if x[t]>0: k=piece(x[t]); tot+=s[t][k]+c[t][k]*x[t]
            return tot
        feas=[(x,list(itertools.accumulate(x))) for x in itertools.product(range(C+1),repeat=T)
              if all(D[t]<=sum(x[:t+1])<=D[t]+H for t in range(T))]
        if len(feas)<2: continue
        done+=1
        vals=[cost(x) for x,_ in feas]; best=min(vals)
        A=np.tril(np.ones((T,T),int))
        def charac(x,S):
            # Conditioning is on the support AND the piece: for a used coordinate the
            # first piece is [1,B1], not [0,B1], because the switch at the origin is
            # frozen by the support.  A coordinate at its piece bound is not interior.
            # With coefficients drawn independently per piece the cost JUMPS at each
            # breakpoint, so the pieces are half-open exactly as (0,u] is.  Integrality
            # closes them: piece k of a used coordinate is [B_k + 1, B_{k+1}], and
            # [1, B_1] for k = 0.
            def lo_of(v):
                k=piece(v); return 1 if k==0 else B[k]+1
            Q=[t for t in range(T) if x[t]>0 and lo_of(x[t])<x[t]<B[piece(x[t])+1]]
            tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
            if not Q: return True
            if not tight: return False
            return np.linalg.matrix_rank(A[np.ix_(tight,Q)])==len(Q)
        if not any(charac(x,S) for (x,S),v in zip(feas,vals) if v<=best+1e-9): viol+=1
        if any(not charac(x,S) for x,S in feas): bites+=1
    return viol,bites,done
for lab,(sg,bd,sd) in {"non-negative coefficients, bounded storage":("nonneg",True,1),
                       "ARBITRARY SIGN,          bounded storage":("any",True,2),
                       "ARBITRARY SIGN,          no storage bound":("any",False,3)}.items():
    v,b,n=run(sg,bd,200,sd); print(f"{lab}: {v}/{n} violations   (check bites on {b}/{n})")
