//在快遞公司(forwarding)跟原本的資料做選擇，再送到ALU
module MUX_Forwarding(bus_ID, bus_EX, bus_MEM, Forward, bus_out);
input [31:0] bus_ID, bus_EX, bus_MEM;
input [1:0] Forward;
output [31:0] bus_out;

assign bus_out = (Forward == 2'b10)?bus_MEM:(Forward == 2'b01)?bus_EX:bus_ID;

endmodule
