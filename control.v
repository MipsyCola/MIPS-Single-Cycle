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
