module plus_f_adder (PCplus , pc,clk);
output reg[12:0] PCplus;
input wire clk;
input wire[12:0] pc;
integer file ;
always @(posedge clk) 
begin 
	PCplus <= pc +1;
end
endmodule

module PC( output1, input_pc ,end_program);
input wire[12:0] input_pc;
output reg[12:0] output1;

output reg end_program;
integer file ,size, _ ;
initial 
begin

// ========================= for Size Calculation ============================
size = 0;
file = $fopen("ins.txt","r");
while (! $feof (file) )
	begin
	_ = $fscanf (file,"%b",_);
	size = size +1;
	end
$display ("SIZE === %d ",size);
// ============================================================================

end

always@(input_pc)
begin 
output1 <= input_pc; 
if(input_pc > size )
	begin
	$display ("end_program will save the memory data and exit the verilog program ");
	end_program = 1 ;
	end
end
endmodule

module Instruction_memory(instruction,clk,pc);
output reg[31:0] instruction;
input [12:0] pc;
input clk;
reg[31:0] Imem[0:8191]; // 32KB memory ehich is 8192 register each one is 32bit 
reg[31:0] i;
integer file;
integer _ ;
integer size;

initial 
begin 
$readmemb("ins.txt",Imem);

end

always @(posedge clk )
begin 
	instruction <= Imem[pc]; 
end

endmodule

module Control(Reg_Dst,Branch,Branch_Not_Equal,Mem_Read,Mem_to_Reg,ALU_Op,Mem_Write,ALU_Src,Reg_Write,Inst_31_26,Jump,reset);

	output reg  Branch,Branch_Not_Equal,Mem_Read,Mem_Write,ALU_Src,Reg_Write,Jump;
	output reg  [1:0] Mem_to_Reg,Reg_Dst;
	output reg  [2:0] ALU_Op;
	input  wire [5:0] Inst_31_26;
	input  wire reset;

	always@(Inst_31_26 or posedge reset) // if any of instruction opcode changes or postive edge of reset comes
	begin
		if(reset == 1'b1) 
		begin
			Reg_Dst<=2'b00;
			Branch<=1'b0;
			Branch_Not_Equal<=1'b0;
			Jump<=1'b0;
			Mem_Read<=1'b0;
			Mem_to_Reg<=2'b00;
			Mem_Write<=1'b0;
			ALU_Src<=1'b0;
			Reg_Write<=1'b0;
			ALU_Op<=3'b000;

		end
		else
		begin
			case(Inst_31_26)

				6'd0:     //R-Formate
				begin
					Reg_Dst<=2'b01;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b0;
					Reg_Write<=1'b1;
					ALU_Op<=3'b010;

				end
				6'd35:     //lw
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b1;
					Mem_to_Reg<=2'b01;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b000;
				end
				6'd43:  //sw
				begin
					Reg_Dst<=2'bxx;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'bxx;
					Mem_Write<=1'b1;
					ALU_Src<=1'b1;
					Reg_Write<=1'b0;
					ALU_Op<=3'b000;
				end
				6'd8: 	//addi
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b000;
				end
				6'd12:	//andi
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b011;
				end
				6'd13:	//ori
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b100;
				end	
				6'd10:	//stli
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b101;
				end	
				6'd14:	//xori
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b110;
				end	
				6'd5:	//bne
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b1;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b110;
				end
				6'd2:	//jump
				begin
					Reg_Dst<=2'bxx;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b1;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'bxx;
					Mem_Write<=1'b0;
					ALU_Src<=1'bx;
					Reg_Write<=1'b0;
					ALU_Op<=3'bxxx;
				end	
				6'd3:	//jal
				begin
					Reg_Dst<=2'b10;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b1;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b10;
					Mem_Write<=1'b0;
					ALU_Src<=1'bx;
					Reg_Write<=1'b1;
					ALU_Op<=3'bxxx;
				end	
				6'd15:	//lui
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b111;
				end	
				6'd32:	//lb
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b111;
				end
				6'd33:	//lh
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b111;
				end
				6'd40:	//sb
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b111;
				end
				6'd41:	//sh
				begin
					Reg_Dst<=2'b00;
					Branch<=1'b0;
					Branch_Not_Equal<=1'b0;
					Jump<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=2'b00;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=3'b111;
				end			
		endcase
	end
end
endmodule
module RegFile(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);

input wire[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
input wire[31:0] Write_Data;
input Reg_Write, Clock;
output reg[31:0] Read_Data_1, Read_Data_2;

reg[31:0] Reg_File[0:31];

initial
begin
Reg_File[0] <= 32'h00000000; //zero register
Reg_File[1] <= 32'h00000000;
Reg_File[2] <= 32'h00000000;
Reg_File[3] <= 32'h00000000;
Reg_File[4] <= 32'h00000000;
Reg_File[5] <= 32'h00000000;
Reg_File[6] <= 32'h00000000;
Reg_File[7] <= 32'h00000000;
Reg_File[8] <= 32'h00000000;
Reg_File[9] <= 32'h00000000;
Reg_File[10] <= 32'h00000000;
Reg_File[11] <= 32'h00000000;
Reg_File[12] <= 32'h00000000;
Reg_File[13] <= 32'h00000000;
Reg_File[14] <= 32'h00000000;
Reg_File[15] <= 32'h00000000;
Reg_File[16] <= 32'h00000000;
Reg_File[17] <= 32'h00000002;
Reg_File[18] <= 32'h00000001;
Reg_File[19] <= 32'h00000000;
Reg_File[29] <= 32'h00000000; //change this address to stack pointer 
end

always @(posedge Clock)
begin
if(Reg_Write)
Reg_File[Write_Reg] <= Write_Data;
$display ("Write_Data=%b",Write_Data);
end

always @(negedge Clock)
begin
Read_Data_1 <= Reg_File[Read_Reg_1];
Read_Data_2 <= Reg_File[Read_Reg_2];
$display ("Read_Reg_1=%b",Read_Reg_1);
$display ("Read_Reg_2=%b",Read_Reg_2);
end
endmodule
module Sign_Extend(Sign_Ext_Output, Inst_15_0);
input wire[15:0] Inst_15_0;
output reg[31:0] Sign_Ext_Output;

always @(Inst_15_0)
begin
if(Inst_15_0[15] == 1)
Sign_Ext_Output = Inst_15_0 | 32'hffff0000;
else if (Inst_15_0[15] == 0)
Sign_Ext_Output = Inst_15_0 | 32'h00000000;
else
Sign_Ext_Output =0'bx;
end
endmodule
module MUX_5_2(in0,in1,ra,Write_Register,RegDst);

input  wire [4:0] in0,in1,ra;
output reg  [4:0] Write_Register;
input wire [1:0]RegDst;

always@(in0,in1,RegDst)
begin 
	if(RegDst == 0)
	begin
	Write_Register <= in0;
	end

	else if (RegDst == 1)
	begin
	Write_Register <= in1;
	end

	else if (RegDst == 2)
	begin
	Write_Register <= ra;
	end

	else 
	begin
	$display ("RegDst: %b",RegDst);
	end
end
endmodule
module MUX_32_1(input_0,input1,output_mux,selector);

input  wire [31:0] input_0;
input  wire [31:0] input1;
output reg  [31:0] output_mux;
input wire selector;

always@(input_0,input1,selector)
begin 
	if(selector == 0)
	begin
	output_mux <= input_0;
	end

	else if (selector == 1)
	begin
	output_mux <= input1;
	end

	else 
	begin
	$display ("selector: %b",selector);
	end
end

endmodule

module MUX_32_2(input_0,input1,input2,output_mux,selector);

input  wire [31:0] input_0;
input  wire [31:0] input1;
input  wire [31:0] input2;

output reg  [31:0] output_mux;
input wire[1:0] selector;

always@(input_0,input1,selector)
begin 
	if(selector == 0)
	begin
	output_mux <= input_0;
	end

	else if (selector == 1)
	begin
	output_mux <= input1;
	end
	
	else if (selector == 2)
	begin
	output_mux <= input2;
	end

	else 
	begin
	$display ("selector: %b",selector);
	end
end

endmodule
module ALU_Control(Alu_Signal, Alu_OP, Inst_5_0,JR_Signal);
	output reg[3:0] Alu_Signal;	 // signal going to ALU can be modified to more bits when adding more instr 
	output reg JR_Signal;
	input wire[2:0] Alu_OP; 	// coming from control unit
	input wire[5:0] Inst_5_0;  	//funct field in instr

	always @(Alu_OP or Inst_5_0)  	// to make sure when any input change;
	begin                         	// operations are executed from begining;
		if(Alu_OP==3'b000)	// sw or lw --> add or addi
		begin
			Alu_Signal <= 4'b0010; 
		end

		else if(Alu_OP==3'b001) // sub for beq
		begin
			Alu_Signal <= 4'b0110;
		end

		else if(Alu_OP==3'b011) // andi
		begin
			Alu_Signal <= 4'b0000;
		end

		else if(Alu_OP==3'b100) // ori
		begin
			Alu_Signal <= 4'b0001;
		end

		else if(Alu_OP==3'b101) // slti
		begin
			Alu_Signal <= 4'b0111;
		end

		else if(Alu_OP==3'b110) // xori
		begin
			Alu_Signal <= 4'b0011;
		end

		else if(Alu_OP==3'b111) // lui
		begin
			Alu_Signal <= 4'b1010;
		end

		else if(Alu_OP==3'b010)   //Incase (010) indicate we have R_FORMATE inst; 
		begin                    //so we diffrentiate using funct field in instr;
			if(Inst_5_0==6'b001000)
			begin
				JR_Signal <= 1'b1;
			end
			else
			begin
			JR_Signal <= 1'b0;
			case (Inst_5_0)
				6'b100000:Alu_Signal <= 4'b0010;  //add
				6'b100010:Alu_Signal <= 4'b0110;  //subtract
				6'b100100:Alu_Signal <= 4'b0000;  //AND
				6'b100101:Alu_Signal <= 4'b0001;  //OR
				6'b101010:Alu_Signal <= 4'b0111;  //slt 
				6'b100110:Alu_Signal <= 4'b0011;  //xor
				6'b100111:Alu_Signal <= 4'b1100;  //nor
				6'b000000:Alu_Signal <= 4'b0100;  //sll
				6'b000010:Alu_Signal <= 4'b1000;  //srl
				6'b000011:Alu_Signal <= 4'b1001;  //sra
			endcase
			end
		end
	end
endmodule
module ALU(Read_Data_1,Alu_Src_Output,ALUctrl,Alu_Result,Zero,Inst_10_6);

	input  wire signed [31:0] Read_Data_1;
	input  wire signed [31:0] Alu_Src_Output;
	input  wire [3:0] ALUctrl;
	input  wire [4:0] Inst_10_6;
	output reg  signed [31:0] Alu_Result;
	output reg  Zero;

	localparam AND  = 4'b0000;
	localparam OR   = 4'b0001;
	localparam ADD  = 4'b0010;
	localparam XOR  = 4'b0011;
	localparam SLL  = 4'b0100;
	localparam SUB  = 4'b0110;
	localparam SLT  = 4'b0111;
	localparam SRL  = 4'b1000;
	localparam SRA  = 4'b1001;
	localparam LUI  = 4'b1010;
	//localparam LB = 4'b1011;
	localparam NOR  = 4'b1100;
	//localparam LH = 4'b1101;
	//localparam SW = 4'b1110;
	//localparam SH = 4'b1111;
	//localparam  	= 4'b0101; 

	
	always@(Read_Data_1,Alu_Src_Output,ALUctrl)
	begin 
		Zero <= ( Read_Data_1 == Alu_Src_Output);
		case(ALUctrl)
			AND: Alu_Result <=  Read_Data_1 &  Alu_Src_Output ;
			OR : Alu_Result <=  Read_Data_1 |  Alu_Src_Output ;
			ADD: Alu_Result <=  Read_Data_1 +  Alu_Src_Output ;
			SUB: Alu_Result <=  Read_Data_1 -  Alu_Src_Output ;
			SLT: Alu_Result <=  (Read_Data_1 < Alu_Src_Output);
			NOR: Alu_Result <= ~(Read_Data_1 | Alu_Src_Output);
			XOR: Alu_Result <=   Read_Data_1 ^ Alu_Src_Output ;
			SLL: Alu_Result <=   Alu_Src_Output << Inst_10_6  ;
			SRL: Alu_Result <=   Alu_Src_Output >> Inst_10_6  ;
			SRA: Alu_Result <=   Alu_Src_Output >>>Inst_10_6  ;
			LUI: Alu_Result <=   Alu_Src_Output << 16  ;
			default : $display ("ERROR_NOT_RAY2 ALUctrl: %b",ALUctrl);
		endcase
	end
endmodule
module Shift_Left_26(Shifted_Output, Inst_25_0);
input wire[25:0] Inst_25_0;
output reg[27:0] Shifted_Output;

always @(Inst_25_0)
begin
Shifted_Output <= (Inst_25_0 << 2);
end

endmodule
module Shift_Left_32(Shifted_Output, signextend);
input wire[31:0] signextend;
output reg[31:0] Shifted_Output;

always @(signextend)
begin
Shifted_Output <= (signextend << 2);
end

endmodule
module Data_Memory(Read_Data,MemWrite,MemRead,Address,Write_data,clock,eof);
output reg[31:0] Read_Data;// reg wait for change value
input wire clock;
input MemWrite,MemRead;
input [31:0] Address,Write_data;
reg[31:0]write_data_storage[0:8191];// 2048 or 8192 

input wire eof;
integer file , size , i , _;
integer mem_file ;


always @(posedge eof)
begin
file = $fopen ("file.txt","w");
	for ( i = 0; i < 8191 ; i = i+1)
	begin
	if ( write_data_storage[i] !== 'hxxxx ) // don't store the garbage values in memory 
	begin $fwrite(file,"%d %d\n",i,write_data_storage[i]); 	end
	end
	$fclose(file); $display("END from data memory ya RAY2");
	$stop();
end

always @ (negedge clock)
begin 
if( MemRead == 1)
	begin
	Read_Data <= write_data_storage[Address];
	end
end

always @ (posedge clock)
begin
if(MemWrite == 1)
    	begin
	write_data_storage[Address] <= Write_data;    
	end
end

endmodule 

module Clock_Gen(Clock);
output reg Clock;
initial
begin
Clock=0;
end
always
begin
#31.25
Clock=~(Clock);
end
endmodule

module branch_adder(branchAdded, pc_and_4, sign_and_shift_out);
output reg[31:0] branchAdded;
input wire[31:0] pc_and_4, sign_and_shift_out;

always @(pc_and_4, sign_and_shift_out)
begin
branchAdded <= pc_and_4 + sign_and_shift_out;
end
endmodule


module final_tb();

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

wire[31:0] branchAdded;
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
wire jr_and_output,jr_not_output,;
not jr_not(jr_not_output,JR_Signal)
and jr_and(jr_and_output,Reg_Write,jr_not_output)
MUX_32_1 jr_mux(pc_mux_output, Read_Data_1,pcIn,JR_Signal);
/************************************/

/*******jal instruction handling******/

/*************************************/
initial
begin
ra <= 5'd31;
end
endmodule