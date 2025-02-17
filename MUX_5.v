module MUX_5(A, B, Sel, S);
input [4:0] A, B;
input Sel;
output [4:0] S;
//選擇 Register destination 是 rd還是rt
assign S = (Sel == 1'b0) ? A : B;

endmodule
