import itertools
p=[1.0,-5.0,-5.0,-5.0]; w=[2,0,0,0]; C=2; T=4
def cost(x): return sum(p[t]*1 + p[t]*x[t] for t in range(T) if x[t]>0)   # s_t=p_t, c_t=p_t
def feas(x, slack):
    served=0
    for t in range(T):
        served+=x[t]
        if sum(w[:t+1])<served: return False            # cannot serve what has not arrived
        if slack is not None:                            # deadline: arrivals of period a due by a+slack
            due=sum(w[:max(0,t-slack+1)])
            if served<due: return False
        if x[t]>C: return False
    return served==sum(w)
for slack,label in [(None,"NO deadline  (what the PAPER's Remark 5 describes)"),(1,"slack=1      (what FINDINGS.md F71 actually ran)")]:
    best=None;arg=None
    for x in itertools.product(range(C+1),repeat=T):
        if not feas(x,slack): continue
        v=cost(x)
        if best is None or v<best-1e-9: best=v;arg=x
    # unguarded: y free of x, y_t=1 allowed with x_t=0
    ub=None;uarg=None
    for x in itertools.product(range(C+1),repeat=T):
        if not feas(x,slack): continue
        for y in itertools.product(range(2),repeat=T):
            if any(x[t]>C*y[t] for t in range(T)): continue   # only x<=Cy, NO y<=x guard
            v=sum(p[t]*y[t] for t in range(T))+sum(p[t]*x[t] for t in range(T))
            if ub is None or v<ub-1e-9: ub=v;uarg=(x,y)
    print(f"{label}")
    print(f"   guarded  optimum = {best:8.4f}  at x={arg}")
    print(f"   unguarded optimum= {ub:8.4f}  at x={uarg[0]}, y={uarg[1]}")
    print(f"   gap = {abs(ub-best)/abs(best)*100:.1f}%\n")
