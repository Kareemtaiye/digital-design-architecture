module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [2:0] alucontrol,
    output logic [31:0] result,
    output logic zero
);

  logic [31:0] condinvb, sum;
  assign condinvb = alucontrol[0] ? ~b : b;  // invert b to 1's complement if op is sub
  assign sum = a + condinvb + alucontrol[0];

  always_comb begin
    case (alucontrol)
      3'b000:  result = sum;  //ADD
      3'b001:  result = sum;  //SUB
      3'b010:  result = a & b;  //AND
      3'b011:  result = a | b;  //OR
      3'b101:  result = {32'b0, sum[31]};  //SLT
      default: result = 32'bx;

    endcase
  end

  assign zero = (result == 32'b0);

endmodule
