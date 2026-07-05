module tb_vector_test_function();
  logic clk, reset;
  logic a, b, c, y, yexpect;
  logic[31:0] vectornum, errors;
  logic[3:0] testvectors[0:7];

  //instantiate the dut
  test_func dut(a, b, c, y);

  // generate4 clock
  always
    begin
      clk = 0; #5; clk = 1; #5;
    end
  
  //at the start of test, load vectors
  initial
    begin
      $dumpfile("build/waveforms/vector_test_func.vcd");
      $dumpvars(0, tb_vector_test_function);

      $readmemb("test/vectors/test_func.txt", testvectors);
      vectornum = 0; errors = 0; 
      reset = 1; #22; reset = 0; 
    end

    //apply test vectors on rising edge of clk
    always @(posedge clk)
      begin
        #1; {a, b, c, yexpect} = testvectors[vectornum];
      end
    
    // check result on negative edge
    always @(negedge clk)
      if (~reset) // skip during reset
        begin
          if (y !== yexpect) begin // check result
            $display("Error: inputs = %b", {a, b, c});
            $display(" outputs = %b (%b expected)", y, yexpect);
            errors = errors + 1;
          end
          
          vectornum = vectornum + 1;
          if (testvectors[vectornum] === 4'bx) begin
            $display("%d tests completed with %d errors", vectornum, errors);
            $finish; // Using $finish to return cleanly to terminal
          end
        end
endmodule