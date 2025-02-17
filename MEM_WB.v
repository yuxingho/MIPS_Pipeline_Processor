module MEM_WB(clk, reset, ReadData_in, ALU_Result_in, rw_in, MemtoReg_in, RegWrite_in,
					ReadData_out, ALU_Result_out, rw_out, MemtoReg_out, RegWrite_out);

input clk, reset, MemtoReg_in, RegWrite_in;
input [31:0] ReadData_in, ALU_Result_in;
input [4:0] rw_in;

output reg MemtoReg_out, RegWrite_out;
output reg [31:0] ReadData_out, ALU_Result_out;
output reg [4:0] rw_out;

always @(posedge clk or negedge reset)begin
	if(!reset)begin
		ReadData_out <= 32'd0;
		ALU_Result_out <= 32'd0;
		rw_out <= 5'd0; 
		MemtoReg_out <= 1'b0;
		RegWrite_out <= 1'b0;
	end
	else begin
		ReadData_out <= ReadData_in;
		ALU_Result_out <= ALU_Result_in;
		rw_out <= rw_in; 
		MemtoReg_out <= MemtoReg_in;
		RegWrite_out <= RegWrite_in;
	end
end

endmodule
