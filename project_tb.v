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
Reg_File[17] <= 32'h00000000;
Reg_File[18] <= 32'h00000000;
Reg_File[19] <= 32'h00000000;
Reg_File[29] <= 32'h00000000; //change this address to stack pointer 
end

always @(posedge Clock)
begin
if(Reg_Write)
Reg_File[Write_Reg] <= Write_Data;
end

always @(negedge Clock)
begin
Read_Data_1 <= Reg_File[Read_Reg_1];
Read_Data_2 <= Reg_File[Read_Reg_2];
end
endmodule

module Register_File(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);

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
Reg_File[17] <= 32'h00000000;
Reg_File[18] <= 32'h00000000;
Reg_File[19] <= 32'h00000000;
Reg_File[20] <= 32'h00000000;
Reg_File[29] <= 32'h00000000; //change this address to stack pointer 
end

always @(posedge Clock)
begin
if(Reg_Write)
Reg_File[Write_Reg] <= Write_Data;
end

always @(negedge Clock)
begin
Read_Data_1 <= Reg_File[Read_Reg_1];
Read_Data_2 <= Reg_File[Read_Reg_2];
end
endmodule

module Control(Reg_Dst,Branch,Mem_Read,Mem_to_Reg,ALU_Op,Mem_Write,ALU_Src,Reg_Write,Inst_31_26,reset);

output reg Reg_Dst,Branch,Mem_Read,Mem_to_Reg,Mem_Write,ALU_Src,Reg_Write;
output reg[1:0] ALU_Op;
input [5:0] Inst_31_26;
input reset;

always
begin

	if(reset == 1'b1) 
	begin
		Reg_Dst<=1'b0;
		Branch<=1'b0;
		Mem_Read<=1'b0;
		Mem_to_Reg<=1'b0;
		Mem_Write<=1'b0;
		ALU_Src<=1'b0;
		Reg_Write<=1'b0;
		ALU_Op<=2'b0;

	end

	else
	begin

		case(Inst_31_26)
			6'd0:   //R-Formate
				begin
					Reg_Dst<=1'b1;
					Branch<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=1'b0;
					Mem_Write<=1'b0;
					ALU_Src<=1'b0;
					Reg_Write<=1'b1;
					ALU_Op<=2'b10;

				end

			6'd35:  //lw
				begin
					Reg_Dst<=1'b0;
					Branch<=1'b0;
					Mem_Read<=1'b1;
					Mem_to_Reg<=1'b1;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=2'b00;



				end

			6'd43:  //sw
				begin
					Reg_Dst<=1'bx;
					Branch<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=1'bx;
					Mem_Write<=1'b1;
					ALU_Src<=1'b1;
					Reg_Write<=1'b0;
					ALU_Op<=2'b0;



				end

			6'd8: 	//addi
				begin
					Reg_Dst<=1'b0;
					Branch<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=1'b0;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=2'b00;
				end

			/*6'd12:	//andi
				begin
					Reg_Dst<=1'b0;
					Branch<=1'b0;
					Mem_Read<=1'b0;
					Mem_to_Reg<=1'b0;
					Mem_Write<=1'b0;
					ALU_Src<=1'b1;
					Reg_Write<=1'b1;
					ALU_Op<=2'b00;
				end
*/
			
				

		endcase
	end

end

endmodule
module ALU(Read_Data_1, Alu_Src_Output, ALUctrl , Alu_Result ,Zero);

input  wire signed [31:0] Read_Data_1;
input  wire signed [31:0] Alu_Src_Output;
input  wire signed [3:0] ALUctrl;
output reg   [31:0] Alu_Result;
input  wire Zero;

localparam AND = 4'b0000;
localparam OR  = 4'b0001;
localparam ADD = 4'b0010;
localparam SUB = 4'b0110;
localparam SLT = 4'b0111;
localparam NOR = 4'b1100;

assign Zero = ( Read_Data_1 == Alu_Src_Output);
always@(Read_Data_1,Alu_Src_Output,ALUctrl)
begin 

	case(ALUctrl)
	AND: Alu_Result <= Read_Data_1 &  Alu_Src_Output ;
	OR : Alu_Result <= Read_Data_1 |  Alu_Src_Output ;
	ADD: Alu_Result <= Read_Data_1 +  Alu_Src_Output ;
	SUB: Alu_Result <= Read_Data_1 -  Alu_Src_Output ;
	SLT: Alu_Result <=(Read_Data_1 <  Alu_Src_Output);
	NOR: Alu_Result <= ~(Read_Data_1 | Alu_Src_Output) ;
	default : $display ("ERROR_NOT_RAY2 CODE: %b",ALUctrl);
	endcase
end

endmodule


module Test_ALU_Ray2;
localparam AND = 4'b0000;
localparam OR  = 4'b0001;
localparam ADD = 4'b0010;
localparam SUB = 4'b0110;
localparam SLT = 4'b0111;
localparam NOR = 4'b1100;

reg  signed[31:0] in1;
reg  signed[31:0] in2;
reg  signed[3:0]  ctrl;
wire [31:0] result;
wire zero;

initial
begin
$monitor ("in1=%d in2=%d ctrl=%b result=%d zero=%b",in1,in2,ctrl,result,zero);

#1
in1 = 50;
in2 =20;
ctrl = ADD;

#1
in1 = 50;
in2 =20;
ctrl = NOR;
#1
in1 = 50;
in2 =20;
ctrl = SLT;
#1
in1 = 50;
in2 =55;
ctrl = SLT;

end

ALU test_ray2(in1, in2, ctrl , result ,zero);


endmodule

module ALU_Control(Alu_Signal,Alu_OP,Inst_5_0);
output reg[3:0] Alu_Signal; // signal going to ALU can be modified to more bits when adding more instr 
input [1:0] Alu_OP;  // coming from control unit
input [5:0] Inst_5_0;  //funct field in instr

always @(Alu_OP or Inst_5_0)  // to make sure when any input change;
begin                         // operations are executed from begining;
if(Alu_OP==2'b00)// sw or lw --> add
Alu_Signal <= 4'b0010; 
else if(Alu_OP==2'b01) //beq
Alu_Signal <= 4'b0110;
else if(Alu_OP==2'b10)   //incase (10) indicate we have R_format; 
begin                    //so we diffrentiate using funct field in instr;
case (Inst_5_0)
6'b100000:Alu_Signal <= 0010;  //add
6'b100010:Alu_Signal <= 0110;  //subtract
6'b100100:Alu_Signal <= 0000;  //AND
6'b100000:Alu_Signal <= 0010;  //OR
6'b101010:Alu_Signal <= 0111;  //slt
endcase
end
end
endmodule 

module pr_tb()

RegFile anwar(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);

ALU_Control(Alu_Signal,Alu_OP,Inst_5_0);
ALU(Read_Data_1, Alu_Src_Output, ALUctrl , Alu_Result ,Zero);
endmodule
