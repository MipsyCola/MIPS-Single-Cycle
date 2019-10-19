module Instruction_memory(instruction,clk,pc);
output reg[31:0] instruction;
input [12:0] pc;
input clk;
reg[31:0] Imem[0:8191]; // 32KB memory ehich is 8192 register each one is 32bit
initial $readmemb("ins.txt",Imem);

always @(posedge clk)
begin 
instruction <= Imem[pc]; 
//$display ("instruction: %d",Imem[pc]);
end
endmodule
