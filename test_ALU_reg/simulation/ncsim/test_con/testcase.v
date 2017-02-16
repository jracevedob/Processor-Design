// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   test_ALU_reg.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Thu Apr  9 10:15:06 2015 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------

//Fill in testcase specific pattern generation
initial begin
    //#1
    //$finish();
	
	data_in		= 0;
	mux_sel		= 0;
	seg_reg   	= 0;
	adr_reg_a 	= 0;
	adr_reg_b 	= 0;
	op_in     	= 0;
	we 		  	= 0;
	
	#(CLKPERIODE*5)
	
	/// fill REG file with values #################################
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0000;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;	// load value to reg file, no ALU op executed 

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0001;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
    data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0011;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0100;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0101;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0110;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0111;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1000;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1001;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1010;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1011;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1100;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1101;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1110;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)
	
	data_in		 = 512;
	mux_sel		 = 2'b11;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b1111;
	adr_reg_b 	 = 4'b0000;
	op_in        = 8'h00;

	#(CLKPERIODE*1)


	data_in		 = 515;
	mux_sel		 = 2'b11;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0011;
	adr_reg_b 	 = 4'b0001;
	op_in        = 8'h00;		//Load 515
	we 		     = 1;
	
	#(CLKPERIODE*1)
	
	data_in		 = 513;
	mux_sel		 = 2'b11;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b0001;
	op_in        = 8'h00;		//Load 513
	we 		     = 1;
	
	#(CLKPERIODE*1)
	
	
	/// do some calculation	#################################
	
	mux_sel		 = 2'b10;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b0001;
	op_in        = 8'h02;		//Mult
	we 		     = 1;
	
	#(CLKPERIODE*20)
	
	
	mux_sel		 = 2'b10;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b0001;
	op_in        = 8'h02;		//Mult
	we 		     = 1;
	
	#(CLKPERIODE*17)
	
	/// fill REG file again 	#################################
	
	data_in		 = 2;
	mux_sel		 = 2'b11;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0011;
	adr_reg_b 	 = 4'b0001;
	op_in        = 8'h00;		//Load 515
	we 		     = 1;
	
	#(CLKPERIODE*1)
	
	data_in		 = 65533;
	mux_sel		 = 2'b11;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b0001;
	op_in        = 8'h00;		//Load 513
	we 		     = 1;
	
	#(CLKPERIODE*2)
	
    /// do some calculation	#################################
	
	mux_sel		 = 2'b10;
	we 		     = 1;
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b1011;
	op_in        = 8'h0f;		// DIV
	
	#(CLKPERIODE*20)
	
	
	mux_sel		 = 2'b10;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b1011;
	op_in        = 8'h08;		// ADD
 	
	#(CLKPERIODE*1)
	
	mux_sel		 = 2'b10;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b1011;
	op_in        = 8'h0b;		// SUB
	
	#(CLKPERIODE*1)

	mux_sel		 = 2'b10;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b1011;
	op_in        = 8'h0f;		// DIV
	
	#(CLKPERIODE*20)
	
	data_in		 = 10;
	mux_sel		 = 2'b10;
	we 		     = 1;
	
	seg_reg      = 4'b0000;
	adr_reg_a 	 = 4'b0010;
	adr_reg_b 	 = 4'b1011;
	op_in        = 8'h22;		// SMUL
	
	#(CLKPERIODE*19)
	
	#(CLKPERIODE*10)
	$finish(); 

end
