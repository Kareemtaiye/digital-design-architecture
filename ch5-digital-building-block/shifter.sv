module shifter #(
        parameter N = 8
    ) (input logic[N-1:0]a,
       input logic[$clog2(N)-1:0]shamt,
       input logic[1:0]shifttype,
       output logic[N-1:0]y  // 00: SLL, 01: SRL, 10: SRA, 11: ROT
       );
    
    always_comb begin
        case(shifttype)
            2'b00:  y = a << shamt;
            2'b01:  y = a >> shamt;
            2'b10:  y = $signed(a) >>> shamt;
            2'b11:  y = (a >> shamt) | (a << (N-shamt)); //ROR
            default: y = {N{1'b0}};
        endcase
    end

endmodule
