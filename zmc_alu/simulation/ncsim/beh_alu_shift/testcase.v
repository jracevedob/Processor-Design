// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_alu.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Jan 14 10:44:25 2015 
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
	ovr_flag_in 	= 0;
    	a_reset_l 	= 1'b1;
	target_val 	= 0;
    
    //SHIFT TESTBENCH

	#(CLKPERIODE*5)
	a_in       = 16'b0000100011111011;
	b_in 	   = 16'b1110000000000110;
	target_val = 16'b0111000000000011;
	op_in = 8'h80; // SHIFT RIGHT 0

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110;
	target_val = 16'b1111000000000011;
	op_in = 8'h81; // SHIFT RIGHT 1

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110;
	target_val = 16'b1111000000000011;
	op_in = 8'h82; // SHIFT MSB RIGHT B

	#(CLKPERIODE*5)
	c_flag_in  = 1'b0;	
	
	b_in 	   = 16'b1110000000000110;
	target_val = 16'b0111000000000011;
	op_in = 8'h83; // SHIFT RIGHT CARRY C

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110;
	target_val = 16'b0111000000000011;
	op_in = 8'h84; // SHIFT LSB RIGHT B

	#(CLKPERIODE*5)
	c_flag_in  = 1'b0;
	
	b_in 	   = 16'b1110000000000110; //Carry = B0=0;
	target_val = 16'b0111000000000011;
	op_in = 8'h85; // An <- Bn+1; A15 <- Carry; Carry <-B0
	
	#(CLKPERIODE*5)
	c_flag_in  = 1'b1;
	
	b_in 	   = 16'b1110000000000110; //Carry = B0 = 0;
	target_val = 16'b1111000000000011;
	op_in = 8'h85; // An <- Bn+1; A15 <- Carry; Carry <-B0

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110; 
	target_val = 16'b1100000000001100;
	op_in = 8'h88; // SHIFT LEFT 0

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110; 
	target_val = 16'b1100000000001101;
	op_in = 8'h89; // SHIFT LEFT 1

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110; 
	target_val = 16'b1100000000001100;
	op_in = 8'h8A; // SHIFT LSB LEFT B

	#(CLKPERIODE*5)
	c_flag_in  = 1'b1;
	b_in 	   = 16'b1110000000000110; 
	target_val = 16'b1100000000001101;
	op_in = 8'h8B; // SHIFT LEFT CARRY C

	#(CLKPERIODE*5)
	
	b_in 	   = 16'b1110000000000110; 
	target_val = 16'b1100000000001101;
	op_in = 8'h8C; // SHIFT MSB LEFT B

	#(CLKPERIODE*5)
	
	c_flag_in  = 1'b0;
	b_in 	   = 16'b1110000000000110; //Carry = B15 =1
	target_val = 16'b1100000000001100;
	op_in = 8'h8D; // An <- Bn-1; A0 <- Carry; Carry <-B15 ; for n = 1 to 15
	
	#(CLKPERIODE*5)
	
	c_flag_in  = 1'b1;
	b_in 	   = 16'b1110000000000110; //Carry = B15 =1
	target_val = 16'b1100000000001101;
	op_in = 8'h8D; // An <- Bn-1; A0 <- Carry; Carry <-B15 ; for n = 1 to 15

	#(CLKPERIODE*100)
    	$finish();
end
