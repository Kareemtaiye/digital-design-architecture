`timescale 1ns/1ps

module tb_alu_extend();
    parameter N = 32;
    logic[N-1:0]a, b, result;
    logic[2:0]alucontrol;
    logic[3:0]flags;

    alu_extend #(.N(N)) dut(
        .a(a),
        .b(b),
        .result(result),
        .alucontrol(alucontrol),
        .flags(flags)
    );

    initial begin
        $display("Starting ALU Simulation.....");
        $monitor("Time=%0t | Ctrl=%b | A=%b | B=%b | Result=%b", $time, alucontrol, a, b, result);

        // Test Case 1: ADD
        alucontrol = 3'b000;
        a = 32'd500;
        b = 32'd250;
        #10;
        assert(result == 32'd750) else $error("AND Failed!");

        //2. SUB;
        alucontrol = 3'd001;
        a = 32'd1000;
        b = 32'd250;
        #10;
        assert(result == 32'd750) else $error("SUB Failed!");

        //3. AND
        alucontrol = 3'b010;
        a = 32'hFF00FF00;
        b = 32'h0F0F0F0F;
        #10;
        assert(result == 32'h0F000F00) else $error("AND Failed!");

        //4. OR
        alucontrol = 3'b011;
        a = 32'hFFFF0000;
        b = 32'hF0F0F0F0;
        #10;
        assert(result == 32'hFFFFF0F0) else $error("OR Failed!");

        //5. Two's Complement Negative Result: SUB
        // 10 - 20 = 10;
        alucontrol = 3'b001;
        a = 32'd10;
        b = 32'd20;
        #10;
        assert(result == 32'hFFFFFFF6) else $error("Negative SUB Failed!");

        //6. Overflow Wrapping Case
        alucontrol = 3'b000; // ADD
        a = 32'h7FFFFFFF; // The MSB is 0 - positive highest no.
        b = 32'd1; // MSB = 1 -highest Negative no.
        #10;
        assert(result == 32'h80000000) else $error("Result wrapping Failed!");

        $display("ALU Simulation finished successfully.");
        $finish;
    end
endmodule




