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
    output [6:0] IO_SSEG,
    output IO_SSEG_DP,
    output [3:0] IO_SSEG_SEL,
    input IO_BTN_C,
    input IO_BTN_U,
    input IO_BTN_L,
    input IO_BTN_R,
    input IO_BTN_D
    );
endmodule
