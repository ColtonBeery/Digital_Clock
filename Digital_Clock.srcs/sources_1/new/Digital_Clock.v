`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
//
// Revision Date: 03/20/2019 10:48 AM
// Module Name: Digital_Clock
// Project Name: Digital Clock
// Target Devices: Basys 3
// Description: Digital Clock for the Basys 3 FPGA
//
// Dependencies:
//      Basys3_Master_Customized.xdc
//      7segVerilog.v
//
// Revision: 0.5
// Additional Comments: Push center button to swap between running mode and set mode. 
//                      When in set time mode
//                         - Push left/right buttons to swap between setting minutes and hours.
//                         - Push up/down buttons to increment and decrement time, respectively 
//
//////////////////////////////////////////////////////////////////////////////////


module Digital_Clock(
    input clk, // FPGA clock signal, 100 MHz
    input IO_BTN_C,IO_BTN_U, IO_BTN_L, IO_BTN_R, IO_BTN_D, // FPGA IO pushbuttons
    output [6:0] IO_SSEG, output [3:0] IO_SSEG_SEL // FPGA 7-Segment Display
    );
    
    /* Timing parameters */
    reg [31:0] counter = 0;
    parameter max_counter = 100000; // 100 MHz / 100000 = 1 kHz
    //parameter max_counter = 25000000; // 100 MHz / 25,000,000 = 4 Hz
    
    /* Data registers */
    reg [5:0] Hours, Minutes, Seconds = 0;
    wire [3:0] Digit_0,Digit_1, Digit_2, Digit_3; 
    reg [0:0] current_bit = 0; //currently only minutes and hours
    sevseg display(.clk(clk),
        .binary_input_0(Digit_0),
        .binary_input_1(Digit_1),
        .binary_input_2(Digit_2),
        .binary_input_3(Digit_3),
        .IO_SSEG_SEL(IO_SSEG_SEL),
        .IO_SSEG(IO_SSEG));
    assign Digit_0 = Minutes % 10;
    assign Digit_1 = Minutes / 10;
    assign Digit_2 = Hours % 10;
    assign Digit_3 = Hours / 10;
    
    /* Modes */
    parameter Hours_And_Minutes = 1'b0; // Military clock mode - 00:00 to 23:59
    parameter Set_Clock = 1'b1;         // Set time mode
    reg [0:0] Current_Mode = Set_Clock; //Start in set time mode by default
    
    always @(posedge clk) begin
        case(Current_Mode)
            Hours_And_Minutes: begin // Military clock mode - 00:00 to 23:59
                if (IO_BTN_C) begin
                    Current_Mode <= Set_Clock; // Swap modes when you push the center button 
                    // Reset variables to prepare for set time mode 
                    counter <= 0;
                    current_bit <= 0;
                    Seconds <= 0; //currently just sets seconds to 0. I'll work on this after I get setting minutes and hours working.
                end
                
                if (counter < max_counter) begin // time
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    Seconds <= Seconds + 1;
                end                
            end //Hours_And_Minutes
            Set_Clock: begin
                if (IO_BTN_C) begin //Push center button to commit time set and return to Military clock mode
                    Current_Mode <= Hours_And_Minutes;
                end
                //if (counter < max_counter) begin 
                if (counter < (25000000)) begin // Because of insanely high clock speed in debug mode,
                                                      // much slower clock when setting - 4 Hz
                    counter <= counter + 1;
                end else begin
                    counter <= 0;
                    case (current_bit)
                        1'b0: begin //minutes
                            if (IO_BTN_U) begin // Increment minutes when you push up
                                Minutes <= Minutes + 1;
                            end
                            if (IO_BTN_D) begin // Decrement minutes when you push down
                                if (Minutes > 0) begin
                                    Minutes <= Minutes - 1;
                                end
                            end
                            if (IO_BTN_L || IO_BTN_R) begin // Push left/right button to swap between hours/minutes
                                current_bit <= 1;
                            end
                        end // end 1'b0
                        1'b1: begin //hours
                            if (IO_BTN_U) begin // Increment hours when you push up
                                Hours <= Hours + 1;
                            end
                            if (IO_BTN_D) begin // Decrement minutes when you push down
                                if (Hours > 0) begin
                                    Hours <= Hours - 1;
                                end
                            end
                            if (IO_BTN_R || IO_BTN_L) begin // Push left/right button to swap between hours/minutes
                                current_bit <= 0;
                            end
                        end // end 1'b1                       
                endcase   // end case (current_bit)            
                end                    
            end // end Set_Clock
        endcase // end case(Current_Mode)
        
        /* Military Time Clock Stuff */
        if (Seconds >= 60) begin // After 60 seconds, increment minutes
                Seconds <= 0;
                Minutes <= Minutes + 1;
        end
        if (Minutes >= 60) begin // After 60 minutes, increment hours
                Minutes <= 0;
                Hours <= Hours + 1;
        end
        if (Hours >= 24) begin // After 24 hours, reset to 00:00
                Hours <= 0;
        end
    end //end always @(posedge clk)
endmodule
