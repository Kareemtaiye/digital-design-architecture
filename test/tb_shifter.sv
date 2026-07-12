module tb_shifter();
    parameter N = 32;
    logic[N-1:0]a,y;
    logic[$clog2(N)-1:0]shamt;
    logic[1:0]shifttype;

    shifter #(.N(N)) dut (
        .a(a),
        .y(y),
        .shamt(shamt),
        .shifttype(shifttype)
    );

    initial 
        begin
            $display("Starting Shifter simulation.....");
          $monitor("Time=0%t, A=%h | shifttype=%b | shamt=%b Y=%h", $time, a, shifttype, shamt, y);

            //1. Testing SLL
            shifttype = 2'b00;
            a = 32'h0000_0001;
            shamt = 4;
            #20;
            assert(y == 32'h0000_0010) else $error("SLL Failed! Got %h", y);

            //2. Testing SRL
            shifttype = 2'b01;
            a = 32'hF000_0000;
            shamt = 4;
            #10;
            assert(y == 32'h0F00_0000) else $error("SRL Failed! Got %h", y);

            //3. Testing SRA
            shifttype = 2'b10;
            a = 32'h7000_0000;
            shamt = 4;
            #10;
            assert(y == 32'h0700_0000) else $error("SRA Failed! Got %h", y);

            //4. Testing ROR - Rotate by right
            shifttype = 2'b11;
            a = 32'h0000_0003;
            shamt = 4;
            #10;
            assert(y == 32'h3000_0000) else $error("ROR Failed! Got %h", y);


            // --- Test Case 6: Edge Case (Shift by 0) ---
            // Data should pass straight through completely unaltered
            shifttype = 2'b00;
            a         = 32'hABCD_EF12;
            shamt     = 0;
            #10;
            assert(y == 32'hABCD_EF12) else $error("Shift by 0 Failed! Got %h", y);

            $display("Shifter Simulation Finished Successfully!");
            $finish;
        end

endmodule