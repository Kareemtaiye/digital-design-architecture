module regfile (
    input logic clk,
    input logic we3,
    input logic [4:0] a1,
    input logic [4:0] a2,
    input logic [4:0] a3,
    input logic [31:0] wd3,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

  // 32 registers, each 32 bits wide
  logic [31:0] rf[31:0];


  always_ff @(posedge clk) begin
    if (we3 && a3 != 5'b0) begin
      rf[a3] <= wd3;
    end
  end

  assign rd1 = (a1 != 5'b0) ? rf[a1] : 32'b0;
  assign rd2 = (a2 != 5'b0) ? rf[a2] : 32'b0;
endmodule
