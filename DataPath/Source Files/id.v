module id(read_reg_1, read_reg_2, write_reg, write_data, read_data_1, read_data_2, regwrite, clk);
input [4:0] read_reg_1;
input [4:0] read_reg_2;
input [4:0] write_reg;
input [31:0] write_data;
output [31:0] read_data_1;
output [31:0] read_data_2;
input regwrite;
input clk;

reg [31:0] regfile [31:0];

assign read_data_1 = regfile[read_reg_1];
assign read_data_2 = regfile[read_reg_2];

initial begin
regfile [0] = 32'h0000;
regfile [1] = 32'h0001;
regfile [2] = 32'h0002;
regfile [3] = 32'h0003;
regfile [4] = 32'h0004;
regfile [5] = 32'h0005;
regfile [6] = 32'h0006;
regfile [7] = 32'h0007;
regfile [8] = 32'h0008;
regfile [9] = 32'h0009;
regfile [10] = 32'h000a;
regfile [11] = 32'h000b;
regfile [12] = 32'h000c;
regfile [13] = 32'h000d;
regfile [14] = 32'h000e;
regfile [15] = 32'h000f;
regfile [16] = 32'h0010;
regfile [17] = 32'h0011;
regfile [18] = 32'h0012;
regfile [19] = 32'h0013;
regfile [20] = 32'h0014;
regfile [21] = 32'h0015;
regfile [22] = 32'h0016;
regfile [23] = 32'h0017;
regfile [24] = 32'h0018;
regfile [25] = 32'h0019;
regfile [26] = 32'h001a;
regfile [27] = 32'h001b;
regfile [28] = 32'h001c;
regfile [29] = 32'h001d;
regfile [30] = 32'h001e;
regfile [31] = 32'h001f;
end
always @(posedge clk)
begin 
	if(regwrite==1)
	begin
		regfile[write_reg] <= write_data;
	end
end
endmodule

module id_tb;

reg [4:0] read_reg_1;
reg [4:0] read_reg_2;
reg [4:0] write_reg;
reg [31:0] write_data;
wire [31:0] read_data_1;
wire [31:0] read_data_2;
reg regwrite;
reg clk;

id id1(read_reg_1, read_reg_2, write_reg, write_data, read_data_1, read_data_2, regwrite, clk);

always #5 clk = ~clk;

initial begin
clk = 0;
#1000 $finish;
end

initial begin
regwrite = 0;
#15;
regwrite = 1; write_data = 20; write_reg=0;
#10;
regwrite = 1; write_data=30; write_reg = 1;
#10;
regwrite = 1; write_data = 40; write_reg =2;
end

initial begin
#10;
read_reg_1 = 0; read_reg_2 = 0;
#15;
read_reg_1 = 0; read_reg_2 = 1;
#10;
read_reg_1 = 1; read_reg_2 = 2;
end
endmodule
