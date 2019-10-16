module Data_Memory(Read_Data,MemWrite,MemRead,Address,Write_data,clock);
output reg[31:0] Read_Data;// reg wait for change value
input wire clock;
input MemWrite,MemRead;
input [31:0] Address,Write_data;
reg[31:0] Address_lines[0:8191];
reg[31:0]write_data_storage[0:8191];// 2048 or 8192 
always @ (posedge clock)
begin
if(MemWrite)
    write_data_storage[Address] <= Write_data;
if(MemRead)
 Read_Data <= write_data_storage[Address];
end
endmodule 
