`timescale 1ns/1ps

module tb_base_alu();
    parameter N = 32;

    logic[1:0]alucontrol;
    logic[N-1:0]a, b, result;

    alu #(.N(N)) dut(
        .a(a),
        .b(b),
        .alucontrol(alucontrol),
        .result(result)
    );

    initial begin
      $display("Starting ALU simulation......");
      $monitor("Time=%0t | Ctrl=%b | A=%b | B=%b | Result=%b", $time, alucontrol, a, b, result);

      //Test case 1: ADD
      alucontrol = 2'b00;
      a = 32'd10;
      b = 32'd20;
      #10; // for the combinational logic to settle
      assert(result == 32'd30) else $error("ADD failed!");


      //Test case 2: SUB
      alucontrol = 2'b01;
      a = 32'd50;
      b = 32'd20;
      #10; 
      assert(result == 32'd30) else $error("SUB failed!");

      //Test case 3: BITWISE AND
      alucontrol = 2'b10;
      a = 32'h00FF00FF;
      b = 32'h0F0F0F0F;
      #10; 
      assert(result == 32'h000F000F) else $error("AND failed!");
   
      //Test case 3: BITWISE OR
      alucontrol = 2'b11;
      a = 32'h00FF00FF;
      b = 32'h0F0F0F0F;
      #10; 
      assert(result == 32'h0FFF0FFF) else $error("OR failed!");

      $display("ALU simulation finish successfully");
      $finish;
    end

endmodule
