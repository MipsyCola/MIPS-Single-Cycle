module ALU_Control(Alu_Signal, Alu_OP, Inst_5_0);
output reg[3:0] Alu_Signal; // signal going to ALU can be modified to more bits when adding more instr 
input wire[1:0] Alu_OP;  // coming from control unit
input wire[5:0] Inst_5_0;  //funct field in instr

always @(Alu_OP or Inst_5_0)  // to make sure when any input change;
begin                         // operations are executed from begining;
if(Alu_OP==2'b00)// sw or lw --> add
begin
Alu_Signal <= 4'b0010; 
end
else if(Alu_OP==2'b01) //beq
begin
Alu_Signal <= 4'b0110;
end
else if(Alu_OP==2'b10)   //incase (10) indicate we have R_format; 
begin                    //so we diffrentiate using funct field in instr;
case (Inst_5_0)
6'b100000:Alu_Signal <= 4'b0010;  //add
6'b100010:Alu_Signal <= 4'b0110;  //subtract
6'b100100:Alu_Signal <= 4'b0000;  //AND
6'b100101:Alu_Signal <= 4'b0001;  //OR
6'b101010:Alu_Signal <= 4'b0111;  //slt 
endcase
end
end
endmodule 
