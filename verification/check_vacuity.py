import itertools, random
random.seed(2026)
def solve(T,C,D,H,s,c):
    best=None; opts=[]
    for x in itertools.product(range(C+1),repeat=T):
        S=list(itertools.accumulate(x))
        if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
        v=sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)
        if best is None or v<best-1e-9: best=v; opts=[x]
        elif abs(v-best)<1e-9: opts.append(x)
    return opts
for label, sgn in [("all charges NON-NEGATIVE (the classical regime)", lambda: random.uniform(0,3)),
                   ("charges of ARBITRARY SIGN (the paper's regime)  ", lambda: random.uniform(-3,3))]:
    nQ=[]; vac=0; n=0; nQmax=[]
    for _ in range(400):
        T=random.choice([4,5,6]); C=random.choice([4,5,6,7,8]); H=random.randint(1,C)
        d=[random.randint(0,C//2) for _ in range(T)]
        D=list(itertools.accumulate(d))
        s=[sgn() for _ in range(T)]; c=[sgn() for _ in range(T)]
        opts=solve(T,C,D,H,s,c)
        if not opts: continue
        n+=1
        # theorem guarantees SOME optimum is a vertex; measure |Q| over optima
        qs=[sum(1 for t in range(T) if 1<x[t]<C) for x in opts]
        nQ.append(min(qs)); nQmax.append(max(qs))
        if max(qs)==0: vac+=1          # EVERY optimum has Q empty -> Corollary 2 says nothing
    import statistics
    print(f"{label}   instances={n}")
    print(f"   mean |Q| over the best-case optimum : {statistics.mean(nQ):.3f}")
    print(f"   instances where EVERY optimum has Q = empty (Corollary 2 VACUOUS): {vac}/{n} = {100*vac/n:.1f}%")
    print(f"   instances with some optimum having |Q|>=2 (bound could bite)      : {sum(1 for q in nQmax if q>=2)}/{n} = {100*sum(1 for q in nQmax if q>=2)/n:.1f}%\n")
