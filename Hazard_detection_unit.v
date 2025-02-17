module Hazard_detection_unit(IF_ID_rs, IF_ID_rt, ID_EX_rt, ID_EX_MemRead, PC_Write, IF_ID_Write, Control_Write);
//Hazard_Detection_unit要偵測data hazard也就是說lw要接著ALU的運算forwarding會來不及
//IF_ID_rs lw下一個指令要讀取的rs
//IF_ID_rt lw下一個指令要讀取的rt
//ID_EX_rt lw要寫入的暫存器
//lw MemRead 才會為 1
input [4:0] IF_ID_rs, IF_ID_rt, ID_EX_rt;
input ID_EX_MemRead;
output PC_Write, IF_ID_Write, Control_Write;
//PC_Write, Program counter的控制信號
//Control_Write作為MUX的控制信號
reg PC_Write, IF_ID_Write, Control_Write;

always @(*)begin
	if((ID_EX_MemRead == 1) && ((ID_EX_rt == IF_ID_rs) | (ID_EX_rt == IF_ID_rt))) begin
		PC_Write <= 1'b0;
		IF_ID_Write <= 1'b0;
		Control_Write <= 1'b0;
	end
	else begin
		PC_Write <= 1'b1;
		IF_ID_Write <= 1'b1;
		Control_Write <= 1'b1;
	end
end

endmodule
