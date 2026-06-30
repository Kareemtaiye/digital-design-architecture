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
