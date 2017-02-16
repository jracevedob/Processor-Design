// Company           :   tud
// Author            :   mast14
// E-Mail            :   <email>
//
// Filename          :   pram_adr_cnt.v
// Project Name      :   prz
// Subproject Name   :   empty
// Description       :   <short description>
//
// Create Date       :   Mon Dec 29 09:22:44 2014
// Last Change       :   $Date$
// by                :   $Author$
//------------------------------------------------------------

//Fill in testcase specific pattern generation
initial begin
    #1
	adr_in 		= 0;
	adr_ld_in 	= 1'b0;
	inc_in		= 1'b0;
	init_mode_in= 1'b0;
	init_ack_in = 1'b0;
	#(CLKPERIODE*3)
	
	// load addr
	adr_in 		= 12;
	adr_ld_in 	= 1'b1;
	inc_in		= 1'b1;
	init_mode_in= 1'b0;
	init_ack_in = 1'b0;
	#(CLKPERIODE*1)
	
	// increase/run mode
	adr_in 		= 2;
	adr_ld_in 	= 1'b0;
	inc_in		= 1'b1;
	init_mode_in= 1'b0;
	init_ack_in = 1'b0;
	#(CLKPERIODE*10)
	
	// stop increment 
	adr_in 		= 2;
	adr_ld_in 	= 1'b0;
	inc_in		= 1'b0;
	init_mode_in= 1'b0;
	init_ack_in = 1'b0;
	#(CLKPERIODE*5)
	
	adr_in 		= 2;
	adr_ld_in 	= 1'b1;
	inc_in		= 1'b0;
	init_mode_in= 1'b0;
	init_ack_in = 1'b0;
	#(CLKPERIODE*1)
	
	adr_in 		= 2;
	adr_ld_in 	= 1'b0;
	inc_in		= 1'b0;
	init_mode_in= 1'b0;
	init_ack_in = 1'b0;
	#(CLKPERIODE*5)
	adr_ld_in 	= 1'b0;
	
	$finish();
end
