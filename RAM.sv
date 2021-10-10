module RAM(address, clock,data,wren,q, mem);
  parameter data_width = 8; 
  parameter addr_width = 8;
  //parameter filename = "data.txt";

  input clock;
  input [addr_width-1:0] address;
  input wren;
  input [data_width-1:0] data;
  output logic [data_width-1:0] q;
  output logic [data_width-1:0] mem [0: 2**addr_width-1];

  //initial $readmemb(filename, mem);

  always @ (posedge clock) begin
    if (wren) mem[address] <= data;
    else q <= mem[address]; // q doesn't get data in this clock cycle 
                               // (this is due to Verilog non-blocking assignment "<=")
  end 
endmodule