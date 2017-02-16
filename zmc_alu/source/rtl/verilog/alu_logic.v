module alu_logic (
	a_in,
	b_in,
	op_in,
	z_flag_in,
	s_flag_in,
	c_flag_in,
	ovr_flag_in,
	c_out,
	z_flag_out,
	s_flag_out,
	c_flag_out,
	ovr_flag_out,
	op_active	
);
	parameter data_wl	= 16;
	parameter op_wl 	= 8;
	
	input	[data_wl-1:0] 	a_in;
	input	[data_wl-1:0]	b_in;
	input 	[op_wl	-1:0]	op_in;
	
	input 	z_flag_in;
	input 	s_flag_in;
	input 	c_flag_in;
	input 	ovr_flag_in;

	output 	[data_wl-1:0]	c_out;
	
	output 	z_flag_out;
	output 	s_flag_out;
	output 	c_flag_out;
	output 	ovr_flag_out;
	output 	op_active;

	reg 	[data_wl:0]	c_reg;
	reg 	z_flag_out;
    	reg     s_flag_out;
	reg 	op_active;
	
	// logic ops
	parameter 	I_LG_0			= 8'h40;
	parameter 	I_NOR			= 8'h41;
	parameter 	I_A_AND_NOT_B	= 8'h42;
	parameter 	I_NOT_B			= 8'h43;
	parameter 	I_NOT_A_AND_B	= 8'h44;
	parameter 	I_NOT_A			= 8'h45;
	parameter 	I_XOR			= 8'h46;
	parameter 	I_NAND			= 8'h47;
	parameter 	I_AND			= 8'h48;
	parameter 	I_XNOR			= 8'h49;
	parameter 	I_LG_A			= 8'h4A;
	parameter 	I_A_OR_NOT_B	= 8'h4B;
	parameter 	I_LG_B			= 8'h4C;
	parameter 	I_NOT_A_OR_B	= 8'h4D;
	parameter 	I_OR			= 8'h4E;
	parameter 	I_LG_1			= 8'h4F;
	
	assign 	c_flag_out	= c_flag_in;		// no change in this block
	assign 	ovr_flag_out	= ovr_flag_in;
	
	always @ (op_in or a_in or b_in)
	begin
	
		op_active = 1'b0;
		case(op_in)
		
			I_LG_0:
				begin
					c_reg = 0;
					op_active = 1'b1;
				end
			I_NOR:	
				begin
					c_reg = ~(a_in | b_in);
					op_active = 1'b1;
				end
			I_A_AND_NOT_B:	
				begin
					c_reg = a_in & (~b_in);
					op_active = 1'b1;
				end
			I_NOT_B:
				begin
					c_reg = (~b_in);
					op_active = 1'b1;
				end
			I_NOT_A_AND_B:	
				begin
					c_reg = (~a_in) & b_in;
					op_active = 1'b1;
				end
			I_NOT_A:		
				begin
					c_reg = (~a_in);
					op_active = 1'b1;
				end
			I_XOR:		
				begin
					c_reg = a_in ^ b_in;
					op_active = 1'b1;
				end
			I_NAND:			
				begin
					c_reg = ~(a_in & b_in);
					op_active = 1'b1;
				end
			I_AND:			
				begin
					c_reg = a_in & b_in;
					op_active = 1'b1;
				end
			I_XNOR:		
				begin
					c_reg = a_in ^~ b_in;
					op_active = 1'b1;
				end
			I_LG_A:		
				begin
					c_reg = a_in;
					op_active = 1'b1;
				end
			I_A_OR_NOT_B:	
				begin
					c_reg = a_in | (~b_in);
					op_active = 1'b1;
				end
			I_LG_B:			
				begin
					c_reg = b_in;
					op_active = 1'b1;
				end
			I_NOT_A_OR_B:	
				begin
					c_reg = (~a_in) | b_in;
					op_active = 1'b1;
				end
			I_OR:			
				begin
					c_reg = a_in | b_in;
					op_active = 1'b1;
				end
			I_LG_1:			
				begin
					c_reg = 1;
					op_active = 1'b1;
				end
				
			default:
				begin
					c_reg = 0;
				end
		endcase
		
		if (c_reg == 0)
			z_flag_out = 1'b1;
		else
			z_flag_out = 1'b0;
		
		s_flag_out 	=  c_reg[data_wl-1];
	end
	
	assign c_out = c_reg;
		
	
	
endmodule
		
		
		
