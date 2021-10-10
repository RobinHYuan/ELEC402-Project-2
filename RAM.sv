module RAM(reset, address, clock,data,wren,q, mem_in, mem_out);
  parameter data_width = 8; 
  parameter addr_width = 8;

  input reset;
  input clock;
  input [addr_width-1:0] address;
  input wren;
  input [data_width-1:0] data;
  output logic [data_width-1:0] q;
  input  logic [data_width-1:0] mem_in  [0: 2**addr_width-1];
  output logic [data_width-1:0] mem_out [0: 2**addr_width-1];

  always @ (posedge clock) begin
    if (reset) mem_out[0: 2**addr_width-1] = mem_in[0: 2**addr_width-1];
    else if (wren) mem_out[address] <= data;
          else q <= mem_out[address]; // q doesn't get data in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule