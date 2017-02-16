`timescale 1ns/10ps
module alu_div (
	a_in,	// divided 
	b_in,	// divisor
	clk,
	a_reset_l,
	ld,	
	p_out,
	valid,
	z_flag,
	ovr_flag
);
	parameter data_wl	= 16;
	parameter op_wl 	= 8;

	input	[data_wl-1:0] 	a_in; // divided 
	input	[data_wl-1:0]	b_in; // divisor
	
	input	clk;
	input	a_reset_l;
	input	ld;
	output 	[data_wl-1:0]	p_out;
	output	valid;
	output	z_flag;
	output	ovr_flag;
	
	reg		[data_wl-1:0]	m_reg, nxt_m_reg, cm_reg, nxt_cm_reg; 	// true/complement divisor (B resp. M)
	reg 	[2*data_wl-1:0]	rd_reg, nxt_rd_reg;		        // remainder dividend/quotient reg
	reg		[data_wl-1:0]	p_out_reg;
	
	reg 					ld_reg;
	reg						valid_reg, nxt_valid_reg;
	reg 					z_flag_reg;
	reg 					ovr_flag_reg;
	reg		[4:0] 			cnt, nxt_cnt;
	
	localparam [4:0]
   	IDLE  = 5'b00001,
	SUB1  = 5'b00010,
   	ADD1  = 5'b00100,
	ADD2  = 5'b01000,
	OUTP  = 5'b10000;
	reg [4:0] current_state, nxt_state;
	
	always @(posedge clk or negedge a_reset_l)
	begin
		if (a_reset_l == 1'b0)
			begin
				current_state <= IDLE;
				m_reg	<= 'b0;
				cm_reg	<= 'b0;
				rd_reg  <= 'b0;
				cnt  	<= 'b0;
				//ld_reg	<= 'b0;

			end
		else
			begin
				current_state <= nxt_state;
				
				m_reg	<= nxt_m_reg;
				cm_reg	<= nxt_cm_reg;
				rd_reg  <= nxt_rd_reg;
				cnt 	<= nxt_cnt;
				ld_reg	<= ld;

			end
	end

   	always @(*)
	begin	
		p_out_reg 	= 'b0;
		valid_reg 	= 1'b0;
		nxt_m_reg	= m_reg;
		nxt_cm_reg 	= cm_reg;
		nxt_rd_reg 	= rd_reg;
		nxt_state	= current_state;
		nxt_cnt 	= cnt;
		z_flag_reg   = 'b0;
		ovr_flag_reg = 'b0;
		
		case (current_state)
			IDLE:
				begin	
				p_out_reg 	= a_in;				
			  		if(ld_reg == 1'b1)
					//if(ld == 1'b1)
						begin
							nxt_rd_reg 	= 'b0;
							nxt_rd_reg[data_wl-1:0] = a_in;	// capture input
							nxt_m_reg	= b_in;
							nxt_cm_reg 	= (~b_in-1);
							nxt_cnt    	= data_wl-1;
							nxt_state 	= SUB1;

						end
					else
						begin
							nxt_rd_reg 	= rd_reg ;
						
							nxt_m_reg  	= 'b0;
							nxt_cm_reg 	= 'b0;
							nxt_cnt    	= 'b0;
							nxt_state  	= IDLE;	// stay in current state
		
							end	
				end
			SUB1:
				begin
					nxt_rd_reg = nxt_rd_reg << 1;
					nxt_rd_reg[2*data_wl-1:data_wl]  = nxt_rd_reg[2*data_wl-1:data_wl] - m_reg;
					nxt_state  = ADD1;
				end	
				
			ADD1:
				begin
					if(rd_reg[2*data_wl-1]  == 1'b1 ) 
						begin
							nxt_rd_reg[0] = 1'b0;
							nxt_rd_reg = nxt_rd_reg << 1;
							nxt_rd_reg[2*data_wl-1:data_wl] = nxt_rd_reg[2*data_wl-1:data_wl] + m_reg;
							
						end
					else
						begin
							nxt_rd_reg[0] = 1'b1;
							nxt_rd_reg = nxt_rd_reg << 1;
							nxt_rd_reg[2*data_wl-1:data_wl] = nxt_rd_reg[2*data_wl-1:data_wl] - m_reg;
						end
						
					nxt_cnt = cnt - 1;
					if(nxt_cnt == 0)
						nxt_state = ADD2;
					else
						nxt_state = ADD1;
					
				end
			ADD2:
				begin
					
					if(rd_reg[2*data_wl-1]  == 1'b1 ) 
						begin
							nxt_rd_reg[0] = 1'b0;
							nxt_rd_reg[2*data_wl-1:data_wl] = nxt_rd_reg[2*data_wl-1:data_wl] + m_reg;
						end
					else
						begin
							nxt_rd_reg[0] = 1'b1;
						end
						
					p_out_reg = nxt_rd_reg[data_wl-1:0];
					valid_reg = 1'b0;	
					//valid_reg = 1'b1;				
					nxt_state = OUTP;
				end
			OUTP:
				
				begin
					valid_reg = 1'b1;
					if (rd_reg == 0)
						z_flag_reg = 1'b1;	
					else
						z_flag_reg = 1'b0;	
						
					if(b_in == 0)
						ovr_flag_reg 	= 1'b1;
					else
						ovr_flag_reg 	= 1'b0;
						
					p_out_reg = rd_reg[2*data_wl-1:data_wl];
					valid_reg = 1'b1;	
					//valid_reg = 1'b0;	
					nxt_state = IDLE;
				end
				
			//Correction hal simulation
			default
				begin
					p_out_reg 	= 'b0;
					valid_reg 	= 1'b0;
					nxt_m_reg	= m_reg;
					nxt_cm_reg 	= cm_reg;
					nxt_state 	= IDLE;
				
				end
			
		endcase
	end //always
	
	assign p_out = p_out_reg;
	assign valid = valid_reg;
	assign z_flag = z_flag_reg;
	assign ovr_flag = ovr_flag_reg;
	
endmodule //
