// y = a'b'c' + ab'c' + ab'c;
module test_func(input logic a, b, c,
                     output logic y);
    logic n1, n2, n3;
    assign {ab, bb, cb} = ~{a, b, c};
    assign n1 = ab & bb & cb;
    assign n2 = a & bb & cb;
    assign n3 = a & bb & c;
    assign y = n1 | n2 | n3;
endmodule