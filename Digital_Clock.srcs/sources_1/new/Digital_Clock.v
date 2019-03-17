`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/13/2019 10:56:37 AM
// Module Name: Digital_Clock
// Project Name: Digital Clock
// Target Devices: Basys 3
// Description: Digital Clock for the Basys 3 FPGA
//
// Dependencies:
//      Basys3_Master_Customized.xdc
//      7segVerilog.v
//
// Revision: 0.1
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Digital_Clock(
    input clk,
    input IO_BTN_C,
    input IO_BTN_U,
    input IO_BTN_L,
    input IO_BTN_R,
    input IO_BTN_D,
    input [15:0] IO_SWITCH,      // IO Dipswitches; up = 1
    output [6:0] IO_SSEG,
    output IO_SSEG_DP,
    output [3:0] IO_SSEG_SEL
    );

//    reg [3:0] Tens_of_Hours, Hours, Tens_of_Minutes, Minutes, Tens_of_Seconds, Seconds = 0;
    reg [3:0] Tens_of_Hours, Hours, Tens_of_Minutes, Minutes, Tens_of_Seconds, Seconds = 0;
    sevseg display(.clk(clk),
        .binary_input_0(Minutes),
        .binary_input_1(Tens_of_Minutes),
        .binary_input_2(Hours),
        .binary_input_3(Tens_of_Hours),
        .IO_SSEG_SEL(IO_SSEG_SEL),
        .IO_SSEG(IO_SSEG));

    always @(posedge clk) begin
        //Minutes <= 1;
         Minutes <= IO_SWITCH[3:0];

        //Tens_of_Minutes <= 2;
        Tens_of_Minutes <= IO_SWITCH[7:4];

        //Hours <= 3;
        Hours <= IO_SWITCH[11:8];

        /*Tens_of_Hours[0] <= IO_SWITCH[12];
        Tens_of_Hours[1] <= IO_SWITCH[13];
        Tens_of_Hours[2] <= IO_SWITCH[14];
        Tens_of_Hours[3] <= IO_SWITCH[15];*/
        //Tens_of_Hours <= 4;
        Tens_of_Hours <= IO_SWITCH[15:12];
    end
endmodule
