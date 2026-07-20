module regfile #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 5
) (
    input logic clk,
    input logic we3,
    input logic [ADDRESS_WIDTH-1:0] ra1,  //Read Adr 1
    input logic [ADDRESS_WIDTH-1:0] ra2,  // Read Adr 2
    input logic [ADDRESS_WIDTH-1:0] wa3,  // Write Adr 3
    input logic [DATA_WIDTH-1:0] wd3,  // Write Data 3
    output logic [DATA_WIDTH-1:0] rd1,  // Read Data 1
    output logic [DATA_WIDTH-1:0] rd2  // Read Data 2
);

  logic [DATA_WIDTH-1:0] rf[2**ADDRESS_WIDTH-1:0];  // From actual f-f

  //Synch write port
  // Register x0 can NEVER be written to; it is hardwired to 0.
  always_ff @(posedge clk) begin
    if (we3 && (wa3 != 5'b00000)) begin
      rf[wa3] <= wd3;
    end
  end

  //Asynchronous Read Ports 
  assign rd1 = (ra1 != 5'b00000) ? rf[ra1] : {DATA_WIDTH{1'b0}};
  assign rd2 = (ra2 != 5'b00000) ? rf[ra2] : {DATA_WIDTH{1'b0}};

endmodule

