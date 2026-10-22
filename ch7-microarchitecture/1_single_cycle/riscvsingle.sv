module riscvsingle (
    input logic clk,
    reset,
    input logic [31:0] Instr,
    input logic [31:0] ReadData,
    output logic [31:0] PC,
    output logic MemWrite,
    output logic [31:0] DataAdr,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData
);

  logic ALUSrc, Jump, RegWrite, Zero, PCSrc;
  logic [1:0] ResultSrc, ImmSrc;
  logic [2:0] ALUControl;

  controller c (
      .op(Instr[6:0]),
      .funct7b5(Instr[30]),
      .funct3(Instr[14:12]),
      .zero(Zero),
      .RegWrite(RegWrite),
      .MemWrite(MemWrite),
      .ALUSrc(ALUSrc),
      .PCSrc(PCSrc),
      .Jump(Jump),
      .ImmSrc(ImmSrc),
      .ResultSrc(ResultSrc),
      .ALUControl(ALUControl)
  );

  datapath d (
      .clk(clk),
      .reset(reset),
      .RegWrite(RegWrite),
      .ResultSrc(ResultSrc),
      .ImmSrc(ImmSrc),
      .PCSrc(PCSrc),
      .ALUSrc(ALUSrc),
      .ALUControl(ALUControl),
      .Zero(Zero),
      .PC(PC),
      .Instr(Instr),
      .ALUResult(ALUResult),
      .WriteData(WriteData),
      .ReadData(ReadData)
  );

endmodule
