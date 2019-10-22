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

