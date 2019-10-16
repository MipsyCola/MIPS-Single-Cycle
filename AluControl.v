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
