module controller (
    input logic [6:0] op,
    input logic funct7b5,
    input logic [2:0] funct3,
    input logic zero,
    output logic RegWrite,
    MemWrite,
    output logic ALUSrc,
    PCSrc,
    output logic Jump,
    output logic [1:0] ImmSrc,
    ResultSrc,
    output logic [2:0] ALUControl
);

  logic [1:0] ALUOp;
  logic Branch;

  main_decoder md (
      op,
      RegWrite,
      MemWrite,
      Branch,
      ALUSrc,
      Jump,
      ImmSrc,
      ALUOp,
      ResultSrc
  );

  alu_decoder ad (
      op[5],
      funct3,
      funct7b5,
      ALUOp,
      ALUControl
  );

  assign PCSrc = Branch & Zero | Jump;
endmodule
