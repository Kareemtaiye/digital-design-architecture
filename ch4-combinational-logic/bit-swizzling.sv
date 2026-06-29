module test_swizzling(output logic[8:0]y);
    logic[3:0]c;
    logic[3:0]d;

    assign c = 4'b1010;
    assign d = 4'b0001;

    assign y = {c[3:2], {3{d[0]}}, c[0], 3'b101};
endmodule