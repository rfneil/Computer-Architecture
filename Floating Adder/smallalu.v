module smallalu(a,b,exp_diff);
input [7:0] a;
input [7:0] b;
output reg [7:0] exp_diff;

always @ *
begin
exp_diff = a-b;
end
endmodule
