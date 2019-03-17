`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
//
// Revision Date: 03/16/2019 9:49 PM
// Module Name: Digital_Clock
// Project Name: Digital Clock
// Target Devices: Basys 3
// Description: Digital Clock for the Basys 3 FPGA
//
// Dependencies:
//      Basys3_Master_Customized.xdc
//      7segVerilog.v
//
// Revision: 0.3
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
        // count to 60 seconds, increment minutes, then reset seconds to 0
            // count to 10 Seconds, increment Tens_of_Seconds, then reset Seconds to 0
            Seconds <= Seconds + 1;
            if (Seconds == 10) begin
                Seconds <= 0;
                Tens_of_Seconds <= Tens_of_Seconds + 1;
            end
            // count to 6 Tens_of_Seconds, increment Minutes, then reset Tens_of_Seconds to 0
            if (Tens_of_Seconds == 6) begin
                Tens_of_Seconds <= 0;
                Minutes <= Minutes + 1;
            end
        // count to 60 minutes, increment hours, then reset minutes to 0
            // count to 10 Minutes, increment Tens_of_Minutes, then reset Minutes to 0
            if (Minutes == 10) begin
                Minutes <= 0;
                Tens_of_Minutes <= Tens_of_Minutes + 1;
            end
            // count to 6 Tens_of_Minutes, increment Hours, then reset Tens_of_Minutes to 0
            if (Tens_of_Minutes == 6) begin
                Tens_of_Minutes <= 0;
                Hours <= Hours + 1;
            end
        // count to 24 hours, then reset everything to 0
            // count to 10 Hours, increment Tens_of_Hours, then reset Hours to 0
            if (Hours == 10) begin
                Hours <= 0;
                Tens_of_Hours <= Tens_of_Hours + 1;
            end
            // count to 2 Tens_of_Hours. if Tens_of_Hours = 2 and Hours = 4, then reset the time
            if (Tens_of_Hours == 2) begin
                if (Hours == 4) begin
                    Hours <= 0;
                    Tens_of_Hours <= 0;
                end
            end
    end
endmodule
