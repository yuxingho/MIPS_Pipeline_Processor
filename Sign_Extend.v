module Sign_Extend(Din, Dout);
input [15:0] Din;
output [31:0] Dout;

reg [31:0] Dout;

always @(Din)begin
	if(Din[15] == 0)
		Dout = {16'b0000_0000_0000_0000, Din};
	else
		Dout = {16'b1111_1111_1111_1111, Din};
end

endmodule
