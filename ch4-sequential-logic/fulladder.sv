module fulladder(input logic a, b, cin,
                 output logic s, cout);
    
    logic p, g;

    always_comb // equivalent to always @(a, b, cin)
      begin
        p = a ^ b; // blocking
        g = a & b; // blocking
        s = p ^ cin; // blocking
        cout = g | (p & cin); // blocking
      end
endmodule