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
