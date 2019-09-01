module sign_extension1(in, out);
input [20:0] in;
output reg [31:0] out;

always @ *
begin 
	if(in[20]==0)
		out = {11'b0, in};
	else
		out = {11'b1, in};
end
endmodule