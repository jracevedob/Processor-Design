// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_alu.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :  top level ALU           
//
// Create Date       :   Mon Sep 22 08:10:44 2014 
// Last Change       :   $Date: 2015-09-10 19:00:53 +0200 (Thu, 10 Sep 2015) $
// by                :   $Author: mast14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module zmc_alu (
	a_in,
	b_in,
	op_in,
	z_flag_in,
	s_flag_in,
	c_flag_in,
	ovr_flag_in,
	clk,
	a_reset_l,
	c_out,
	z_flag_out,
	s_flag_out,
	c_flag_out,
	ovr_flag_out,
	valid_out
);

parameter data_wl	= 16;
parameter op_wl 	= 8;

input	[data_wl-1:0] 	a_in;		// operand a
input	[data_wl-1:0]	b_in;		// operand b
input 	[op_wl	-1:0]	op_in;		// type of operation, keep constnt during operation
	
input	s_flag_in;					// flag inputs
input 	z_flag_in;
input 	c_flag_in;
input   ovr_flag_in;

input 	clk;
input	a_reset_l;

output 	[data_wl-1:0]	c_out;		// result output
output 	z_flag_out;					// flag outputs
output 	s_flag_out;
output 	c_flag_out;
output 	ovr_flag_out;
output	valid_out;					// goes to one if uppter 16bit of result are outputted and calculation is done

wire [data_wl-1:0] c_out_arith;
wire [data_wl-1:0] c_out_logic;
wire [data_wl-1:0] c_out_shift;
wire [data_wl-1:0] c_out_muldiv;
wire [3:0] op_active_vec;
wire s_flag_out_arith, s_flag_out_logic, s_flag_out_shift, s_flag_out_muldiv;
wire z_flag_out_arith, z_flag_out_logic, z_flag_out_shift, z_flag_out_muldiv;
wire c_flag_out_arith, c_flag_out_logic, c_flag_out_shift, c_flag_out_muldiv;
wire ovr_flag_out_arith, ovr_flag_out_logic,ovr_flag_out_shift, ovr_flag_out_muldiv;
wire valid_out_muldiv;
 
assign valid_out = valid_out_muldiv;

alu_arith alu_arith_i (
	.a_in(a_in),
	.b_in(b_in),
	.op_in(op_in),
	.z_flag_in(z_flag_in),
	.s_flag_in(s_flag_in),
	.c_flag_in(c_flag_in),
	.ovr_flag_in(ovr_flag_in),
	.c_out(c_out_arith),
	.z_flag_out(z_flag_out_arith),
	.s_flag_out(s_flag_out_arith),
	.c_flag_out(c_flag_out_arith),
	.ovr_flag_out(ovr_flag_out_arith),
	.op_active(op_active_vec[0])	
);


alu_logic alu_logic_i (
	.a_in(a_in),
	.b_in(b_in),
	.op_in(op_in),
	.z_flag_in(z_flag_in),
	.s_flag_in(s_flag_in),
	.c_flag_in(c_flag_in),
	.ovr_flag_in(ovr_flag_in),
	.c_out(c_out_logic),
	.z_flag_out(z_flag_out_logic),
	.s_flag_out(s_flag_out_logic),
	.c_flag_out(c_flag_out_logic),
	.ovr_flag_out(ovr_flag_out_logic),
	.op_active(op_active_vec[1])	
);

alu_shift alu_shift_i (
	.a_in(a_in),
	.b_in(b_in),
	.op_in(op_in),
	.z_flag_in(z_flag_in),
	.s_flag_in(s_flag_in),
	.c_flag_in(c_flag_in),
	.ovr_flag_in(ovr_flag_in),
	.c_out(c_out_shift),
	.z_flag_out(z_flag_out_shift),
	.s_flag_out(s_flag_out_shift),
	.c_flag_out(c_flag_out_shift),
	.ovr_flag_out(ovr_flag_out_shift),
	.op_active(op_active_vec[2])	
);

alu_muldiv alu_muldiv_i (
	.a_in(a_in),
	.b_in(b_in),
	.op_in(op_in),
	.clk(clk),
	.a_reset_l(a_reset_l),
	.z_flag_in(z_flag_in),
	.s_flag_in(s_flag_in),
	.c_flag_in(c_flag_in),
	.ovr_flag_in(ovr_flag_in),
	.c_out(c_out_muldiv),
	.z_flag_out(z_flag_out_muldiv),
	.s_flag_out(s_flag_out_muldiv),
	.c_flag_out(c_flag_out_muldiv),
	.ovr_flag_out(ovr_flag_out_muldiv),
	.valid_out(valid_out_muldiv),
	.op_active(op_active_vec[3])	

);

alu_selector alu_selector_i (
	.c_in_arith(c_out_arith),
	.c_flag_in_arith(c_flag_out_arith),
	.ovr_flag_in_arith(ovr_flag_out_arith),
	
	.c_in_logic(c_out_logic),
	.c_flag_in_logic(c_flag_out_logic),
	.ovr_flag_in_logic(ovr_flag_out_logic),
	
	.c_in_shift(c_out_shift),
	.c_flag_in_shift(c_flag_out_shift),
	.ovr_flag_in_shift(ovr_flag_out_shift),
	
	.c_in_muldiv(c_out_muldiv),
	.c_flag_in_muldiv(c_flag_out_muldiv),
	.ovr_flag_in_muldiv(ovr_flag_out_muldiv),
	.valid_in_muldiv(valid_out_muldiv),
	
	.z_flag_in_arith(z_flag_out_arith),
	.s_flag_in_arith(s_flag_out_arith),
	.z_flag_in_logic(z_flag_out_logic),
	.s_flag_in_logic(s_flag_out_logic),
	.z_flag_in_shift(z_flag_out_shift),
	.s_flag_in_shift(s_flag_out_shift),
	.z_flag_in_muldiv(z_flag_out_muldiv),
	.s_flag_in_muldiv(s_flag_out_muldiv),
	
	.op_in(op_in),
	.active_vec(op_active_vec),
	
	.c_out(c_out),
	.z_flag_out(z_flag_out),
	.s_flag_out(s_flag_out),
	.c_flag_out(c_flag_out),
	.ovr_flag_out(ovr_flag_out)
);



endmodule
