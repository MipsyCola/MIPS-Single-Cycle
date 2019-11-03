module PC(PC_plus, PC, clock, eof);
	integer file ,size, _ ;
	input wire clock;
	input wire [31:0] PC;
	output reg[31:0] PC_plus;
	output reg eof;
	initial 
	begin
		PC_plus = 32'd0;
		eof = 0 ;
	// ========================= for Size Calculation ============================
	size = 0;
	file = $fopen("ins.txt","r");
	while (! $feof (file) )
	begin
	_ = $fscanf (file,"%h",_);
	size = size +1;
	end
	$display ("SIZE === %d ",size);
	// ============================================================================
	end

	always @(posedge clock)
	begin
		PC_plus = PC;
		if( PC > size )
		begin
		$display ("end_program will save the memory data and exit the verilog program ");
		eof = 1 ;
		end
	end
endmodule


module PC_ADDER(PC_Adder_output,PC);
	output reg[31:0] PC_Adder_output;
	input [31:0] PC;
	always @(PC)
	begin
		PC_Adder_output=PC+1;
	end
endmodule
module INS_MEMORY(instruction, clk, pc);
	output reg[31:0] instruction;
	input  wire[31:0] pc;
	input  wire clk;
	reg[31:0] Imem[0:8191]; // 32KB memory ehich is 8192 register each one is 32bit 
	initial 
	begin 
		$readmemh("ins.txt",Imem);
	end
	always @(negedge clk )
	begin 
		
		instruction <= Imem[pc]; 
	end
endmodule
module CONTROL(Reg_Dst,Branch,Branch_Not_Equal,Mem_Read,Mem_to_Reg,ALU_Op,Mem_Write,ALU_Src,Reg_Write,Jump,Inst_31_26);
	output reg  Branch,Branch_Not_Equal,Mem_Read,Mem_Write,ALU_Src,Reg_Write,Jump;
	output reg  [1:0] Mem_to_Reg,Reg_Dst;
	output reg  [2:0] ALU_Op;
	input  wire [5:0] Inst_31_26;

	initial
	begin
		Branch <= 0;
		Jump <= 0 ;
		Branch_Not_Equal <= 0;
		Mem_Read <= 0 ;
		Mem_Write <=0;
		Reg_Write <= 0;
		ALU_Src <= 0;
		Mem_to_Reg <= 0;
		Reg_Dst <=0;
	end

	always@(Inst_31_26) // if any of instruction opcode changes 
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
			6'd4:	//beq
			begin
				Reg_Dst<=2'b00;
				Branch<=1'b1;
				Branch_Not_Equal<=1'b0;
				Jump<=1'b0;
				Mem_Read<=1'b0;
				Mem_to_Reg<=2'b00;
				Mem_Write<=1'b0;
				ALU_Src<=1'b0;
				Reg_Write<=1'b0;
				ALU_Op<=3'b001;
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
				ALU_Src<=1'b0;
				Reg_Write<=1'b0;
				ALU_Op<=3'b001;
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
			default : 
			begin
				Branch <= 0;
				Jump <= 0 ;
				Branch_Not_Equal <= 0;
				Mem_Read <= 0 ;
				Mem_Write <=0;
				Reg_Write <= 0;
				ALU_Src <= 0;
				Mem_to_Reg <= 0;
				Reg_Dst <=0;
			end		
		endcase
	end
endmodule
module REG_FILE(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock ,eof);

	input wire[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
	input wire[31:0] Write_Data;
	input Reg_Write, Clock;
	output reg[31:0] Read_Data_1, Read_Data_2;

	reg[31:0] Reg_File[0:31];

	input wire eof;
	integer file,i;
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
		Reg_File[17] <= 32'h00000000;
		Reg_File[18] <= 32'h00000000;
		Reg_File[19] <= 32'h00000000;
		Reg_File[20] <= 32'h00000000;
		Reg_File[21] <= 32'h00000000;
		Reg_File[22] <= 32'h00000000;
		Reg_File[23] <= 32'h00000000;
		Reg_File[24] <= 32'h00000000;
		Reg_File[25] <= 32'h00000000;
		Reg_File[26] <= 32'h00000000;
		Reg_File[27] <= 32'h00000000;
		Reg_File[28] <= 32'h00000000;
		Reg_File[29] <= 32'h00001FFF; //stack pointer address
		Reg_File[30] <= 32'h00000000;
		Reg_File[31] <= 32'h00000000;
		
	end
	always @(posedge eof)
	begin
		file = $fopen ("regFile.txt","w");
		for ( i = 0; i < 32 ; i = i+1)
		begin
			$fwrite(file,"%0d,%0d\n",i,Reg_File[i]);
		end
		$fclose(file); $display("END from regFile ya RAY2");
	end

	always @(Read_Reg_1, Read_Reg_2)
	begin
		Read_Data_1 = Reg_File[Read_Reg_1];
		Read_Data_2 = Reg_File[Read_Reg_2];
	end
	
	always @(negedge Clock)
	begin
		if(Reg_Write)
		begin
			Reg_File[Write_Reg] <= Write_Data;
		end
	end

endmodule 
module ALU_CONTROL(Alu_Signal,JR_Signal, Alu_OP, Inst_5_0);
	output reg[3:0] Alu_Signal;	 // signal going to ALU can be modified to more bits when adding more instr 
	output reg JR_Signal;
	input wire[2:0] Alu_OP; 	// coming from control unit
	input wire[5:0] Inst_5_0;  	//funct field in instr

	always @(Alu_OP or Inst_5_0)  	// to make sure when any input change;
	begin                         	// operations are executed from begining;
		if(Alu_OP==3'b000)	// sw or lw --> add or addi
		begin
			JR_Signal <= 1'b0;
			Alu_Signal <= 4'b0010; 
		end

		else if(Alu_OP==3'b001) // sub for beq
		begin
			JR_Signal <= 1'b0;
			Alu_Signal <= 4'b0110;
		end

		else if(Alu_OP==3'b011) // andi
		begin
			JR_Signal <= 1'b0;
			Alu_Signal <= 4'b0000;
		end

		else if(Alu_OP==3'b100) // ori
		begin
JR_Signal <= 1'b0;
			Alu_Signal <= 4'b0001;
		end

		else if(Alu_OP==3'b101) // slti
		begin
JR_Signal <= 1'b0;
			Alu_Signal <= 4'b0111;
		end

		else if(Alu_OP==3'b110) // xori
		begin
JR_Signal <= 1'b0;
			Alu_Signal <= 4'b0011;
		end

		else if(Alu_OP==3'b111) // lui
		begin
JR_Signal <= 1'b0;
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
					default  :Alu_Signal <= 4'b0000; 
				endcase
			end
		end
	end
endmodule
module ALU(Alu_Result, Zero, Inst_10_6, Read_Data_1, Alu_Src_Output, ALUctrl);
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

	initial 
	begin 
		Zero =  0 ; 
	end	
	always@(Read_Data_1,Alu_Src_Output,ALUctrl)
	begin 
		case(ALUctrl)
			AND: 
			begin
			Alu_Result <=  Read_Data_1 &  Alu_Src_Output ;
			Zero = (Read_Data_1 &  Alu_Src_Output) ? 0: 1;
			end
			OR :
			begin
			Alu_Result <=  Read_Data_1 |  Alu_Src_Output ;
			Zero = ( Read_Data_1 |  Alu_Src_Output )? 0: 1;
			end
			ADD:
			begin
			Alu_Result <=  Read_Data_1 +  Alu_Src_Output ;
			Zero = (Read_Data_1 +  Alu_Src_Output )? 0 : 1;
			end
			SUB: 
			begin
			Alu_Result <=  Read_Data_1 -  Alu_Src_Output ;
			Zero = (Read_Data_1 -  Alu_Src_Output)? 0:1;
			end
			SLT: Alu_Result <=  (Read_Data_1 < Alu_Src_Output);
			NOR: Alu_Result <= ~(Read_Data_1 | Alu_Src_Output);
			XOR: Alu_Result <=   Read_Data_1 ^ Alu_Src_Output ;
			SLL: Alu_Result <=   Alu_Src_Output << Inst_10_6  ;
			SRL: Alu_Result <=   Alu_Src_Output >> Inst_10_6  ;
			SRA: Alu_Result <=   Alu_Src_Output >>>Inst_10_6  ;
			LUI: Alu_Result <=   Alu_Src_Output << 16  ;
			default : 
			begin
				//Alu_Result <=  Read_Data_1 +  Alu_Src_Output ;
				$display ("ERROR_NOT_RAY22 ALUctrl: %b",ALUctrl);
			end
		endcase
	end
endmodule
module BR_ADDER(branchAdded, PC_Adder_output, Sign_Ext_Output);
	output reg [31:0] branchAdded;
	input  wire[31:0] PC_Adder_output;
	input  wire signed [31:0] Sign_Ext_Output; // signed since mover up or down
	always @(PC_Adder_output or Sign_Ext_Output)
	begin
		branchAdded <= PC_Adder_output + Sign_Ext_Output;
	end
endmodule
`timescale 1ns / 1ns
module CLOCK(Clock);
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
module DATA_MEMORY(Read_Data,MemWrite,MemRead,Address,Write_data,clock,eof);
	output reg signed[31:0] Read_Data;// reg wait for change value
	input wire clock, eof;
	input wire MemWrite,MemRead;
	input wire [12:0] Address ;
	input wire signed [31:0] Write_data;
	reg[31:0]write_data_storage[0:8191];
	integer file , size , i , _;
	integer mem_file ;
	
	always @(posedge eof)
	begin
		file = $fopen ("dataMemory.txt","w");
		for ( i = 0; i < 8192 ; i = i+1)
		begin
			if ( write_data_storage[i] !== 'hxxxx ) // don't store the garbage values in memory 
			begin $fwrite(file,"%0d,%0d\n",i,write_data_storage[i]); 	end
		end
		$fclose(file); $display("END from data memory ya RAY2");
		$stop();
	end
	
	always @ (negedge clock)
	begin 
		if(MemWrite == 1)
    		begin
			write_data_storage[Address] <= Write_data;    
		end
	end
	always @ (posedge MemRead)
	begin
		Read_Data <= write_data_storage[Address];
	end
endmodule
module INS_MEMORY(instruction, clk, pc);
	output reg[31:0] instruction;
	input  wire[31:0] pc;
	input  wire clk;
	reg[31:0] Imem[0:8191]; // 32KB memory ehich is 8192 register each one is 32bit 
	initial 
	begin 
		$readmemh("ins.txt",Imem);
	end
	always @(negedge clk )
	begin 
		
		instruction <= Imem[pc]; 
	end
endmodule
module JUMP_ADDRESS(J_address,Inst_25_0,pc_31_26);
	input wire[25:0] Inst_25_0;
	input wire[5:0] pc_31_26;
	output reg[31:0] J_address;

	always @(Inst_25_0)
	begin
		J_address <= {pc_31_26,Inst_25_0};
	end
endmodule
module Reg_Dst_MUX(Write_Register,in0,in1,RegDst);
	input  wire [4:0] in0,in1;
	input  wire [1:0] RegDst;
	output reg  [4:0] Write_Register;
	reg [4:0] ra;
	initial 
	begin
		ra = 5'd31;
	end
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
		end
	end
endmodule
module MUX_32_1(output_mux,input_0,input1,selector);
	output reg  [31:0] output_mux;
	input  wire [31:0] input_0;
	input  wire [31:0] input1;
	input  wire selector;
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
	end
endmodule
module MUX_32_2(output_mux,input_0,input1,input2,selector);

	input  wire [31:0] input_0;
	input  wire [31:0] input1;
	input  wire [31:0] input2;
	input wire  [1:0] selector;
	output reg  [31:0] output_mux;
	
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
		end
end

endmodule
module REG_FILE(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock ,eof);

	input wire[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
	input wire[31:0] Write_Data;
	input Reg_Write, Clock;
	output reg[31:0] Read_Data_1, Read_Data_2;

	reg[31:0] Reg_File[0:31];

	input wire eof;
	integer file,i;
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
		Reg_File[17] <= 32'h00000000;
		Reg_File[18] <= 32'h00000000;
		Reg_File[19] <= 32'h00000000;
		Reg_File[20] <= 32'h00000000;
		Reg_File[21] <= 32'h00000000;
		Reg_File[22] <= 32'h00000000;
		Reg_File[23] <= 32'h00000000;
		Reg_File[24] <= 32'h00000000;
		Reg_File[25] <= 32'h00000000;
		Reg_File[26] <= 32'h00000000;
		Reg_File[27] <= 32'h00000000;
		Reg_File[28] <= 32'h00000000;
		Reg_File[29] <= 32'h00001FFF; //stack pointer address
		Reg_File[30] <= 32'h00000000;
		Reg_File[31] <= 32'h00000000;
		
	end
	always @(posedge eof)
	begin
		file = $fopen ("regFile.txt","w");
		for ( i = 0; i < 32 ; i = i+1)
		begin
			$fwrite(file,"%0d,%0d\n",i,Reg_File[i]);
		end
		$fclose(file); $display("END from regFile ya RAY2");
	end

	always @(Read_Reg_1, Read_Reg_2)
	begin
		Read_Data_1 = Reg_File[Read_Reg_1];
		Read_Data_2 = Reg_File[Read_Reg_2];
	end
	
	always @(negedge Clock)
	begin
		if(Reg_Write)
		begin
			Reg_File[Write_Reg] <= Write_Data;
		end
	end

endmodule 
module SIGN_EXTEND(Sign_Ext_Output, Inst_15_0);
	input wire[15:0] Inst_15_0;
	output reg signed[31:0] Sign_Ext_Output;

	always @(Inst_15_0)
	begin
		if(Inst_15_0[15] == 1)
			Sign_Ext_Output <= Inst_15_0 | 32'hffff0000;
		else if (Inst_15_0[15] == 0)
			Sign_Ext_Output <= Inst_15_0 | 32'h00000000;
		else
			Sign_Ext_Output <=32'd0;
	end
endmodule

module MIPS();

/*********WIRES********/
wire Clock, eof, Branch, Branch_Not_Equal, Mem_Read, Mem_Write, ALU_Src, Reg_Write, Jump, JR_Signal, Zero, beq_and_output, bne_and_output, bne_not_output, branch_or_output, jr_not_output;
wire[31:0] tempregdata,pcOut, Read_Data, branch_adder_output, pc_branch_mux_output, jump_address_output, jump_mux_output, pcIn, jr_mux_output, data_memory_mux_output, instruction, Read_Data_1, Read_Data_2, Sign_Ext_Output, Alu_Result, alu_src_mux_Output;
wire[1:0] Reg_Dstn, Mem_to_Reg;
wire[2:0] ALU_Op;
wire[3:0] ALUctrl;
wire[4:0] reg_dest_mux_output;
/**********************/

/**********CLOCK*******/
CLOCK myClock(Clock);
/**********************/

/*****PC & PC ADDER*****/
PC pc(pcOut,jr_mux_output,Clock,eof);
PC_ADDER pc_adder(pcIn, pcOut);
/***********************/

/******INSTRUCTION MEMORY**********/
INS_MEMORY ins_memory(instruction, Clock, pcOut);
/**********************************/

/**********REGISTER FILE**********/
Reg_Dst_MUX reg_dest_mux(reg_dest_mux_output, instruction[20:16], instruction[15:11], Reg_Dstn);
REG_FILE register_file(Read_Data_1, Read_Data_2, instruction[25:21], instruction[20:16], reg_dest_mux_output, data_memory_mux_output, jr_and_output, Clock,eof);
/**********************************/

/**************CONTROLLER**********/
CONTROL control_unit(Reg_Dstn, Branch, Branch_Not_Equal, Mem_Read, Mem_to_Reg, ALU_Op, Mem_Write, ALU_Src, Reg_Write, Jump, instruction[31:26]);
/**********************************/

/************SIGN EXTEND***********/
SIGN_EXTEND sign_extend(Sign_Ext_Output, instruction[15:0]);
/**********************************/

/************ALU CONTROL***********/
ALU_CONTROL alu_control(ALUctrl, JR_Signal, ALU_Op, instruction[5:0]);
/**********************************/

/****************ALU *******************/
ALU alu(Alu_Result, Zero, instruction[10:6], Read_Data_1, alu_src_mux_Output, ALUctrl);
MUX_32_1 alu_src_mux(alu_src_mux_Output, Read_Data_2, Sign_Ext_Output, ALU_Src);
/***************************************/

/**********DATA MEMORY**************/
DATA_MEMORY data_memory(Read_Data, Mem_Write, Mem_Read, Alu_Result[12:0], Read_Data_2, Clock, eof);
MUX_32_2 data_mem_mux(data_memory_mux_output, Alu_Result, Read_Data, pcIn, Mem_to_Reg);
/**********************************/

/***BRANCH EQUAL AND BRANCH NOT EQUAL***/
BR_ADDER branch_adder(branch_adder_output, pcIn, Sign_Ext_Output);
and  beq_and(beq_and_output,Branch,Zero);
not  bne_not(bne_not_output,Zero);
and  bne_and(bne_and_output,Branch_Not_Equal,bne_not_output);
or   branch_or(branch_or_output,bne_and_output,beq_and_output);
MUX_32_1 pc_branch_mux(pc_branch_mux_output, pcIn, branch_adder_output, branch_or_output);
/****************************************/

/***********JUMP ADDRESS EXTEND***********/
JUMP_ADDRESS jump_add(jump_address_output,instruction[25:0],pcIn[31:26]);
MUX_32_1 jump_mux(jump_mux_output,pc_branch_mux_output,jump_address_output, Jump);
/*****************************************/

/**************JUMP REGISTER**************/
not jr_not(jr_not_output, JR_Signal);
and jr_and(jr_and_output, Reg_Write, jr_not_output);
MUX_32_1 jr_mux(jr_mux_output, jump_mux_output, Read_Data_1, JR_Signal);
/*****************************************/

initial
begin
$monitor("***************** %b *******************\n pcOut=%h, pcIn:%h, instruction: %h \n Read_Data_1:%h, Read_Data_2:%h, instruction[25:21]:%h, instruction[20:16]:%h \n beq_and_output:%h, Branch:%h, branch_or_output:%h, pc_branch_mux_output:%h\n Read_Data_1:%h, alu_src_mux_Output:%h, ALU_Src: %h, Zero:%h, Alu_Result: %h\n ***************************************",Clock,pcOut,pcIn,instruction,Read_Data_1, Read_Data_2, instruction[25:21], instruction[20:16], beq_and_output, Branch,branch_or_output,pc_branch_mux_output, Read_Data_1, alu_src_mux_Output, ALU_Src,Zero, Alu_Result);
end
endmodule
