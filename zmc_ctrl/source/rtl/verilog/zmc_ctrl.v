// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_ctrl.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Thu Nov 12 15:15:22 2015 
// Last Change       :   $Date: 2016-07-26 17:14:23 +0200 (Tue, 26 Jul 2016) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module zmc_ctrl (
	clk,
	a_reset_l,
	
	// data ports
	data_in,				// a bus data to wb_port
	data_out,				// data from wb_port
	data_b_bus_in,			// b bus data 
	data_instr_out, 		// data out to be charged in PC (load instruction)
	
	// reg_file write enable
	reg_file_we_out,
	
	// reg file address in
	a_adr_out,				// A addr
	b_adr_out,				// B addr
	seg_reg_out,			// segmentation reg value out	
	seg_reg_load_out,		// load seg reg value
	
	// alu control
	alu_op_out,				// Output of FSM
	alu_valid_in,			// Input to trigger wait in MUL and DIV
	
	// flags
	flag_reg_ce_out,		// flag reg clock enable,  to activate writing
	zflag_in,				// FLAGS for ALU and MASK
	sflag_in,
	cflag_in,
	ovr_flag_in,
	
	// pram address counter
	
	// pram	
	
	// wish bone signals
	 wb_ack_in,				// acknowledge signal
	 wb_we_out,				// we wishbone
	 wb_stb_out, 			// strobe signal
	 wb_cyc_out, 			// cycle signal
	 wb_adr_out,			// address bus
	 wb_data_in,			// input data bus
	 wb_data_out,			// output data bus
	 intr_h,				// interruption request
	 intr_ack_h,		    // interruption acknowledge
	 sync_h,				// synch signal wb
	
	// mask signal
	
	// alu mux select: 1 instr bus ; 2 ALU res ; 3 data_in
	alu_mux_sel_out 
	
	// stack pointer mux select : 2 B register ; 1 Stack pointer

	// data mux select: 2 Program counter ; 1 Data out
		
	);

parameter 	DATA_WL 	= 16;	// data word length
parameter 	ADR_WL		= 16;
parameter 	OP_WL	 	= 8;	// alu operation word length
parameter	REG_CNT		= 16;	// number of register in reg file
parameter 	PC_ADR_WL	= 12;	// program counter 

parameter 	SEG_REG_WL	= 4;	// segmentation reg length
parameter 	ADR_REG_WL	= 4;	// reg file address length 
localparam 	RAM_ADR_WL	= SEG_REG_WL + ADR_REG_WL -1;

input	clk;
input	a_reset_l;
	
	// data ports
input	[DATA_WL-1 : 0]		data_in;		// a bus data to wb_port
output	[DATA_WL-1 : 0]		data_out;		// data from wb_port
input	[DATA_WL-1 : 0]		data_b_bus_in;		// b bus data 
output  [DATA_WL-1 : 0]		data_instr_out; // data to instruction in PC (load instruction)
	
	// reg file enable
output						reg_file_we_out;
	
	// reg file address in
output[ADR_REG_WL-1 : 0] 	a_adr_out;		
output[ADR_REG_WL-1 : 0] 	b_adr_out;	
output[SEG_REG_WL-1 : 0] 	seg_reg_out;			
output						seg_reg_load_out;	

	// alu control
output[OP_WL-1:0]			alu_op_out;
input						alu_valid_in;

	// flags
output		flag_reg_ce_out;	// flag reg clock enable,  to activate writing
input		zflag_in;
input		sflag_in;
input		cflag_in;
input		ovr_flag_in;
	
	// pram address counter
	
	// pram

	// wishbone signals
input 						wb_ack_in;
output  					wb_we_out;
output						wb_stb_out;		
output						wb_cyc_out; 		
output[ADR_WL-1:0]			wb_adr_out;			
input [DATA_WL-1 : 0]		wb_data_in;	
output[DATA_WL-1 : 0]		wb_data_out;	
input 						intr_h;				
output						intr_ack_h;		    
input						sync_h;			

	// mask result

	// alu mux select: 1 instr bus ; 2 ALU res ; 3 data_in
output[1:0]					alu_mux_sel_out;

	// stack pointer mux select : 2 B register ; 1 Stack pointer

	// data mux select: 2 Program counter ; 1 Data out


wire intr;				// interruption request
wire intr_ack;		    // interruption acknowledge
wire sync;				// synch signal wb

// wire definitions
wire[DATA_WL-1 : 0]		data_out;  			//data out
wire[DATA_WL-1 : 0]		data_instr_out;	//data instr to PC

// register file wires
wire					reg_file_we_out;	//enable reg_file
wire[ADR_REG_WL-1:0] 	a_adr_out;			//4bits reg A
wire[ADR_REG_WL-1:0] 	b_adr_out;			//4bits reg B
wire[SEG_REG_WL-1:0] 	seg_reg_out;		//seg_reg vector			
wire 					seg_reg_load_out; //enable seg_reg write

// alu wires
wire[OP_WL-1:0]			alu_op_out;			//operation of ALU

// flag register wire
wire					flag_reg_ce_out;	

// pram wires
wire					ovr_out;				//goes to 1 if WB loaded
wire[PC_ADR_WL-1:0]		adr_out;				//12 bit data out FSM
wire[PC_ADR_WL-1:0]		pram_adr_out;			//address out of pram_adr_gen
wire					init_mode_out;			//init mode WB
wire 					adr_ld_out;	
wire					inc_out;

// to be checked
wire[DATA_WL-1 : 0]		data_to_pram_out;	
wire[DATA_WL-1 : 0]		data_from_pram_out;	
wire					we_pram_out;
wire					start_out;	

// Wish bone signals to chip
wire					wb_we_out;
wire					wb_stb_out;		
wire					wb_cyc_out; 		
wire[ADR_WL-1:0]		wb_adr_out;			
wire[DATA_WL-1 : 0]		wb_data_out;			
wire					intr_ack_h;

// Wish bone interface	
wire					int_wb_we_out;	    	
wire					wb_start_out;
wire					wb_busy_out;
wire					valid_out;

// mask content
wire 					mask_in;

// MUX
wire[1:0]				alu_mux_sel_out;
wire[1:0]				sp_mux_sel_out;
wire[1:0]				data_mux_sel_out;

// Wish bone RAM
wire [DATA_WL-1 : 0]	wb_ram_data_out;
wire [3:0]				sel_wb_ram_out;
wire [2:0]				cti_wb_ram_out;


wire  [DATA_WL-1:0]		stack_pnt;	
wire [DATA_WL-1:0]		data_io_addr;
wire [DATA_WL-1:0]		data_mux_out;
reg  [SEG_REG_WL-1:0]  	seg_reg;


ctrl_fsm ctrl_fsm_i(
	.clk_i				(clk),
	.a_reset_l			(a_reset_l),
	.out_data_pram_i	(data_instr_out),
	.intr_h_i			(intr),		
	.ovr_i				(ovr_out),			
	.valid_i			(valid_out), 		
	.wb_ack_i			(wb_ack_in),
	.data_b_bus_i		(data_b_bus_in), 
	//.data_wb_bus_i		(data_out),	
	.data_wb_bus_i		(data_in),
	.read_data_wb_bus_i	(data_out),		
	.mask_i				(mask_in),	
	.sync_h_i			(sync),	
	.alu_valid_i		(alu_valid_in),
	.alu_op_o			(alu_op_out),
	.wb_we_o			(int_wb_we_out),		
	.wb_start_o			(wb_start_out),		
	.regfile_we_o		(reg_file_we_out),	
	.adr_a_o			(a_adr_out),		
	.adr_b_o			(b_adr_out),		
	.seg_reg_we_o		(seg_reg_load_out), 	
	.seg_reg_o			(seg_reg_out), 		
	.adr_ld_o			(adr_ld_out),		
	.adr_pc_o			(adr_out),		
	.init_mode_o		(init_mode_out),	
	.alu_mux_o			(alu_mux_sel_out),		
	.sp_mux_o			(sp_mux_sel_out),		
	.data_mux_o			(data_mux_sel_out),
	.inc_o				(inc_out),
	.intr_ack_h			(intr_ack),
	.stack_pnt			(stack_pnt)
	);

data_mux3_1 sp_mux(
	.in_1				(stack_pnt),
	.in_2				(data_b_bus_in),
	//.in_3				(16'd0),
	.in_3				({4'b0000,pram_adr_out}),
	.sel				(sp_mux_sel_out),
	.out				(data_io_addr)
	);

data_mux3_1 data_mux(
	.in_1				(data_in),
	.in_2				({4'b0000,pram_adr_out}),
	.in_3				(16'd0),
	.sel				(data_mux_sel_out),
	.out				(data_mux_out)
	);
	
pram_adr_cnt pram_adr_cnt_i(
	.clk				(clk),
	.a_reset_l			(a_reset_l),
	.adr_in				(adr_out),				
	.adr_ld_in			(adr_ld_out),
	.inc_in				(inc_out),
	.init_mode_in		(init_mode_out),
	.init_ack_in		(wb_ack_in),
	//.data_in1			(data_to_pram_out),  			// check
	.data_in1			(data_out),  			
	.data_in2			(data_instr_out),
	//.data_in2			(pram_adr_out),
	.adr_out			(pram_adr_out),
	.we_out				(we_pram_out),
	.start_out			(start_out),
	.ovr_out			(ovr_out)
	);
	
mask_cndt mask_cndt_i(
	.out_data_pram_i	(data_instr_out),	
	.z_flag_i			(zflag_in),			
	.s_flag_i			(sflag_in),			
	.c_flag_i			(cflag_in),			
	.ovr_flag_i			(ovr_flag_in),		
	.mask_o				(mask_in)
	);
	
wb_interface wb_interface_i(
	.clk				(clk),				// interface side to outer world
	.a_reset_l			(a_reset_l),	
	.wb_ack_i			(wb_ack_in),
	.wb_we_o			(wb_we_out),
	.wb_stb_o			(wb_stb_out),
	.wb_cyc_o			(wb_cyc_out),
	.wb_adr_o			(wb_adr_out),
	.wb_dat_i			(wb_data_in),
	.wb_dat_o			(wb_data_out),
	.intr_h				(intr_h),
	.intr_ack_h			(intr_ack_h),
	.sync_h				(sync_h),
	
	.addr_i				(data_io_addr),		// interface to chip side
	.data_i				(data_mux_out),
	.data_o				(data_out),
	.we_i				(int_wb_we_out),
	.start_i			(wb_start_out),
	.busy_o				(wb_busy_out),
	.valid_o			(valid_out),
	.intr				(intr),
	.intr_ack			(intr_ack),
	.sync				(sync)
	);
	
	
pram #(.INITFILE("none"))
//pram #(.INITFILE(INITFILE))
	pram_i(
	//.data_in			(data_to_pram_out),
	.data_in			(data_out),
	.adr_in				(pram_adr_out),
	.cs					(1'b1),
	.we					(we_pram_out),
	.clk				(clk),
	.data_out			(data_instr_out)
	);
	
	// output assignment
assign data_from_pram_out = data_out;

endmodule
