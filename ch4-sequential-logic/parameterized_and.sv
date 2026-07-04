module andN #(
        parameter N = 8
    ) (
        input logic[N-1:0]a,
        output logic y
    );

    //A bus for the internal connecting wires
    logic chain[N-1:0];

    // The first input goes directly into the start of the chain
    assign chain[0] = a[0];

    genvar i;

    generate
        for(i = 1; i < N; i = i + 1) begin: forloop
          assign chain[i] = chain[i-1] & a[i]
        end
    endgenerate
    
    assign y = chain[N-1]
endmodule