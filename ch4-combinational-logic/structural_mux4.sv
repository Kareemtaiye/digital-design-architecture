module mux2(input logic[3:0]d0, d1,
            input logic s,
            output logic[3:0]y);
    assign y = s ? d1 : d0;
endmodule

module mux4(input logic[3:0]d0, d1, d2, d3,
           input logic[1:0]s,
           output logic[3:0]y); 
    logic[3:0]low, high;

    mux2 muxlow(d0, d1, s[0], low);
    mux2 muxhigh(d2, d3, s[0], high);
    mux2 muxfinal(low, high, s[1], y);
endmodule 


module mux2_8(input logic[7:0]d0, d1, 
              input logic s, 
              output logic[7:0]y);
    mux2(d0[3:0], d1[3:0], s, y[3:0]);
    mux2(d0[7:4], d1[7:4], s, y[7:4]);
endmodule