`timescale 1ns/100ps
module pram (
	data_in,
	adr_in,
	cs,
	we,
	clk,
	data_out
);

parameter INITFILE = "none";

input 	[15:0]	data_in;	// input data
input 	[11:0]	adr_in;		// input address for load case
input			cs;			// chip select
input 			we;			// write enable high-active
input 			clk;
output 	[15:0]	data_out;	// output data

wire 	[15:0]	data_in;	
wire 	[11:0]	adr_in;		
wire			cs;				
wire 			clk;
wire 	[15:0]	data_out;	

wire    [15:0]  adr_int;
wire 	[15:0]	data_int;	

assign #1 adr_int = adr_in;
assign #1 data_int = data_in;

reg we_n;

always @(we or clk)
	begin
	   #1 we_n = !we;			// convert to low-active
	end
	
   SU180_4096X16X1BM2 #(.INITFILE(INITFILE)
     ) SU180_4096X16X1BM2_i  (.A0(adr_int[0]),
                              .A1(adr_int[1]),
                              .A2(adr_int[2]),
                              .A3(adr_int[3]),
                              .A4(adr_int[4]),
                              .A5(adr_int[5]),
                              .A6(adr_int[6]),
                              .A7(adr_int[7]),
                              .A8(adr_int[8]),
                              .A9(adr_int[9]),
                              .A10(adr_int[10]),
                              .A11(adr_int[11]),
                              .DO0(data_out[0]),
                              .DO1(data_out[1]),
                              .DO2(data_out[2]),
                              .DO3(data_out[3]),
                              .DO4(data_out[4]),
                              .DO5(data_out[5]),
                              .DO6(data_out[6]),
                              .DO7(data_out[7]),
							  .DO8(data_out[8]),
                              .DO9(data_out[9]),
                              .DO10(data_out[10]),
                              .DO11(data_out[11]),
                              .DO12(data_out[12]),
                              .DO13(data_out[13]),
                              .DO14(data_out[14]),
                              .DO15(data_out[15]),
                              .DI0(data_int[0]),
                              .DI1(data_int[1]),
                              .DI2(data_int[2]),
                              .DI3(data_int[3]),
                              .DI4(data_int[4]),
                              .DI5(data_int[5]),
                              .DI6(data_int[6]),
                              .DI7(data_int[7]),
							  .DI8(data_int[8]),
                              .DI9(data_int[9]),
                              .DI10(data_int[10]),
                              .DI11(data_int[11]),
                              .DI12(data_int[12]),
                              .DI13(data_int[13]),
                              .DI14(data_int[14]),
                              .DI15(data_int[15]),
                              .WEB(we_n),
                              .CK(clk),
                              .CS(cs),
                              .OE(1'b1)
                              );
endmodule
