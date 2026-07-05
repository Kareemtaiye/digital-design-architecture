// y = a'b'c' + ab'c' + ab'c;
// y = b'(a + c')
module tb_self_test_func();
  logic a, b, c, y;

  test_func dut(a, b, c, y);

  initial 
    begin 
      $monitor("Time %0d ns: a = %b, b = %b, c = %b -> y = %b", $time, a, b, c, y);

      $dumpfile("self_test_func.vcd");
      $dumpvars(0, tb_self_test_func);

      a = 0; b = 0; c = 0; #10;
      assert (y === 1) else $error("000 failed");
      c = 1;               #10;
      assert (y === 0) else $error("001 failed");
      b = 1; c = 0;        #10;
      assert (y === 0) else $error("010 failed");
      c = 1;               #10;
      assert (y === 0) else $error("011 failed");
      a = 1; b = 0; c = 0; #10;
      assert (y === 1) else $error("100 failed");
      c = 1;               #10;
      assert (y === 1) else $error("101 failed");
      b = 1; c = 0;         #10;
      assert (y === 1) else $error("110 failed");
      c = 1;                #10;
      assert (y === 1) else $error("111 failed");
      $finish;
    end
endmodule
