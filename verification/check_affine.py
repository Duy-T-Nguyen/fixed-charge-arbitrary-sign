"""Phi is affine on P(S); negative control: NOT affine when the support varies."""
import itertools, random
random.seed(5)
def cell_pts(T,C,D,H):
    return [(x,list(itertools.accumulate(x))) for x in itertools.product(range(C+1),repeat=T)
            if all(D[t]<=sum(x[:t+1])<=D[t]+H for t in range(T))]
worst=0.0; pairs=0; nonaff=0; ninst=0
for _ in range(220):
    T=random.choice([3,4]); C=random.choice([4,5,6]); H=random.randint(1,C)
    d=[random.randint(0,C//2) for _ in range(T)]; D=list(itertools.accumulate(d))
    s=[random.uniform(-3,3) for _ in range(T)]; c=[random.uniform(-3,3) for _ in range(T)]
    pts=cell_pts(T,C,D,H)
    if len(pts)<2: continue
    ninst+=1
    Phi=lambda x: sum(s[t]+c[t]*x[t] for t in range(T) if x[t]>0)
    same=[(x,y) for (x,_),(y,_) in itertools.combinations(pts,2)
          if [j for j in range(T) if x[j]>0]==[j for j in range(T) if y[j]>0]]
    for x,y in same[:6]:
        lam=random.random(); z=[lam*x[t]+(1-lam)*y[t] for t in range(T)]
        lhs=sum(s[t]+c[t]*z[t] for t in range(T) if z[t]>0)
        worst=max(worst,abs(lhs-(lam*Phi(x)+(1-lam)*Phi(y)))); pairs+=1
    diff=[(x,y) for (x,_),(y,_) in itertools.combinations(pts,2)
          if [j for j in range(T) if x[j]>0]!=[j for j in range(T) if y[j]>0]]
    hit=False
    for x,y in diff[:25]:
        lam=random.random(); z=[lam*x[t]+(1-lam)*y[t] for t in range(T)]
        lhs=sum(s[t]+c[t]*z[t] for t in range(T) if z[t]>0)
        if abs(lhs-(lam*Phi(x)+(1-lam)*Phi(y)))>1e-9: hit=True; break
    nonaff+=hit
print(f"same-support pairs: {pairs}   worst affinity error: {worst:.2e}")
print(f"negative control - instances where varying the support breaks affinity: {nonaff}/{ninst}")
