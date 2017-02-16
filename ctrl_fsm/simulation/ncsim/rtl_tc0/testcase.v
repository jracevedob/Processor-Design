// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   ctrl_fsm.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Oct 21 09:46:06 2015 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------

//Fill in testcase specific pattern generation
initial begin
    
	out_data_pram_i = 16'd0;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b0;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	data_wb_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)
	
	out_data_pram_i = 16'b0000000000001101;
	a_reset_l		= 1'b0;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b0;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)
	
	out_data_pram_i = 16'b0000000000001101;
	a_reset_l		= 1'b1;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b0;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1) 
	
	out_data_pram_i = 16'b0000000000001101;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b0;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)	//Check ALU A = B
	
	out_data_pram_i = 16'b0000000011010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A = B+1
	
	out_data_pram_i = 16'b0000000111010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A = -B
	
	out_data_pram_i = 16'b0000001111010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A = B-1
	
	out_data_pram_i = 16'b0000010011010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A = A+B
	
	out_data_pram_i = 16'b0000100011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A = A-B
	
	out_data_pram_i = 16'b0000101111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU SP =B
	
	out_data_pram_i = 16'b0010000011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= B+C
	
	out_data_pram_i = 16'b0010000111010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= -B-1+C
	
	out_data_pram_i = 16'b0010001111010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= B-1+C
	
	out_data_pram_i = 16'b0010010011010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= A+B+C
	
	out_data_pram_i = 16'b0010100011011110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= A-B-1+C
	
	out_data_pram_i = 16'b0010101111010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= A*B
	
	out_data_pram_i = 16'b0000001011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0; 		//Wait until multiplication is finish
	
		#(CLKPERIODE*1)  //Check ALU A= A*B
	
	out_data_pram_i = 16'b0000001011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b1; 		//Multiplication finished
	
		#(CLKPERIODE*1)  //Check ALU A= A*B Signed
	
	out_data_pram_i = 16'b0010001011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0; 		//Wait until multiplication is finish
	
		#(CLKPERIODE*1)  //Check ALU A= A*B Signed
	
	out_data_pram_i = 16'b0010001011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b1; 		//Multiplication is finished
	
		#(CLKPERIODE*1)  //Check ALU A= A/B 
	
	out_data_pram_i = 16'b0000111111011110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0; 		//Wait until division is finish
	
		#(CLKPERIODE*1)  //Check ALU A= A/B 
	
	out_data_pram_i = 16'b0000111111011110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b1; 		//Division is finished
	
		#(CLKPERIODE*1)  //Check ALU A = 0 
	
	out_data_pram_i = 16'b0100000011010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0; 		
	
		#(CLKPERIODE*1)  //Check ALU A= A NOR B
	
	out_data_pram_i = 16'b0100000111011110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0; 	
	
		#(CLKPERIODE*1)  //Check ALU A= A AND NOT B
	
	out_data_pram_i = 16'b0100001011011110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= NOT B
	
	out_data_pram_i = 16'b0100001111010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= NOT A AND B
	
	out_data_pram_i = 16'b0100010011010000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= NOT A
		
	out_data_pram_i = 16'b0100010111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= A XOR B
		
	out_data_pram_i = 16'b0100011011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= A NAND B
		
	out_data_pram_i = 16'b0100011111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check ALU A= A AND B
		
	out_data_pram_i = 16'b0100100011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= A XNOR B
		
	out_data_pram_i = 16'b0100100111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= A LG B
		
	out_data_pram_i = 16'b0100101011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;		
	
		#(CLKPERIODE*1)  //Check ALU A= A OR NOT B
		
	out_data_pram_i = 16'b0100101111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= LG B
		
	out_data_pram_i = 16'b0100110011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU A= NOT A OR B
		
	out_data_pram_i = 16'b0100110111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
	
		#(CLKPERIODE*1)  //Check ALU A= A OR B
		
	out_data_pram_i = 16'b0100111011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
	
		#(CLKPERIODE*1)  //Check ALU A= LG 1
		
	out_data_pram_i = 16'b0100111111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU SHR0
		
	out_data_pram_i = 16'b1000000011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU SHR1
		
	out_data_pram_i = 16'b1000000111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;

		#(CLKPERIODE*1)  //Check ALU SHRA
		
	out_data_pram_i = 16'b1000001011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;		
	
		#(CLKPERIODE*1)  //Check ALU SHRC
		
	out_data_pram_i = 16'b1000001111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;		

		#(CLKPERIODE*1)  //Check ALU ROTR
		
	out_data_pram_i = 16'b1000010011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU ROTRC
		
	out_data_pram_i = 16'b1000010111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU SHL0
		
	out_data_pram_i = 16'b1000100011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	

		#(CLKPERIODE*1)  //Check ALU SHL1
		
	out_data_pram_i = 16'b1000100111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	

		#(CLKPERIODE*1)  //Check ALU SHLA
		
	out_data_pram_i = 16'b1000101011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU SHRC
		
	out_data_pram_i = 16'b1000101111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU SHRC
		
	out_data_pram_i = 16'b1000110011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check ALU SHRC
		
	out_data_pram_i = 16'b1000110111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check JUMP
		
	out_data_pram_i = 16'b1100111111110110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check JUMPR Mask False
		
	out_data_pram_i = 16'b1111000111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1)  //Check JUMPR Mask True
		
	out_data_pram_i = 16'b1111000111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b1;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;		
	
		#(CLKPERIODE*1)  //Check CALL wb_Ack_i = 0
		
	out_data_pram_i = 16'b1101000011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd1254;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;	
	
		#(CLKPERIODE*1) //Check CALL wb_Ack_i = 1
		
	out_data_pram_i = 16'b1101000011010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b1;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check CALLR Mask 1
		
	out_data_pram_i = 16'b1111001111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd1234;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check CALLR  Mask 1 wb_Ack_i = 0 Valid = 1
		
	out_data_pram_i = 16'b1111001111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd1234;
	mask_i			= 1'b1;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check CALLR Mask 1 wb_Ack_i = 0 Valid = 1
		
	out_data_pram_i = 16'b1111001111010110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b1;
	data_b_bus_i	= 16'd0;
	data_wb_bus_i	= 16'd0;
	mask_i			= 1'b1;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check RET Valid_i 0
		
	out_data_pram_i = 16'b1111101000000000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_wb_bus_i	= 16'd1236;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check RET Valid_i 1
		
	out_data_pram_i = 16'b1111101000000000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b0;
	data_wb_bus_i	= 16'd1236;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check RET wb_Ack_i 1
		
	out_data_pram_i = 16'b1111101000000000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b1;
	data_wb_bus_i	= 16'd1236;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	

		#(CLKPERIODE*1)  //Check RETi valid_i 0
		
	out_data_pram_i = 16'b1111101100000000;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	data_wb_bus_i	= 16'd1234;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	

		#(CLKPERIODE*1)  //Check RETI intr_h_i 0
		
	out_data_pram_i = 16'b1111101100000000;
	intr_h_i 		= 1'b1;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	data_wb_bus_i	= 16'd1234;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check MRD Valid_i 0
		
	out_data_pram_i = 16'b1111000000000101;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	data_wb_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	

		#(CLKPERIODE*1)  //Check MRD Valid_i 1
		
	out_data_pram_i = 16'b1111000000000101;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check MRD Valid_i 1
		
	out_data_pram_i = 16'b1111000000000101;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b1;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;

		#(CLKPERIODE*1)  //Check MWD Valid_i 1
		
	out_data_pram_i = 16'b1111001000000110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check MWD Valid_i 1 wb_Ack_i 1
		
	out_data_pram_i = 16'b1111001000000110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b1;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	

		#(CLKPERIODE*1)  //Check MWD Valid_i 1 wb_Ack_i 1
		
	out_data_pram_i = 16'b1111001000000110;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b1;
	wb_ack_i		= 1'b1;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check LOAD
		
	out_data_pram_i = 16'b1111010000000011;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check LOAD Charge value
		
	out_data_pram_i = 16'b1100110011001100;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	

		#(CLKPERIODE*1)  //Check LOAD

	out_data_pram_i = 16'b1111010000000011;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check LOAD Charge value
		
	out_data_pram_i = 16'b1100110011001111;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	

		#(CLKPERIODE*1)  //Check LOADR
		

		
	out_data_pram_i = 16'b1111010111001100;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check CND Mask 0
		
	out_data_pram_i = 16'b1111011000001100;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check CND Mask 1
		
	out_data_pram_i = 16'b1111011000001100;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b1;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check WAIT Snyc 0
		
	out_data_pram_i = 16'b1111011100001100;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check CWAIT Sync 1
		
	out_data_pram_i = 16'b1111011100001100;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b1;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check HALT reset 1
		
	out_data_pram_i = 16'b1111100000001100;
	a_reset_l		= 1'b1;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b0;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check Halt reset 0
		
	out_data_pram_i = 16'b1111100000001100;
	a_reset_l		= 1'b0;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
	
		#(CLKPERIODE*1)  //Check Segmentation
	
	out_data_pram_i = 16'b1111100100001100;
	a_reset_l		= 1'b1;
	intr_h_i 		= 1'b0;
	ovr_i			= 1'b1;
	valid_i			= 1'b0;
	wb_ack_i		= 1'b0;
	data_b_bus_i	= 16'd0;
	mask_i			= 1'b0;
	sync_h_i		= 1'b0;
	alu_valid_i		= 1'b0;
		
	
	#(CLKPERIODE*10)
	$finish(); 

end
