module Data_Memory(Read_Data,MemWrite,MemRead,Address,Write_data,clock,eof);
output reg[31:0] Read_Data;// reg wait for change value
input wire clock;
input MemWrite,MemRead;
input [31:0] Address,Write_data;
reg[31:0]write_data_storage[0:8191];// 2048 or 8192 

input wire eof;
integer file , size , i , _;
integer mem_file ;


always @(posedge eof)
begin
file = $fopen ("file.txt","w");
	for ( i = 0; i < 8191 ; i = i+1)
	begin
	if ( write_data_storage[i] !== 'hxxxx ) // don't store the garbage values in memory 
	begin $fwrite(file,"%d %d\n",i,write_data_storage[i]); 	end
	end
	$fclose(file); $display("END from data memory ya RAY2");
	$stop();
end

always @ (negedge clock)
begin 
if( MemRead == 1)
	begin
	Read_Data <= write_data_storage[Address];
	end
end

always @ (posedge clock)
begin
if(MemWrite == 1)
    	begin
	write_data_storage[Address] <= Write_data;    
	end
end

endmodule 


module TEST;
reg clk ;
wire [31:0] Read_Data;
reg MemWrite,MemRead;
reg [31:0] Address,Write_data;

reg write_memory_file;
Data_Memory ray2(Read_Data,MemWrite,MemRead,Address,Write_data,clk,write_memory_file);

initial 
begin
$monitor("Read=%b Write_Dddddata=%b",Read_Data,Write_data);
clk = 0; write_memory_file = 0;

#10 Address  = 0; MemWrite = 1; Write_data = 4'b1000; 
#10 Address  = 1; MemWrite = 1; Write_data = 4'b1111;
#10 Address  = 2; MemWrite = 1; Write_data = 4'b0111;
#10 MemWrite = 0;
#10 Address  = 0; MemRead = 1; 
#10 Address  = 1; MemRead = 1; 
#10 Address  = 2; MemRead = 1; 

#10 write_memory_file =1 ;
end


always begin #5 clk = ~ clk ; end


endmodule
