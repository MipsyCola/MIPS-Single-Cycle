module plus_f_adder(pcPlus,pc,clk);
input wire [12:0] pc;
output reg[12:0] pcPlus;
input wire clk;
always@(posedge clk) begin
pcPlus = pc +1; 
$display ("PC=%d,pcPlus=%d",pc,pcPlus);
end
endmodule
