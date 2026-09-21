import itertools
import numpy as np

def run_demonstration():
    print("=" * 80)
    print("DEMO: KHÔNG GIAN BÀI TOÁN, SỰ 'ĂN GIAN' CỦA SOLVER VÀ ĐỈNH CỦA Ô P(S)")
    print("=" * 80)
    
    # 1. Thông số bài toán (Remark 7 trong Paper)
    # 4 chu kỳ, tổng sản xuất = 2, công suất mỗi chu kỳ u = 2
    # Giá p = (1, -5, -5, -5) -> s_t = p_t, c_t = p_t
    T = 4
    u = 2
    total_demand = 2
    s = [1, -5, -5, -5]
    c = [1, -5, -5, -5]
    
    print(f"Cấu hình: T={T} chu kỳ, Công suất tối đa mỗi chu kỳ u={u}, Tổng nhu cầu = {total_demand}")
    print(f"Chi phí cố định s = {s}")
    print(f"Chi phí biên     c = {c}")
    print("-" * 80)
    
    # 2. Liệt kê toàn bộ không gian nghiệm nguyên khả thi (Feasible Integer Space)
    # Các vector x = (x1, x2, x3, x4) sao cho 0 <= x_t <= 2 và sum(x_t) = 2
    all_feasible_x = [
        x for x in itertools.product(range(u + 1), repeat=T)
        if sum(x) == total_demand
    ]
    
    print(f"Tổng số nghiệm khả thi trong toàn bộ không gian: {len(all_feasible_x)} nghiệm.\n")
    print(f"{'Kế hoạch x':<16} | {'Support S':<12} | {'Chi phí THỰC':<15} | {'Thực tế của Solver':<20} | {'Đỉnh ô P(S)?':<12}")
    print("-" * 80)
    
    true_costs = []
    opt_plans = []
    
    for x in all_feasible_x:
        S = [t + 1 for t in range(T) if x[t] > 0]
        
        # Chi phí THỰC TẾ theo định nghĩa phi tuyến: phi(0) = 0, phi(x) = s + c*x khi x > 0
        real_cost = sum(s[t] + c[t] * x[t] for t in range(T) if x[t] > 0)
        true_costs.append((real_cost, x, S))
        
        # Kiểm tra xem x có phải là ĐỈNH của ô P(S) hay không:
        # Ô P(S) = { x in R^T : sum(x) = 2, x_t = 0 (t not in S), 1 <= x_t <= 2 (t in S) }
        # Ta lập ma trận các ràng buộc chặt (tight constraints) tại x
        A_tight = []
        # Ràng buộc tổng: sum(x) = 2 luôn chặt
        A_tight.append([1 if t in [i-1 for i in S] else 0 for t in range(T)])
        # Ràng buộc ngoài S: x_t = 0
        for t in range(T):
            if (t + 1) not in S:
                row = [0] * T
                row[t] = 1
                A_tight.append(row)
        # Ràng buộc trong S: x_t = 1 hoặc x_t = u
        for t in range(T):
            if (t + 1) in S:
                if x[t] == 1 or x[t] == u:
                    row = [0] * T
                    row[t] = 1
                    A_tight.append(row)
        
        rank = np.linalg.matrix_rank(np.array(A_tight, dtype=float)) if A_tight else 0
        is_vertex = (rank == T)
        
        # Solver Standard MIP "ăn gian" trên kế hoạch x=(0,0,0,2):
        # Solver bật y2=1, y3=1, y4=1 dù x2=0, x3=0
        solver_note = ""
        if x == (0, 0, 0, 2):
            solver_note = "Solver báo ảo -25 (thực chất chỉ được -15)"
        elif x in [(0, 1, 0, 1), (0, 0, 1, 1), (0, 1, 1, 0)]:
            solver_note = "TỐI ƯU THỰC SỰ (-20)"
            
        print(f"{str(x):<16} | {str(S):<12} | {real_cost:>10.1f}      | {solver_note:<28} | {'Có (Vertex)' if is_vertex else 'Không':<12}")

    # Tìm cực tiểu toàn cục thực sự
    min_cost = min(c[0] for c in true_costs)
    optima = [c for c in true_costs if c[0] == min_cost]
    
    print("=" * 80)
    print("PHÂN TÍCH KẾT QUẢ:")
    print("=" * 80)
    print(f"1. CỰC TIỂU TOÀN CỤC THỰC TẾ (True Global Minimum): Giá trị = {min_cost}")
    print(f"   Các nghiệm tối ưu thực sự gồm {len(optima)} kế hoạch:")
    for cost, x, S in optima:
        print(f"   -> x = {x}, Support S = {S}, Chi phí = {cost}")
        
    print("\n2. VÌ SAO SOLVER BÁO -25 LÀ 'ĂN GIAN' VÀ TỆ HƠN?")
    print("   - Solver nộp phương án: x = (0, 0, 0, 2), nhưng bật biến nhị phân y = (0, 1, 1, 1).")
    print("   - Solver 'tưởng' nó được -25 vì nó cộng khống 2 lần tiền thưởng cố định (-5) ở chu kỳ 2 và 3.")
    print("   - Nhưng khi triển khai thực tế: Vì chu kỳ 2 và 3 KHÔNG SẢN XUẤT (x2=0, x3=0),")
    print("     chi phí thực tế tại đó là phi(0) = 0.")
    print("   - Giá trị THỰC TẾ mà kế hoạch của Solver mang lại chỉ là: phi_4(2) = -5 + (-5)*2 = -15!")
    print("   => Nghiệm của bạn (-20) mang lại lợi nhuận THỰC TẾ cao hơn nghiệm của Solver (-15) tới 5 đơn vị!")

    print("\n3. LÀM SAO BIẾT MỌI NGHIỆM TỐI ƯU ĐỀU LÀ ĐỈNH CỦA Ô P(S)?")
    for cost, x, S in optima:
        print(f"   Xét ô P({S}):")
        print(f"   - Ràng buộc: x_t = 0 với t ngoài S, 1 <= x_t <= 2 với t trong S, và sum(x_t) = 2.")
        print(f"   - Tại nghiệm x = {x}: Cả hai biến trong S đều chạm cận dưới x_t = 1.")
        print(f"   - Hệ phương trình ràng buộc chặt: {{x_t=0 (ngoài S), x_t=1 (trong S), sum=2}} có HẠNG = 4 (Rank đầy đủ).")
        print(f"   => x = {x} là một ĐỈNH ĐỘC NHẤT (Extreme Point/Vertex) của đa diện P({S})!")
    print("=" * 80)

if __name__ == "__main__":
    run_demonstration()
