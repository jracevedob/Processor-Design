// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   tb_zmc_alu.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Jan 14 11:02:18 2015 
// Last Change       :   $Date: 2015-09-10 19:07:35 +0200 (Thu, 10 Sep 2015) $
// by                :   $Author: mast14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module tb_zmc_alu (
);

 parameter data_wl =16;
 parameter op_wl =8;
  reg  [ data_wl - 1 : 0 ] a_in;
  reg  [ data_wl - 1 : 0 ] b_in;
  reg  [ op_wl - 1 : 0 ] op_in;
  reg  s_flag_in;
  reg  z_flag_in;
  reg  c_flag_in;
  reg  ovr_flag_in;
  reg  clk;
  reg  a_reset_l;
  
  reg [ data_wl - 1 : 0 ] target_val;
  reg error;
  
  wire [ data_wl - 1 : 0 ] c_out;
  wire z_flag_out;
  wire s_flag_out;
  wire c_flag_out;
  wire ovr_flag_out;
  wire valid_out;
 
  zmc_alu zmc_alu_i (
		.a_in(a_in),
		.b_in(b_in),
		.op_in(op_in),
		.s_flag_in(s_flag_in),
		.z_flag_in(z_flag_in),
		.c_flag_in(c_flag_in),
		.ovr_flag_in(ovr_flag_in),
		.clk(clk),
		.a_reset_l(a_reset_l),
		.c_out(c_out),
		.z_flag_out(z_flag_out),
		.s_flag_out(s_flag_out),
		.c_flag_out(c_flag_out),
		.ovr_flag_out(ovr_flag_out),
		.valid_out(valid_out)
        );

  ///////////////////////////////////////////////
  //// Template for clk and reset generation ////
  //// uncomment it when needed              ////
  ///////////////////////////////////////////////
  parameter CLKPERIODE = 100;

  initial clk = 1'b1;
  always #(CLKPERIODE/2) clk = !clk;

  initial begin
      a_reset_l = 1'b0;
      #33
      a_reset_l = 1'b1;
  end
  
  always @ (negedge clk)
  	begin
		if(c_out != target_val)
			error = 1'b1;
		else
			error = 1'b0;
	end
  ///////////////////////////////////////////////

  // Template for testcase specific pattern generation
  // File has to be situated in simulation/<simulator_name>/[testcase] directory
   `include "testcase.v"

endmodule
