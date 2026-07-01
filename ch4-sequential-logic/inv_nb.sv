module inv(input logic[3:0]a,
           output logic[3:0]y);

    always_comb //equiavalent to always @(a)
        assign y = ~a;
endmodule    
