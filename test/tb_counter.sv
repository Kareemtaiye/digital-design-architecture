module tb_counter();
    parameter N = 8;
    logic clk, reset;
    logic[N-1:0]q;

    counter #(.N(N)) dut(
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Clock Heartbeat (10ns period -> 100 MHz clock)
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    // 2. Stimulus Block
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_counter);

        $display("Starting counter simulation...");

        //Initialize and system reset;
        reset = 1; 
        #2;
        @(posedge clk);
        #1; // to avoid setup violation
        reset = 0; // Release reset

        // 3. Letting it run to see the count accumulate
        // Since N=8, it will overflow back to 0 after 256 clock cycles.
        // letting it run for 300 clock cycles (3000 ns) to see the full cycle.
      #3000;

        // Ending simulation safely
        $display("Counter simulation finished successfully");
        $finish;
    end

endmodule
