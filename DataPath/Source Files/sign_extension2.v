module sign_extension2(in, out);
input [4:0] in;
output reg [31:0] out;

always @ *
begin 
	if(in[4]==0)
		out = {27'b0, in};
	else
		out = {27'b1, in};
end
endmodule