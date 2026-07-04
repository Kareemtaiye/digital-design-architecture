module decoder #(
    parameter N = 3
) (
    input logic[N-1:0]a,
    output logic[2**N-1:0]y
);
    always_comb
      begin
        y = 0;
        // y[a] = 1; //elegant way of updating
         y = (1 << a); //for some synthesis tool support, like the one i'm using - digitaljs(yoys).
      end
endmodule

module decoder_4(input logic[3:0]a,
                 output logic[15:0]y);
  decoder #(4) mydec(
    .a(a),
    .y(y)
  );
endmodule
