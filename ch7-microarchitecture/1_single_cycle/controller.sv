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
      .op(op),
      .RegWrite(RegWrite),
      .MemWrite(MemWrite),
      .Branch(Branch),
      .ALUSrc(ALUSrc),
      .Jump(Jump),
      .ImmSrc(ImmSrc),
      .ALUOp(ALUOp),
      .ResultSrc(ResultSrc)
  );

  alu_decoder ad (
      .op(op),
      .funct3(funct3),
      .funct7b5(funct7b5),
      .ALUOp(ALUOp),
      .ALUControl(ALUControl)
  );

  assign PCSrc = Branch & Zero | Jump;
endmodule
