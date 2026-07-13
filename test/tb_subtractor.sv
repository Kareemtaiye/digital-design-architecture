`timescale 1ns/1ps
module tb_subtractor();

    // 1. Parameters and Signals
    parameter N = 8;
    logic [N-1:0] a;
    logic [N-1:0] b;
    logic [N-1:0] y;

    // 2. Instantiate the Device Under Test (DUT)
    subtractor #(.N(N)) dut (
        .a(a),
        .b(b),
        .y(y)
    );

    // 3. VCD Waveform Generation Block
    initial begin
        $dumpfile("subtractor_waveform.vcd");
        $dumpvars(0, tb_subtractor);
    end

    // 4. Test Stimulus Procedure
    initial begin
        $display("Starting Subtractor Simulation...");

        // Test Case 1: Simple Subtraction, positive result
        a = 8'd10; b = 8'd4;
        #10;
        assert(y == 8'd6)
            else $error("TC1 Failed! y=%d", y);

        // Test Case 2: Subtraction resulting in underflow (a < b)
        a = 8'd4; b = 8'd10;
        #10;
        assert(y == 8'd250) // 4 - 10 = -6 -> wraps to 250 (8-bit unsigned)
            else $error("TC2 Failed! y=%d", y);

        // Test Case 3: Equal values
        a = 8'd50; b = 8'd50;
        #10;
        assert(y == 8'd0)
            else $error("TC3 Failed! y=%d", y);

        // Test Case 4: Edge Case - Zero minus Max
        a = 8'd0; b = 8'd255;
        #10;
        assert(y == 8'd1) // 0 - 255 = -255 -> wraps to 1
            else $error("TC4 Failed! y=%d", y);

        // Test Case 5: Edge Case - Max minus Zero
        a = 8'd255; b = 8'd0;
        #10;
        assert(y == 8'd255)
            else $error("TC5 Failed! y=%d", y);

        $display("Subtractor Simulation Finished Successfully!");
        $finish;
    end

endmodule