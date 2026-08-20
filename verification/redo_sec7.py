import itertools, random
random.seed(7)
viol_rank=viol_arr=0; n=0; bites=0
for _ in range(399):
    T=random.choice([4,5,6]); C=random.choice([4,5,6,7,8]); H=random.randint(1,C)
    d=[random.randint(0,C//2) for _ in range(T)]; D=list(itertools.accumulate(d))
    s=[random.uniform(-3,3) for _ in range(T)]; c=[random.uniform(-3,3) for _ in range(T)]
    best=None; opts=[]
    for x in itertools.product(range(C+1),repeat=T):
        S=list(itertools.accumulate(x))
        if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
        v=sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)
        if best is None or v<best-1e-9: best=v; opts=[(x,S)]
        elif abs(v-best)<1e-9: opts.append((x,S))
    if not opts: continue
    n+=1
    ok_rank=ok_arr=False
    for x,S in opts:
        tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
        Q=[t for t in range(T) if 1<x[t]<C]
        if len(Q)<=len(tight): ok_rank=True            # |Q| <= rank A_t  (rank <= #tight rows)
        # arrangement: an inventory point separates any two interior periods
        if all(any(t in tight for t in range(i,k)) for i in Q for k in Q if i<k): ok_arr=True
    if not ok_rank: viol_rank+=1
    if not ok_arr:  viol_arr+=1
    if any(len([t for t in range(T) if 1<x[t]<C])>=2 for x,_ in opts): bites+=1
print(f"independent re-run, {n} lot-sizing instances, T in 4..6, C in 4..8, charges in [-3,3]")
print(f"  violations of the rank bound      : {viol_rank}/{n}")
print(f"  violations of the arrangement     : {viol_arr}/{n}")
print(f"  instances where the bound could bite (some optimum with |Q|>=2): {bites}/{n}")
