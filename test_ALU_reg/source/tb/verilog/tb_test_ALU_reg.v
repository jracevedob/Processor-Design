// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   tb_test_ALU_reg.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Thu Apr  9 10:01:56 2015 
// Last Change       :   $Date: 2015-05-07 15:37:24 +0200 (Thu, 07 May 2015) $
// by                :   $Author: mast14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module tb_test_ALU_reg (
);
reg [15:0]data_in;
reg [1:0]mux_sel;

reg [3:0]seg_reg;
reg [3:0]adr_reg_a;
reg [3:0]adr_reg_b;
reg [7:0]op_in;
reg we;
reg clk;
reg a_reset_l;

wire valid_o;
wire [15:0] data_o;
 
 
 test_ALU_reg test_ALU_reg_i (
 	.data_in(data_in),
	.mux_sel(mux_sel),
 	.seg_reg(seg_reg),
	.adr_reg_a(adr_reg_a),
	.adr_reg_b(adr_reg_b),
	.op_in(op_in),
	.we(we),
	.clk(clk),
	.a_reset_l(a_reset_l),
	.valid_o(valid_o),
	.data_o(data_o)
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
  ///////////////////////////////////////////////

  // Template for testcase specific pattern generation
  // File has to be situated in simulation/<simulator_name>/[testcase] directory
  `include "testcase.v"

endmodule
