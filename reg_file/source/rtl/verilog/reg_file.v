// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   data_path.v                
// Project Name      :   prz    
// Subproject Name   :   tutorial    
// Description       :   instantiation of reg_bank and bus_mux
//
// Create Date       :   Fri Apr 25 07:45:49 2014 
// Last Change       :   $Date: 2016-07-26 17:14:23 +0200 (Tue, 26 Jul 2016) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module reg_file (
	clk,
	a_reset_l,
	a_adr_in,
	b_adr_in,
	reg_a_in,
	we,
	reg_a_out,
	reg_b_out
);
	parameter SEG_REG_WL	= 4;	// segment register width
	parameter ADR_REG_WL	= 4;	// address register width
	parameter RAM_ADR_WL 	= SEG_REG_WL + ADR_REG_WL -1; 	// RAM address width, 7 from documentation 
	parameter DATA_WL		= 16;
	parameter REG_CNT		= 16;	// number of regs 
	
	input 						clk;
	input 						a_reset_l;
	input 	[RAM_ADR_WL-1 :0]	a_adr_in;	// address of memory fed out to reg_a port 
	input	[RAM_ADR_WL-1 :0]	b_adr_in;	// address of memory fed out to reg_b port 
	input 	[DATA_WL-1 :0]		reg_a_in;	// input fed into memory with a_adr
	input 						we;			// write enable of reg a (using a_adr_in)
	output 	[DATA_WL-1 :0]		reg_a_out;	// output of memory on a_adr
	output 	[DATA_WL-1 :0]		reg_b_out;	// output of memory on b_adr
	
	reg 	[DATA_WL-1 :0] mem [0:REG_CNT-1];	// register array 16*16bit
	//reg 	[DATA_WL-1 :0]		reg_a;
	//reg 	[DATA_WL-1 :0]		reg_b;
	
	integer i;	// loop constant for resetting all register
	
	
always @(posedge clk or negedge a_reset_l)
	begin
		if (a_reset_l == 1'b0)
			begin
				for (i = 0; i < REG_CNT; i = i + 1) begin
					mem[i] <= 16'd10;
    			end
			end
		else if (we == 1'b1)
			begin
				mem[a_adr_in] <= reg_a_in;
			end
	end // always @ (posedge clk or negedge a_reset_l)
/*
always @(a_adr_in or b_adr_in or mem )
	begin
	reg_a = mem[a_adr_in];
	reg_b = mem[b_adr_in];		
end // always @ (posedge clk or negedge a_reset_l)


assign reg_a_out = reg_a;
assign reg_b_out = reg_b;
*/

assign reg_a_out = mem[a_adr_in];
assign reg_b_out = mem[b_adr_in];

endmodule //

