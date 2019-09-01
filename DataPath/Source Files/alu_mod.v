module alu_mod(a, b, control, out);
input [31:0] a,b;
input [2:0] control;
output reg [31:0] out;

always @ *
begin
	case(control)
	3'b000: out = a + b;
	3'b001: out = a - b;
	3'b010: out = a & b;
	3'b011: out = a | b;
	3'b100: out = a << b;
	3'b101: out = a >> b;
	3'b111: out = b;
	endcase
end
endmodule