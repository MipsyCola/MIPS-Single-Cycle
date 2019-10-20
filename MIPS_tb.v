`include "control.v"
`include "ALU.v"
`include "AluControl.v"
`include "pc_pcAdder_InsMem.v"
`include "regFile.v"
`include "dataMemory.v"
`include "signExtend.v"
`include "mux.v"
`include "shiftLeft.v"
`include "clock.v"

module full_house_tb();

wire Clock;
Clock_Gen myClock(Clock);

wire[31:0] pcOut, pcIn;
wire eof;
PC myPC(pcOut, pcIn, eof);

wire[31:0] PCplus;
plus_f_adder pcAdd(PCplus, pcOut, Clock);

wire[31:0] instruction;
Instruction_memory insMemory(instruction, Clock, pcOut);

wire  Branch, Branch_Not_Equal, Mem_Read, Mem_Write, ALU_Src, Reg_Write, Jump, reset;
wire[1:0] Mem_to_Reg, Reg_Dst;
wire[2:0] ALU_Op;
Control controlGod(Reg_Dst, Branch, Branch_Not_Equal, Mem_Read, Mem_to_Reg, ALU_Op, Mem_Write, ALU_Src, Reg_Write ,instruction[31:26] , Jump, reset);


reg [4:0] ra;
wire [4:0] Write_Reg;
MUX_5_2 mux5(instruction[20:16], instruction[15:11], ra, Write_Reg, Reg_Dst);

wire[4:0] Read_Reg_1, Read_Reg_2;
wire[31:0] Write_Data,Read_Data_1, Read_Data_2;
RegFile myRegFile(Read_Data_1, Read_Data_2, instruction[25:21], instruction[20:16], Write_Reg, Write_Data, jr_and_output, Clock);

wire[31:0] Sign_Ext_Output;
Sign_Extend extender(Sign_Ext_Output, instruction[15:0]);

wire[31:0] Alu_Src_Output;
MUX_32_1 aluIN_mux(Read_Data_2, Sign_Ext_Output, Alu_Src_Output, ALU_Src);

wire[3:0] ALUctrl; 
wire JR_Signal;
ALU_Control aluCtrl(ALUctrl, ALU_Op, instruction[5:0], JR_Signal);

wire[31:0] Alu_Result;
wire Zero;
ALU theALU(Read_Data_1, Alu_Src_Output, ALUctrl, Alu_Result, Zero, instruction[10:6]);

wire[31:0] Read_Data;
Data_Memory myMemory(Read_Data, Mem_Write, Mem_Read, Alu_Result, Read_Data_2, Clock, eof);

MUX_32_2 datamemory_mux(Alu_Result, Read_Data,branchAdded, Write_Data, Mem_to_Reg);

wire[31:0] brAddIN;
Shift_Left_32 shift_sign(brAddIN, Sign_Ext_Output);

branch_adder brAdder(branchAdded, PCplus, brAddIN);


/********Branch equal and not equal handling******/
wire beq_and_output,bne_and_output,bne_not_output,branch_or_output;
and  beq_and( beq_and_output,Branch,Zero);
and  bne_and(bne_and_output,Branch_Not_Equal,bne_not_output);
not  bne_not(Zero,bne_not_output);
or   branch_or(branch_or_output,bne_and_output,beq_and_output);
/**************************************************/

wire[31:0] PcSrcOUT;
MUX_32_1 pcsrc_mux(PCplus,branchAdded, PcSrcOUT, branch_or_output);

wire [27:0] jumpin;
wire [31:0]pc_mux_output;
Shift_Left_26 shift_add(jumpin, instruction[25:0]);

MUX_32_1 pc_mux(PcSrcOUT, {PCplus[31:28],jumpin}, pc_mux_output, Jump);

/********jump register handling******/
not jr_not(jr_not_output,JR_Signal);
and jr_and(jr_and_output,Reg_Write,jr_not_output);
MUX_32_1 jr_mux(pc_mux_output, Read_Data_1,pcIn,JR_Signal);
/************************************/

/*******jal instruction handling******/

/*************************************/
initial
begin
ra <= 5'd31;
end
endmodule
