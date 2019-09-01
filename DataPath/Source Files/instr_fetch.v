module instr_fetch(input clk, input reset, output [31:0] instr_code);

reg [31:0] pc;

instr_mem insmem(pc, reset, instr_code);

always @(posedge clk ,negedge reset)
begin 
	if(reset==0)
		pc<=0;
	else
		pc<=pc+4;
end
endmodule

module instr_fetch_tb;
reg clk;
reg reset;
wire [31:0] instr_code;
reg [31:0] pc;

instr_fetch insfet(clk, reset, instr_code);

always #5 clk = ~clk;

initial begin clk=0; end

initial begin 
reset = 0;
pc = 0;

#10;
reset = 1;
pc = 32'd4;

#15;
reset = 1;
pc = 32'd7;

#1;
pc = 32'd12;

#8;
reset = 1;
pc = 32'd6;

#10;
reset = 0;

#12;
reset = 1;
pc = 32'd11;

#12;
reset = 0;
pc = 32'd9;

#12;
reset = 1;
pc = 32'd14;

#10;
$finish;
end
endmodule
