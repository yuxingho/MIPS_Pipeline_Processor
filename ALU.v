module ALU(A, B, ALUCtrl, Zero, ALUResult);
input [31:0] A, B;
input [3:0] ALUCtrl;

output Zero;
output [31:0] ALUResult;

reg [31:0] ALUResult;

always @(A or B or ALUCtrl) begin
	case(ALUCtrl)
		4'b0000: ALUResult = A & B;
		
		4'b0001: ALUResult = A | B;

		4'b0010: ALUResult = A + B;
		
		4'b0110: ALUResult = A - B;
		
		4'b0111: ALUResult = (A<B)? 1 : 0;
		
		default: ALUResult = 32'd0;
	endcase
end

assign Zero = !(ALUResult == 32'd0);

endmodule