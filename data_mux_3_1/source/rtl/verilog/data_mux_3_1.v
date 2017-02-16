module data_mux3_1 (
	in_1,
	in_2,
	in_3,
	sel,
	out
);

	parameter data_wl	= 16;
	
	input 	[data_wl-1:0]	in_1;
	input 	[data_wl-1:0] 	in_2;
	input 	[data_wl-1:0] 	in_3;
	input 	[1:0] 			sel;		//selection of input 1->in_1 and so on
	
	output 	[data_wl-1:0]	out;
	reg 	[data_wl-1:0]	out;
	
always @ (in_1 or in_2 or in_3 or sel) 
	begin 
		case(sel)
			2'b00:
				begin
					out = 0;
				end				
			2'b01:
				begin
					out = in_1;
				end	
			2'b10:
				begin
					out = in_2;
				end	
			2'b11:
				begin
					out = in_3;
				end	
			default:
			     begin
                 end
		endcase
	end
endmodule