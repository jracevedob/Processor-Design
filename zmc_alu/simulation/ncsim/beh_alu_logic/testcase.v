// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_alu.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Jan 14 11:09:00 2015 
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
	

	//LOGIC TESTBENCH
	
	

	#(CLKPERIODE*20)
	a_in = 16'b0000000110101010;
	b_in = 16'b0000000110100101;
	target_val = 0;
	op_in = 8'h40; //LOG_0

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101;
	target_val = 16'b1111111001010000;
	op_in = 8'h41; //NOR

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101; // Not B = 001011010;
	target_val = 16'b0000000000001010;
	op_in = 8'h42; //A AND NOT B

	#(CLKPERIODE*5)
	b_in 	   = 16'b0000000110100101;
	target_val = 16'b1111111001011010;
	op_in = 8'h43; //NOT B

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010; // Not A = 001010101;
	b_in 	   = 16'b0000000110100101; 
	target_val = 16'b0000000000000101;
	op_in = 8'h44; //NOT A AND B

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010; // Not A = 001010101;
	target_val = 16'b1111111001010101;
	op_in = 8'h45; //NOT A

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101;
	target_val = 16'b0000000000001111;
	op_in = 8'h46; //XOR

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101;
	target_val = 16'b1111111001011111;
	op_in = 8'h47; //NAND

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101;
	target_val = 16'b0000000110100000;
	op_in = 8'h48; //AND

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101;
	target_val = 16'b1111111111110000;
	op_in = 8'h49; //XNOR

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	target_val = 16'b0000000110101010;
	op_in = 8'h4A; //LOG A

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101; // Not B = 001011010
	target_val = 16'b1111111111111010;
	op_in = 8'h4B; //A OR NOT B

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010;
	b_in 	   = 16'b0000000110100101; 
	target_val = 16'b0000000110100101;
	op_in = 8'h4C; //LOG B

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010; // Not A = 001010101
	b_in 	   = 16'b0000000110100101; 
	target_val = 16'b1111111111110101;
	op_in = 8'h4D; //NOT A OR B

	#(CLKPERIODE*5)
	a_in 	   = 16'b0000000110101010; 
	b_in 	   = 16'b0000000110100101; 
	target_val = 16'b0000000110101111;
	op_in = 8'h4E; //OR

	#(CLKPERIODE*5)
	target_val = 1;
	op_in = 8'h4F; //LOG 1
	
	#(CLKPERIODE*10)
	$finish();
	

	
end
