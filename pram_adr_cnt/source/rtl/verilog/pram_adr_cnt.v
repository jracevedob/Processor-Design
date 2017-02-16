// loadable address counter

module pram_adr_cnt (
	clk,
	a_reset_l,
	adr_in,
	adr_ld_in,
	inc_in,
	init_mode_in,
	init_ack_in,
	data_in1,
	data_in2,
	adr_out,
	we_out,
	start_out,
	ovr_out
);
parameter data_wl = 16;		
parameter adr_wl  = 12;
input 					clk;
input 					a_reset_l;
input 	[adr_wl-1:0]	adr_in;			// input address for load case
input 					adr_ld_in;		// load input address 
input 					inc_in;			// increment address
input					init_mode_in;	// initialisation mode -> copy data from WB ram to PRAM, after start set to one
input					init_ack_in;	// acknowledge from wishbone port
input	[data_wl-1:0]	data_in1;		// PRAM data ports in 
input	[data_wl-1:0]	data_in2;		// PRAM data ports out , to compare data 

output 	[adr_wl-1:0]	adr_out;		// address to local PRAM, in case of init PRAM connect to WB interface
output					we_out;			// write enable of PRAM 
output					ovr_out;		// goes to 1, if all data copied from WB RAM, counter simply overflows
output					start_out;

reg 	[adr_wl-1:0]	adr_out_reg, nxt_adr_out;
reg						ovr_out_reg, nxt_ovr_out;
reg						we_out_reg, nxt_we_out;
reg 					start_out_reg, nxt_start_out;

// states of state machine, 1hot
localparam [4:0]
RUN   = 5'b00001,
INIT  = 5'b00010,
WAIT  = 5'b00100,
ADR   = 5'b01000;
reg [4:0] current_state, nxt_state;
	

always @(posedge clk or negedge a_reset_l)
	begin
		if (a_reset_l == 1'b0)	
			begin
				current_state	<= RUN;
				adr_out_reg 	<= 'b0;
				ovr_out_reg		<= 'b0;
				we_out_reg 		<= 'b0;
				start_out_reg	<= 'b0;
				
			end
		else
			begin
				current_state 	<= nxt_state;
				adr_out_reg 	<= nxt_adr_out;
				ovr_out_reg		<= nxt_ovr_out;
				we_out_reg 		<= nxt_we_out;
				start_out_reg	<= nxt_start_out;
			end
	end
	
always @(*)
	begin
		nxt_state 	= current_state;
		nxt_adr_out = adr_out_reg;
		nxt_ovr_out	= ovr_out_reg;
		nxt_we_out 	= we_out_reg;
		nxt_start_out	= start_out_reg;
		
		case(current_state)
			RUN:				// normal operation, increment, load data	
				begin
					if (adr_ld_in == 1'b1) 
						nxt_adr_out = adr_in + 1;
					else if (inc_in == 1'b1) 
						nxt_adr_out = nxt_adr_out + 1;
					else 
						nxt_adr_out = nxt_adr_out;
	
					//init mode active
					if(init_mode_in == 1'b1)
						begin
							nxt_state     = INIT;
							nxt_adr_out   = 'b0;
							nxt_we_out	  = 1'b0;
							nxt_start_out = 1'b1;
						end
					else
						nxt_state = RUN;
				
				end
				
			INIT:			// init mode copy data from whishbone memory to program ram
				begin
					nxt_start_out	= 1'b0;
					
					if(init_ack_in == 1'b1)		// wait for acknowledgement from WishBone memory
						begin
							nxt_we_out	= 1'b1;
							nxt_state  	= WAIT;
							//nxt_state  	= ADR;
						end
					else
						begin
							nxt_we_out 	= 1'b0;
							nxt_state 	= INIT;
						end
					
				end
				
			WAIT:	// compare incoming with outgoing data of program ram	
				begin
					nxt_start_out	= 1'b0;
					if(data_in1 == data_in2 && init_ack_in == 1'b1)	// wait for correct data at PRAM data_out 
						begin		
							nxt_state   = ADR;
							nxt_we_out  = 1'b0;
						end
					else
						begin
							nxt_we_out  = 1'b1;
							nxt_state   = WAIT;
						end
				end
				
			ADR:	// switch to next address 
				begin
					nxt_we_out 	= 1'b0;
					nxt_adr_out = nxt_adr_out + 1;
					
					//if(nxt_adr_out == 12'bxxxx)	//12bit adr
					if(data_in1 == 16'bxxxx || nxt_adr_out == 12'h050 )	//12bit adr
						begin
							nxt_state   = RUN;
							nxt_ovr_out = 1'b1;
							nxt_adr_out = 12'b0;
						end
					else
						begin
							nxt_ovr_out = 1'b0;
							nxt_state   = INIT;
							nxt_start_out	= 1'b1;
						end
				end
			default:
				begin
				
				end
				
		endcase
		
	end 
	assign adr_out = (adr_ld_in==1'b0)? adr_out_reg : adr_in;
	assign ovr_out = ovr_out_reg;
	assign start_out = start_out_reg;
	assign we_out  = we_out_reg;
	
	
endmodule
    
