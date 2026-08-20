import itertools, random
random.seed(11)
def run(coupled, n=3000):
    fail=0; tot=0
    for _ in range(n):
        T=random.choice([3,4,5]); C=random.choice([3,4,5,6]); H=random.randint(0,C)
        d=[random.randint(0,C//2) for _ in range(T)]; D=list(itertools.accumulate(d))
        if coupled:  # s_t = p_t*sigma, c_t = p_t*gamma, sigma,gamma>0  -> SAME sign
            p=[random.uniform(-3,3) for _ in range(T)]
            sg=random.uniform(.2,3); gm=random.uniform(.2,3)
            s=[pt*sg for pt in p]; c=[pt*gm for pt in p]
        else:        # independent signs (what the paper's Theorem allows)
            s=[random.uniform(-3,3) for _ in range(T)]; c=[random.uniform(-3,3) for _ in range(T)]
        best=None; opts=[]
        for x in itertools.product(range(C+1),repeat=T):
            S=list(itertools.accumulate(x))
            if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
            v=sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)
            if best is None or v<best-1e-9: best=v; opts=[(x,S)]
            elif abs(v-best)<1e-9: opts.append((x,S))
        if not opts: continue
        tot+=1
        ok=False
        for x,S in opts:
            tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
            fr=[t for t in range(T) if 0<x[t]<C]
            if all(any(t in tight for t in range(i,k)) for i in fr for k in fr if i<k): ok=True
        if not ok: fail+=1
    return fail,tot
for lab,cp in [("COUPLED  s,c both = p_t x (positive coeff)  [the paper's stated application]",True),
               ("INDEPENDENT signs                          [what Theorem 1 allows]",False)]:
    f,t=run(cp)
    print(f"{lab}\n   instances={t}  FK/Love property fails on EVERY optimum: {f}  ({100*f/t:.2f}%)\n")
