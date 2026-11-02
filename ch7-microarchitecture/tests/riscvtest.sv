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

  initial begin
    $dumpfile("../build/waveforms/single_cycle.vcd");
    $dumpvars(0, riscvtest);
  end

  //  Watchdog Timer so it doesn't hang forever 
  initial begin
    #5000;  // After 5000 time units, force a stop if it hasn't finished
    $display("ERROR: Simulation timed out!");
    $stop;
  end

  //  Real-time trace of what the CPU is doing 
  initial begin
    $monitor(
        "Time=%0t | PC=%0h | Instr=%0h | MemWrite=%b | DataAdr=%0d | WriteData=%0d | PCSrc=%b | PCSrc1=%h |PCSrc2=%h | Br=%b | Jp=%b | Zero=%b | op=%b | a=%h | b=%h | ctrl=%b | res=%h",
        $time, dut.PC, dut.imem.rd, MemWrite, DataAdr, WriteData, dut.rvsingle.PCSrc,
        dut.rvsingle.d.pcmux.d0, dut.rvsingle.d.pcmux.d1, dut.rvsingle.c.Branch,
        dut.rvsingle.c.Jump, dut.rvsingle.c.Zero, dut.rvsingle.c.op, dut.rvsingle.d.alu.a,
        dut.rvsingle.d.alu.b, dut.rvsingle.d.alu.alucontrol, dut.rvsingle.d.alu.result);
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
