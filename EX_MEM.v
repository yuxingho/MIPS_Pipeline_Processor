module EX_MEM(clk, reset, MemtoReg_in, RegWrite_in, MemRead_in, MemWrite_in, ALU_Result_in, busB_in, RW_in,
					MemtoReg_out, RegWrite_out, MemRead_out, MemWrite_out, ALU_Result_out, busB_out, RW_out);

input clk, reset;
input MemtoReg_in, RegWrite_in, MemRead_in, MemWrite_in;
input [31:0] ALU_Result_in, busB_in;
input [4:0] RW_in;
//控制信號
output reg MemtoReg_out, RegWrite_out, MemRead_out, MemWrite_out;
// busB_out 寫入memory的data
// ALU_Result_out是address或是要寫回reg的值
output reg [31:0] ALU_Result_out, busB_out;
//寫回暫存器的地址看是rd還是rt
output reg [4:0] RW_out;

always @(posedge clk or negedge reset)begin
	if(!reset)begin
		ALU_Result_out <= 32'd0;
		busB_out <= 32'd0;
		RW_out <= 5'd0;
		
		MemtoReg_out <= 1'b0;
		RegWrite_out <= 1'b0;
		MemRead_out <= 1'b0;
		MemWrite_out <= 1'b0;
	end 
	else begin
		ALU_Result_out <= ALU_Result_in;
		busB_out <= busB_in;
		RW_out <= RW_in;
		
		MemtoReg_out <= MemtoReg_in;
		RegWrite_out <= RegWrite_in;
		MemRead_out <= MemRead_in;
		MemWrite_out <= MemWrite_in;
	end
end

endmodule 