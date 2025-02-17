module Controller(op, Control_Write, RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop, IF_Flush);
input Control_Write;
input [5:0]op;
output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, IF_Flush;
output [1:0] ALUop;
reg RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, IF_Flush;
reg [1:0]ALUop;

//Control_Write在data hazard發生時等於0，控制信號都要清0
always @(*) begin
	if(Control_Write == 1'b1)begin
		case(op)
			// R-format
			6'b000000: begin
			RegDst = 1'b1;
			ALUSrc = 1'b0;
			MemtoReg = 1'b0;
			RegWrite = 1'b1;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			Branch = 1'b0;
			ALUop = 2'b10;
			IF_Flush = 1'b0;
			end
			
			// I-format的lw
			6'b100011: begin
			RegDst = 1'b0;
			ALUSrc = 1'b1;
			MemtoReg = 1'b1;
			RegWrite = 1'b1;
			MemRead = 1'b1;
			MemWrite = 1'b0;
			Branch = 1'b0;
			ALUop = 2'b00;
			IF_Flush = 1'b0;
			end
			
			// I-format的sw
			6'b101011: begin
			RegDst = 1'bx;
			ALUSrc = 1'b1;
			MemtoReg = 1'bx;
			RegWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b1;
			Branch = 1'b0;
			ALUop = 2'b00;
			IF_Flush = 1'b0;
			end
			
			// I-format的beq
			6'b000100: begin
			RegDst = 1'b0;
			ALUSrc = 1'b0;
			MemtoReg = 1'b0;
			RegWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			Branch = 1'b1;
			ALUop = 2'b01;
			IF_Flush = 1'b1;
			end
			
			// J-format的Jump
			//6'b000010: begin
			//RegDst <= 1'bx;
			//ALUSrc <= 1'bx;
			//MemtoReg <= 1'bx;
			//RegWrite <= 1'b0;
			//MemRead <= 1'b0;
			//MemWrite <= 1'b0;
			//Branch <= 1'bx;
			//ALUop <= 2'bxx;
			//jump <= 1'b1;
			//IF_Flush <= 1'b1;
			//end
			
			default: begin
			RegDst = 1'b0;
			ALUSrc = 1'b0;
			MemtoReg = 1'b0;
			RegWrite = 1'b0;
			MemRead = 1'b0;
			MemWrite = 1'b0;
			Branch = 1'b0;
			ALUop = 2'b00;
			IF_Flush = 1'b0;
			end
		endcase
	end
	else begin
		RegDst = 1'b0;
		ALUSrc = 1'b0;
		MemtoReg = 1'b0;
		RegWrite = 1'b0;
		MemRead = 1'b0;
		MemWrite = 1'b0;
		Branch = 1'b0;
		ALUop = 2'b00;
		IF_Flush = 1'b0;
	end
end

endmodule
