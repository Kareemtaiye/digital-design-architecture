`timescale 1ns/1ps

module tb_logic_gate_delay();
    // 1. Create fake wires to connect to our design inputs/outputs
    logic a, b, c;
    logic y;

    // 2. Instantiate your design module (like plugging it into the testing rig)
    logic_gate_delay dut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );

    // 3. Drive the inputs over time
    initial begin
        // --- ADD THESE TWO LINES FOR EDA PLAYGROUND ---
        $dumpfile("dump.vcd"); // Tells the simulator the name of the file to create
        $dumpvars(0, tb_logic_gate_delay); // Tells it to record EVERY wire inside tb_logic_gate_delay

        // Print changes to the console automatically whenever variables update
        $monitor("At time %0tns: a=%b b=%b c=%b -> y=%b", $time, a, b, c, y);

        // Initialize everything to 0 at t=0ns
        a = 0; b = 0; c = 0;
        
        // Wait 10 nanoseconds, then change inputs
        #10;
        a = 1; b = 0; c = 0;

        // Wait 10 nanoseconds, then change inputs
        #5;
        a = 1; b = 0; c = 0;
        
        // Wait another 10 nanoseconds, change inputs again
        #5;
        a = 0; b = 1; c = 0;

        // Finish the simulation
        #10;
        $finish;
    end
endmodule