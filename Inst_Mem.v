module Inst_Mem(addr_in, inst_out);
input [31:0] addr_in;
output [31:0] inst_out;

reg [31:0]ROM[31:0];

initial begin
	$readmemh("D:/MARS/instruction1.txt",ROM);
end 

assign inst_out = ROM[addr_in[6:2]];

endmodule