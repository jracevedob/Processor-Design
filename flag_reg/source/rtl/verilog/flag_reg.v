// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   flag_reg.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Thu Apr  9 07:57:51 2015 
// Last Change       :   $Date: 2015-04-09 10:03:56 +0200 (Thu, 09 Apr 2015) $
// by                :   $Author: mast14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module flag_reg (
	clk,
	a_reset_l,
	ce,
	z_flag_in,
	s_flag_in,
	c_flag_in,
	ovr_flag_in,
	z_flag_out,
	s_flag_out,
	c_flag_out,
	ovr_flag_out
);
	input 	clk;
	input 	a_reset_l;
	input 	ce;
	input 	z_flag_in;
	input 	s_flag_in;
	input 	c_flag_in;
	input 	ovr_flag_in;
	
	output 	z_flag_out;
	output 	s_flag_out;
	output 	c_flag_out;
	output 	ovr_flag_out;
	
	reg 	z_flag_out;
	reg 	s_flag_out;
	reg 	c_flag_out;
	reg 	ovr_flag_out;	
	
always @(posedge clk or negedge a_reset_l)
	begin
		if (a_reset_l == 1'b0)
		    begin
				z_flag_out		= 1'b0;
				s_flag_out		= 1'b0;	
				c_flag_out		= 1'b0;
				ovr_flag_out	= 1'b0;	
			end	
		else if (ce == 1'b1)
			begin
				z_flag_out		= z_flag_in;
				s_flag_out		= s_flag_in;	
				c_flag_out		= c_flag_in;
				ovr_flag_out	= ovr_flag_in;	
			end
	end // always @ (posedge clk or negedge a_reset_l)
endmodule //

