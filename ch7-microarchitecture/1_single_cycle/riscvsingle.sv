module riscvsingle(
    input logic clk, reset,
    input logic[31:0] Instr, 
    input logic[31:0] ReadData, 
    output logic[31:0] PC, 
    output logic MemWrite, 
    output logic[31:0] DataAdr, 
    output logic[31:0] ALUResult, WriteData, 
);

    logic ALUSrc, Jump, RegWrite, Zero;
    logic[1:0] ResultSrc, ImmSrc;
    logic[2:0] ALUContril;

    controller c(Instr[6:0], );
