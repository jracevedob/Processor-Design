module ram (
	dat_i, 
	dat_o, 
	adr_i, 
	we_i, 
	clk );

	parameter INITFILE = "none";
	parameter dat_width = 16;
	parameter adr_width = 16;
	parameter mem_size  = 2**adr_width;

	input [dat_width-1:0]      dat_i;
	input [adr_width-1:0]      adr_i;
	input 		     	       we_i;
	output reg [dat_width-1:0] dat_o;
	input 		     		   clk;   

	reg [dat_width-1:0] ram [0:mem_size - 1]; /* synthesis ram_style = no_rw_check */
   
	initial begin
		$readmemh(INITFILE, ram, 0, mem_size-1);	//initialize RAM
	end
   
	always @ (posedge clk)
		begin 
			dat_o <= ram[adr_i];
			if (we_i)
				ram[adr_i] <= dat_i;
		end 

endmodule // ram
