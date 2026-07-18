module rom (
    input  logic [1:0] adr,
    output logic [2:0] dout
);

  always_comb begin
    case (adr)
      2'b00:   dout = 3'b011;
      2'b01:   dout = 3'b010;
      2'b10:   dout = 3'b100;
      2'b11:   dout = 3'b111;
      default: dout = 3'b0;
    endcase
  end
endmodule
