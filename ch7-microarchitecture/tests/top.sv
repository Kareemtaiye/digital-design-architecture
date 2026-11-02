module top (
    input logic clk,
    reset,
    output logic [31:0] WriteData,
    DataAdr,
    output logic MemWrite
);

  logic [31:0] PC, Instr, ReadData;

  //Instantiate processor and memories
  riscvsingle rvsingle (
      .clk(clk),
      .reset(reset),
      .PC(PC),
      .Instr(Instr),
      .DataAdr(DataAdr),
      .ReadData(ReadData),
      .WriteData(WriteData),
      .MemWrite(MemWrite)
  );

  imem imem (
      .a (PC),
      .rd(Instr)
  );
  dmem dmem (
      .clk(clk),
      .we (MemWrite),
      .a  (DataAdr),
      .wd (WriteData),
      .rd (ReadData)
  );

endmodule
