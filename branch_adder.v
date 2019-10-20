module branch_adder(branchAdded, pc_and_4, sign_and_shift_out);
output reg[31:0] branchAdded;
input wire[31:0] pc_and_4, sign_and_shift_out;

always @(pc_and_4, sign_and_shift_out)
begin
branchAdded <= pc_and_4 + sign_and_shift_out;
end
endmodule
