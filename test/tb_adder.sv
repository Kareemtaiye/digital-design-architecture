`timescale 1ns/1ps

module tb_adder();

    // 1. Parameters and Signals
    parameter N = 4; // Keeping it at 4 bits for a clean, readable waveform screenshot
    logic [N-1:0] a;
    logic [N-1:0] b;
    logic         cin;
    logic [N-1:0] s;
    logic         cout;

    // 2. Instantiate the Device Under Test (DUT)
    // Replace 'adder' with the exact module name you used
    adder #(.N(N)) dut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );

    // 3. VCD Waveform Generation Block
    initial begin
        $dumpfile("adder_waveform.vcd"); // Name of the output wave file
        $dumpvars(0, tb_adder);          // Dumps all signals inside this testbench module
    end

    // 4. Test Stimulus Procedure
    initial begin
        $display("Starting Adder Simulation...");

        // Test Case 1: Simple Addition without Carry
        a = 4'd4; b = 4'd3; cin = 1'b0;
        #10;
        assert(s == 4'd7 && cout == 1'b0) 
            else $error("TC1 Failed! s=%d, cout=%b", s, cout);

        // Test Case 2: Addition that creates a Carry-Out (Overflow for unsigned)
        a = 4'd12; b = 4'd5; cin = 1'b0;
        #10;
        assert(s == 4'd1 && cout == 1'b1) // 12 + 5 = 17 -> (16 carry + 1 s)
            else $error("TC2 Failed! s=%d, cout=%b", s, cout);

        // Test Case 3: Utilizing the Carry-In pin
        a = 4'd7; b = 4'd2; cin = 1'b1;
        #10;
        assert(s == 4'd10 && cout == 1'b0) 
            else $error("TC3 Failed! s=%d, cout=%b", s, cout);

        // Test Case 4: Edge Case - Maximum Values
        a = 4'b1111; b = 4'b1111; cin = 1'b1;
        #10;
        assert(s == 4'b1111 && cout == 1'b1) 
            else $error("TC4 Failed! s=%d, cout=%b", s, cout);

        $display("Adder Simulation Finished Successfully!");
        $finish;
    end

endmodule