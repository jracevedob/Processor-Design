// Company           :   tud
// Author            :   mast14
// E-Mail            :   <email>
//
// Filename          :   tb_pram_adr_cnt.v
// Project Name      :   prz
// Subproject Name   :   empty
// Description       :   <short description>
//
// Create Date       :   Mon Dec 29 09:19:19 2014
// Last Change       :   $Date: 2015-04-17 14:43:35 +0200 (Fri, 17 Apr 2015) $
// by                :   $Author: mast14 $
//------------------------------------------------------------
`timescale 1ns/10ps
  module tb_pram_adr_cnt (
                        );

  parameter data_wl = 16;		
  parameter adr_wl  = 12;
  
  reg  [ adr_wl - 1 : 0 ] adr_in;
  reg  adr_ld_in;
  reg  inc_in;
  reg  init_mode_in;
  reg  init_ack_in;
  
  wire  [ data_wl - 1 : 0 ] data_in1;
  wire  [ data_wl - 1 : 0 ] data_in2;
  
  reg  clk;
  reg  a_reset_l;
  
  wire [ adr_wl - 1 : 0 ] adr_out;
  wire we_out, start_out;
  wire ovr_out;
 
  pram_adr_cnt pram_adr_cnt_i (
		.adr_in(adr_in),
		.adr_ld_in(adr_ld_in),
		.inc_in(inc_in),
		.init_mode_in(init_mode_in),
		.init_ack_in(init_ack_in),
		.data_in1(data_in1),
		.data_in2(data_in2),
		.clk(clk),
		.a_reset_l(a_reset_l),
		.adr_out(adr_out),
		.we_out(we_out),
		.start_out(start_out),
		.ovr_out(ovr_out)
                      );

pram #(.INITFILE("./mem.txt")) pram_i (
	.data_in(data_in1),
	.adr_in(adr_out),
	.cs(1'b1),
	.we(we_out),
	.clk(clk),
	.data_out(data_in2)
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
