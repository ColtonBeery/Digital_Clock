`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
//
// Revision Date: 03/16/2019 9:30 PM
// Module Name: Digital_Clock
// Project Name: Digital Clock
// Target Devices: Basys 3
// Description: Digital Clock for the Basys 3 FPGA
//
// Dependencies:
//      Basys3_Master_Customized.xdc
//      7segVerilog.v
//
// Revision: 0.2
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
        /* SSEG Multiplexing Debug Code */
        Minutes <= IO_SWITCH[3:0];
        Tens_of_Minutes <= IO_SWITCH[7:4];
        Hours <= IO_SWITCH[11:8];
        Tens_of_Hours <= IO_SWITCH[15:12];
    end
endmodule
