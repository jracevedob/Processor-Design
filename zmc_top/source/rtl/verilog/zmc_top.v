// Company           :   tud                      
// Author            :   jaac14           
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_top.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Mon Sep 22 08:10:15 2014 
// Last Change       :   $Date: 2016-07-26 17:14:23 +0200 (Tue, 26 Jul 2016) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------

module zmc_top (
	clk,
	a_reset_l,
	wb_ack_i,
	wb_we_o,
	wb_stb_o,
	wb_cyc_o,
	wb_adr_o,
	wb_dat_i,
	wb_dat_o,
	intr_h,
	intr_ack_h,
	sync_h
);

input 		  clk;
input 		  a_reset_l;
input 		  wb_ack_i;
input [15:0]  wb_dat_i;
input 		  intr_h;
input 		  sync_h;

output 		  wb_we_o;
output		  wb_stb_o;
output 		  wb_cyc_o;
output [15:0] wb_adr_o;
output [15:0] wb_dat_o;
output 		  intr_ack_h; 


wire [15:0] data_in;
wire [15:0] data_out;
wire [15:0] data_b;
wire [15:0] data_instr;
wire reg_file_we;
wire [3:0] a_adr;
wire [3:0] b_adr;
wire [3:0] seg_reg;
wire seg_reg_load;
wire [7:0] alu_op;
wire alu_valid;
wire flag_reg_ce;
wire zflag;
wire sflag;
wire cflag;
wire ovr_flag;
wire [1:0] alu_mux_sel;

zmc_comp zmc_comp_i(
	.clk (clk),
	.a_reset_l(a_reset_l),
	.data_in(data_in),				// data from wb_port
	.data_out(data_out),			// a bus data to wb_port
	.data_b_out(data_b),			// b bus data 
	.data_instr_in(data_instr), 	// data from from instruction (load instruction)
	.reg_file_we_in(reg_file_we), 	// reg_file write enable
	.a_adr_in(a_adr),				// reg file address in
	.b_adr_in(b_adr),	
	.seg_reg_in(seg_reg),			// segmentation reg value in	
	.seg_reg_load_in(seg_reg_load),	// load seg reg value
	.alu_op_in(alu_op),				// alu control
	.alu_valid_out(alu_valid),
	.flag_reg_ce_in(flag_reg_ce),	// flag reg clock enable(),  to activate writing
	.zflag_out(zflag),
	.sflag_out(sflag),
	.cflag_out(cflag),
	.ovr_flag_out(ovr_flag),
	.alu_mux_sel_in(alu_mux_sel) 	 // alu mux select: 1 instr bus ; 2 ALU res ; 3 data_in
	);

 zmc_ctrl zmc_ctrl_i (
    .clk(clk),
	.a_reset_l(a_reset_l),
	.data_in(data_out),				// a bus data to wb_port
	.data_out(data_in),				// data from wb_port
	.data_b_bus_in(data_b),			// b bus data 
	.data_instr_out(data_instr),	// data out to be charged in PC (load instruction)
	.reg_file_we_out(reg_file_we),	// reg_file write enable
	.a_adr_out(a_adr),				// A addr
	.b_adr_out(b_adr),				// B addr
	.seg_reg_out(seg_reg),			// segmentation reg value out	
	.seg_reg_load_out(seg_reg_load),// load seg reg value
	.alu_op_out(alu_op),			// Output of FSM
	.alu_valid_in(alu_valid),		// Input to trigger wait in MUL and DIV
	.flag_reg_ce_out(flag_reg_ce),	// flag reg clock enable(),  to activate writing
	.zflag_in(zflag),				// FLAGS for ALU and MASK
	.sflag_in(sflag),
	.cflag_in(cflag),
	.ovr_flag_in(ovr_flag),
	.wb_ack_in(wb_ack_i),			// acknowledge signal
	.wb_we_out(wb_we_o),			// we wishbone
	.wb_stb_out(wb_stb_o), 			// strobe signal
	.wb_cyc_out(wb_cyc_o), 			// cycle signal
	.wb_adr_out(wb_adr_o),			// address bus
	.wb_data_in(wb_dat_i),			// input data bus
	.wb_data_out(wb_dat_o),			// output data bus
	.intr_h(intr_h),				// interruption request
	.intr_ack_h(intr_ack_h),		// interruption acknowledge
	.sync_h(sync_h),				// synch signal wb
	.alu_mux_sel_out(alu_mux_sel) 	
	);

endmodule
