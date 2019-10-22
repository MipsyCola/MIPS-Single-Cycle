module temp_reg(data,pcIn,Jump);
	output reg [31:0] data;
	input wire [31:0] pcIn;	
	input Jump;
	always @ (posedge Jump)
	begin
		data<=pcIn;
	end
endmodule

