`timescale 1ns/1ps

module tb_sync;

    // 1. Emulate the physical wires connecting to the FSM
    logic clk;
    logic rst;
    logic a;
    logic y_moore;
    logic y_mealy;

    // 2. Instantiate your design modules under test (MUT)
    // (Make sure these port names match your actual module definitions)
  patterndetectormoore uut_moore (.clk(clk), .reset(rst), .a(a), .y(y_moore));
  //mux_mealy uut_mealy (.clk(clk), .reset(rst), .a(a), .y(y_mealy));

    // 3. Generate the Clock Heartbeat (10ns period)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // 4. Inject the Sequence Vector
    initial begin
        // Dump waves for EPWave/GTKWave configuration
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_sync);

        // Step A: Initialize and Reset the system safely
        rst = 1;
        a = 0;
        @(posedge clk); // Wait for one clock edge
        #1;             // Small 1ns delay after edge to avoid setup violation
        rst = 0;        // Release reset

        // Step B: Drive the sequence '0100110111' bit-by-bit
        // We change 'a' slightly after the posedge so the FSM captures it perfectly
        
        a = 0; @(posedge clk); #1; // Bit 0
        a = 1; @(posedge clk); #1; // Bit 1 -> Mealy smiles here, Moore smiles NEXT cycle
        a = 0; @(posedge clk); #1; // Bit 2
        a = 0; @(posedge clk); #1; // Bit 3
        a = 1; @(posedge clk); #1; // Bit 4 -> Mealy smiles
        a = 1; @(posedge clk); #1; // Bit 5
        a = 0; @(posedge clk); #1; // Bit 6
        a = 1; @(posedge clk); #1; // Bit 7 -> Mealy smiles
        a = 1; @(posedge clk); #1; // Bit 8
        a = 1; @(posedge clk); #1; // Bit 9

        // End simulation safely
        #20;
        $finish;
    end

endmodule