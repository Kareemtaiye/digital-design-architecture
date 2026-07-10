module alu_extend # (
        parameter N = 32
    ) (input logic[N-1:0]a, b,
       input logic[2:0]alucontrol,
       output logic[N-1:0]result,
       output logic[3:0]flags); // {N,Z, C, V}
    
    logic[N-1:0]sum;
    logic cout;
    logic is_sub;
   
    // Control bit decoded:
    //SUB (3'b001) and SLT (3'b101) both have an LSB of 1.
    assign is_sub = alucontrol[0];

    //1. Core adder/subtractor logic
    assign {cout, sum} = is_sub ? (a + ~b + 1'b1) : (a + b + 1'b0);

   //2. Main ALU multiplexer
   always_comb begin
     case(alucontrol)
      3'b000:  result = sum;   // ADD
      3'b001:  result = sum;    // SUB;
      3'b010:  result = a & b; // AND
      3'b011:  result = a | b; // OR
      3'b101:  result = {{(N-1){1'b0}}, (flags[3] ^ flags[0])}; // SLT (Set if Less Than)
      default: result = {N{1'b0}};
     endcase
   end

   //3. Status flags
   // N (Negative): Bit 3
   assign flags[3] = result[N-1];

   //Z (Zero): Bit 2
   assign flags[2] = (result == {N{1'b0}});

   // C (Carry-out): Bit 1 // only valid during arithmetic ADD/SUB
   assign flags[1] = (~alucontrol[1] & cout);

   //V (Overflow): Bit 0 // only valid during arithmetic ADD/SUB
   assign flags[0] = ~alucontrol[1] &
                     ((~is_sub & (a[N-1] == b[N-1]) & (a[N-1] != sum[N-1])) |
                     (is_sub & (a[N-1] != b[N-1]) & (a[N-1] != sum[N-1])));

endmodule