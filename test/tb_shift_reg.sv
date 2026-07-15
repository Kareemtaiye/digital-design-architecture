`timescale 1ns/1ps

module tb_shift_reg();
    parameter N = 8;
    logic clk, reset, load, sout, sin;
    logic[N-1:0]d, q;

    shift_reg #(.N(N)) dut(
        .clk(clk),
        .reset(reset),
        .load(load),
        .sin(sin),
        .sout(sout),
        .d(d),
        .q(q)
    );

    // Clock cycle.
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
        $dumpfile("build/waveforms/shift_reg.vcd");
        $dumpvars(0, tb_shift_reg);

        load = 0;
        sin = 0;
        d = 0;

        $display("Starting shift register simulation....");
        $monitor("Time=%0t, r=%b | load=%b | sin=%b | sout=%b | d=%b | q=%b", $time, reset, load, sin, sout, d, q);

        // Initialize and reset;
        reset = 1;
        #2;
        @(posedge clk);
        #1; // avoiding setup time violation
        reset = 0; //Release reset

        // 1. Testing SISO/PISO: 10101100;
        $display("Starting serial-in serial-out (SISO) test....");
        d = 8'B10101100;

        // If we shift in a '1' into the LSB, the new LSB of q must be 1, 
        // and the older bits must have moved left.

        sin = d[7]; @(posedge clk); #1;
        assert(q[0] == 1'b1) else $error("SISO: q[0] should be 1.");

        sin = d[6]; @(posedge clk); #1;
        // Old LSB (1) should have shifted left to q[1]. New LSB should be 0.
        assert(q[1:0] == 2'b10) else $error("SISO:. q[1:0] should be 2'b10.");

        sin = d[5]; @(posedge clk); #1;
        assert(q[2:0] == 3'b101) else $error("SISO: q[2:0] should be 3'b101.");

        sin = d[4]; @(posedge clk); #1;
        assert(q[3:0] == 4'b1010) else $error("SISO: q[3:0] should be 4'b1010.");

        sin = d[3]; @(posedge clk); #1;
        assert(q[4:0] == 5'b10101) else $error("SISO: q[4:0] should be 5'b10100.");

        sin = d[2]; @(posedge clk); #1;
        assert(q[5:0] == 6'b101011) else $error("SISO: q[5:0] should be 6'b101001.");

        sin = d[1]; @(posedge clk); #1;
        assert(q[6:0] == 7'b1010110) else $error("SISO: q[6:0] should be 7'b1010011.");

        sin = d[0]; @(posedge clk); #1;
        // The entire byte should now be fully shifted in and match 'd' exactly.
        assert(q == d) else $error("SISO Complete Shift Failed. q = %b, expected %b", q, d);

        // 2. Testing PISO
        $display("Starting parallel-in serial-out (PISO) test....");
        load = 1;        // Assert load line
        @(posedge clk); #1;
        load = 0;        // Deassert load line immediately so it stays in shift mode

        // Assert that the full byte is loaded correctly into q
        assert(q == d) else $error("PISO load Failed.");

        //assert that sout instantly shows the MSB of q
        assert(sout == q[N-1]) else $error("PISO initial bit out mismatch.");

        // watch the bits march out of 'sout' one by one over the next clock ticks
        $display("--- Watching serial bits march out of sout ---");

        @(posedge clk); #1;
        assert(sout == q[N-1])  else $error("PISO Shift Bit 1 failed.");

        @(posedge clk); #1;
        assert(sout == q[N-1])  else $error("PISO Shift Bit 2 failed.");

        @(posedge clk); #1;
        assert(sout == q[N-1])  else $error("PISO Shift Bit 3 failed.");

        #50;
        $display("Shift register simulation completed successfully.");
        $finish;
    end
endmodule


