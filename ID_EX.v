module ID_EX(clk, reset, 
ReadData1_in, ReadData2_in, sign_ext_in, 
ReadData1_out, ReadData2_out, sign_ext_out,

Fw_rs_in, Fw_rt_in, MUX_rd_in, MUX_rt_in,
Fw_rs_out, Fw_rt_out, MUX_rd_out, MUX_rt_out,

RegDst_in, ALUSrc_in, MemtoReg_in, RegWrite_in, 
MemRead_in, MemWrite_in, Branch_in, ALUop_in,

RegDst_out, ALUSrc_out, MemtoReg_out, RegWrite_out, 
MemRead_out, MemWrite_out, Branch_out, ALUop_out
);

input clk, reset;
input [31:0] ReadData1_in, ReadData2_in, sign_ext_in;
input [4:0] Fw_rs_in, Fw_rt_in, MUX_rd_in, MUX_rt_in;
input [1:0] ALUop_in;
input RegDst_in, ALUSrc_in, MemtoReg_in, RegWrite_in, MemRead_in, MemWrite_in, Branch_in;

output reg [31:0] ReadData1_out, ReadData2_out, sign_ext_out;
output reg [4:0] Fw_rs_out, Fw_rt_out, MUX_rd_out, MUX_rt_out;
output reg [1:0] ALUop_out;
output reg RegDst_out, ALUSrc_out, MemtoReg_out, RegWrite_out, MemRead_out, MemWrite_out, Branch_out;

always @(posedge clk or negedge reset)begin
	if(!reset)begin
		ReadData1_out <= 32'd0;
		ReadData2_out <= 32'd0;
		sign_ext_out <= 32'd0;
		Fw_rs_out <= 5'd0;
		Fw_rt_out <= 5'd0;	
		MUX_rd_out <= 5'd0;
		MUX_rt_out <= 5'd0;
		ALUop_out <= 2'd0;
		RegDst_out <= 1'b0;
		ALUSrc_out <= 1'b0;
		MemtoReg_out <= 1'b0;
		RegWrite_out <= 1'b0;
		MemRead_out <= 1'b0;
		MemWrite_out <= 1'b0;
		Branch_out <= 1'b0;
	end
	else begin
		ReadData1_out <= ReadData1_in;
		ReadData2_out <= ReadData2_in;
		sign_ext_out <= sign_ext_in;
		Fw_rs_out <= Fw_rs_in;
		Fw_rt_out <= Fw_rt_in;	
		MUX_rd_out <= MUX_rd_in;
		MUX_rt_out <= MUX_rt_in;
		ALUop_out <= ALUop_in;
		RegDst_out <= RegDst_in;
		ALUSrc_out <= ALUSrc_in;
		MemtoReg_out <= MemtoReg_in;
		RegWrite_out <= RegWrite_in;
		MemRead_out <= MemRead_in;
		MemWrite_out <= MemWrite_in;
		Branch_out <= Branch_in;
	end
end

endmodule
