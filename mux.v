module MUX_5_2(in0,in1,ra,Write_Register,RegDst);

input  wire [4:0] in0,in1,ra;
output reg  [4:0] Write_Register;
input wire [1:0]RegDst;

always@(in0,in1,RegDst)
begin 
	if(RegDst === 0)
	begin
	Write_Register <= in0;
	end

	else if (RegDst === 1)
	begin
	Write_Register <= in1;
	end

	else if (RegDst == 2)
	begin
	Write_Register <= ra;
	end

	else 
	begin
	end
	$display ("RegDst: %b",RegDst);

end
endmodule
module MUX_32_1(input_0,input1,output_mux,selector);

input  wire [31:0] input_0;
input  wire [31:0] input1;
output reg  [31:0] output_mux;
input wire selector;

always@(input_0,input1,selector)
begin 
	if(selector == 0)
	begin
	output_mux <= input_0;
	end

	else if (selector == 1)
	begin
	output_mux <= input1;
	end

	else 
	begin
//	$display ("selectorMux_32_1: %b",selector);
	end
	$display ("selectorMux_32_1: %b",selector);

end

endmodule

module MUX_32_2(input_0,input1,input2,output_mux,selector);

input  wire [31:0] input_0;
input  wire [31:0] input1;
input  wire [31:0] input2;

output reg  [31:0] output_mux;
input wire[1:0] selector;

always@(input_0,input1,selector)
begin 
	if(selector == 0)
	begin
	output_mux <= input_0;
	end

	else if (selector == 1)
	begin
	output_mux <= input1;
	end
	
	else if (selector == 2)
	begin
	output_mux <= input2;
	end

	else 
	begin
	end
	$display ("selector_Mux_32_2: %b",selector);

end

endmodule

