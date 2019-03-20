`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
//
// Revision Date: 03/20/2019 9:34 AM
// Module Name: Digital_Clock
// Project Name: Digital Clock
// Target Devices: Basys 3
// Description: Digital Clock for the Basys 3 FPGA
//
// Dependencies:
//      Basys3_Master_Customized.xdc
//      7segVerilog.v
//
// Revision: 0.4
// Additional Comments: Push center button to swap between running mode and set mode. 
//      
//
//////////////////////////////////////////////////////////////////////////////////


module Digital_Clock(
    input clk,
    input IO_BTN_C,IO_BTN_U, IO_BTN_L, IO_BTN_R, IO_BTN_D,
    //input [15:0] IO_SWITCH,      // IO Dipswitches; up = 1
    output [6:0] IO_SSEG,
//    output IO_SSEG_DP,
    output [3:0] IO_SSEG_SEL
    );
    
    /* Timing parameters */
    reg [31:0] counter = 0;
    //parameter max_counter = 100000; // 100 MHz / 100000 = 1 kHz
    parameter max_counter = 25000000; // 100 MHz / 25,000,000 = 4 Hz
    
    /* Data registers */
    reg [3:0] Tens_of_Hours, Hours, Tens_of_Minutes, Minutes, Tens_of_Seconds, Seconds = 0;
    wire [3:0] Digit_0,Digit_1, Digit_2, Digit_3; 
    reg [0:0] current_bit = 0; //currently only minutes and hours
    /*sevseg display(.clk(clk),
        .binary_input_0(Minutes),
        .binary_input_1(Tens_of_Minutes),
        .binary_input_2(Hours),
        .binary_input_3(Tens_of_Hours),
        .IO_SSEG_SEL(IO_SSEG_SEL),
        .IO_SSEG(IO_SSEG));*/
    sevseg display(.clk(clk),
        .binary_input_0(Digit_0),
        .binary_input_1(Digit_1),
        .binary_input_2(Digit_2),
        .binary_input_3(Digit_3),
        .IO_SSEG_SEL(IO_SSEG_SEL),
        .IO_SSEG(IO_SSEG));
    assign Digit_0 = Minutes;
    assign Digit_1 = Tens_of_Minutes;
    assign Digit_2 = Hours;
    assign Digit_3 = Tens_of_Hours; 
    /* Modes */
    parameter Hours_And_Minutes = 1'b0;
    parameter Set_Clock = 1'b1;
    reg [0:0] Current_Mode = Set_Clock;
    
    always @(posedge clk) begin
        case(Current_Mode)
            Hours_And_Minutes: begin
                if (IO_BTN_C) begin
                    Current_Mode <= Set_Clock;
                    counter <= 0;
                    current_bit <= 0;
                    Seconds <= 0; //currently just sets seconds to 0. I'll work on this after I get setting minutes and hours working.
                end
                if (counter < max_counter) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    Seconds <= Seconds + 1;
                end                
            end
            Set_Clock: begin
                if (IO_BTN_C) begin //center button used to commit time set
                    Current_Mode <= Hours_And_Minutes;
                end 
                if (counter < max_counter) begin
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    case (current_bit)
                    1'b00: begin //minutes
                        if (IO_BTN_U) begin
                            Minutes <= Minutes + 1;
                        end
                        if (IO_BTN_D) begin
                            if (Minutes != 0) begin
                                Minutes <= Minutes - 1;
                            end
                        end
                        if (IO_BTN_L) begin
                            current_bit <= 1;
                        end
                    end
                    2'b01: begin //hours
                        if (IO_BTN_U) begin
                            Hours <= Hours + 1;
                        end
                        if (IO_BTN_D) begin
                            if (Hours != 0) begin
                                Hours <= Hours - 1;
                            end
                        end
                        if (IO_BTN_R) begin
                            current_bit <= 0;
                        end
                    end                        
                endcase               
                end
                    
            end
        endcase
        
        /* Military Time Clock Stuff */
        begin       
        // count to 60 seconds, increment minutes, then reset seconds to 0
            // count to 10 Seconds, increment Tens_of_Seconds, then reset Seconds to 0
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
        
        
    end
endmodule
