// Company           :   tud                      
// Author            :   mast14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_alu.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Jan 14 10:44:04 2015 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------

//Fill in testcase specific pattern generation
initial begin

	a_in = 0;
	b_in = 0;
	op_in = 0;
	s_flag_in = 0;
	z_flag_in = 0;
	c_flag_in = 0;
	ovr_flag_in = 0;
    	a_reset_l = 1'b1;
	target_val = 0;
	
	
    	// ARITHMETIC TESTBENCH

	#(CLKPERIODE*5)
	a_in = 3;
	b_in = -20;
	target_val = -20;
	op_in = 8'h00; //A = B
	
	
	#(CLKPERIODE*5)
	target_val = -19;
	op_in = 8'h01; //A = B + 1
	
	#(CLKPERIODE*5)
	target_val =  20;
	op_in = 8'h03; //A = -B
	
	#(CLKPERIODE*5)
	target_val = -21;
	op_in = 8'h04; //A = B - 1

	#(CLKPERIODE*5)
	target_val = -17;
	op_in = 8'h08; //A = A + B

	#(CLKPERIODE*5)
	target_val =  23;
	op_in = 8'h0B; //A = A - B

	#(CLKPERIODE*5)
	target_val = -20;
	op_in = 8'h20; //SP = B

	#(CLKPERIODE*5)
	target_val = -19;
	c_flag_in = 1'b1;
	op_in = 8'h21; //A = B + C

	#(CLKPERIODE*5)
	target_val = 20;
	c_flag_in = 1'b1;
	op_in = 8'h23; //A = -B -1 +C
	
	#(CLKPERIODE*5)
	target_val = -20;
	c_flag_in = 1'b1;
	op_in = 8'h24; //A = B -1 +C

	#(CLKPERIODE*5)
	target_val = -16;
	c_flag_in = 1'b1;
	op_in = 8'h28; //A = A + B + C

	#(CLKPERIODE*5)
	target_val = 23;
	c_flag_in = 1'b1;
	op_in = 8'h2B; //A = A -B -1 +C

	#(CLKPERIODE*10)
	$finish(); 

	
	
end
