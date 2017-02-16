// one bit full adder
`timescale 1ns/10ps
module full_add (
	a,
	b,
	c_in,
	c_out,
	s
);
	input	a;
	input	b;
	input	c_in;
	output	c_out;
	output	s;
	
	reg c_out, s;
	
always @ (a,b,c_in)
	begin
		// s = a ^ b ^ c_in; // ^xor
		// c_out = (a & c_in) | (b & c_in) | (a & b); 
		{c_out,s} = a + b + c_in;
	end
endmodule
