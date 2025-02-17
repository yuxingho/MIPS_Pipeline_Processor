module Detect_zero(busA, busB, zero);//給control hazard比較是否相等
input [31:0] busA, busB;
output zero;

assign zero=(busA==busB)?1:0;

endmodule
