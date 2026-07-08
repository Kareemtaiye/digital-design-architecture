module comparator # (parameter N = 8)
                    (input logic[N-1:0]a, b,
                    output logic eq, neq, gt, lt, lte, gte);
        
    assign eq = (a == b);
    assign neq = (a != b);
    assign gt = (a > b);
    assign gte = (a >= b);
    assign lt = (a < b);
    assign lte = (a <= b);
endmodule