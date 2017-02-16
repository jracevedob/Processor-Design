`timescale 1ns/10ps
module alu_selector (
	c_in_arith,	//ALU
	z_flag_in_arith,
	s_flag_in_arith,
	c_flag_in_arith,
	ovr_flag_in_arith,

	c_in_logic,	//LOGIC
	z_flag_in_logic,
	s_flag_in_logic,
	c_flag_in_logic,
	ovr_flag_in_logic,
	
	c_in_shift,	//SHIFT
	z_flag_in_shift,
	s_flag_in_shift,
	c_flag_in_shift,
	ovr_flag_in_shift,
	
	c_in_muldiv,	//MULDIV
	z_flag_in_muldiv,
	s_flag_in_muldiv,
	c_flag_in_muldiv,
	ovr_flag_in_muldiv,
	valid_in_muldiv,
		
	op_in,		//INPUT signals
	active_vec,
	
	c_out,		//OUTPUT signals
	z_flag_out,
	s_flag_out,
	c_flag_out,
	ovr_flag_out
	
);

	parameter data_wl = 16;
	parameter op_wl   = 8;
	
	
	input   [data_wl-1:0]   c_in_arith;	//ALU
	input   		z_flag_in_arith;
	input 			s_flag_in_arith;
	input 			c_flag_in_arith;
	input 			ovr_flag_in_arith;
	
	input   [data_wl-1:0]   c_in_logic;	//LOGIC
	input   		z_flag_in_logic;
	input 			s_flag_in_logic;
	input			c_flag_in_logic;
	input			ovr_flag_in_logic;
	
	input   [data_wl-1:0]   c_in_shift;	//SHIFT
	input   		z_flag_in_shift;
	input 			s_flag_in_shift;
	input			c_flag_in_shift;
	input			ovr_flag_in_shift;
	
	input   [data_wl-1:0]   c_in_muldiv;	//MULDIV
	input   		z_flag_in_muldiv;
	input 			s_flag_in_muldiv;
	input			c_flag_in_muldiv;
	input			ovr_flag_in_muldiv;
	input			valid_in_muldiv;
	
					
	input	[op_wl	-1:0] 	op_in;		//INPUTS to Selector
	input   [3:0]		active_vec;
	
	output  [data_wl-1:0]	c_out;		//OUTPUTS to ZMC
	output			z_flag_out;
	output			s_flag_out;	
	output			c_flag_out;
	output			ovr_flag_out;
	
	reg 	[data_wl:0]     c_reg;
	reg			z_flag_out_reg;
	reg			s_flag_out_reg;	
	reg			c_flag_out_reg;	
	reg			ovr_flag_out_reg;

	always@(c_in_arith or c_in_logic or c_in_shift or c_in_muldiv)
	begin
		
		case(active_vec)
			     
			1: 
			 begin  
			     c_reg = c_in_arith;
			     z_flag_out_reg = z_flag_in_arith;
			     s_flag_out_reg = s_flag_in_arith;
			     c_flag_out_reg = c_flag_in_arith;
			     ovr_flag_out_reg = ovr_flag_in_arith;
			     
			 end
			 
			2: 
			 begin  
			     c_reg = c_in_logic;
			     z_flag_out_reg = z_flag_in_logic;
			     s_flag_out_reg = s_flag_in_logic;
			     c_flag_out_reg = c_flag_in_logic;
			     ovr_flag_out_reg = ovr_flag_in_logic;
			     
			 end
			 
			4: 
			 begin  
			     c_reg = c_in_shift;
			     z_flag_out_reg = z_flag_in_shift;
			     s_flag_out_reg = s_flag_in_shift;
			     c_flag_out_reg = c_flag_in_shift;	
			     ovr_flag_out_reg = ovr_flag_in_shift; 
			     
			 end
			 
			8: 
			 begin  
			     c_reg = c_in_muldiv;
			     z_flag_out_reg = z_flag_in_muldiv;
			     s_flag_out_reg = s_flag_in_muldiv;
			     c_flag_out_reg = c_flag_in_muldiv;
			     ovr_flag_out_reg = ovr_flag_in_muldiv;	
			     
			 end
			 
			default:
			 begin
			     c_reg = 0;
			     z_flag_out_reg = 0;
			     s_flag_out_reg = 0;
			     c_flag_out_reg = 0;
			     ovr_flag_out_reg = 0;	
				  
			 end
			 
		endcase		 

	end
	
	assign c_out = c_reg;
	assign z_flag_out = z_flag_out_reg;
	assign s_flag_out = s_flag_out_reg;
	assign c_flag_out = c_flag_out_reg;
	assign ovr_flag_out = ovr_flag_out_reg;
	


endmodule
