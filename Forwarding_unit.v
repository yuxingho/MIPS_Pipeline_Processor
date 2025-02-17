module Forwarding_unit(ID_EX_rs, ID_EX_rt, EX_MEM_rw, MEM_WB_rw, EX_MEM_RegWrite, MEM_WB_RegWrite, F_Ctrl_A, F_Ctrl_B);
input [4:0] ID_EX_rs, ID_EX_rt, EX_MEM_rw, MEM_WB_rw;
input EX_MEM_RegWrite, MEM_WB_RegWrite;
output reg [1:0] F_Ctrl_A, F_Ctrl_B;

always @(*)begin
	F_Ctrl_A = 2'b00;
	F_Ctrl_B = 2'b00;
	if(EX_MEM_RegWrite & (EX_MEM_rw != 5'd0) & (EX_MEM_rw == ID_EX_rs)) // EX_MEM pipeline寫回去暫存器的值控制信號是01
		F_Ctrl_A = 2'b01;
	else if((MEM_WB_RegWrite & (MEM_WB_rw != 5'd0) & (MEM_WB_rw == ID_EX_rs)))// MEM_WB pipeline寫回去暫存器的值控制信號是10
		F_Ctrl_A = 2'b10;
	else
		F_Ctrl_A = 2'b00;
		
	if(EX_MEM_RegWrite & (EX_MEM_rw != 5'd0) & (EX_MEM_rw == ID_EX_rt))
		F_Ctrl_B = 2'b01;
	else if((MEM_WB_RegWrite & (MEM_WB_rw != 5'd0) & (MEM_WB_rw == ID_EX_rt)))
		F_Ctrl_B = 2'b10;
	else
		F_Ctrl_B = 2'b00;
end

endmodule
