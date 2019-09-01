
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