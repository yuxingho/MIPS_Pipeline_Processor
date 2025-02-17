module Shift_Left2(Din, Dout);
input [31:0] Din;
output [31:0] Dout;

reg [31:0] Dout;

always @(Din)begin
	Dout <= {Din[31:2], 2'b00};
end
endmodule
