module ram_wb ( 
	dat_i, 
	dat_o, 
	adr_i, 
	we_i, 
	sel_i, 
	cyc_i, 
	stb_i, 
	ack_o, 
	cti_i, 
	clk_i, 
	rst_i);
	
   //parameter INITFILE = "none";
   parameter INITFILE = "mem.txt";
   parameter dat_width = 16;
   parameter adr_width = 16;
   parameter mem_size  = 2**adr_width;
   
   // wishbone signals
   input  [dat_width-1:0]   dat_i;   
   output [dat_width-1:0]   dat_o;
   input  [adr_width-1:0] 	adr_i;
   input 					we_i;
   input [3:0] 	sel_i;
   input 		cyc_i;
   input 		stb_i;
   output reg 	ack_o;
   input [2:0] 	cti_i;
   
   // clock
   input 		clk_i;
   // async reset
   input 		rst_i;
   
   wire [dat_width-1:0] 		wr_data;
   reg nxt_we_i;

   // mux for data to ram
   //assign wr_data[31:24] = sel_i[3] ? dat_i[31:24] : dat_o[31:24];
   //assign wr_data[23:16] = sel_i[2] ? dat_i[23:16] : dat_o[23:16];
   //assign wr_data[15: 8] = sel_i[1] ? dat_i[15: 8] : dat_o[15: 8];
   //assign wr_data[ 7: 0] = sel_i[0] ? dat_i[ 7: 0] : dat_o[ 7: 0];
   assign wr_data = dat_i;

   
   ram
     #(
	 //.INITFILE(INITFILE),
	  .INITFILE("./mem.txt"),
      .dat_width(dat_width),
      .adr_width(adr_width),
      .mem_size(mem_size)
      )
     ram_i
     (
      .dat_i(wr_data),
      .dat_o(dat_o),
      .adr_i(adr_i), 
      .we_i(nxt_we_i && ack_o),
      .clk(clk_i)
      );
 
   // ack_o
   always @ (posedge clk_i or posedge rst_i)
	 if (rst_i == 1'b0)
       ack_o <= 1'b0;
     else if (ack_o == 1'b0)
	    begin
			if (cyc_i & stb_i)
	 			 ack_o <= 1'b1;
				 nxt_we_i <= we_i;
		end  
     else
		if ((sel_i != 4'b1111) | (cti_i == 3'b000) | (cti_i == 3'b111))
	  		ack_o <= 1'b0;
         
endmodule
 
	      
