module ALUCtrl(ALUop, Func, ALUctr);
input [1:0] ALUop;
input [5:0] Func;
output [3:0] ALUctr;

reg [3:0] ALUctr;

always @(ALUop or Func)
	case(ALUop)
		2'b00: ALUctr <= 4'b0010;
		
		2'b01: ALUctr <= 4'b0110;
	
		2'b10: begin
			case(Func)
				//AND
				6'b100100: ALUctr <= 4'b0000;
				//OR
				6'b100101: ALUctr <= 4'b0001;
				//ADD
				6'b100000: ALUctr <= 4'b0010;
				//SUB
				6'b100010: ALUctr <= 4'b0110;
				//set-on-less-than
				6'b101010: ALUctr <= 4'b0111;
				
				default: ALUctr <= 4'b1111;
			endcase
		end
		default: ALUctr <= 4'b1111;
	endcase
endmodule
