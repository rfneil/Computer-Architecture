module processor(clk ,reset);
input clk;
input reset;

wire [31:0] instr_code;
wire [4:0] id_read_reg_1, id_read_reg_2, id_write_reg;
wire [31:0] id_write_data;
wire [31:0] id_read_data_1, id_read_data_2, alu_result, signed_const, signed_const_li,signed_const_sh, alu_input_1, alu_input_2;
wire id_regwrite;
wire alu_src, optype;
wire [2:0] alu_control;

assign alu_input_1 = id_read_data_1;
assign id_read_reg_1 = instr_code[20:16];
assign id_read_reg_2 = instr_code[15:11];
assign id_write_data = alu_result;
assign id_write_reg = instr_code[25:21];
assign id_regwrite = 1'b1;

instr_fetch if1(clk,reset,instr_code);
//instr_mem insmem(pc, reset, instr_code);
id instr_dec(id_read_reg_1, id_read_reg_2, id_write_reg, id_write_data, id_read_data_1, id_read_data_2, id_regwrite, clk);
alu_mod al(alu_input_1, alu_input_2, alu_control, alu_result);
sign_extension1 signextend1(instr_code[20:0], signed_const_li);
sign_extension2 signextend2(instr_code[10:6], signed_const_sh);
mux_2ip_31b mu2(optype, signed_const_sh, signed_const_li, signed_const);
mux_2ip_31b mu(alu_src, id_read_data_2, signed_const, alu_input_2);
control_unit ctrl(instr_code[31:26], instr_code[5:0], alu_control,alu_src, optype);


endmodule

		    	



