module ADD_Addr(Addr1, Addr2, Addr_out);
//用於pc+4 or branch指令立即數和pc+4相加，也就是計算跳轉指令的address
input [31:0] Addr1, Addr2;
output [31:0] Addr_out;

assign Addr_out = Addr1 + Addr2;

endmodule