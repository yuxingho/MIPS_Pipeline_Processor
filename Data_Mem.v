module Data_Mem(clk, Addr_in, WriteData, ReadData, MemWrite, MemRead);
input clk, MemWrite, MemRead;
input [31:0] Addr_in, WriteData;
output [31:0] ReadData;

reg [31:0] Memory [31:0];

integer i;
// 初始化記憶體（模擬用，實際硬體可能不需要）
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        Memory[i] = i; // 初始化為固定值
    end
end

always @(posedge clk)
	if(MemWrite)
		Memory[Addr_in[6:2]] <= WriteData; //因為記憶體是word address,一個address就是4個byte
	else
		Memory[Addr_in[6:2]] <= Memory[Addr_in[6:2]];

assign ReadData = (MemRead)? Memory[Addr_in[6:2]] : 32'd0;
		
endmodule