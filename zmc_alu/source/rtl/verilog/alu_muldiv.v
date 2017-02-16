`timescale 1ns/10ps
module alu_muldiv (
	a_in,
	b_in,
	op_in,
	clk,
	a_reset_l,
	z_flag_in,
	s_flag_in,
	c_flag_in,
	ovr_flag_in,
	c_out,
	z_flag_out,
	s_flag_out,
	c_flag_out,
	ovr_flag_out,
	valid_out,
	op_active	
);
	parameter data_wl	= 16;
	parameter op_wl 	= 8;

	input	[data_wl-1:0] 	a_in;
	input	[data_wl-1:0]	b_in;
	input 	[op_wl	-1:0]	op_in;
	output 	[data_wl-1:0]	c_out;
	
	input	clk;
	input	a_reset_l;	
	
	input 	z_flag_in;
	input 	s_flag_in;
	input 	c_flag_in;
	input 	ovr_flag_in;
	
	output 	z_flag_out;
	output 	s_flag_out;
	output 	c_flag_out;
	output 	ovr_flag_out;
	output	valid_out;
	output  op_active;
	
	// arith ops
	parameter 	I_MUL	= 8'h02;
	parameter 	I_SMUL	= 8'h22;
	parameter 	I_DIV	= 8'h0F;
	
	reg ld_mul, ld_div;
	reg signd_int;
	reg [data_wl-1:0] c_out_int;
	reg valid_int;
	reg z_flag_int, s_flag_int, ovr_flag_int;
	
	wire  z_flag_mul, s_flag_mul;	
	wire  z_flag_div, ovr_flag_div;	
	wire  [data_wl-1:0]	c_out_div;
	wire  [data_wl-1:0]	c_out_mul;
	wire  valid_div, valid_mul;
	
	reg op_active_int;

	assign c_flag_out 	= c_flag_in;	// no change in this block
	
always @ ( op_in or z_flag_in or s_flag_in or ovr_flag_in or valid_mul or c_out_mul or z_flag_mul or s_flag_mul or
valid_div or ovr_flag_div or c_out_div or z_flag_div or s_flag_in)
	begin		
		ld_mul = 1'b0;
		ld_div = 1'b0;
		signd_int = 1'b0;
		valid_int = 1'b0;
		c_out_int = 'b0;
		z_flag_int = z_flag_in;
		s_flag_int = s_flag_in;
		ovr_flag_int = ovr_flag_in;
		//valid_in = 1'b0;
		op_active_int = 1'b0;
		
		
		case(op_in)
			I_MUL:
				begin
					ld_mul = 1'b1;
					signd_int = 1'b0;
					valid_int = valid_mul;
					c_out_int = c_out_mul;
					z_flag_int = z_flag_mul; 
					s_flag_int = s_flag_mul;
					op_active_int = 1'b1;

				end
			I_SMUL:
				begin
					ld_mul = 1'b1;
					signd_int = 1'b1;
					valid_int = valid_mul;
					c_out_int = c_out_mul;
					z_flag_int = z_flag_mul;
					s_flag_int = s_flag_mul;
					op_active_int = 1'b1;
				end
			I_DIV:
				begin
					ld_div = 1'b1;
					ld_mul = 1'b0;
					valid_int = valid_div;
					c_out_int = c_out_div;
					z_flag_int = z_flag_div;
					s_flag_int = s_flag_in;
					ovr_flag_int = ovr_flag_div;
					op_active_int = 1'b1;
				end	
			
			default:
				begin
					valid_int = 1'b0;
					op_active_int = 1'b0;
				end
		endcase
	end
	
alu_mul alu_mul_i (
	.a_in(a_in),
	.b_in(b_in),
	.signd(signd_int),
	.clk(clk),
	.a_reset_l(a_reset_l),
	.ld(ld_mul),	
	.p_out(c_out_mul),
	.valid(valid_mul),
	.z_flag(z_flag_mul),
	.s_flag(s_flag_mul)
);

alu_div alu_div_i(
	.a_in(a_in),	// divided 
	.b_in(b_in),	// divisor
	.clk(clk),
	.a_reset_l(a_reset_l),
	.ld(ld_div),	
	.p_out(c_out_div),
	.valid(valid_div),
	.z_flag(z_flag_div),
	.ovr_flag(ovr_flag_div)
);

assign c_out = c_out_int ;
assign z_flag_out = z_flag_int;
assign s_flag_out = s_flag_int;
assign ovr_flag_out = ovr_flag_int;
assign valid_out = valid_int ;
assign op_active = op_active_int;

endmodule //
