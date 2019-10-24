module REG_FILE(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);

	input wire[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
	input wire[31:0] Write_Data;
	input Reg_Write, Clock;
	output reg[31:0] Read_Data_1, Read_Data_2;

	reg[31:0] Reg_File[0:31];

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
		Reg_File[16] <= 32'h00000005;
		Reg_File[17] <= 32'h00000003;
		Reg_File[18] <= 32'h00000001;
		Reg_File[19] <= 32'h00000000;
		Reg_File[29] <= 32'h00001FFF; //stack pointer address
		Reg_File[30] <= 32'h00000000;
		Reg_File[31] <= 32'h00000000;
		
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

