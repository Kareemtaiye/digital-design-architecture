module tb_comparator();

    parameter N = 8;
    logic [N-1:0]a,b;
    logic eq, neq, lt, lte, gt, gte;

    comparator #(.N(N)) dutt(
        .a(a),
        .b(b),
        .eq(eq),
        .neq(neq),
        .gt(gt),
        .gte(gte),
        .lt(lt),
        .lte(lte)
    );

    initial begin
      $display("Starting simulation....");
      $monitor("Time=%0t, a=%b, b0%b -> eq=%b | neq=%b | gt=%b | lt=%b | gte=%b | lte=%b", $time, a, b, eq, neq, gt, lt, gte, lte);

      //Test for eq, gte, lte
      a = 8'b10; 
      b = 8'b10;
      #5;

      //Test for lt, lte
      a = 8'b10; 
      b = 8'b11;
      #5;

      //Test for gt, gte
      a = 8'b11; 
      b = 8'b01;
      #5;

      //Test for ne
      a = 8'b11; 
      b = 8'b01;

      //End simulation
      $display("Comparator simulation finished successfully");
     $finish;
  end

endmodule
    

