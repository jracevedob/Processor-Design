`timescale 1ns/10ps
module alu_arith (
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
	output  op_active;
	

	wire 	z_flag_out;
	wire 	s_flag_out;
	wire 	c_flag_out;
	wire 	ovr_flag_out;
	
	// carry ripple adder in-/ outputs
	reg  	[data_wl-1:0]		a_reg;
	reg 	[data_wl-1:0]		b_reg;
	reg 				carry_in_reg;
	wire 	[data_wl:0]		carry_reg;
	wire 	[data_wl-1:0]		s_reg;
	
	reg 	z_flag;
	reg 	s_flag;
	reg		c_flag;
	reg		ovr_flag;
	reg		op_active;
	
	// arith ops
	parameter 	I_MOV	= 8'h00;
	parameter 	I_INC	= 8'h01;
	parameter 	I_NEG	= 8'h03;
	parameter 	I_DEC	= 8'h04;
	parameter 	I_ADD	= 8'h08;
	parameter 	I_SUB	= 8'h0B;
	parameter 	I_MOVC	= 8'h20;
	parameter 	I_INCC	= 8'h21;
	parameter 	I_NEGC	= 8'h23;
	parameter 	I_DECC	= 8'h24;
	parameter 	I_ADC	= 8'h28;
	parameter 	I_SUBC	= 8'h2B;
	
	
	// generate carry-ripple adder 
	genvar i;
	generate for (i = 0; i < data_wl; i = i + 1)
		begin: gen_loop	
			full_add full_add_i(a_reg[i],b_reg[i],carry_reg[i],carry_reg[i+1],s_reg[i]); //full_add (a,b,c_in,c_out,s);
		end 
	endgenerate
	
// multiplexing of carry-ripple adder inputs
always @ (op_in or b_in or a_in or c_flag_in or s_flag_in or s_reg or z_flag_in or ovr_flag_in or carry_reg)
	begin
		a_reg	= 0;
		b_reg	= 0; 
		carry_in_reg = 1'b0;
		z_flag	= 1'h0;
		op_active = 1'b0;
		
		case(op_in)
			I_MOV:
				begin
					//c_reg = b_in;op_cont
					a_reg = 0;
					b_reg = b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_INC:	
				begin
					//c_reg = b_in + 1;
					a_reg = 1;
					b_reg = b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_NEG:	
				begin
					//c_reg = -b_in;
					a_reg = 0;
					b_reg = -b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_DEC:
				begin
					//c_reg = b_in - 1;
					a_reg = -1;
					b_reg = b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_ADD:	
				begin
					//c_reg = a_in + b_in;
					a_reg = a_in;
					b_reg = b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_SUB:	
				begin
					//c_reg = a_in - b_in;
					a_reg = a_in;
					b_reg = -b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_MOVC:	//output to SP reg
				begin
					//c_reg = b_in;
					a_reg = 0;
					b_reg = b_in;
					carry_in_reg = 1'b0;
					op_active = 1'b1;
				end
			I_INCC:	
				begin
					//c_reg = b_in + c_flag_in;
					a_reg = 0;
					b_reg = b_in;
					carry_in_reg = c_flag_in;
					op_active = 1'b1;
				end
			I_NEGC:	
				begin
					//c_reg = -b_in - 1 + c_flag_in;
					a_reg = -1;
					b_reg = -b_in;
					carry_in_reg  = c_flag_in;
					op_active = 1'b1;
				end
			I_DECC:	
				begin
					//c_reg = b_in - 1 + c_flag_in;
					a_reg = -1;
					b_reg = b_in;
					carry_in_reg = c_flag_in;
					op_active = 1'b1;
				end
			I_ADC:	
				begin
					//c_reg = a_in + b_in + c_flag_in;
					a_reg = a_in;
					b_reg = b_in;
					carry_in_reg = c_flag_in;
					op_active = 1'b1;
				end
			I_SUBC:	
				begin
					//c_reg = a_in - b_in -1 + c_flag_in;
					a_reg = a_in;
					b_reg = -b_in -1;
					carry_in_reg = c_flag_in;
					op_active = 1'b1;
				end
			
			default:
				begin
					op_active = 1'b0;
				end
		endcase
		
		// flag generation
		if( op_in != I_MOVC && op_in != I_MOV)
			begin
				if (s_reg == 0 && op_in[7:4] == 4'h0) 
					begin		// non continuous
						z_flag = 1'h1;
					end
				else if(s_reg == 0 && op_in[7:4] == 4'h2 && z_flag_in == 1'b1)	// continuous
					begin
						z_flag = 1'h1;
					end
				else 
					begin
						z_flag = 1'h0;
					end
					
				s_flag 		= s_reg[data_wl-1];		// MSB
				c_flag 		= carry_reg[data_wl]; 		// MSB of carry reg
				ovr_flag 	= carry_reg[data_wl] ^ carry_reg[data_wl-1];	// XOR	
			end		
		else
			begin
				z_flag = z_flag_in;
				s_flag = s_flag_in;
				c_flag = c_flag_in;
				ovr_flag = ovr_flag_in;
			end
			
	end //always
	
	assign #1 carry_reg[0]	= carry_in_reg;
	
	assign #1 c_out	= s_reg;	//sum reg
	
	assign #1 z_flag_out 	= z_flag;
	assign #1 s_flag_out 	= s_flag;	// MSB;
	assign #1 c_flag_out 	= c_flag; 	// carry of MSB
	assign #1 ovr_flag_out	= ovr_flag;	// XOR

endmodule
	
	
	
	
