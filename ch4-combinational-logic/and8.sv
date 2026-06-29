module and8(input logic[7:0]a,
            output y);
    assign y = &a;
    //easier to write than a[7] &...& a[0] 
endmodule