module tb_regfile ();
  parameter DATA_WIDTH = 32;
  parameter ADDRESS_WIDTH = 5;
  logic clk, we3;
  logic [ADDRESS_WIDTH-1:0] ra1, ra2, wa3;
  logic [DATA_WIDTH-1:0] rd1, rd2, wd3;

  regfile #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDRESS_WIDTH(ADDRESS_WIDTH)
  ) dut (
      .clk(clk),
      .we3(we3),
      .ra1(ra1),
      .ra2(ra2),
      .wa3(wa3),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2)
  );


  // Clock generation (10ns)
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end


  initial begin
    $dumpfile("build/waveforms/regfile.vcd");
    $dumpvars(0, tb_regfile);

    ra1 = 0;
    ra2 = 0;
    wd3 = 0;
    we3 = 0;
    wa3 = 0;

    $display("Starting Shift register simulation......");

    // Wait for first clock edge to stabilize system
    @(posedge clk);
    #1;

    // 1. Test Asynchronous Read of Uninitialized Memory
    ra1 = 5'd3;
    ra2 = 5'd10;
    #1;  // Give combinational logic a tiny moment
    $display(
        "Time=%0t | Reading uninitialized Address 3 and 10: rd1 = %h, rd1: %h (Expect: Garbage/X)",
        $time, rd1, rd2);

    //2. Testing writing to x0;
    $display("Testing write to x0...");
    wa3 = 5'd0;
    wd3 = 32'hFFFFFFFF;
    we3 = 1;
    @(posedge clk);
    #1;
    $display("Time=%0t | Writing data to Address x0: wd3: %h", $time, wd3);

    //3. Testing synch write 
    $display("Write 32'hDEADBEEF to address 7");
    wa3 = 5'd7;
    wd3 = 32'hDEADBEEF;
    @(posedge clk);
    #2;

    we3 = 0;  // Disable write
    wa3 = 5'd0;
    wd3 = 32'h00000000;

    // 4. Testing the previously write address 7 and address 0
    ra1 = 5'd7;
    ra2 = 5'd0;

    $display("Time=%0t | Reading address 7 and 0. Address 5: %h, Adddress 0: %d", $time, rd1, rd2);

    assert ((rd1 == 32'hDEADBEEF) & (rd2 == 32'h00000000))
    else $error("Register File Write/Read on Adress 7 and 0 failed.");


    // 4. Test another address to show isolation
    $display("\nChecking Address 8 to make sure it wasn't overwritten...");
    ra1 = 6'd8;
    #1;
    $display("Time=%0t | Reading Address 8: dout = %h (Expect: Garbage/Different from DEADBEEF)",
             $time, rd1);
    #10;
    $display("\Register File simulation completed successfully!");
    $finish;


  end


endmodule
