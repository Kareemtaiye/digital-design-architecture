module riscvtest ();
  logic clk, reset;
  logic [31:0] WriteData, DataAdr;
  logic MemWrite;

  //instantiate device to be tested
  top dut (
      .clk(clk),
      .reset(reset),
      .WriteData(WriteData),
      .DataAdr(DataAdr),
      .MemWrite(MemWrite)
  );

  //Initialize test
  initial begin
    reset <= 1;
    #22;
    reset <= 0;
  end

  // Generate clock sequence test
  always begin
    clk <= 1;
    #5;
    clk <= 0;
    #5;
  end

  // Check result
  always @(negedge clk) begin
    if (MemWrite)
      if (DataAdr == 100 & WriteData == 25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (DataAdr !== 96) begin
        $display("Simulation failed");
        $stop;
      end
  end
endmodule
