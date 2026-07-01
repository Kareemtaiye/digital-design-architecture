module flop(input logic clk, 
            input logic[3:1]d,
            output logic[3:0]q);
            
    always_ff @(posedge clk)
        q <= d; // q gets d ONLY on the rising edge of the clk
endmodule