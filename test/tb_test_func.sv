module tb_test_func();
  logic a, b, c, y;

  //instantiate device under test
  test_func dut(a, b, c, y);

  //apply inputs one at a time
  initial
    begin
      $monitor("Time = %0d ns: a = %b, b = %b, c = %b -> y = %b", $time, a, b, c, y);
      //
      $dumpfile("test_func.vcd");
      $dumpvars(0, tb_test_func);

      a = 0; b = 0; c = 0; #10;
      c = 1;               #10;
      b = 1; c = 0;        #10;
      c = 1;               #10;
      a = 1; b = 0; c = 0; #10;              
      c = 1;               #10;
      b = 1; c = 0;        #10;
      c = 1;               #10;
      $finish;
    end
endmodule