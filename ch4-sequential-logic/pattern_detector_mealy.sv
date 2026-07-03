//Mealy machine
module patterndetectormealy(input logic clk,
                            input logic reset,
                            input logic a,
                            output logic y);
    typedef enum logic {S0, S1} statetype;
    statetype state, nextstate;