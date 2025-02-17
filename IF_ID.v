module IF_ID(clk, reset, Inst_in, PC_in, IF_Flush, IF_ID_Write, Inst_out, PC_out);
input clk, reset, IF_Flush, IF_ID_Write;
input [31:0] Inst_in, PC_in;
output [31:0] Inst_out, PC_out;

reg [31:0] Inst_out, PC_out;

always @(posedge clk or negedge reset) begin
	if(!reset)begin
		PC_out <= 32'd0;
		Inst_out <= 32'd0;
	end
	else if(IF_Flush)begin
		PC_out <= 32'd0;
		Inst_out <= 32'd0;
	end
	else if(IF_ID_Write) begin
		PC_out <= PC_in;
		Inst_out <= Inst_in;
	end
	else begin
      PC_out <= PC_out; // 保持原值
      Inst_out <= Inst_out;
   end
end

endmodule
