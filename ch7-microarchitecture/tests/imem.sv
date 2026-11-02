module imem (
    input  logic [31:0] a,
    output logic [31:0] rd
);

  logic [31:0] RAM[63:0];

  initial begin
    $readmemh("tests/riscvtest.txt", RAM);
  end

  assign rd = RAM[a[31:2]];

endmodule
