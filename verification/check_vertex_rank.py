"""Vertex condition vs rank of the active constraint matrix, on every feasible plan."""
import itertools, random, numpy as np
random.seed(9)
tot=0; disagree=0; ninst=0
for _ in range(120):
    T=random.choice([3,4]); C=random.choice([3,4,5]); H=random.randint(1,C)
    d=[random.randint(0,C//2) for _ in range(T)]; D=list(itertools.accumulate(d))
    A=np.tril(np.ones((T,T),int)); ninst+=1
    for x in itertools.product(range(C+1),repeat=T):
        S=list(itertools.accumulate(x))
        if any(S[t]<D[t] or S[t]>D[t]+H for t in range(T)): continue
        tot+=1
        sup=[j for j in range(T) if x[j]>0]; Q=[j for j in sup if 1<x[j]<C]
        tight=[t for t in range(T) if S[t]==D[t] or S[t]==D[t]+H]
        # (a) Cor 2 condition: columns of tight rows indexed by Q independent
        if not Q: cond=True
        elif not tight: cond=False
        else: cond = np.linalg.matrix_rank(A[np.ix_(tight,Q)])==len(Q)
        # (b) vertex of the cell: full-rank active system (rows + active bounds)
        rows=[A[t] for t in tight]
        for j in range(T): 
            if j not in sup or x[j] in (1,C): rows.append(np.eye(T,dtype=int)[j])
        vert = np.linalg.matrix_rank(np.array(rows)) == T if rows else False
        if cond != vert: disagree+=1
print(f"instances {ninst}, feasible plans {tot}, disagreements between the vertex condition and the rank test: {disagree}")
