// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   tb_zmc_adr_gen.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Mon Sep 22 10:22:02 2014 
// Last Change       :   $Date: 2015-09-10 19:26:35 +0200 (Thu, 10 Sep 2015) $
// by                :   $Author: mast14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module tb_zmc_adr_gen (
);
 
reg  clk;

parameter seg_reg_wl	= 4;	// segment register width
parameter adr_reg_wl	= 4;	// address register width
parameter ram_adr_wl 	= seg_reg_wl + adr_reg_wl -1; 	// RAM address width, 7 from documentation 
  
reg [seg_reg_wl-1:0] 	seg_reg;	// segment register
reg [adr_reg_wl-1:0] 	adr_reg_a;	// address register a
reg [adr_reg_wl-1:0] 	adr_reg_b;	// address register a
wire [ram_adr_wl-1:0] 	a_adr;		// ram address A
wire [ram_adr_wl-1:0] 	b_adr;		// ram address B
  
zmc_adr_gen zmc_adr_gen_i (
	.seg_reg(seg_reg),
	.adr_reg_a(adr_reg_a),
	.adr_reg_b(adr_reg_b),
	.a_adr(a_adr),
	.b_adr(b_adr)
);  
  
// clock generation
  parameter CLKPERIODE = 100;
  initial clk = 1'b1;
  initial seg_reg = 4'b0000;  
  initial adr_reg_a = 4'b0000;
  initial adr_reg_b = 4'b0000;
  always #(CLKPERIODE/2) clk = !clk;

  
always @ (posedge clk)
	begin
	
	adr_reg_a <= adr_reg_a + 1;
	adr_reg_b <= adr_reg_b + 2;
	
	if(adr_reg_a <= 7)
		seg_reg <= 4'b0000;
	else
		seg_reg <= seg_reg + 1;
	end


endmodule


