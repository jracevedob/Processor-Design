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
module zmc_comp(
	clk,
	a_reset_l,
	
	// data ports
	data_in,		// data from wb_port
	data_out,		// a bus data to wb_port
	data_b_out,		// b bus data 
	data_instr_in, 	// data from from instruction (load instruction)
	
	// reg_file write enable
	reg_file_we_in,
	
	// reg file address in
	a_adr_in,		
	b_adr_in,	
	seg_reg_in,			// segmentation reg value in	
	seg_reg_load_in,	// load seg reg value
	// alu control
	alu_op_in,
	alu_valid_out,
	// flags
	flag_reg_ce_in,		// flag reg clock enable,  to activate writing
	zflag_out,
	sflag_out,
	cflag_out,
	ovr_flag_out,
	// alu mux select: 1 instr bus ; 2 ALU res ; 3 data_in
	alu_mux_sel_in 	 
	
	
);
parameter 	DATA_WL 	= 16;	// data word length
parameter 	OP_WL	 	= 8;	// alu operation word length
parameter	REG_CNT		= 16;	// number of register in reg file

parameter 	SEG_REG_WL	= 4;	// segmentation reg length
parameter 	ADR_REG_WL	= 4;	// reg file address length 
localparam 	RAM_ADR_WL	= SEG_REG_WL + ADR_REG_WL;

input	clk;
input	a_reset_l;
	
	// data ports
input	[DATA_WL-1 : 0]		data_in;		// data from wb_port
output	[DATA_WL-1 : 0]		data_out;		// a bus data to wb_port
output	[DATA_WL-1 : 0]		data_b_out;		// b bus data 
input	[DATA_WL-1 : 0]		data_instr_in; 	// data from from instruction (load instruction)
	
input						reg_file_we_in;
	// reg file address in
input	[ADR_REG_WL-1 : 0] 	a_adr_in;		
input	[ADR_REG_WL-1 : 0] 	b_adr_in;	
input	[SEG_REG_WL-1 : 0] 	seg_reg_in;			
input						seg_reg_load_in;	
	// alu control
input	[OP_WL-1:0]			alu_op_in;
output						alu_valid_out;
	// flags
input	flag_reg_ce_in;		// flag reg clock enable,  to activate writing
output	zflag_out;
output	sflag_out;
output	cflag_out;
output	ovr_flag_out;
	// alu mux select: 1 instr bus ; 2 ALU res ; 3 data_in
input	[1:0]				alu_mux_sel_in;	 




// wire definitions
wire [DATA_WL-1 : 0]		a_bus;
wire [DATA_WL-1 : 0]		a_bus_reg_file;	// 
	
wire [DATA_WL-1 : 0]		b_bus;
wire [DATA_WL-1 : 0]		c_bus;

wire alu_valid;
wire zflag_to_reg;
wire sflag_to_reg;
wire cflag_to_reg;
wire ovr_flag_to_reg;

wire zflag_from_reg;
wire sflag_from_reg;
wire cflag_from_reg;
wire ovr_flag_from_reg;

wire [ADR_REG_WL+SEG_REG_WL-2:0] a_adr;
wire [ADR_REG_WL+SEG_REG_WL-2:0] b_adr;

reg	 [SEG_REG_WL-1:0]  			 seg_reg;

zmc_alu zmc_alu_i(
	.clk			(clk),
	.a_reset_l		(a_reset_l),
	.a_in			(a_bus),
	.b_in			(b_bus),
	.op_in			(alu_op_in),
	.c_out			(c_bus),
	.z_flag_in		(zflag_from_reg),
	.s_flag_in		(sflag_from_reg),
	.c_flag_in		(cflag_from_reg),
	.ovr_flag_in	(ovr_flag_from_reg),
	.z_flag_out		(zflag_to_reg),
	.s_flag_out		(sflag_to_reg),
	.c_flag_out		(cflag_to_reg),
	.ovr_flag_out	(ovr_flag_to_reg),
	.valid_out		(alu_valid)
);

flag_reg flag_reg_i(
	.clk			(clk),
	.a_reset_l		(a_reset_l),
	.ce				(flag_reg_ce_in),
	.z_flag_in		(zflag_to_reg),
	.s_flag_in		(sflag_to_reg),
	.c_flag_in		(cflag_to_reg),
	.ovr_flag_in	(ovr_flag_to_reg),
	.z_flag_out		(zflag_from_reg),
	.s_flag_out		(sflag_from_reg),
	.c_flag_out		(cflag_from_reg),
	.ovr_flag_out	(ovr_flag_from_reg)
);

data_mux3_1 alu_mux(
	.in_1			(data_instr_in),
	.in_2			(c_bus),
	.in_3			(data_in),
	.sel			(alu_mux_sel_in),
	.out			(a_bus_reg_file)
);

reg_file#(
	.REG_CNT		(REG_CNT)	// number of register entires
) reg_file_i(
	.clk			(clk),
	.a_reset_l		(a_reset_l),
	.a_adr_in		({a_adr[ADR_REG_WL+SEG_REG_WL-2:1], a_adr[0] | alu_valid }), // alu valid for adr increment
	.b_adr_in		(b_adr),
	.reg_a_in		(a_bus_reg_file),
	.we				(reg_file_we_in),
	.reg_a_out		(a_bus),
	.reg_b_out		(b_bus)
);

zmc_adr_gen zmc_adr_gen_i(
	.seg_reg		(seg_reg),
	.adr_reg_a		(a_adr_in),
	.adr_reg_b		(b_adr_in),
	.a_adr			(a_adr),
	.b_adr			(b_adr)
);

always @(posedge clk or negedge a_reset_l)
	begin	
		if(a_reset_l == 1'b0)
			begin
				seg_reg <= 0;
			end	
		else
			begin
				if(seg_reg_load_in == 1'b1)
				 seg_reg <= seg_reg_in;
			end	
		
	end

// output assignment
assign data_out 		= a_bus;
assign data_b_out		= b_bus;

assign alu_valid_out 	= alu_valid;  
assign	zflag_out 		= zflag_from_reg;
assign	sflag_out		= sflag_from_reg;
assign	cflag_out		= cflag_from_reg;
assign	ovr_flag_out	= ovr_flag_from_reg;

endmodule
