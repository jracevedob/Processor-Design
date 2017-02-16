`timescale 1ns/10ps
module alu_mul (
	a_in,
	b_in,
	signd,
	clk,
	a_reset_l,
	ld,	
	p_out,
	valid,
	z_flag,
	s_flag
);
	parameter data_wl	= 16;
	parameter op_wl 	= 8;

	input	[data_wl-1:0] 	a_in;
	input	[data_wl-1:0]	b_in;
	input 					signd;		// signed mult
	input					clk;
	input					a_reset_l;
	input					ld;			// load values start calculation
	output 	[data_wl-1:0]	p_out;		// product output
	output					valid;		// goes to one for second 16 bit part
	output					z_flag;
	output					s_flag;
		
	reg 	[data_wl-1:0]		p_out_reg;
	reg 	[2*data_wl:0]		pa_reg, nxt_pa_reg; //one bit wider for carry
	reg		[data_wl-1:0]		a_reg, nxt_a_reg;
	reg		[data_wl-1:0]		b_reg, nxt_b_reg;
	
	reg 	ld_reg;
	reg		valid_reg, nxt_valid_reg;
	reg 	z_flag_reg;
	reg 	s_flag_reg;
	reg		[3:0] cnt, nxt_cnt;
	
	localparam [3:0]
    IDLE  = 4'b0001,
    ADD   = 4'b0010,
	OUTP  = 4'b0100;
	reg [3:0] current_state, next_state;
	
	always @(posedge clk or negedge a_reset_l)
	begin
		if (a_reset_l == 1'b0)
			begin
				current_state <= IDLE;
				pa_reg  <= 'b0;
				a_reg	<= 'b0;
				b_reg	<= 'b0;
				cnt  	<= 'b0;
				ld_reg	<= 'b0;
			end
		else
			begin
				current_state <= next_state;
				pa_reg 	<= nxt_pa_reg;
				a_reg	<= nxt_a_reg;
				b_reg	<= nxt_b_reg;
				cnt 	<= nxt_cnt;
				ld_reg	<= ld;
			end
	end

   	always @(*)
	begin	
		p_out_reg 	= 'b0;
		valid_reg 	= 1'b0;
		z_flag_reg 	= 1'b0;
		s_flag_reg 	= 1'b0;
		nxt_pa_reg 	= pa_reg;
		nxt_a_reg	= a_reg;
		nxt_b_reg	= b_reg;
		next_state	= current_state;
		nxt_cnt 	= cnt;
	
		case (current_state )
			IDLE:
				begin		
					p_out_reg 	= a_in;			
			  		if(ld_reg == 1'b1)
						begin
							nxt_pa_reg = 'b0;
							nxt_pa_reg[data_wl-1:0] = a_in;	// capture input
							nxt_a_reg  <= a_in;
							nxt_b_reg  <= b_in;
							nxt_cnt    = 'b0;
							next_state = ADD;
							
						end
					else
						begin
							nxt_pa_reg = 'b0;
							nxt_a_reg  = 'b0;
							nxt_b_reg  = 'b0;
							nxt_cnt    = 'b0;
							next_state 	= IDLE;	// stay in current state
		
						end	
				end
			ADD:
				begin
				
					if(pa_reg[0] == 1'b0) 
						begin
							nxt_pa_reg[2*data_wl:data_wl] = pa_reg[2*data_wl-1:data_wl] + 0;
							nxt_pa_reg = nxt_pa_reg >> 1;
						end
					else
						begin
							nxt_pa_reg[2*data_wl:data_wl] = pa_reg[2*data_wl-1:data_wl] + b_reg;
							nxt_pa_reg = nxt_pa_reg >> 1;
						end
					
					nxt_cnt  = cnt + 1;
					if(nxt_cnt == 0) 
						begin
							next_state = OUTP;
							//valid_reg = 1'b1;
							p_out_reg = nxt_pa_reg[data_wl-1:0];	//lower byte to output port as it is
						end
					else 
						next_state = ADD;
					
				end
			OUTP:
				begin
					valid_reg = 1'b1;	// output upper part 
					if(signd == 1'b1)	// correction of upper byte required if signed
						begin
							
							if(a_reg[data_wl-1] == 1'b1 && b_reg[data_wl-1] == 1'b0 )		 // only A negative
								begin
									p_out_reg = nxt_pa_reg[2*data_wl-1:data_wl] + (~b_reg+1);
									s_flag_reg = 1'b1;
								end
							else if(a_reg[data_wl-1] == 1'b0 && b_reg[data_wl-1] == 1'b1 )	 // only B negative
								begin
									p_out_reg = nxt_pa_reg[2*data_wl-1:data_wl] + (~a_reg+1);
									s_flag_reg = 1'b1;
								end
							else
								p_out_reg = nxt_pa_reg[2*data_wl-1:data_wl] + (~a_reg+1) + (~b_reg+1);
							
							
						end
					else 
						begin
							p_out_reg = nxt_pa_reg[2*data_wl-1:data_wl];
							s_flag_reg = 1'b0;
						end
					
					if(nxt_pa_reg == 0)
						z_flag_reg = 1'b1; // zero flag 
					else
						z_flag_reg = 1'b0;
						
					next_state = IDLE;
				end
				
			default:
				begin
				end
			
		endcase
	end //always
	
	assign p_out = p_out_reg;
	assign valid = valid_reg;
	assign z_flag = z_flag_reg;
	assign s_flag = s_flag_reg;
	
endmodule //
