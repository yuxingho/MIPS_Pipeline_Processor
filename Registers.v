module Registers(clk, ReadReg1, ReadReg2, WriteReg, WriteData, ReadData1, ReadData2, RegWrite);
input clk, RegWrite;
input [4:0] ReadReg1;
input [4:0] ReadReg2;
input [4:0] WriteReg;
input [31:0] WriteData;
output [31:0] ReadData1;
output [31:0] ReadData2;
reg [31:0] Register[31:0];
integer i = 0;	

assign ReadData1 = Register[ReadReg1];
assign ReadData2 = Register[ReadReg2];

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        Register[i] = i; // 初始化為固定值
    end
end
always @(posedge clk)begin
	if(RegWrite) //當Ctrl Signal Write == 1 才可寫入暫存器
		Register[WriteReg] <= WriteData; // 寫入資料到指定暫存器
end

endmodule