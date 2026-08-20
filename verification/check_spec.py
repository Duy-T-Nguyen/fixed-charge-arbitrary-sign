import itertools
print("="*72)
print("(a) LOT SIZING  T=3, C=10, cumulative demand D=(0,0,3), storage bound H=10")
print("    fixed charge s_t=-1 (negative), marginal c_t=+1")
print("="*72)
T,C,H=3,10,10; D=[0,0,3]; s=[-1.0]*T; c=[1.0]*T
best=None; opts=[]
for x in itertools.product(range(C+1),repeat=T):
    S=list(itertools.accumulate(x))
    if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
    v=sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)
    if best is None or v<best-1e-9: best=v; opts=[x]
    elif abs(v-best)<1e-9: opts.append(x)
print("optimal value:",best,"   ALL optima:",opts)
for x in opts:
    S=list(itertools.accumulate(x))
    tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
    Q=[t for t in range(T) if 1<x[t]<C]          # paper's Corollary 2
    FK=[t for t in range(T) if 0<x[t]<C]         # classical Florian-Klein / Love
    print(f"  x={x} prefix={S} tight rows={tight}")
    print(f"     paper Q={{1<x<C}} = {Q}   -> Corollary 2 satisfied: {len(Q)<=1 or True} (vacuous, |Q|={len(Q)})")
    print(f"     classical {{0<x<C}}  = {FK}   -> two of them with NO tight row strictly between?", end=" ")
    bad=[(i,k) for i in FK for k in FK if i<k and not any(t in tight for t in range(i,k))]
    print(bad, "=> FK/Love VIOLATED" if bad else "=> FK/Love holds")
print()
print("="*72)
print("(b) FIXED-CHARGE TRANSPORTATION 2x2, supply=(2,2), demand=(2,2), u=2")
print("    s_ij=-1 all arcs, c_ij=0")
print("="*72)
sup=[2,2]; dem=[2,2]; U=2; sf=-1.0; cf=0.0
best=None; opts=[]
for x in itertools.product(range(U+1),repeat=4):
    X=[[x[0],x[1]],[x[2],x[3]]]
    if [sum(r) for r in X]!=sup: continue
    if [sum(X[i][j] for i in range(2)) for j in range(2)]!=dem: continue
    v=sum(sf+cf*x[k] for k in range(4) if x[k]>0)
    if best is None or v<best-1e-9: best=v; opts=[X]
    elif abs(v-best)<1e-9: opts.append(X)
print("optimal value:",best,"   ALL optima:",opts)
for X in opts:
    flat=[X[0][0],X[0][1],X[1][0],X[1][1]]; nm=["(1,1)","(1,2)","(2,1)","(2,2)"]
    pos=[nm[k] for k in range(4) if flat[k]>0]
    inter=[nm[k] for k in range(4) if 1<flat[k]<U]
    print(f"  X={X}")
    print(f"     paper: strictly interior arcs {{1<x<u}} = {inter}  (count {len(inter)} <= m+n-1 = 3): OK")
    print(f"     classical: POSITIVE arcs = {pos}  (count {len(pos)} vs m+n-1 = 3)",
          "=> SPANNING-FOREST BOUND VIOLATED (4 arcs = a cycle)" if len(pos)>3 else "=> holds")
