module MIPS_Pipeline(clk, reset, ALUResult, Read_Data1, Read_Data2, Address_in_PC, Address_out_PC, Address_Add_PC, Inst, Read_Data_Mem);
input clk, reset;
//ALU運算後的結果
output [31:0] ALUResult;
//暫存器讀出來的rs和rt
output [31:0] Read_Data1;
output [31:0] Read_Data2;
//PC暫存器in 和 out
output [31:0] Address_in_PC;
output [31:0] Address_out_PC;
//PC+4的結果
output [31:0] Address_Add_PC;
//Instruction memory讀出來的指令
output [31:0] Inst;
//Data memory讀出來的data
output [31:0] Read_Data_Mem;

wire [4:0]WriteReg;
//選擇rt or rd
wire RegDst;
//選擇 bus2或是sign-extentsion後的immediate
wire ALUSrc;
//選擇data memory讀出來的資料寫回register(lw) 或是 ALU的運算結果寫回register(r-format)
wire MemtoReg;
//控制register能不能寫入
wire RegWrite;
//控制data memory能不能讀出data
wire MemRead;
//控制data memory能不能寫入data
wire MemWrite;
//branch會和zero and後控制地址要不要跳
wire Branch;
//大哥控制小弟(Controller控制ALUCtrl)
wire [1:0] ALUop;
//Zero
wire Zero;
//控制要不要branch
wire BranchZero;
//偵測到hazard IF_ID後要原地踏步
wire PCWrite;
//controller給出還沒跟zero bit做判斷
wire IF_Flush_nojudge;
//控制 IF_ID pipeline register要不要Flush，由controller和zero bit and後給出
wire IF_Flush;
//控制 IF_ID pipeline register能不能write，由Hazard_detection_unit給出
wire IF_ID_Write;
//IF_ID 輸出的Inst
wire [31:0] Inst_IF_ID;
//IF_ID 輸出的PC
wire [31:0] PC_IF_ID;
//Control_Write
wire Control_Write;

//ALUResult 和 Read_Data_Mem MUX過後的結果
wire [31:0] WriteData;
//Sign extentsion過後的結果
wire [31:0] Sign_ext;
//左移兩位的結果
wire [31:0] Sign_out;
//Branch_Addr = pc+4 + sign_out
wire [31:0] Branch_Addr;
//選擇完branch address 或 pc+4後的結果
wire [31:0] Branch_PC4;
//ALU control 來控制 ALU的
wire [3:0] ALUctr;
//ID_EX pipeline input和output stage2
wire [31:0] ReadData1_ID;
wire [31:0] ReadData2_ID;
wire [31:0] Sign_ext_ID;
wire [4:0] Fw_rs;
wire [4:0] Fw_rt;
wire [4:0] MUX_rd;
wire [4:0] MUX_rt;
wire RegDst_ID;
wire ALUSrc_ID;
wire MemtoReg_ID;
wire RegWrite_ID;
wire MemRead_ID;
wire MemWrite_ID;
wire Branch_ID;
wire [1:0]ALUop_ID;

//stage3 
wire [31:0] ALU_A;//經過MUX到ALU input A
wire [31:0] ALU_B;//經過MUX到ALU input B
wire [31:0] DataorSign; //Read_Data2和sign extentsion mux後的結果
wire [4:0] rw; //寫回rt還是rd
//stage 3 forwarding unit
wire [1:0] F_Ctrl_A;
wire [1:0] F_Ctrl_B;

//EX_MEM pipeline input和output stage 4
wire MemtoReg_EX;
wire RegWrite_EX;
wire MemRead_EX;
wire MemWrite_EX;
wire [31:0] ALUResult_EX;
wire [31:0] busB_EX;
wire [4:0] rw_ex;//要寫回rt還是rd選完的值
//stage 4
wire [31:0] ReadData_MEM;
wire [31:0] ALUResult_MEM;
//選擇data memory讀出來的資料寫回register(lw) 或是 ALU的運算結果寫回register(r-format)
wire MemtoReg_MEM;
//控制register能不能寫入
wire RegWrite_MEM;	

//Controller
//Control_Write在data hazard發生時等於0，控制信號都要清0
Controller C1(.op(Inst_IF_ID[31:26]), .Control_Write(Control_Write), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .ALUop(ALUop), .IF_Flush(IF_Flush_nojudge));
//偵查hazard並給出控制指令
Hazard_detection_unit Hazard_detection_unit_1(.IF_ID_rs(Inst_IF_ID[25:21]), .IF_ID_rt(Inst_IF_ID[20:16]), .ID_EX_rt(Fw_rs), .ID_EX_MemRead(MemRead_ID), .PC_Write(PCWrite), .IF_ID_Write(IF_ID_Write), .Control_Write(Control_Write));

//stage 1
//PC暫存器
PC PC1(.clk(clk), .reset(reset), .PCWrite(PCWrite), .addr_in(Address_in_PC), .addr_out(Address_out_PC));
//PC+4
PC_Add PC_Add1(.pc_in(Address_out_PC), .pc_out(Address_Add_PC));
//選擇PC+4還是branch地址
MUX_32 MUX_32_1(.A(Address_Add_PC), .B(Branch_Addr), .Sel(BranchZero), .S(Address_in_PC));
//Instruction Memory
Inst_Mem Inst_Mem1(.addr_in(Address_out_PC), .inst_out(Inst));
//IF_ID pipeline暫存器
IF_ID IF_ID_1(.clk(clk), .reset(reset), .Inst_in(Inst), .PC_in(Address_Add_PC), .IF_Flush(IF_Flush), .IF_ID_Write(IF_ID_Write), .Inst_out(Inst_IF_ID), .PC_out(PC_IF_ID));

//stage 2
ADD_Addr ADD_Addr_1(.Addr1(Sign_out), .Addr2(PC_IF_ID), .Addr_out(Branch_Addr));
//branch 要跳的地址是PC+4和immediate sign_extentsion再乘4,相加
Sign_Extend Sign_Extend_1(.Din(Inst_IF_ID[15:0]), .Dout(Sign_ext));
Shift_Left2 Shift_Left2(.Din(Sign_ext), .Dout(Sign_out));
//Registers
Registers Registers(.clk(clk), .ReadReg1(Inst_IF_ID[25:21]), .ReadReg2(Inst_IF_ID[20:16]), .WriteReg(WriteReg), .WriteData(WriteData), .ReadData1(Read_Data1), .ReadData2(Read_Data2), .RegWrite(RegWrite_MEM));
//給Branch指令判斷是不是一樣
Detect_zero Detect_zero(.busA(Read_Data1), .busB(Read_Data2), .zero(Zero));

assign IF_Flush = Zero & IF_Flush_nojudge;
assign BranchZero = Branch & Zero;

//stage 3
ID_EX ID_EX_1(.clk(clk), .reset(reset), 
.ReadData1_in(Read_Data1), .ReadData2_in(Read_Data2), .sign_ext_in(Sign_ext), 
.ReadData1_out(ReadData1_ID), .ReadData2_out(ReadData2_ID), .sign_ext_out(Sign_ext_ID),

.Fw_rs_in(Inst_IF_ID[25:21]), .Fw_rt_in(Inst_IF_ID[20:16]), .MUX_rd_in(Inst_IF_ID[15:11]), .MUX_rt_in(Inst_IF_ID[20:16]),
.Fw_rs_out(Fw_rs), .Fw_rt_out(Fw_rt), .MUX_rd_out(MUX_rd), .MUX_rt_out(MUX_rt),

.RegDst_in(RegDst), .ALUSrc_in(ALUSrc), .MemtoReg_in(MemtoReg), .RegWrite_in(RegWrite), 
.MemRead_in(MemRead), .MemWrite_in(MemWrite), .Branch_in(Branch), .ALUop_in(ALUop),

.RegDst_out(RegDst_ID), .ALUSrc_out(ALUSrc_ID), .MemtoReg_out(MemtoReg_ID), .RegWrite_out(RegWrite_ID), 
.MemRead_out(MemRead_ID), .MemWrite_out(MemWrite_ID), .Branch_out(Branch_ID), .ALUop_out(ALUop_ID)
);


MUX_Forwarding MUX_Forwarding_A(.bus_ID(ReadData1_ID), .bus_EX(ALUResult_EX), .bus_MEM(WriteData), .Forward(F_Ctrl_A), .bus_out(ALU_A));
MUX_32 MUX_32_2(.A(ReadData2_ID), .B(Sign_ext_ID), .Sel(ALUSrc_ID), .S(DataorSign));
MUX_Forwarding MUX_Forwarding_B(.bus_ID(DataorSign), .bus_EX(ALUResult_EX), .bus_MEM(WriteData), .Forward(F_Ctrl_B), .bus_out(ALU_B));
//選擇write back的register
MUX_5 MUX_5_1(.A(MUX_rt), .B(MUX_rd), .Sel(RegDst_ID), .S(rw));
//ALUCtrl
ALUCtrl ALUCtrl(.ALUop(ALUop_ID), .Func(Sign_ext_ID[5:0]), .ALUctr(ALUctr));
//ALU
ALU ALU(.A(ALU_A), .B(ALU_B), .ALUCtrl(ALUctr), .Zero(), .ALUResult(ALUResult));
//Forwarding unit
Forwarding_unit Forwarding_unit(.ID_EX_rs(Fw_rs), .ID_EX_rt(Fw_rt), .EX_MEM_rw(rw_ex), .MEM_WB_rw(WriteReg), .EX_MEM_RegWrite(RegWrite_EX), .MEM_WB_RegWrite(RegWrite_MEM), .F_Ctrl_A(F_Ctrl_A), .F_Ctrl_B(F_Ctrl_B));

//stage 4
//EX_MEM pipeline register
EX_MEM EX_MEM(.clk(clk), .reset(reset), .MemtoReg_in(MemtoReg_ID), .RegWrite_in(RegWrite_ID), .MemRead_in(MemRead_ID), .MemWrite_in(MemWrite_ID), .ALU_Result_in(ALUResult), .busB_in(ReadData2_ID), .RW_in(rw),
					.MemtoReg_out(MemtoReg_EX), .RegWrite_out(RegWrite_EX), .MemRead_out(MemRead_EX), .MemWrite_out(MemWrite_EX), .ALU_Result_out(ALUResult_EX), .busB_out(busB_EX), .RW_out(rw_ex));
Data_Mem Data_Mem(.clk(clk), .Addr_in(ALUResult_EX), .WriteData(busB_EX), .ReadData(Read_Data_Mem), .MemWrite(MemWrite_EX), .MemRead(MemRead_EX));

//stage 5
//MEM_WB pipeline register
MEM_WB MEM_WB(.clk(clk), .reset(reset), .ReadData_in(Read_Data_Mem), .ALU_Result_in(ALUResult_EX), .rw_in(rw_ex), .MemtoReg_in(MemtoReg_EX), .RegWrite_in(RegWrite_EX), 
					.ReadData_out(ReadData_MEM), .ALU_Result_out(ALUResult_MEM), .rw_out(WriteReg), .MemtoReg_out(MemtoReg_MEM), .RegWrite_out(RegWrite_MEM));

MUX_32 MUX_32_3(.A(ALUResult_MEM), .B(ReadData_MEM), .Sel(MemtoReg_MEM), .S(WriteData));
					
endmodule
