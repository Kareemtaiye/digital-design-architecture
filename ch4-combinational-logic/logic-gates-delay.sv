/*CL equation: y = a'b'c' + ab'c' + ab'c
NOT pd = 1ns, 3-input AND pd = 2ns, 3-input OR pd = 4ns.
*/
`timescale 1ns/1ps

module logic_gate_delay(input logic a, b, c,
                output logic y);
   
    /*
     // Fixed for iverilog: split individual assignments
    assign #1 ab = ~a;
    assign #1 bb = ~b;
    assign #1 cb = ~c;
    */

    assign #1 {ab, bb, cb} = ~{a, b, c};

    assign #2 n1 = ab & bb & cb;
    assign #2 n2 = a & bb & cb;
    assign #2 n3 = a & bb & c;
    assign #4 y = n1 | n2 | n3;
endmodule