// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   test_ALU_reg.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Thu Apr  9 08:05:27 2015 
// Last Change       :   $Date: 2015-05-07 15:36:25 +0200 (Thu, 07 May 2015) $
// by                :   $Author: mast14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module test_ALU_reg (
	data_in,
	mux_sel,
	seg_reg,
	adr_reg_a,
	adr_reg_b,
	op_in,
	we,
	clk,
	a_reset_l,
	
	valid_o,
	data_o
);

parameter seg_reg_wl	= 4;	// segment register width
parameter adr_reg_wl	= 4;	// address register width
parameter op_wl 		= 8; 

input	[15:0] 				data_in;
input   [1:0] 				mux_sel;
input	[seg_reg_wl-1:0] 	seg_reg;	// segment register
input	[adr_reg_wl-1:0] 	adr_reg_a;	// address register A
input	[adr_reg_wl-1:0] 	adr_reg_b;	// address register B
input 	[op_wl	-1:0]		op_in;
input						we;
input 						clk;
input						a_reset_l;
output						valid_o;
output	[15:0] 				data_o;

wire	[15:0]a_bus;
wire	[15:0]b_bus;
wire	z_from_reg;
wire 	s_from_reg;
wire 	c_from_reg;
wire    ovr_from_reg;

wire 	[15:0]c_bus;
wire 	z_to_reg;
wire 	s_to_reg;
wire 	c_to_reg;
wire 	ovr_to_reg;
wire	valid_bus;

wire 	ce;

wire	[15:0]ir_bus;

wire 	[15:0]reg_bus;

wire 	[6:0]a_adr_bus;
wire	[6:0]b_adr_bus;

reg 	[3:0]adr_reg_a_int;

always@ (*) begin
 	adr_reg_a_int = adr_reg_a;
	adr_reg_a_int[0] = adr_reg_a[0] | valid_bus;
end

zmc_alu zmc_alu_i(
	.a_in(a_bus),
	.b_in(b_bus),
	.op_in(op_in),
	.z_flag_in(z_from_reg),
	.s_flag_in(s_from_reg),
	.c_flag_in(c_from_reg),
	.ovr_flag_in(ovr_from_reg),
	.clk(clk),
	.a_reset_l(a_reset_l),
	.c_out(c_bus),
	.z_flag_out(z_to_reg),
	.s_flag_out(s_to_reg),
	.c_flag_out(c_to_reg),
	.ovr_flag_out(ovr_to_reg),
	.valid_out(valid_bus)
);

flag_reg flag_reg_i(
	.clk(clk),
	.a_reset_l(a_reset_l),
	.ce(1'b1),
	.z_flag_in(z_to_reg),
	.s_flag_in(s_to_reg),
	.c_flag_in(c_to_reg),
	.ovr_flag_in(ovr_to_reg),
	.z_flag_out(z_from_reg),
	.s_flag_out(s_from_reg),
	.c_flag_out(c_from_reg),
	.ovr_flag_out(ovr_from_reg)
);

data_mux3_1 data_mux3_1(
	.in_1(ir_bus),
	.in_2(c_bus),
	.in_3(data_in),
	.sel(mux_sel),
	.out(reg_bus)
);

reg_file reg_file_i(
	.clk(clk),
	.a_reset_l(a_reset_l),
	.a_adr_in(a_adr_bus),
	.b_adr_in(b_adr_bus),
	.reg_a_in(reg_bus),
	.we(we),
	.reg_a_out(a_bus),
	.reg_b_out(b_bus)
);

zmc_adr_gen zmc_adr_gen_i(
	.seg_reg(seg_reg),
	.adr_reg_a(adr_reg_a_int),
	.adr_reg_b(adr_reg_b),
	.a_adr(a_adr_bus),
	.b_adr(b_adr_bus)
);

assign valid_o = valid_bus;
assign data_o = c_bus;

endmodule
