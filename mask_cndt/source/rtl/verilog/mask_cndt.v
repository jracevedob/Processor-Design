// Company           :   tud                      
// Author            :   jaac14            
// E-Mail            :   <email>                    
//                    			
// Filename          :   mask_cndt.v                
// Project Name      :   prz    
// Subproject Name   :   empty    
// Description       :   <short description>            
//
// Create Date       :   Mon Oct 12 12:18:26 2015 
// Last Change       :   $Date: 2015-11-26 14:31:16 +0100 (Thu, 26 Nov 2015) $
// by                :   $Author: jaac14 $                  			
//------------------------------------------------------------
`timescale 1ns/10ps
module mask_cndt #(
	parameter INSTR_WIDTH    	= 16,
	parameter JMPR_OPCODE	 	= 4
)(
	input wire [INSTR_WIDTH-1:0] out_data_pram_i,	//output data from the PRAM
	input wire 					 z_flag_i,			//zero flag 
	input wire 					 s_flag_i,			//sign flag
	input wire 					 c_flag_i,			//carry flag
	input wire 					 ovr_flag_i,		//overflow flag
	output wire 				 mask_o				//mask bit
);

//CONDITION MNEMONICS
localparam [3:0]
TRUE	= 4'b0000,
LE		= 4'b0001,
C		= 4'b0010,
OVR		= 4'b0011,
NEG		= 4'b0100,
Z		= 4'b0101,
POS		= 4'b0110,
GE		= 4'b0111,
FALSE	= 4'b1000,
GT		= 4'b1001,
NC		= 4'b1010,
NOVR	= 4'b1011,
NNEG	= 4'b1100,
NZ 		= 4'b1101,
NPOS	= 4'b1110,
LT		= 4'b1111;

reg [JMPR_OPCODE-1:0] jmpr_opcd;
reg mask_reg;

always @(*)
	begin
		jmpr_opcd = out_data_pram_i[3:0];
		case(jmpr_opcd)
									
				TRUE:
					begin
						mask_reg = 1'b1;
					end
										
				LE:
					begin
						mask_reg = z_flag_i | (ovr_flag_i ^ s_flag_i);
					end
									
				C:	
					begin
						mask_reg = c_flag_i;
					end
										
				OVR:
					begin
						mask_reg = ovr_flag_i;
					end
									
				NEG:
					begin
						mask_reg = s_flag_i;
					end
									
				Z: 
					begin
						mask_reg = z_flag_i;
					end
									
				POS:
					begin
						mask_reg = ~(s_flag_i | z_flag_i);
					end
									
				GE:
					begin
						mask_reg = ~(ovr_flag_i ^ s_flag_i);
					end
									
				FALSE:
					begin
						mask_reg = 1'b0;
					end
									
				GT:
					begin
						mask_reg = ~(z_flag_i|(ovr_flag_i^s_flag_i));
					end
									
				NC:
					begin
						mask_reg = ~c_flag_i;
					end
									
				NOVR:
					begin
						mask_reg = ~ovr_flag_i;
					end
										
				NNEG:
					begin
						mask_reg = ~s_flag_i;
					end
										
				NZ:
					begin
						mask_reg = ~z_flag_i;
					end
									
				NPOS:
					begin
						mask_reg = s_flag_i | z_flag_i;
					end
										
				LT:
					begin
						mask_reg = ovr_flag_i ^ s_flag_i;
					end
										
				default:
					begin
											
					end

		endcase
	end
	
	assign mask_o = mask_reg;
	
endmodule
