module alu # (
        parameter N = 32
    ) (input logic[N-1:0]a, b,
        input logic[1:0]alucontrol,
        output logic[N-1:0]result);
    
    logic[N-1:0]sum;
    logic cout;
    logic is_sub;       //if the alu is performing subtraction

    // Control bit decoded
    assign is_sub = alucontrol[0];

    //1. Core adder/subtractor unit
    //If subtracting, we invert B and assert the carry-in to 1 (a + ~b + 1)
    assign {cout, sum} = is_sub ? (a + ~b + 1'b1) : (a + b + 1'b0);

    // Main ALU operation multiplexer 
    always_comb begin
      case(alucontrol) 
        2'b00:      result = sum; //ADD
        2'b01:      result = sum; //SUB
        2'b10:      result = A & B; //AND
        2'b11:      result = A | B; //OR
        default:    result = {N{1'b0}};
      endcase
    end
endmodule