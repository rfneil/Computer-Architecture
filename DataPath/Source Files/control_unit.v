module control_unit(opcode, funct, alu_control, alu_src, optype);

input[5:0]opcode, funct;
output reg [2:0] alu_control;
output reg alu_src;
output reg optype;

always @ *
begin
	if(opcode[5]==0)
		optype = 0;
	else
		optype = 1;
end

always @ *
begin
	if(opcode[5] == 0)
	begin
		if(funct[5]==1)
			alu_src = 0;
	end
	else
		alu_src = 1;
end
	
always @ *
begin
case ({opcode[5],funct})
7'b0100000 : alu_control = 3'b000;
7'b0100010 : alu_control = 3'b001;
7'b0100100 : alu_control = 3'b010;
7'b0100101 : alu_control = 3'b011;
7'b0000000 : alu_control = 3'b100;
7'b0000010 : alu_control = 3'b101;
default : alu_control = 3'b111;
endcase
end
endmodule