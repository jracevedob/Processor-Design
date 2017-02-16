// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   tb_ctrl_fsm.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Oct 21 09:56:27 2015 
// Last Change       :   $Date: 2015-11-23 18:58:12 +0100 (Mon, 23 Nov 2015) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module tb_ctrl_fsm (
);

 parameter INSTR_WIDTH    	= 16;
 parameter ADDR_WIDTH_OP  	= 4;
 parameter ADDR_WIDTH_PC  	= 12;
 parameter OPCODE_LGNT 	 	= 8;
 parameter JMPR_OPCODE	 	= 4;
 parameter SEG_REG_WIDTH	= 4;

	reg  				 				clk_i;
	reg  				 				a_reset_l;                           
	reg  [INSTR_WIDTH-1:0] 				out_data_pram_i;	//output data from the PRAM
	reg  				 				intr_h_i;			//interrupt request
	reg  				 				ovr_i;				//goes to 1 if wish bone already loaded
	reg  				 				valid_i; 			//loaded WISHBONE
	reg 				 				wb_ack_i;			//full WISHBONE and ready to be read
	reg  [INSTR_WIDTH-1:0]				data_b_bus_i; 		//bus from B-reg
	reg  [INSTR_WIDTH-1:0]				data_wb_bus_i; 		//bus from wishbone
	reg  				 				mask_i;				//bit for masking
	reg 								sync_h_i;			//synchronization signal
	reg 								alu_valid_i;		//valid signal for mult and div
	wire [OPCODE_LGNT-1:0]				alu_op_o;			// alu operation
	wire 			 					wb_we_o;			//enable wrtie WISHBONE
	wire 			 					wb_start_o;			//start to wrt from WISHBONE
	wire 			 					regfile_we_o;		//register file writes on reg A
	wire [ADDR_WIDTH_OP-1:0] 			adr_a_o;			//addr reg A
	wire [ADDR_WIDTH_OP-1:0] 			adr_b_o;			//addr reg B
	wire 			 					seg_reg_we_o; 		//write enable to write on reg. file
	wire [SEG_REG_WIDTH-1:0] 			seg_reg_o; 			//segmentation register to load reg. file
	wire 								adr_ld_o;			//load addr out to load input address next block
	wire [ADDR_WIDTH_PC-1:0] 			adr_pc_o;			//jumping addr from pc to pram
	wire 								init_mode_o;		//begin initial mode: copy from WISH BONE to PRAM
	wire [1:0]							alu_mux_o;			//output bus to control MUX ALU instr[3], ALU[2] & data_in[1]		
	wire [1:0]							sp_mux_o;			//output bus to control MUX, B_reg[2] & SP[1]	
	wire [1:0]							data_mux_o;			//output bus to control PC[2] & data_out[1]		
	wire								inc_o;				//increment address of program counter
	//wire [INSTR_WIDTH-1:0]     			data_instr_o;		//data from the instruction
 
 
 
ctrl_fsm ctrl_fsm_i (
	.clk_i			(clk_i			),
	.a_reset_l		(a_reset_l		),
	.out_data_pram_i(out_data_pram_i),
	.intr_h_i		(intr_h_i		),		
	.ovr_i			(ovr_i			),					
	.valid_i		(valid_i		), 		
	.wb_ack_i		(wb_ack_i		),
	.data_b_bus_i	(data_b_bus_i	),
	.data_wb_bus_i	(data_wb_bus_i	),  	
	.mask_i			(mask_i			),	
	.sync_h_i		(sync_h_i		),	
	.alu_valid_i	(alu_valid_i	),
	.alu_op_o		(alu_op_o		),
	.wb_we_o		(wb_we_o		),		
	.wb_start_o		(wb_start_o		),		
	.regfile_we_o	(regfile_we_o	),	
	.adr_a_o		(adr_a_o		),		
	.adr_b_o		(adr_b_o		),		
	.seg_reg_we_o	(seg_reg_we_o	), 	
	.seg_reg_o		(seg_reg_o		), 		
	.adr_ld_o		(adr_ld_o		),		
	.adr_pc_o		(adr_pc_o		),		
	.init_mode_o	(init_mode_o	),	
	.alu_mux_o		(alu_mux_o		),		
	.sp_mux_o		(sp_mux_o		),		
	.data_mux_o		(data_mux_o		),
	.inc_o			(inc_o			)
	//.data_instr_o	(data_instr_o	)
	);
 

  ///////////////////////////////////////////////
  //// Template for clk and reset generation ////
  //// uncomment it when needed              ////
  ///////////////////////////////////////////////
  parameter CLKPERIODE = 100;

  initial clk_i = 1'b0;
  always #(CLKPERIODE/2) clk_i = !clk_i;
  

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
