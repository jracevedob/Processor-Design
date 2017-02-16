module alu_shift (
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
	output	ovr_flag_out;
	output  op_active;

	reg 	[data_wl-1:0]	c_reg;
	reg 	z_flag_out;
   	reg     s_flag_out;
	reg     c_flag_out;
	reg 	op_active_int;
	
	// shift ops
	parameter 	I_SHR0 			= 8'h80; 		
	parameter 	I_SHR1 			= 8'h81; 		
	parameter 	I_SHRA 			= 8'h82; 		
	parameter 	I_SHRC 			= 8'h83; 		
	parameter 	I_ROTR 			= 8'h84; 		
	parameter 	I_ROTRC 		= 8'h85; 		
	parameter 	I_SHL0 			= 8'h88; 		
	parameter 	I_SHL1 			= 8'h89; 		
	parameter 	I_SHLA 			= 8'h8A; 		
	parameter 	I_SHLC 			= 8'h8B; 		
	parameter 	I_ROTL 			= 8'h8C; 		
	parameter 	I_ROTLC 		= 8'h8D; 
	
	assign ovr_flag_out = ovr_flag_in;
	
	always @ (op_in or b_in or c_flag_in)
	begin
		op_active_int = 1'b0;
		case(op_in)
		
			I_SHR0: 	// shift right, shift-in '0'
				begin
					c_reg [data_wl-2:0] = b_in [data_wl-1:1];
					c_reg [data_wl-1] 	= 1'b0;
					c_flag_out			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_SHR1:		// shift right, shift-in '1'
				begin
					c_reg [data_wl-2:0] = b_in [data_wl-1:1];
					c_reg [data_wl-1]	= 1'b1;
					c_flag_out 			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_SHRA: 	// shift right, shift-in MSB of B
				begin
					c_reg [data_wl-2:0] = b_in [data_wl-1:1];
					c_reg [data_wl-1]	= b_in [data_wl-1];
					c_flag_out			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_SHRC: 	// shift right, shift-in carry
				begin
					c_reg [data_wl-2:0] = b_in [data_wl-1:1];
					c_reg [data_wl-1]	= c_flag_in;
					c_flag_out			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_ROTR: 	// shift right, shift-in LSB of B (rotate)
				begin
					c_reg [data_wl-2:0] = b_in [data_wl-1:1];
					c_reg [data_wl-1]	= b_in [0];
					c_flag_out		 	= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_ROTRC:
				begin
					c_reg [data_wl-2:0] = b_in [data_wl-1:1];
					c_reg [data_wl-1]	= c_flag_in;
					c_flag_out 			= b_in[0];
					op_active_int 		= 1'b1;
				end
			I_SHL0: 
				begin
					c_reg [data_wl-1:1] = b_in [data_wl-2:0];
					c_reg [0]		 	= 1'b0;
					c_flag_out 			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_SHL1: 
				begin
					c_reg [data_wl-1:1] = b_in [data_wl-2:0];
					c_reg [0]		 	= 1'b1;
					c_flag_out 			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_SHLA: 
				begin
					c_reg [data_wl-1:1] = b_in [data_wl-2:0];
					c_reg [0]		 	= b_in [0]; //Correction c_reg [0]= b_in [data_wl-1];
					c_flag_out 			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_SHLC: 
				begin
					c_reg [data_wl-1:1] = b_in [data_wl-2:0];
					c_reg [0]		 	= c_flag_in;
					c_flag_out 			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_ROTL: 
				begin
					c_reg [data_wl-1:1] = b_in [data_wl-2:0];
					c_reg [0]		 	= b_in [data_wl-1];
					c_flag_out 			= c_flag_in;
					op_active_int 		= 1'b1;
				end
			I_ROTLC:
				begin
					c_reg [data_wl-1:1] = b_in [data_wl-2:0];
					c_reg [0]		 	= c_flag_in;
					c_flag_out 			= b_in [data_wl-1];
					op_active_int 		= 1'b1;
				end

			default:
				begin
					c_reg 		= 0;
					c_flag_out 	= 1'b0;
				end
		endcase
		
		if (c_reg == 0)
			z_flag_out = 1'b1;
		else
			z_flag_out = 1'b0;
		
		s_flag_out 	=  c_reg[data_wl-1];
	end
	
	assign c_out = c_reg;
	assign op_active = op_active_int;
endmodule
		
