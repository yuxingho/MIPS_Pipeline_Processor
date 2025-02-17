module MUX_32(A, B, Sel, S);
input [31:0] A, B;
input Sel;
output [31:0] S;

assign S = (Sel == 1'b0) ? A : B;

endmodule