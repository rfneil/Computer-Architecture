module instr_fetch(input clk, input reset, input [7:0] pc_i, output [7:0] instr_code, output reg [7:0] pc_o, output reg [7:0] pc_to_ifid);

instr_mem insmem(pc_o, reset, instr_code);

always @(posedge clk ,negedge reset)
begin 
	if(reset==0)
	begin
		pc_o<=0;
		pc_to_ifid<=1;
	end
	else
	begin
		pc_o<=pc_i;
		pc_to_ifid<=pc_i +1;
	end
end
endmodule

module instr_mem(
input [7:0] pc,
input reset,
output [7:0] instr_code);

reg [7:0] mem [10:0];

assign instr_code = mem[pc];

initial
begin 
	$readmemh("mem2.mem", mem);
	
end
endmodule

module ifidreg(clk, reset, stall,instr_code_i, pc_i, instr_code_o, pc_o);
input clk, reset, stall;
input [7:0] pc_i, instr_code_i;
output reg [7:0] instr_code_o, pc_o;

always @ (posedge clk or negedge reset)
begin
	if(reset==0)
	begin
		instr_code_o<=0;
		pc_o<=0;
	end
	else if(stall==1&reset!=0)
  	begin
		instr_code_o<=8'bz;
		pc_o<=pc_i;
	end
 	else
	begin
		instr_code_o <= instr_code_i;
		pc_o <= pc_i;
	end
end
endmodule


module reg_file(read_reg_1, read_reg_2, write_reg, write_data, read_data_1, read_data_2,  regwrite);
input [2:0] read_reg_1, read_reg_2;
input [2:0] write_reg;
input [7:0] write_data;
output [7:0] read_data_1, read_data_2;
input regwrite;

reg [7:0] regfile [7:0];

assign read_data_1 = regfile[read_reg_1];
assign read_data_2 = regfile[read_reg_2];

initial begin
regfile [0] = 32'h00;
regfile [1] = 32'h01;
regfile [2] = 32'h02;
regfile [3] = 32'h03;
regfile [4] = 32'h04;
regfile [5] = 32'h05;
regfile [6] = 32'h06;
regfile [7] = 32'h07;
end

always @ *
begin 
	if(regwrite==1)
	begin
		regfile[write_reg] <= write_data;
	end
end
endmodule

module idexreg(clk, reset, stall, read_reg_in, read_data_1_in,  read_data_2_in, write_reg_in, regwrite_in, alucontrol_in, read_reg_o, read_data_1_o, read_data_2_o, write_reg_o, regwrite_o, alucontrol_o);
input clk, reset, regwrite_in;
input [7:0] read_data_1_in, read_data_2_in;
input [2:0] read_reg_in, write_reg_in;
input alucontrol_in, regwrite_in,stall;
output reg [7:0] read_data_1_o, read_data_2_o;
output reg [2:0] read_reg_o, write_reg_o;
output reg alucontrol_o, regwrite_o;

always @ (posedge clk or negedge reset)
begin
	if(reset==0||stall==1)
	begin
		read_data_1_o<=0;
		read_data_2_o<=0;
		write_reg_o<=0;
		regwrite_o<=0;
		alucontrol_o<=0;
		read_reg_o<=0;
	end
 	else
	begin
		read_data_1_o<=read_data_1_in;
		read_data_2_o<=read_data_2_in;
		write_reg_o<=write_reg_in;
		regwrite_o <= regwrite_in;
		alucontrol_o<=alucontrol_in;
		read_reg_o<=read_reg_in;
	end
end
endmodule

module alu(a, b, alucontrol, result);
input[7:0] a,b;
output reg [7:0] result;
input alucontrol;

always @ *
begin
	case(alucontrol)
	1'b0: result = a;
	1'b1: result = a+b;
	endcase
end
endmodule

module mux(sel, a, b, out);
input [7:0] a,b;
input sel;
output reg [7:0] out;

always @ *
begin
	case (sel)
	1'b0: out=a;
	1'b1: out=b;
	endcase
end
endmodule

module exwbreg(clk ,reset, alures_i, regwrite_i, write_reg_i, write_reg_o, alures_o, regwrite_o);
input clk, reset;
input [7:0] alures_i;
input [2:0] write_reg_i;
input regwrite_i;
output reg regwrite_o;
output reg [7:0] alures_o;
output reg [2:0] write_reg_o;

always @ (posedge clk or negedge reset)
begin
	if(reset==0)
	begin
		write_reg_o<=0;
		alures_o<=0;
		regwrite_o<=0;
	end
 	else
	begin
		write_reg_o<=write_reg_i;
		alures_o <= alures_i;
		regwrite_o<=regwrite_i;
	end
end
endmodule

module control_unit(opcode, alucontrol, pcsrc, regwrite, stall);
input [1:0] opcode;
output reg pcsrc, alucontrol, regwrite, stall;

always @ *
begin
	case(opcode)
	2'b00: begin  alucontrol = 1'b0; pcsrc = 1'b0; regwrite = 1'b1; stall = 1'b0; end
	2'b01: begin  alucontrol = 1'b1; pcsrc = 1'b0; regwrite = 1'b1; stall = 1'b0; end
	2'b11: begin  pcsrc = 1'b1; regwrite = 1'b0; stall = 1'b1; end
	2'bzz: begin  pcsrc = 1'b0; regwrite = 1'b0; stall = 1'b0; end

	endcase
end
endmodule

module j_append(before, pc, after);
input [5:0] before;
input [7:0] pc;
output [7:0] after;

assign after = {pc[7:6], before};

endmodule



module forwarding_unit(idex_rd_reg_1, idex_rd_reg_2, exwb_wr_reg, exwb_regwrite, sel1, sel2);
input [2:0] idex_rd_reg_1,idex_rd_reg_2, exwb_wr_reg;
input exwb_regwrite;
output reg sel1, sel2;

always @ *
begin
	sel1 = 0;
	sel2 = 0;
	if(exwb_regwrite==1'b1 & (idex_rd_reg_1==exwb_wr_reg))
		sel1 = 1;
	else if(exwb_regwrite==1'b1 & (idex_rd_reg_2==exwb_wr_reg))
		sel2 = 1;
end
endmodule


module processor(clk, reset);
input reset, clk;

wire [7:0] instr_code, instr_code_ifid_i, instr_code_ifid_o;
wire [7:0] pc, pc_ifid_i, pc_ifid_o, pc_idex_i, pc_idex_o, pc_final,pc_if_o, jump_add;
wire [7:0] read_data_1_idex_i,read_data_2_idex_i,read_data_1_idex_o,read_data_2_idex_o;
wire [7:0] write_data, read_data_1_x, read_data_2_x,  alu_result, alures_exwb_i, alures_exwb_o, read_data_1_fw_ex, read_data_2_fw_ex;
wire [2:0] read_reg, read_reg_idex_i, read_reg_idex_o, write_reg, write_reg_idex_i, write_reg_idex_o, write_reg_exwb_i, write_reg_exwb_o;
wire regwrite, regwrite_idex_i, regwrite_idex_o, regwrite_exwb_i, regwrite_exwb_o;
wire alucontrol, alucontrol_idex_i, alucontrol_idex_o, stall;
wire pcsrc, pcsrc_idex_i, pcsrc_idex_o, fw_sel_1, fw_sel_2;

//regfile inputs
assign read_reg = instr_code_ifid_o[2:0];
assign write_reg = instr_code_ifid_o[5:3];
assign instr_code_ifid_i = instr_code;

//idex reg inputs
assign pc_idex_i = pc_ifid_o;
assign read_data_1_idex_i = read_data_1_x;
assign read_data_2_idex_i = read_data_2_x;
assign write_reg_idex_i = write_reg;
assign regwrite_idex_i = regwrite;
assign alucontrol_idex_i = alucontrol;
assign pcsrc_idex_i = pcsrc;
assign read_reg_idex_i = read_reg;

//exwb reg inputs
assign alures_exwb_i = alu_result;
assign regwrite_exwb_i = regwrite_idex_o;
assign write_reg_exwb_i = write_reg_idex_o;

instr_fetch if1(clk, reset, pc_final, instr_code, pc_if_o, pc_ifid_i);
ifidreg ifid(clk, reset, stall, instr_code_ifid_i, pc_ifid_i, instr_code_ifid_o, pc_ifid_o);
j_append app(instr_code_ifid_o[5:0], pc_ifid_o, jump_add);
mux pcval(pcsrc, pc_ifid_i, jump_add, pc_final);

reg_file rf(read_reg, write_reg, write_reg_exwb_o, alures_exwb_o, read_data_1_x, read_data_2_x,  regwrite_exwb_o);
idexreg idex(clk, reset, stall, 
read_reg_idex_i, read_data_1_idex_i,  read_data_2_idex_i, write_reg_idex_i, regwrite_idex_i, alucontrol_idex_i, read_reg_idex_o, read_data_1_idex_o, read_data_2_idex_o, write_reg_idex_o, regwrite_idex_o, alucontrol_idex_o);

alu al(read_data_1_fw_ex, read_data_2_fw_ex, alucontrol_idex_o, alu_result);
control_unit cu(instr_code_ifid_o[7:6], alucontrol, pcsrc, regwrite, stall);
exwbreg exwb(clk ,reset, alures_exwb_i, regwrite_exwb_i, write_reg_exwb_i, write_reg_exwb_o, alures_exwb_o, regwrite_exwb_o);

forwarding_unit fu(read_reg_idex_o, write_reg_idex_o, write_reg_exwb_o, regwrite_exwb_o, fw_sel_1, fw_sel_2);
mux fwd1(fw_sel_1, read_data_1_idex_o, alures_exwb_o, read_data_1_fw_ex);
mux fwd2(fw_sel_2, read_data_2_idex_o, alures_exwb_o, read_data_2_fw_ex);


endmodule

module processor_tb_2;

reg clk, reset;

processor p(clk, reset);

always #5 clk=~clk;
initial
begin 
clk=1;
reset = 0;
#20;
reset=1;
#1000 $finish;
end
endmodule
