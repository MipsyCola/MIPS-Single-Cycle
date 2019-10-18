
module plus_f_adder(pcPlus,pc,clk);
input wire [12:0] pc;
output reg[12:0] pcPlus;
input wire clk;
always@(posedge clk) begin
pcPlus = pc +1; 
$display ("PC=%d,pcPlus=%d",pc,pcPlus);
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

module PC(input_pc , output1);
input wire[12:0] input_pc;
output reg[12:0] output1;
always@(input_pc)
begin output1 <= input_pc; end
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
