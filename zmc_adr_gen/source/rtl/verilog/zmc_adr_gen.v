// address generation register RAM
// use of segmentation 

module zmc_adr_gen (
	seg_reg,
	adr_reg_a,
	adr_reg_b,
	a_adr,
	b_adr
);

parameter seg_reg_wl	= 4;	// segment register width
parameter adr_reg_wl	= 4;	// address register width
parameter ram_adr_wl 	= seg_reg_wl + adr_reg_wl -1; 	// RAM address width, 7 from documentation 

input	[seg_reg_wl-1:0] 	seg_reg;	// segment register
input	[adr_reg_wl-1:0] 	adr_reg_a;	// address register A
input	[adr_reg_wl-1:0] 	adr_reg_b;	// address register B
output	[ram_adr_wl-1:0] 	a_adr;		// ram address A
output	[ram_adr_wl-1:0] 	b_adr;		// ram address B

reg		[ram_adr_wl-1:0] 	a_adr;		// ram address A
reg		[ram_adr_wl-1:0] 	b_adr;		// ram address B

always @ (*)
	begin
		if(adr_reg_a[adr_reg_wl-1] == 0)		// highest bit of adr_reg
			begin	// lower addresses
				a_adr = {4'b0000,adr_reg_a[adr_reg_wl-2:0]};		// 0000 XXX
			end
		else
			begin
				a_adr = {seg_reg,adr_reg_a[adr_reg_wl-2:0]};		// XXXX XXX
			end
			
			
		if(adr_reg_b[adr_reg_wl-1] == 0)		// highest bit of adr_reg
			begin	// lower addresses
				b_adr = {4'b0000,adr_reg_b[adr_reg_wl-2:0]};
			end
		else
			begin
				b_adr = {seg_reg,adr_reg_b[adr_reg_wl-2:0]};		// seg	adr
			end
	end	
	endmodule
