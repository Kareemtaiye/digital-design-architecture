module tb_ram ();
  parameter N = 6;
  parameter M = 32;

  logic clk;
  logic we;
  logic [N-1:0] adr;
  logic [M-1:0] din;
  logic [M-1:0] dout;

  ram #(
      .N(N),
      .M(M)
  ) dut (
      .clk (clk),
      .we  (we),
      .adr (adr),
      .din (din),
      .dout(dout)
  );

  // Clock generator 
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  initial begin
    $dumpfile("build/waveforms/ram.vcd");
    $dumpvars(0, tb_ram);

    // Initialize inputs
    we  = 0;
    adr = 0;
    din = 0;

    $display("Starting RAM Simulation...");

    // Wait for first clock edge to stabilize system
    @(posedge clk);
    #1;

    // 1. Test Asynchronous Read of Uninitialized Memory
    // ontent is unpredictable/garbage on power-up!
    adr = 6'd5;
    #1;  // Give combinational logic a tiny moment
    $display("Time=%0t | Reading uninitialized Address 5: dout = %h (Expect: Garbage/X)", $time,
             dout);

    // 2. Test Synchronous Write to Address 5
    $display("\nWriting 32'hDEADBEEF to Address 5...");
    adr = 6'd5;
    din = 32'hDEADBEEF;
    we  = 1;  // Pull write-enable high

    @(posedge clk);  // Data locks into the FF on this edge
    #1;
    we  = 0;  // Turn off write-enable
    din = 32'h00000000;  // Clear the input bus to prove RAM is holding the data

    // 3. Test Reading Back the Data (Immediate)
    adr = 6'd5;
    #1;
    $display("Time=%0t | Reading Address 5: dout = %h (Expect: DEADBEEF)", $time, dout);
    assert (dout == 32'hDEADBEEF)
    else $error("RAM Write/Read Failed at Address 5!");

    // 4. Test another address to show isolation
    $display("\nChecking Address 6 to make sure it wasn't overwritten...");
    adr = 6'd6;
    #1;
    $display("Time=%0t | Reading Address 6: dout = %h (Expect: Garbage/Different from DEADBEEF)",
             $time, dout);

    #10;
    $display("\nRAM simulation completed successfully!");
    $finish;
  end
endmodule
