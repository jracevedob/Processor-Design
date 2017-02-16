                                                                                                                                             // Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   ctrl_fsm.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Fri Aug  7 11:33:33 2015 
// Last Change       :   $Date: 2016-07-26 17:14:23 +0200 (Tue, 26 Jul 2016) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
//`default_nettype none

module ctrl_fsm ( //:(
	clk_i,
	a_reset_l,
	out_data_pram_i,
	intr_h_i,		
	ovr_i,			
	valid_i, 		
	wb_ack_i,
	data_b_bus_i, 
	data_wb_bus_i,	
	read_data_wb_bus_i,	
	mask_i,	
	sync_h_i,	
	alu_valid_i,
	alu_op_o,
	wb_we_o,		
	wb_start_o,		
	regfile_we_o,	
	adr_a_o,		
	adr_b_o,		
	seg_reg_we_o, 	
	seg_reg_o, 		
	adr_ld_o,		
	adr_pc_o,		
	init_mode_o,	
	alu_mux_o,		
	sp_mux_o,		
	data_mux_o,
	inc_o,
	intr_ack_h,
	stack_pnt
	//,data_instr_o
	);

	parameter INSTR_WIDTH    	= 16;
	parameter ADDR_WIDTH_OP  	= 4;
	parameter ADDR_WIDTH_PC  	= 12;
	parameter OPCODE_LGNT 	 	= 8;
	parameter JMPR_OPCODE	 	= 4;
	parameter SEG_REG_WIDTH	 	= 4;
	parameter ADDR_WIDTH_SP		= 16;

	input  				 					clk_i;
	input  				 					a_reset_l;
	input  [INSTR_WIDTH-1:0] 				out_data_pram_i;	//output data from the PRAM
	input  				 					intr_h_i;			//interrupt request
	input  				 					ovr_i;				//goes to 1 if wish bone already loaded
	input  				 					valid_i; 			//loaded WISHBONE
	input 				 					wb_ack_i;			//full WISHBONE and ready to be read
	input  [INSTR_WIDTH-1:0]				data_b_bus_i; 		//bus from B-reg to WB
	input  [INSTR_WIDTH-1:0]				data_wb_bus_i; 		//bus from wishbone
	input  [INSTR_WIDTH-1:0]				read_data_wb_bus_i; //Data read from the WB memory
	input  				 					mask_i;				//bit for masking
	input 									sync_h_i;			//synchronization signal
	input 									alu_valid_i;		//valid signal for mult and div
	output reg 	[OPCODE_LGNT-1:0]			alu_op_o;			//alu operation
	output reg 			 					wb_we_o;			//enable wrtie WISHBONE
	output reg 			 					wb_start_o;			//start to wrt from WISHBONE
	output reg 			 					regfile_we_o;		//register file writes on reg A
	output reg [ADDR_WIDTH_OP-1:0] 			adr_a_o;			//addr reg A
	output reg [ADDR_WIDTH_OP-1:0] 			adr_b_o;			//addr reg B
	output reg 			 					seg_reg_we_o; 		//write enable to write on reg. file
	output reg [SEG_REG_WIDTH-1:0] 			seg_reg_o; 			//segmentation register to load reg. file
	output reg 								adr_ld_o;			//load addr out to load input address next block
	output reg [ADDR_WIDTH_PC-1:0] 			adr_pc_o;			//jumping addr from pc to pram
	output reg 								init_mode_o;		//begin initial mode: copy from WISH BONE to PRAM
	output reg [1:0]						alu_mux_o;			//output bus to control MUX ALU instr[1], ALU[2] & data_in[3]		
	output reg [1:0]						sp_mux_o;			//output bus to control MUX, B_reg[2] & SP[1]	
	output reg [1:0]						data_mux_o;			//output bus to control PC[2] & data_out[1]		
	output reg								inc_o;				//increment address of program counter
	output reg 	     						intr_ack_h;			//acknowledge from attended interruption
	output reg [ADDR_WIDTH_SP-1:0]			stack_pnt;
	
	//reg 					init_mode_o;
	reg [5:0] 				next_state;
	reg [5:0]				current_state;
	reg [OPCODE_LGNT-1:0]	opcode;	
	reg [ADDR_WIDTH_SP-1:0]	next_stack_pnt;
	reg [ADDR_WIDTH_OP-1:0] adr_a_reg, next_adr_a_reg;			//addr reg A
	reg [ADDR_WIDTH_OP-1:0] adr_b_reg, next_adr_b_reg;
	reg [ADDR_WIDTH_PC-1:0] nxt_adr_pc_o;
	reg						nxt_intr_rqst_reg, intr_rqst_reg;	// interruption registers					
	

localparam [4:0]
S_RSET  	= 5'd0,
S_INIT  	= 5'd1,
S_EXET  	= 5'd2,
S_WAIT  	= 5'd3,
S_CALL  	= 5'd4,
S_WT_ACK  	= 5'd5,
S_CALL2		= 5'd6,
S_WTR_ACK  	= 5'd7,
S_CALLR2	= 5'd8,
S_WT_RET 	= 5'd9,
S_RET2		= 5'd10,
S_WT_RETI 	= 5'd11,
S_RETI2		= 5'd12,
S_WT_MRD	= 5'd13,
S_MRD2		= 5'd14,
S_WT_MWD 	= 5'd15,
S_MWD2 		= 5'd16,
S_WT_LD		= 5'd17,
S_LDR2		= 5'd18,
S_WT_CND    = 5'd19,
S_WT_SYNC	= 5'd20,
S_INTR_RQST = 5'd21,
S_INTR_RET 	= 5'd22,
S_WT_INIT	= 5'd23;

parameter ALU_CONT  	= 4'h0;
parameter ALU_DCONT 	= 4'h2;
parameter ALU_MUL   	= 8'h02; 
parameter ALU_SMUL  	= 8'h22;
parameter ALU_DIV   	= 8'h0F;
parameter ALU_LOG		= 4'h4;
parameter ALU_SHFT  	= 4'h8;
parameter JMP			= 4'hC;
parameter JMPR			= 8'hF1;
parameter CALL			= 4'hD;
parameter CALLR		    = 8'hF3;
parameter RET			= 8'hFA;
parameter RETI			= 8'hFB;
parameter MRD			= 8'hF0;
parameter MWR			= 8'hF2;
parameter LOAD			= 8'hF4;
parameter LDR			= 8'hF5;
parameter CND			= 8'hF6;
parameter WT			= 8'hF7;
parameter HLT			= 8'hF8;
parameter SEG			= 8'hF9; 

always @(posedge clk_i or negedge a_reset_l)
	begin	
		if(a_reset_l == 1'b0)
			begin
				current_state <= S_RSET;
				stack_pnt 	  <= 16'd1;   //4 first bits to shift, 12 to pram data
				adr_a_reg	  <= {ADDR_WIDTH_OP{1'b0}};
				adr_b_reg	  <= {ADDR_WIDTH_OP{1'b0}};
				intr_rqst_reg <= 0;
			end	
		else
			begin
				current_state <= next_state;
				stack_pnt	  <= next_stack_pnt;
				adr_a_reg	  <= next_adr_a_reg;
				adr_b_reg	  <= next_adr_b_reg;
				intr_rqst_reg <= nxt_intr_rqst_reg;
			end	
		
	end
	
always @(*)
	begin
		next_state 		= current_state;
		next_stack_pnt	= stack_pnt;
		next_adr_a_reg  = adr_a_reg;
		next_adr_b_reg	= adr_b_reg;		
		
		wb_we_o			= 1'b0;
		wb_start_o		= 1'b0;
		regfile_we_o	= 1'b0;
		alu_op_o		= 8'b0;
		adr_a_o			= 4'b0;
		adr_b_o			= 4'b0;
		seg_reg_we_o	= 1'b0;
		seg_reg_o		= 4'b0;
		adr_ld_o		= 1'b0;
		adr_pc_o		= 12'b0;
		init_mode_o		= 1'b0;
		alu_mux_o		= 2'b0;
		sp_mux_o		= 2'b0;
		data_mux_o		= 2'b0;
		inc_o			= 1'b1;
		nxt_intr_rqst_reg = intr_rqst_reg;
		intr_ack_h		= 1'b0;

	case(current_state)
		S_RSET:				//RESET
			begin
				//next_state 	 	= S_EXET;
				next_state 	 	= S_INIT;
				regfile_we_o  	= 1'b0;
				adr_a_o 	  	= 4'b0;
				adr_b_o 	  	= 4'b0;
				seg_reg_we_o  	= 1'b0;
				seg_reg_o 	  	= 4'b0;
				adr_ld_o	  	= 16'b0;
				init_mode_o   	= 1'b0;	
				inc_o			= 1'b0;
			end
		
		S_INIT:				//INIT nxt_init_mode_i -> 0
			begin
				//wb_we_o		 = 1'b0; //make rqst to read the WB
				//wb_start_o	 = 1'b1;
				init_mode_o  = 1'b1;	
				inc_o		 = 1'b0;
				next_state 	 = S_WT_INIT;		
			end

		S_EXET:				//PROGRAM EXECUTION
			begin
				opcode 	= out_data_pram_i[INSTR_WIDTH-1:8];
				// alu_op_o= 	opcode;	
				case(opcode)
					
					ALU_MUL:
						begin
							if(intr_h_i == 0)
								begin
									alu_mux_o	  	= 2'd2;
									next_state 	  	= S_WAIT;
									regfile_we_o  	= 1'b0;
									adr_ld_o	  	= 1'b0;
									alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
									adr_b_o 	  	= out_data_pram_i[7:4];
									adr_a_o 	  	= out_data_pram_i[3:0];
									// maintain address value
									next_adr_b_reg  = out_data_pram_i[7:4];
									next_adr_a_reg	= out_data_pram_i[3:0];
									inc_o			= 1'b0;	
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end	
						end
						
					ALU_SMUL:
						begin
							if(intr_h_i == 0)
								begin
									alu_mux_o	  	= 2'd2;
									next_state 	  	= S_WAIT;
									regfile_we_o  	= 1'b1;
									adr_ld_o	  	= 1'b0;
									alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
									adr_b_o 	  	= out_data_pram_i[7:4];
									adr_a_o 	  	= out_data_pram_i[3:0];
									// maintain address value
									next_adr_b_reg  = out_data_pram_i[7:4];
									next_adr_a_reg	= out_data_pram_i[3:0];
									inc_o			= 1'b0;
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
						
					ALU_DIV:
						begin
							if(intr_h_i == 0)
								begin
									alu_mux_o	  	= 2'd2;
									next_state	  	= S_WAIT;
									regfile_we_o  	= 1'b1;
									adr_ld_o	  	= 1'b0;
									alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
									adr_b_o 	  	= out_data_pram_i[7:4];
									adr_a_o 	  	= out_data_pram_i[3:0];	
									// maintain address value
									next_adr_b_reg  = out_data_pram_i[7:4];
									next_adr_a_reg	= out_data_pram_i[3:0];
									inc_o			= 1'b0;	
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end		
						end
									
					JMPR:
						begin
							if(intr_h_i == 0)
								begin	
									sp_mux_o 	= 2'd2; //B_reg up
									data_mux_o  = 2'd2; //PC up
									if(mask_i == 1'b0)
										begin
											next_state	= S_EXET;
											inc_o		= 1'b1;	
										end
									else
										begin
											//alu_mux_o 	= 2'd3;
											next_state	= S_EXET;
											adr_b_o 	= out_data_pram_i[7:4];
											adr_pc_o	= data_b_bus_i[11:0];
											regfile_we_o= 1'b0;
											adr_ld_o  	= 1'b1;	
											inc_o 		= 1'b0;	
										end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end									
						end
									
					CALLR:
						begin
							//sp_mux_o	  	= 2'd1; //Input Stack Pointer
							//data_mux_o    	= 2'd2; //Input PC
							//regfile_we_o  	= 1'b0;
							//adr_ld_o	  	= 1'b0;
							if(intr_h_i == 0)
								begin
									if(mask_i == 0)
										begin
											next_state 	= S_EXET;
											inc_o		= 1'b1;
										end
									else
										begin
											sp_mux_o	  	= 2'd1; //Input Stack Pointer
											data_mux_o    	= 2'd2; //Input PC
											regfile_we_o  	= 1'b0;
											adr_ld_o	  	= 1'b0;
											inc_o 			= 1'b0;
											wb_we_o		  	= 1'b1;
											wb_start_o	  	= 1'b1;
											adr_b_o 		= out_data_pram_i[7:4];
											nxt_adr_pc_o	= data_b_bus_i[11:0]; 
											//if(valid_i == 1'b0)
												//begin
												next_state = S_WTR_ACK; //wait until WB loaded		
												//end
											//else
												//begin
												//next_state = S_CALLR2;  
												//end
										end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
						
					RET:
						begin
							if(intr_h_i == 0)
								begin
									sp_mux_o	  	= 2'd1; //Input SP
									data_mux_o    	= 2'd3; //Input WB
									adr_ld_o	  	= 1'b0;
									wb_start_o	  	= 1'b1;
									wb_we_o		  	= 1'b0;
									inc_o			= 1'b0;
									//next_stack_pnt 	= stack_pnt - 12'd1;   //decrement stack by one
									stack_pnt 	= stack_pnt - 12'd1;   //decrement stack by one	
									next_stack_pnt 	= stack_pnt;   //decrement stack by one
									//init_mode_o     = 1'b1;
									//if(valid_i == 1'b0)
										//begin
										next_state = S_WT_RET;
										//end
									//else
										//begin
										//next_state = S_RET2;	
									//end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end	
						end
					
					RETI:
						begin
							sp_mux_o	  	= 2'd1; //Input SP
							data_mux_o    	= 2'd3; //Input WB
							adr_ld_o	  	= 1'b0;
							wb_start_o	  	= 1'b1;
							wb_we_o		  	= 1'b0;
							inc_o			= 1'b0;
							//next_stack_pnt 	= stack_pnt - 12'd1;   //decrement stack by one
							stack_pnt 	= stack_pnt - 12'd1;   //decrement stack by one	
							next_stack_pnt 	= stack_pnt;   //decrement stack by one
							//init_mode_o     = 1'b1;
							//if(valid_i == 1'b0)
								//begin
								next_state = S_WT_RET;
								//end
							//else
								//begin
								//next_state = S_RET2;	
								//end
						end
					
					MRD:
						begin
							if(intr_h_i == 0)
								begin
									sp_mux_o	  	= 2'd2; //reg_B on
									data_mux_o		= 2'd1; //data_out on
									regfile_we_o  	= 1'b0;
									adr_ld_o	  	= 1'b0;
									wb_start_o	  	= 1'b1;
									wb_we_o		  	= 1'b0;
									inc_o 			= 1'b0;
									next_adr_a_reg 	= out_data_pram_i[3:0];
									adr_a_o 		= out_data_pram_i[3:0];
									next_adr_b_reg 	= out_data_pram_i[7:4];
									adr_b_o 		= out_data_pram_i[7:4];
									//if(valid_i == 1'b0)
										//begin
										next_state = S_WT_MRD;
										//end
									//else
										//begin
										//next_state = S_MRD2;
										//end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						
						end
						
					MWR:
						begin
							if(intr_h_i == 0)
								begin
									sp_mux_o	  	= 2'd2; //address B_reg
									data_mux_o    	= 2'd1; //reg A data_out
									regfile_we_o  	= 1'b0;
									adr_ld_o	  	= 1'b0;
									wb_start_o	  	= 1'b1;
									wb_we_o		  	= 1'b1;
									inc_o 			= 1'b0;
									adr_a_o			= out_data_pram_i[3:0];
									next_adr_a_reg 	= out_data_pram_i[3:0];
									adr_b_o 		= out_data_pram_i[7:4];
									next_adr_a_reg  = out_data_pram_i[7:4];
									//if(valid_i == 1'b0)
										//begin
										next_state = S_WT_MWD;
										//end
									//else
										//begin
										//next_state = S_MWD2;
										//end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
						
					LOAD:
						begin
							if(intr_h_i == 0)
								begin
									alu_mux_o		= 2'd1; //B_reg
									next_adr_a_reg	= out_data_pram_i[3:0];
									next_state 	  	= S_WT_LD;
									regfile_we_o  	= 1'b0;
									inc_o	  		= 1'b1;
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
						
					LDR:
						begin
							if(intr_h_i == 0)
								begin
									alu_mux_o		= 2'd2; //A_reg
									next_state  	= S_EXET;
									adr_a_o         = out_data_pram_i[3:0];
									adr_b_o         = out_data_pram_i[7:4];
									alu_op_o		= 8'h00;
									regfile_we_o 	= 1'b1;
									inc_o 			= 1'b1;
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
					
					CND:
						begin
							if(intr_h_i == 0)
								begin
									if(mask_i == 1'b0)
										begin
											next_state 	 = S_WT_CND;
											regfile_we_o = 1'b0;
											inc_o 		 = 1'b1;
										end
									else
										begin
											next_state  = S_EXET;
											inc_o 		= 1'b1;
										end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
					
					WT:
						begin
							if(intr_h_i == 0)
								begin
									next_state 		= S_WT_SYNC;
									regfile_we_o	= 1'b0;
									adr_ld_o   		= 1'b0;
									inc_o 			= 1'b0;
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
					
					HLT:
						begin
							if(a_reset_l == 1'b0)
								begin
									next_state = S_RSET;
								end
							else
								begin
									next_state 		= HLT;
									regfile_we_o	= 1'b0;
									adr_ld_o   		= 1'b0;
								end	
						end
					
					SEG:
						begin
							if(intr_h_i == 0)
								begin
									next_state   	= S_EXET;
									regfile_we_o 	= 1'b1;
									adr_ld_o	 	= 1'b0;
									seg_reg_we_o 	= 1'b1;
									seg_reg_o    	= out_data_pram_i[3:0];
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end				
						end
					
					default:
						begin
						
						end
						
				endcase
				
				if((opcode[7:4] == ALU_CONT) && (opcode[3:0] != 4'h2 && opcode[3:0] != 4'hF))	
					begin
						if(intr_h_i == 0)
							begin
								alu_mux_o	  	= 2'd2;
								next_state 	  	= S_EXET;
								regfile_we_o  	= 1'b1;
								adr_ld_o	  	= 1'b0;
								alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
								adr_b_o 	  	= out_data_pram_i[7:4];
								adr_a_o 	 	= out_data_pram_i[3:0];
								//inc_o			= 1'b1;
							end
						else 
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
								//next_state = S_WT_ACK; //wait until WB loaded
							end	
					end	
					
				else if((opcode[7:4] == ALU_DCONT) && (opcode[3:0] != 4'h2))	
					begin
						if(intr_h_i == 0)
							begin
								alu_mux_o	  	= 2'd2;
								next_state 	  	= S_EXET;
								regfile_we_o  	= 1'b1;
								adr_ld_o	  	= 1'b0;
								alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
								adr_b_o 	  	= out_data_pram_i[7:4];
								adr_a_o 	  	= out_data_pram_i[3:0];
							end
						else
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
								//next_state = S_WT_ACK; //wait until WB loaded
							end	
					end
					
				else if(opcode[7:4] == ALU_LOG)
					begin
						if(intr_h_i == 0)
							begin
								alu_mux_o	  	= 2'd2;
								next_state 	  	= S_EXET;
								regfile_we_o  	= 1'b1;
								adr_ld_o	  	= 1'b0;
								alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
								adr_b_o 	  	= out_data_pram_i[7:4];
								adr_a_o 	  	= out_data_pram_i[3:0];
							end
						else
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
								//next_state = S_WT_ACK; //wait until WB loaded
							end	
					end	
									
				else if(opcode[7:4] == ALU_SHFT)
					begin
						if(intr_h_i == 0)
							begin
								alu_mux_o	  	= 2'd2;
								next_state 	 	= S_EXET;
								regfile_we_o  	= 1'b1;
								adr_ld_o	  	= 1'b0;
								alu_op_o		= out_data_pram_i[INSTR_WIDTH-1:8];
								adr_b_o 	  	= out_data_pram_i[7:4];
								adr_a_o 	  	= out_data_pram_i[3:0];
							end
						else
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
								//next_state = S_WT_ACK; //wait until WB loaded
							end
					end
					
				else if(opcode[7:4] == JMP)
					begin
						if(intr_h_i == 0)
							begin
								alu_mux_o	  	= 2'd1;  //instruction ON
								next_state	  	= S_EXET;
								adr_pc_o	  	= out_data_pram_i[11:0];
								regfile_we_o  	= 1'b1;
								adr_ld_o	  	= 1'b1;
							end	
						else
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
								//next_state = S_WT_ACK; //wait until WB loaded
							end		
					end
					
				else if(opcode[7:4] == CALL)
						begin
							if(intr_h_i == 0)
								begin
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									nxt_adr_pc_o = out_data_pram_i[11:0];
									//if(valid_i == 1'b0)
										//begin
										next_state = S_WT_ACK; //wait until WB loaded		
										//end
									//else
										//begin
										//next_state = S_CALL2;  
									//end
								end
							else
								begin
									next_state 	 = S_INTR_RQST;
									sp_mux_o	 = 2'd1; //Input Stack Pointer
									data_mux_o   = 2'd2; //Input PC
									regfile_we_o = 1'b0;
									adr_ld_o	 = 1'b0;
									wb_we_o		 = 1'b1;
									wb_start_o	 = 1'b1;
									inc_o		 = 1'b0;
									//next_state = S_WT_ACK; //wait until WB loaded
								end
						end
				
			
			end
		//ALU WAIT STATES	
		S_WAIT:				//WAIT ALU OPERATIONS
			begin
				if(alu_valid_i == 1'b0)
					begin
						//alu_op_o 	 =out_data_pram_i[INSTR_WIDTH-1:8];
						alu_op_o	 = 	opcode;	 
						inc_o 		 = 1'b0;
						next_state 	 = S_WAIT;
						regfile_we_o = 1'b0;
						adr_ld_o 	 = 1'b0;
						alu_mux_o	 = 2'd2;
						adr_a_o 	 = adr_a_reg;
						adr_b_o 	 = adr_b_reg;
						if(intr_h_i == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
					end
				else
					begin	
						//alu_op_o 	 = out_data_pram_i[INSTR_WIDTH-1:8];
						alu_op_o	 = opcode;	
						//next_state 	 = S_EXET;
						regfile_we_o = 1'b1;
						inc_o 		 = 1'b1;
						adr_ld_o 	 = 1'b0;
						alu_mux_o	 = 2'd2;
						adr_a_o 	 = adr_a_reg;
						adr_b_o 	 = adr_b_reg;
						if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
							end
						else 
							begin
								next_state 	 = S_EXET;
							end
					end
			end
		
		//CALL STATES
		S_WT_ACK:
			begin
				if(wb_ack_i == 1'b1)
					begin
						next_state 		= S_CALL2;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						inc_o			= 1'b0;
						sp_mux_o 		= 2'd1;		
						data_mux_o   	= 2'd2; //Input PC
						//wb_we_o		 	= 1'b1;
						//wb_start_o	 	= 1'b1;
						if(intr_h_i == 1'b1)
							begin
								intr_rqst_reg = 1'b1;
							end
					end	
	
				else
					begin
						next_state 		= S_WT_ACK;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						inc_o			= 1'b0;
						sp_mux_o 		= 2'd1;
						data_mux_o   	= 2'd2; //Input PC
						//wb_we_o		 	= 1'b1;
						//wb_start_o	 	= 1'b1;
						if(intr_h_i == 1'b1)
							begin
								intr_rqst_reg = 1'b1;
							end
					end
			end
					
		S_CALL2:
			begin
				inc_o			= 1'd0;
				sp_mux_o 		= 2'd1;
				data_mux_o   	= 2'd2; //Input PC
				//next_state 	  	= S_EXET;
				regfile_we_o  	= 1'b0;
				adr_ld_o	  	= 1'b1;	
				adr_pc_o 	  	= nxt_adr_pc_o;
				next_stack_pnt  = stack_pnt + 12'd1;   //increment stack by one	
				//wb_we_o		 	= 1'b1;
				//wb_start_o	 	= 1'b1;
				if(intr_rqst_reg == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end
			end
			
				//CALL STATES
		S_WTR_ACK:
			begin
				if(wb_ack_i == 1'b1)
					begin
						next_state = S_CALLR2;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						sp_mux_o 		= 2'd1;
						inc_o		    = 1'b0;
						data_mux_o   	= 2'd2; //Input PC	
						if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
						else
							begin
								nxt_intr_rqst_reg = 1'b0;
							end
					end	
	
				else
					begin
						next_state = S_WTR_ACK;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						sp_mux_o 		= 2'd1;
						inc_o		    = 1'b0;
						data_mux_o   	= 2'd2; //Input PC
						if(intr_h_i == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
					end
			end
					
		S_CALLR2:
			begin
				inc_o			= 1'd0;
				sp_mux_o 		= 2'd1;
				data_mux_o		= 2'd2;
				//next_state 	  	= S_EXET;
				regfile_we_o  	= 1'b0;
				adr_ld_o	  	= 1'b1;	
				adr_pc_o	  	= nxt_adr_pc_o;
				next_stack_pnt  = stack_pnt + 12'd1;   //increment stack by one	
				if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
						sp_mux_o	 = 2'd1; //Input Stack Pointer
						data_mux_o   = 2'd2; //Input PC
						regfile_we_o = 1'b0;
						adr_ld_o	 = 1'b0;
						wb_we_o		 = 1'b1;
						wb_start_o	 = 1'b1;
						inc_o		 = 1'b0;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end	
			end
		
		//RETURN STATES
		S_WT_RET:
			begin
			    sp_mux_o	= 2'd1; //stack pointer
				alu_mux_o	= 2'd3;
				if(valid_i == 1'b0)
					begin
						next_state 		= S_WT_RET;
						//adr_pc_o 		= read_data_wb_bus_i[11:0];
						adr_ld_o	  	= 1'b0;
						wb_start_o	  	= 1'b0;
						wb_we_o		  	= 1'b0;
						inc_o			= 1'b0;	
						if(intr_h_i == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
					end
				else
					begin
						next_state 		= S_RET2;
						nxt_adr_pc_o 	= read_data_wb_bus_i[11:0];
						adr_ld_o	  	= 1'b0;
						wb_start_o	  	= 1'b0;
						wb_we_o		  	= 1'b0;
						inc_o			= 1'b0;	
						//stack_pnt 		= stack_pnt - 16'd1;   //decrement stack by one	
						if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
						else 
							begin
								nxt_intr_rqst_reg = 1'b0;
							end
					end
			end
		
		S_RET2:
			begin
				sp_mux_o		= 2'd1; //stack pointer
				alu_mux_o		= 2'd3; //write register returned from WB
				//next_state 		= S_EXET;
				adr_pc_o 		= nxt_adr_pc_o;
				adr_ld_o	  	= 1'b1;
				wb_start_o	  	= 1'b0;
				wb_we_o		  	= 1'b0;
				//next_stack_pnt 	= stack_pnt - 12'd1;   //decrement stack by one	
				if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
						sp_mux_o	 = 2'd1; //Input Stack Pointer
						data_mux_o   = 2'd2; //Input PC
						regfile_we_o = 1'b0;
						adr_ld_o	 = 1'b0;
						wb_we_o		 = 1'b1;
						wb_start_o	 = 1'b1;
						inc_o		 = 1'b0;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end	
				
			end
		
		S_WT_RETI:
			begin
				sp_mux_o	= 2'd1; //stack pointer
				alu_mux_o	= 2'd3;
				if(valid_i == 1'b0)
					begin
						next_state = S_WT_RETI;
						//adr_pc_o 		= read_data_wb_bus_i[11:0];
						adr_ld_o	  	= 1'b0;
						wb_start_o	  	= 1'b0;
						wb_we_o		  	= 1'b0;
						inc_o			= 1'b0;	
					end
				else
					begin
						next_state 		= S_RETI2;
						nxt_adr_pc_o 	= read_data_wb_bus_i[11:0];
						adr_ld_o	  	= 1'b0;
						wb_start_o	  	= 1'b0;
						wb_we_o		  	= 1'b0;
						inc_o			= 1'b0;	
						//stack_pnt 		= stack_pnt - 12'd1;   //decrement stack by one
					end
			
			end
		S_RETI2:
			begin
				sp_mux_o		= 2'd1; //stack pointer
				alu_mux_o		= 2'd3; //write register returned from WB
				inc_o			= 1'b0;
				next_state 		= S_EXET;
				adr_pc_o 		= nxt_adr_pc_o;
				adr_ld_o	  	= 1'b1;
				wb_start_o	  	= 1'b0;
				wb_we_o		  	= 1'b0;
				//next_stack_pnt 	= stack_pnt - 12'd1;   //decrement stack by one	
			end
		
		
		S_WT_MRD:
			begin
				sp_mux_o	  	= 2'd2; //reg_B on
				data_mux_o		= 2'd1; //data_out on
				alu_mux_o		= 2'd3;
				if(valid_i == 1'b0)
					begin
						next_state 		= S_WT_MRD;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						inc_o 			= 1'b0;
						adr_a_o			= next_adr_a_reg;
						adr_b_o			= next_adr_b_reg;
						if(intr_h_i == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
					end
				else
					begin
						next_state 		= S_MRD2;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						inc_o 			= 1'b0;
						adr_a_o			= next_adr_a_reg;
						adr_b_o			= next_adr_b_reg;
						if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
						else
							begin
								nxt_intr_rqst_reg = 1'b0;
							end
					end
			end
		
		S_MRD2:
			begin
				alu_mux_o		= 2'd3;
				sp_mux_o		= 2'd2;
				data_mux_o		= 2'd1;
				//next_state 	  	= S_EXET;
				regfile_we_o  	= 1'b1;
				adr_a_o			= next_adr_a_reg;
				adr_b_o			= next_adr_b_reg;
				inc_o 			= 1'b1;
				if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
						sp_mux_o	 = 2'd1; //Input Stack Pointer
						data_mux_o   = 2'd2; //Input PC
						regfile_we_o = 1'b0;
						adr_ld_o	 = 1'b0;
						wb_we_o		 = 1'b1;
						wb_start_o	 = 1'b1;
						inc_o		 = 1'b0;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end
			end
			
		S_WT_MWD:
			begin
				sp_mux_o	  	= 2'd2; //reg_B on
				data_mux_o		= 2'd1; //data_out on
				//adr_a_o         = next_adr_a_reg;
				//adr_b_o		  = next_adr_b_reg;
				if(valid_i == 1'b0)
					begin
						next_state = S_WT_MWD;
						inc_o 	   = 1'b0;
						adr_a_o    = next_adr_a_reg;
						adr_b_o	   = next_adr_b_reg;
						if(intr_h_i == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
					end
				else
					begin
						next_state = S_MWD2;
						inc_o 	   = 1'b0;
						adr_a_o    = next_adr_a_reg;
						adr_b_o	   = next_adr_b_reg;
						if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end
						else
							begin
								nxt_intr_rqst_reg = 1'b0;
							end
					end
			end
		
		S_MWD2:
			begin
				sp_mux_o	  = 2'd2;	//B_reg
				data_mux_o	  = 2'd1; 	//data_out
				//next_state 	  = S_EXET;	
				inc_o 		  = 1'b1;
				adr_a_o		  = next_adr_a_reg;
				adr_b_o		  = next_adr_b_reg;	
				if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
						sp_mux_o	 = 2'd1; //Input Stack Pointer
						data_mux_o   = 2'd2; //Input PC
						regfile_we_o = 1'b0;
						adr_ld_o	 = 1'b0;
						wb_we_o		 = 1'b1;
						wb_start_o	 = 1'b1;
						inc_o		 = 1'b0;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end
			end
			
		S_WT_LD:
			begin
				adr_a_o 	 = next_adr_a_reg;
				alu_mux_o	 = 2'd1; 	//instruction to A reg
				//next_state 	 = S_EXET;
				regfile_we_o = 1'b1;
				inc_o		 = 1'b1;
				if(intr_h_i == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
						sp_mux_o	 = 2'd1; //Input Stack Pointer
						data_mux_o   = 2'd2; //Input PC
						regfile_we_o = 1'b0;
						adr_ld_o	 = 1'b0;
						wb_we_o		 = 1'b1;
						wb_start_o	 = 1'b1;
						inc_o		 = 1'b0;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end
			end
			
			
		S_WT_CND:
			begin
				//next_state 	 = S_EXET;
				regfile_we_o = 1'b0;
				adr_ld_o   	 = 1'b0;		// ignoring next instruction		
				inc_o 		 = 1'b1;
				if(intr_h_i == 1'b1)
					begin
						next_state 	  = S_INTR_RQST;
						sp_mux_o	 = 2'd1; //Input Stack Pointer
						data_mux_o   = 2'd2; //Input PC
						regfile_we_o = 1'b0;
						adr_ld_o	 = 1'b0;
						wb_we_o		 = 1'b1;
						wb_start_o	 = 1'b1;
						inc_o		 = 1'b0;
					end	
				else
					begin
						next_state 	  = S_EXET;
					end
			end
		
		S_WT_SYNC:
			begin
				if(sync_h_i == 1'b0)
					begin
						next_state	 = S_WT_SYNC;
						regfile_we_o = 1'b0;
						inc_o 		 = 1'b0;
						if(intr_h_i == 1'b1)
							begin
								nxt_intr_rqst_reg = 1'b1;
							end	
					end
				else
					begin
						//next_state 	 = S_EXET;
						regfile_we_o = 1'b0;
						inc_o 		 = 1'b1;
						if(intr_h_i == 1'b1 || intr_rqst_reg == 1'b1)
							begin
								next_state 	 = S_INTR_RQST;
								sp_mux_o	 = 2'd1; //Input Stack Pointer
								data_mux_o   = 2'd2; //Input PC
								regfile_we_o = 1'b0;
								adr_ld_o	 = 1'b0;
								wb_we_o		 = 1'b1;
								wb_start_o	 = 1'b1;
								inc_o		 = 1'b0;
							end 
						else
							begin
								next_state 	 = S_EXET;
							end
					end
			end
			
		S_INTR_RQST:
			begin
				if(wb_ack_i == 1'b1)
					begin
						next_state 		= S_INTR_RET;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						inc_o			= 1'b0;
						sp_mux_o 		= 2'd1;		
						data_mux_o   	= 2'd2; //Input PC
						//wb_we_o		 	= 1'b1;
						//wb_start_o	 	= 1'b1;
					end	
	
				else
					begin
						next_state 		= S_INTR_RQST;
						regfile_we_o  	= 1'b0;
						adr_ld_o	  	= 1'b0;
						inc_o			= 1'b0;
						sp_mux_o 		= 2'd1;
						data_mux_o   	= 2'd2; //Input PC
						//wb_we_o		 	= 1'b1;
						//wb_start_o	 	= 1'b1;
					end
			end
			
		S_INTR_RET:
			begin
				inc_o			= 1'd0;
				sp_mux_o 		= 2'd1;
				data_mux_o   	= 2'd2; //Input PC
				//next_state 	  	= RETI;
				next_state 	  	= S_EXET;
				regfile_we_o  	= 1'b0;
				adr_ld_o	  	= 1'b1;	
				adr_pc_o 	  	= 12'h04A;
				next_stack_pnt  = stack_pnt + 12'd1;   //increment stack by one	
				//wb_we_o		 	= 1'b1;
				//wb_start_o	 	= 1'b1;
				intr_ack_h		= 1'b1;
				nxt_intr_rqst_reg = 1'b0;
			end
			
		S_WT_INIT:
			begin
				if(ovr_i == 1'b0)
					begin
						next_state 	 = S_WT_INIT; 	//stay in INIT until ovr_i ->1, in which PRAM is full
						init_mode_o  = 1'b0;
						wb_we_o		 = 1'b0; //make rqst to read the WB
						wb_start_o	 = 1'b1;
						inc_o 		 = 1'b0;
						sp_mux_o	 = 2'd3;	
					end
				else
					begin
						next_state 	 = S_EXET;
						init_mode_o  = 1'b0;
						wb_we_o		 = 1'b0; //make rqst to read the WB
						wb_start_o	 = 1'b0;
						inc_o 		 = 1'b0;
					end
			end
				
		endcase	
	end

endmodule
 

