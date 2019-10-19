
module RegFile(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);
	
	output reg[31:0] Read_Data_1, Read_Data_2;

	input wire[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
	input wire[31:0] Write_Data;
	input wire Reg_Write, Clock;
	
	reg [31:0] Reg_File[0:31];
	

	initial 
	begin
		Reg_File[0]  <= 32'h00000000; //zero register
		Reg_File[1]  <= 32'h00000000;
		Reg_File[2]  <= 32'h00000000;
		Reg_File[3]  <= 32'h00000000;
		Reg_File[4]  <= 32'h00000000;
		Reg_File[5]  <= 32'h00000000;
		Reg_File[6]  <= 32'h00000000;
		Reg_File[7]  <= 32'h00000000;
		Reg_File[8]  <= 32'h00000000;
		Reg_File[9]  <= 32'h00000000;
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
	end

	always @(negedge Clock)
	begin
		Read_Data_1 <= Reg_File[Read_Reg_1];
		Read_Data_2 <= Reg_File[Read_Reg_2];
	end

endmodule











module Control(Reg_Dst,Branch,Branch_Not_Equal,Mem_Read,Mem_to_Reg,ALU_Op,Mem_Write,ALU_Src,Reg_Write,Inst_31_26,Jump,JR,reset);

	output reg  Branch,Branch_Not_Equal,Mem_Read,Mem_Write,ALU_Src,Reg_Write,Jump,JR;
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
			ALU_Op<=2'b0;

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
	/*			6'd32:	//lb
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
					*/	
				//default:			
		endcase
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
				#10
				JR_Signal <= 1'b0;
			end
			else
			begin
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
				//default:
			endcase
			end
		end
	end
endmodule





module ALU(Read_Data_1,Alu_Src_Output,ALUctrl,Alu_Result,Zero,Inst_10_6);

	input  wire signed [31:0] Read_Data_1;
	input  wire signed [31:0] Alu_Src_Output;
	input  wire [3:0] ALUctrl;
	input  wire [5:0] Inst_10_6;
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



module Data_Memory(Read_Data,MemWrite,MemRead,Address,Write_data,clock);
	output reg[31:0] Read_Data;// reg wait for change value
	input wire clock;
	input MemWrite,MemRead;
	input [31:0] Address,Write_data;
	reg[31:0] Address_lines[0:8191];
	reg[31:0]write_data_storage[0:8191];// 2048 or 8192 
	always @ (posedge clock)
	begin
		if(MemWrite)
  		 	 write_data_storage[Address] <= Write_data;
		if(MemRead)
			 Read_Data <= write_data_storage[Address];
	end
endmodule 


module PC(input_pc , output1);

	input wire[12:0] input_pc;
	output reg[12:0] output1;
	always@(input_pc)
	begin
		output1 <= input_pc;
	end
endmodule





module Instruction_memory(instruction,clk,pc);
	output reg[31:0] instruction;
	input [12:0] pc;
	input clk;
	reg[31:0] Imem[0:8191];
	integer fileMem;
	initial 
	begin
		#1
		fileMem=$fopen("F:\eslam.list","r");
		#1
		$readmemh(fileMem,Imem);
		#1
		$display(" %b",Imem[0]);
		#1
		$fclose(fileMem);
		/*Imem[0]=13'b0;
		Imem[1]=13'b0000_0000_0000_1;
		Imem[2]=13'b0000_0000_0001_0;*/

	end
	always @(posedge clk )
	begin 
		instruction <= Imem[pc]; 
		$display ("instruction: %d",Imem[pc]);
	end
endmodule

module tb_initialize_Imem();
wire[31:0] inst;
reg clk;
reg [12:0] input_PC;
wire[12:0] output_PC;
wire[12:0] outpfour;
initial 
begin 
//$monitor("%b ",inst);
#1
input_PC = 0;
clk=0;
end

always begin  #5 clk= ~clk; end

always @(outpfour)
begin 
input_PC <= outpfour;
end

Instruction_memory x(inst,clk,output_PC); // inst => output of instruction memory , output_PC = Read_Address 
PC p_c(input_PC,output_PC);		  // input_PC = output_PC = PC+4 
plus_f_adder  adder(outpfour , output_PC,clk);// output of adder = inputPC , input_adder = output PC


endmodule
module pr_tb();

wire Reg_Dst,Branch,Mem_Read,Mem_to_Reg,Mem_Write,ALU_Src,Reg_Write;
wire[1:0] Alu_OP;
wire Clock;
reg[5:0] op_code;
reg[5:0] fn;
reg[4:0] rs, rt, rd;
wire[31:0] Read_Data_1, Read_Data_2;
wire[31:0] Alu_Result;
wire[3:0]  Alu_Signal;
wire Zero;

Clock_Gen gene(Clock);
Control jimmmy (Reg_Dst, Branch, Mem_Read, Mem_to_Reg, Alu_OP, Mem_Write, ALU_Src, Reg_Write, op_code, 1'b0);
RegFile anwar(Read_Data_1, Read_Data_2, rs, rt, rd, Alu_Result, Reg_Write ,Clock);
ALU_Control abdellatif(Alu_Signal, Alu_OP, fn);
ALU sersy(Read_Data_1, Read_Data_2, Alu_Signal , Alu_Result ,Zero);


initial
begin
$monitor("Read_Data_1:%h ,Read_Data_2:%h",Read_Data_1 ,Read_Data_2);
$monitor("Alu_Signal:%h", Alu_Signal);
$monitor("Alu_Result:%h	Zero:%h",Alu_Result ,Zero);
#5
op_code = 6'b000000;
fn = 6'b100000;
rs = 5'b10001;
rt = 5'b10010;
rd = 5'b01000;
end
endmodule