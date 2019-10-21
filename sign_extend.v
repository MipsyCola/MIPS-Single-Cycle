module SIGN_EXTEND(Sign_Ext_Output, Inst_15_0);
	input wire[15:0] Inst_15_0;
	output reg signed[31:0] Sign_Ext_Output;

	always @(Inst_15_0)
	begin
		if(Inst_15_0[15] == 1)
			Sign_Ext_Output <= Inst_15_0 | 32'hffff0000;
		else if (Inst_15_0[15] == 0)
			Sign_Ext_Output <= Inst_15_0 | 32'h00000000;
		else
			Sign_Ext_Output <=32'd0;
	end
endmodule
