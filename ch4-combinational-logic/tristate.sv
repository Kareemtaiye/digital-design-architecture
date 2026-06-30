module tristate(input logic[3:0] a,
                input logic en,
                output logic[3:0]y);
                
        assign y = en ? a : 4'bz;
endmodule