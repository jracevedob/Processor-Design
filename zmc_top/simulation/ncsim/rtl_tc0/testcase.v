// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   zmc_top.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Wed Nov 25 09:23:09 2015 
// Last Change       :   $Date$
// by                :   $Author$                  			
//------------------------------------------------------------

//Fill in testcase specific pattern generation
initial begin
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
		
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)

	a_reset_l = 1'b1;
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)
	
	a_reset_l = 1'b1;
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)

	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*200)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b1;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	sync_h	  = 1'b0;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
		
	#(CLKPERIODE*1000)
	
	a_reset_l = 1'b0;
	
	#(CLKPERIODE*1)
	
	a_reset_l = 1'b1;
	
	#(CLKPERIODE*20)
	
	intr_h	  = 1'b1;
	
	#(CLKPERIODE*1)
	
	intr_h	  = 1'b0;
	
	#(CLKPERIODE*100)
   
    $finish();
end
