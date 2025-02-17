module PC(clk, reset, PCWrite, addr_in, addr_out);
input clk, reset, PCWrite;
input [31:0] addr_in;
output [31:0] addr_out;

reg [31:0] addr_out;

always @(posedge clk or negedge reset) begin
	if(!reset)
		addr_out <= 32'b0;
	else if(PCWrite)
		addr_out <= addr_in;
end

endmodule
