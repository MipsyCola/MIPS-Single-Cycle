module Shift_Left(Shifted_Output, Inst_25_0);
input wire[25:0] Inst_25_0;
output reg[27:0] Shifted_Output;

always @(Inst_25_0)
begin
Shifted_Output <= (Inst_25_0 << 2);
end

endmodule

