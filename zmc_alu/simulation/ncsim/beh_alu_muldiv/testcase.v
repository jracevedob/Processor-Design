// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_alu.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Jan 14 10:44:36 2015 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------

//Fill in testcase specific pattern generation
initial begin
    
    a_in 		= 0;
	b_in 		= 0;
	op_in 		= 0;
	s_flag_in 	= 0;
	z_flag_in 	= 0;
	c_flag_in 	= 0;
	ovr_flag_in = 0;
    a_reset_l 	= 1'b1;
	target_val 	= 0;
	
	#1;
	
	//MULDIV TESTBENCH
	
	
		//#(CLKPERIODE);
	
	a_reset_l = 1'b0;
	a_in = 20;
	b_in = -80;
	target_val = -1600;
	op_in = 8'h02; // A = A*B Z

	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);
	a_in = -20;
	b_in = -80;
	target_val = 1600;
	op_in = 8'h02;  // A = A*B Z

	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);
	a_in = -20;
	b_in = 80;
	target_val = -1600;
	op_in = 8'h02; // A = A*B Z

	#(CLKPERIODE);

	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);
	a_in = 20;
	b_in = 80;
	target_val = 1600;
	op_in = 8'h02;  // A = A*B Z

	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);
	a_reset_l = 1'b1;
	a_in = 30;
	b_in = -80;
	target_val = -2400;
	op_in = 8'h22; // A = A*B Z & S

	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);

	a_in = -30;
	b_in = -80;
	target_val = 2400;
	op_in = 8'h22;  // A = A*B Z & S

	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);

	a_in = -30;
	b_in = 80;
	target_val = -2400;
	op_in = 8'h22; // A = A*B Z & S

	#(CLKPERIODE);

	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);
	a_in = 30;
	b_in = 80;
	target_val = 2400;
	op_in = 8'h22;  // A = A*B Z & S
	
	#(CLKPERIODE);
	
	// DIVISION TESTBENCH
	
    while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE)
	a_in = 30;
	b_in = 0;
	target_val = 0;
	op_in = 8'h0F;  // A = A/B Ovr flag ON
	#(CLKPERIODE)
	
		
    while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE)
	
	a_in = 30;
	b_in = 10;
	target_val = 3;
	op_in = 8'h0F;  //  A = A/B
	#(CLKPERIODE)

	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	#(CLKPERIODE)
	
	a_in = 40;
	b_in = 25;
	target_val = 0;
	op_in = 8'h0F;  //  A = A/B
	#(CLKPERIODE);
	
	
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);

	#(CLKPERIODE);
	
	a_in = 45;
	b_in = 9;
	target_val = 5;
	op_in = 8'h0F;  //  A = A/B 
	#(CLKPERIODE*50);
	
		
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE);
	a_in = 125;
	b_in = 5;
	target_val = 25;
	op_in = 8'h0F;  //  A = A/B 
	#(CLKPERIODE);
   	
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE);
	a_in = 128;
	b_in = 16;
	target_val = 8;
	op_in = 8'h0F;  //  A = A/B 
	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE);
	a_in = 120;
	b_in = 40;
	target_val = 3;
	op_in = 8'h0F;  //  A = A/B 
	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE);
	a_in = 0;
	b_in = 5;
	target_val = 0;
	op_in = 8'h0F;  //  A = A/B 
	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
		
	//#(CLKPERIODE);
	a_in = 10;
	b_in = 5;
	target_val = 50;
	op_in = 8'h22;  //  A = A/B 
	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	//#(CLKPERIODE);
	a_in = 9;
	b_in = 5;
	target_val = 45;
	op_in = 8'h22;  //  A = A/B 
	#(CLKPERIODE);
	
	while (valid_out == 1'b0)
		#(CLKPERIODE);
	
	#(CLKPERIODE);
	a_in = 10;
	b_in = 5;
	target_val = 2;
	op_in = 8'h0F;  //  A = A/B 
	#(CLKPERIODE);
	
	
	
		#(CLKPERIODE*20)
    	$finish();
	
end
