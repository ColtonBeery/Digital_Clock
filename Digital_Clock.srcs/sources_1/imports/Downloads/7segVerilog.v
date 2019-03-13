`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
// 
// Create Date:    12:01 AM 02/20/2019 
// Design Name: 
// Module Name:     sevseg
// Project Name: CombinationalLogic
// Target Devices: Basys 3
// Tool versions: 
// Description: (a) Write a Verilog module that receives a 4-bit binary input from the 
//						4 LSB dip IO_SWITCHitches and shows its equivalent hexadecimal value on the 
//						seven segment display upon pushing a push button.
//
// Dependencies: Basys3_Master.xdc
//
// Revision: 1.0
// Revision 1.0 - Modified version of lab 2 for Basys 3 board
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sevseg (
    input [15:0] IO_SWITCH, //IO Dipswitches S15,S14...,S1, active high
	output [3:0] IO_SSEG_SEL, //IO Board 7-segment selector (left-to-right), active low
    output reg [6:0] IO_SSEG //6=g, 5=f, 4=e, 3=d, 2=c, 1=b, 0=a, acive low
    );
    
	assign IO_SSEG_SEL = 4'b1110; //only use right-most 7-seg
	 
    always @*
		case(IO_SWITCH[15:12]) //S15, S14, S13, S12 are the binary data bits, MSB->LSB
			 4'b0000 : IO_SSEG = 7'b1000000; //0
			 4'b0001 : IO_SSEG = 7'b1111001; //1
			 4'b0010 : IO_SSEG = 7'b0100100; //2
			 4'b0011 : IO_SSEG = 7'b0110000; //3
			 4'b0100 : IO_SSEG = 7'b0011001; //4
			 4'b0101 : IO_SSEG = 7'b0010010; //5
			 4'b0110 : IO_SSEG = 7'b0000010; //6
			 4'b0111 : IO_SSEG = 7'b1111000; //7
			 4'b1000 : IO_SSEG = 7'b0000000; //8
			 4'b1001 : IO_SSEG = 7'b0011000; //9
			 4'b1010 : IO_SSEG = 7'b0001000; //10	A
			 4'b1011 : IO_SSEG = 7'b0000011; //11	b
			 4'b1100 : IO_SSEG = 7'b1000110; //12	C
			 4'b1101 : IO_SSEG = 7'b0100001; //13	d
			 4'b1110 : IO_SSEG = 7'b0000110; //14	E
			 default : IO_SSEG = 7'b0001110; //Otherwise, F
		 endcase
endmodule
