module mux_2ip_31b(sel, a, b, out);
input sel;
input [31:0] a;
input [31:0] b;
output reg [31:0] out;

always @ (*)
begin
case (sel)
1'b0 : out=a;
1'b1 : out=b;
endcase 
end
endmodule