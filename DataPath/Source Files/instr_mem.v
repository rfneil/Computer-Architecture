module instr_mem(
input [31:0] pc,
input reset,
output [31:0] instr_code);

reg [7:0] mem [27:0];

assign instr_code = {mem[pc], mem[pc+1], mem[pc+2], mem[pc+3]};

initial
begin 
	$readmemh("instrmemory.mem", mem);
	
end
endmodule

module instr_mem_tb;

reg [31:0] pc;
reg reset;
wire [31:0] instr_code;

instr_mem ifb(pc, reset, instr_code);

initial begin
reset = 0;
pc = 0;

#10;
reset = 1;
pc = 32'd4;

#10;
reset = 0;

#10;
reset = 1;
pc = 32'd7;

#10;
reset = 0;
pc = 32'd12;

#10;
reset = 1;
pc = 32'd6;

#10;
reset = 0;

#10;
reset = 1;
pc = 32'd11;

#10;
$finish;
end
endmodule
	