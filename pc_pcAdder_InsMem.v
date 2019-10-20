module plus_f_adder (PCplus , pc,clk);
output reg[31:0] PCplus;
input wire clk;
input wire[31:0] pc;
integer file ;

initial begin PCplus =0 ; end

always @(posedge clk) 
begin 
	PCplus <= pc +1;
end
endmodule 

module PC( output1, input_pc ,end_program);
input wire[31:0] input_pc;
output reg[31:0] output1;

output reg end_program;
integer file ,size, _ ;
initial 
begin
output1 = 0 ;

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
input [31:0] pc;
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
	$display("INST_PC==================%b",pc);
	instruction <= Imem[pc]; 
end

endmodule


/*
* File : instructionMemory.v
* Name : Eslam Ahmed & Amr Elsersy 
* Course : CO2
* Data : 10/18/2019
* Contents : Modules for instruction memory, PC register and +4Adder all working with positive edge clock  
* Description : Fetching the instruction from memory 
		PC register holds the address of the current instruction
		Instruction memory stores all the instrictions (max 8192 instruction = 32KB ,each instruction = 32bit = 4Bytes = 1word)  
		Plus_f_adder increase the PC addres by 1 (word) to point at the next instruction  
* 
*/


/***************tt************************************************************************************
* Module : plus_f_adder (PCplus , pc,clk)
* Parameters : 
*	output: 1
*		PCplus: new instruction address
*	inputs: 2
*		clk : the master clock of all modules 
*		pc : a 32 bit register holds the address of the instruction to be outputed
* Discription :  increase the PC addres by 1 (word) to point at the next instruction  
***************************************************************************************************/


/***************tt************************************************************************************
* Module : Instruction_memory(instruction,clk,pc)
* Parameters : 
*	output: 1
*		instruction: a 32 register holds the instruction machine code
*	inputs: 2
*		clk : the master clock of all modules 
*		pc : a 13 bit register holds the adress of the instruction to be outputed
* Discription :  outputs the instruction at the index PC 
***************************************************************************************************/
/***************tt************************************************************************************
* Module : tb_initialize_Imem()
* Parameters : N/A
* Discription : Just for the sake of testing 
***************************************************************************************************/
/*`include "dataMemory.v"

module pc_test();
wire[31:0] inst;
reg clk;
reg [31:0] input_PC; 
wire[31:0] output_PC;
wire[31:0] outpfour;
wire eof ;

// ===== for data memory =========
wire [31:0] Read_Data;
reg MemWrite,MemRead;
reg [31:0] Address,Write_data;
// ===============================
initial 
begin 
//$monitor("%b ",inst);
#1
input_PC = 0; // intialize PC  at the first ins.
clk=0;
//#10 Address  = 0; MemWrite = 1; Write_data = 4'b1000; 
//#10 Address  = 1; MemWrite = 1; Write_data = 4'b1111;
//#10 Address  = 2; MemWrite = 1; Write_data = 4'b0111;
end

always begin  #5 clk= ~clk; end //clock

always @(outpfour)
begin 
input_PC <= outpfour;  // pc = pc+4 --> assgin the output of the adder to the pc 
$display ("instruction: %b ",inst);
end

Instruction_memory x(inst,clk,output_PC); // inst => output of instruction memory , output_PC = Read_Address 
PC p_c(output_PC,input_PC , eof);		  // input_PC = output_PC = PC+4 
plus_f_adder  adder(outpfour , output_PC,clk);// output of adder = inputPC , input_adder = output PC
Data_Memory ray2(Read_Data,MemWrite,MemRead,Address,Write_data,clk,eof);

endmodule 
*/
/***************tt************************************************************************************
* Module : PC( output1, input_pc)
* Parameters : 
*	output: 1
*		output1: PC
*	inputs: 1
*		input_pc : PC
* Discription :  A register that holds the pc
***************************************************************************************************/

