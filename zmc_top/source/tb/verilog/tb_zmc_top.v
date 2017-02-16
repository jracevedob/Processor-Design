// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   tb_zmc_top.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Nov 25 09:17:53 2015 
// Last Change       :   $Date: 2016-07-26 17:14:23 +0200 (Tue, 26 Jul 2016) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module tb_zmc_top (
);

  reg  clk;
  reg  a_reset_l;
  reg  intr_h;
  reg  sync_h;
  
  wire  wb_ack_i;
  wire  [ 15 : 0 ] wb_dat_i;
  wire wb_we_o;
  wire wb_stb_o;
  wire wb_cyc_o;
  wire [ 15 : 0 ] wb_adr_o;
  wire [ 15 : 0 ] wb_dat_o;
 
  zmc_top zmc_top_i (
		.clk(clk),
		.a_reset_l(a_reset_l),
		.wb_ack_i(wb_ack_i),
		.wb_dat_i(wb_dat_i),
		.intr_h(intr_h),
		.sync_h(sync_h),
		.wb_we_o(wb_we_o),
		.wb_stb_o(wb_stb_o),
		.wb_cyc_o(wb_cyc_o),
		.wb_adr_o(wb_adr_o),
		.wb_dat_o(wb_dat_o),
		.intr_ack_h(intr_ack_h)
        );
		
  ram_wb #(.INITFILE("none")
  )ram_wb_i(
 		.dat_i(wb_dat_o), 
		.dat_o(wb_dat_i), 
		.adr_i(wb_adr_o), 
		.we_i(wb_we_o), 
		.sel_i(4'b1111), 
		.cyc_i(wb_cyc_o), 
		.stb_i(wb_stb_o), 
		.ack_o(wb_ack_i), 
		.cti_i(3'b000), 
		.clk_i(clk), 
		.rst_i(a_reset_l)
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
      #420
      a_reset_l = 1'b1;
  end
  ///////////////////////////////////////////////

  // Template for testcase specific pattern generation
  // File has to be situated in simulation/<simulator_name>/[testcase] directory
   `include "testcase.v"

endmodule
