import itertools, numpy as np
A=np.array([[1,1,0],[0,1,1],[1,0,1]]); b=np.array([6,7,6]); u=np.array([5,5,5])
s=np.array([1.32,2.51,0.55]); c=np.array([-2.02,-2.06,-1.19])
best=None; opts=[]
for x in itertools.product(range(0,6),repeat=3):
    x=np.array(x)
    if np.any(A@x>b): continue
    val=sum(s[j]+c[j]*x[j] for j in range(3) if x[j]>0)
    if best is None or val<best-1e-9: best=val; opts=[tuple(x)]
    elif abs(val-best)<1e-9: opts.append(tuple(x))
print("det(A) =",round(np.linalg.det(A),6),"-> TU?",abs(np.linalg.det(A))<=1+1e-9)
print("optimal value =",round(best,6))
print("all optima   =",opts, " UNIQUE?" , len(opts)==1)
xh=np.array(opts[0]); print("x_hat =",tuple(xh))
tight=[i for i in range(3) if A[i]@xh==b[i]]
print("tight A-rows:",tight,"  bounds tight:",[j for j in range(3) if xh[j] in (1,u[j])])
M=A[tight] if tight else np.zeros((0,3))
print("rank of tight system =",np.linalg.matrix_rank(M) if len(tight) else 0,"  need 3 for a vertex")
