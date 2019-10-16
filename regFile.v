module RegFile(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);

input wire[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
input wire[31:0] Write_Data;
input Reg_Write, Clock;
output reg[31:0] Read_Data_1, Read_Data_2;

reg[31:0] Reg_File[0:31];

initial
begin
Reg_File[0] <= 32'h00000000; //zero register
Reg_File[1] <= 32'h00000000;
Reg_File[2] <= 32'h00000000;
Reg_File[3] <= 32'h00000000;
Reg_File[4] <= 32'h00000000;
Reg_File[5] <= 32'h00000000;
Reg_File[6] <= 32'h00000000;
Reg_File[7] <= 32'h00000000;
Reg_File[8] <= 32'h00000000;
Reg_File[9] <= 32'h00000000;
Reg_File[10] <= 32'h00000000;
Reg_File[11] <= 32'h00000000;
Reg_File[12] <= 32'h00000000;
Reg_File[13] <= 32'h00000000;
Reg_File[14] <= 32'h00000000;
Reg_File[15] <= 32'h00000000;
Reg_File[16] <= 32'h00000000;
Reg_File[17] <= 32'h00000002;
Reg_File[18] <= 32'h00000001;
Reg_File[19] <= 32'h00000000;
Reg_File[29] <= 32'h00000000; //change this address to stack pointer 
end

always @(posedge Clock)
begin
if(Reg_Write)
Reg_File[Write_Reg] <= Write_Data;
$display ("Write_Data=%b",Write_Data);
end

always @(negedge Clock)
begin
Read_Data_1 <= Reg_File[Read_Reg_1];
Read_Data_2 <= Reg_File[Read_Reg_2];
$display ("Read_Reg_1=%b",Read_Reg_1);
$display ("Read_Reg_2=%b",Read_Reg_2);
end
endmodule

module Clock_Gen(Clock);
output reg Clock;
initial
begin
Clock=0;
end
always
begin
#31.25
Clock=~(Clock);
end
endmodule
module regFile_tb();
reg[4:0] Read_Reg_1, Read_Reg_2, Write_Reg;
reg[31:0] Write_Data;
reg Reg_Write;
wire Clock;
wire[31:0] Read_Data_1, Read_Data_2;

Clock_Gen generat(Clock);
RegFile anwar(Read_Data_1, Read_Data_2, Read_Reg_1, Read_Reg_2, Write_Reg, Write_Data, Reg_Write, Clock);

initial
begin
Read_Reg_1=5'b10001;
Read_Reg_2=5'b10010;
Write_Reg= 5'b01000;
Write_Data=32'h00000000;
Reg_Write=0;
//$monitor("%h 	%h",Read_Data_1, Read_Data_2);
end

endmodule
