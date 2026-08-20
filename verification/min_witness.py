import itertools
from fractions import Fraction as F
best=None
# search small COUPLED instances: s_t = p_t, c_t = p_t (sigma=gamma=1), p_t integral
for T in (3,):
 for C in (3,4):
  for H in range(0,C+1):
   for d in itertools.product(range(0,3),repeat=T):
    D=list(itertools.accumulate(d))
    for p in itertools.product((-2,-1,1,2),repeat=T):
     s=list(p); c=list(p)
     bv=None; opts=[]
     for x in itertools.product(range(C+1),repeat=T):
      S=list(itertools.accumulate(x))
      if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
      v=sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)
      if bv is None or v<bv: bv=v; opts=[(x,S)]
      elif v==bv: opts.append((x,S))
     if not opts: continue
     ok=False
     for x,S in opts:
      tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
      fr=[t for t in range(T) if 0<x[t]<C]
      if all(any(t in tight for t in range(i,k)) for i in fr for k in fr if i<k): ok=True
     if not ok:
      score=(T,C,len(opts),sum(abs(v) for v in p))
      if best is None or score<best[0]: best=(score,T,C,H,d,D,p,bv,opts)
if best:
 _,T,C,H,d,D,p,bv,opts=best
 print(f"MINIMAL COUPLED WITNESS  T={T} C={C} storage bound H={H}")
 print(f"  demand per period d={d}   cumulative D={D}")
 print(f"  prices p={p}   (s_t=c_t=p_t, i.e. sigma=gamma=1)")
 print(f"  optimal value {bv};  number of optima: {len(opts)}")
 for x,S in opts:
  tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
  print(f"    x={x}  prefix={S}  tight rows={tight}")
  print(f"      periods with 0<x<C : {[t for t in range(T) if 0<x[t]<C]}   -> classical property FAILS")
  print(f"      periods with 1<x<C : {[t for t in range(T) if 1<x[t]<C]}   -> Corollary 2 holds")
