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

	initial begin Zero =  0 ; end	
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

