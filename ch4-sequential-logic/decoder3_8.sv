module decoder3_8(input logic[2:0] a,
                  output logic[7:0] y);
    always_comb
      case(a)
        0:      y = 8'b00000001; 
        1:      y = 8'b00000010;
        2:      y = 8'b00000100; 
        3:      y = 8'b00001000; 
        4:      y = 8'b00010000;
        5:      y = 8'b00100000; 
        6:      y = 8'b01000000; 
        7:      y = 8'b10000000;
        default: y = 8'bxxxxxxxx;
      endcase
endmodule