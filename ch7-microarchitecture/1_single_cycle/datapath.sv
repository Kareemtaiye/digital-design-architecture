module datapath (
    input logic clk,
    input logic reset,
    input logic RegWrite,
    input logic [1:0] ResultSrc,
    input logic [1:0] ImmSrc,
    input logic PCSrc,
    input logic ALUSrc,
    input logic [2:0] ALUControl,

    output logic Zero,
    output logic [31:0] PC,
    input logic [31:0] Instr,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    input logic [31:0] ReadData
);

  logic [31:0] PCNext, PCPlus4, PCTarget;
  logic [31:0] ImmExt;
  logic [31:0] SrcA, SrcB;
  logic [31:0] Result;

  //Next PC logic
  flopr #(
      .WIDTH(32)
  ) pcreg (
      .clk(clk),
      .reset(reset),
      .d(PCNext),
      .q(PC)
  );

  adder pcadd4 (
      .a(PC),
      .b(32'd4),
      .y(PCPlus4)
  );

  adder pcaddbranch (
      .a(PC),
      .b(ImmExt),
      .y(PCTarget)
  );

  mux2 #(
      .WIDTH(32)
  ) pcmux (
      .d0(PCPlus4),
      .d1(PCTarget),
      .s (PCSrc),
      .y (PCNext)
  );


  // Register file logic
  regfile rf (
      .clk(clk),
      .we3(RegWrite),
      .ra1(Instr[19:15]),
      .ra2(Instr[24:20]),
      .wa3(Instr[11:7]),
      .wd3(Result),
      .rd1(SrcA),
      .rd2(WriteData)
  );



endmodule
