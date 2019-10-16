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

module ALU(Read_Data_1, Alu_Src_Output, ALUctrl , Alu_Result ,Zero);

input  wire signed [31:0] Read_Data_1;
input  wire signed [31:0] Alu_Src_Output;
input  wire  [3:0] ALUctrl;
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

reg  signed[31:0] in1;
reg  signed[31:0] in2;
reg  [5:0]  fn;
reg[1:0] aluOp;
wire[3:0] Alu_Signal;
wire [31:0] result;
wire zero;
 
initial
begin
$monitor ("in1=%d in2=%d ctrl=%b result=%d zero=%b",in1,in2,Alu_Signal,result,zero);

#1
in1 = 50;
in2 =20;
fn = 6'b100000;
aluOp = 2'b10; 
#1
in1 = 50;
in2 =55;

end
ALU_Control toto(Alu_Signal, aluOp, fn);
ALU test_ray2(in1, in2, Alu_Signal , result ,zero);


endmodule
