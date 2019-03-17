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
// Description: Multiplexed SSEG display
//
// Dependencies: Basys3_Master.xdc
//
// Revision: 0.6
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sevseg (
    input clk,
    input [3:0] binary_input_0, //workaround because apparently verilog doesn't allow 2D arrays as input
    input [3:0] binary_input_1,
    input [3:0] binary_input_2,
    input [3:0] binary_input_3,
    output reg [3:0] IO_SSEG_SEL, //IO Board 7-segment selector (left-to-right), active low
    output reg [6:0] IO_SSEG //6=g, 5=f, 4=e, 3=d, 2=c, 1=b, 0=a, acive low
    );
    
    reg [1:0] current_LED = 0;
    reg [7:0] LED_out [3:0];
    
    reg [18:0] counter = 0; 
    parameter max_counter = 500000; //cycle through SSEG's every 500000 clock cycles -> 1/200 seconds
    
    wire [3:0] four_bit_data [3:0]; //workaround because apparently verilog doesn't allow 2D arrays as input
    assign  four_bit_data[0] = binary_input_0;
    assign  four_bit_data[1] = binary_input_1;
    assign  four_bit_data[2] = binary_input_2;
    assign  four_bit_data[3] = binary_input_3;
                      	 
    always @(posedge clk) begin
        if (counter < max_counter) begin
            counter <= counter+1;
        end else begin
            current_LED <= current_LED + 1;
            counter <= 0;
        end
                
		case(four_bit_data[current_LED]) //S15, S14, S13, S12 are the binary data bits, MSB->LSB
			 4'b0000 : LED_out[current_LED] <= 7'b1000000; //0
			 4'b0001 : LED_out[current_LED] <= 7'b1111001; //1
			 4'b0010 : LED_out[current_LED] <= 7'b0100100; //2
			 4'b0011 : LED_out[current_LED] <= 7'b0110000; //3
			 4'b0100 : LED_out[current_LED] <= 7'b0011001; //4
			 4'b0101 : LED_out[current_LED] <= 7'b0010010; //5
			 4'b0110 : LED_out[current_LED] <= 7'b0000010; //6
			 4'b0111 : LED_out[current_LED] <= 7'b1111000; //7
			 4'b1000 : LED_out[current_LED] <= 7'b0000000; //8
			 4'b1001 : LED_out[current_LED] <= 7'b0011000; //9
			 4'b1010 : LED_out[current_LED] <= 7'b0001000; //10	A
			 4'b1011 : LED_out[current_LED] <= 7'b0000011; //11	b
			 4'b1100 : LED_out[current_LED] <= 7'b1000110; //12	C
			 4'b1101 : LED_out[current_LED] <= 7'b0100001; //13	d
			 4'b1110 : LED_out[current_LED] <= 7'b0000110; //14	E
			 default : LED_out[current_LED] <= 7'b0001110; //Otherwise, F
		 endcase
        
        case(current_LED)
            0: begin
                IO_SSEG_SEL <= 4'b1110;
                IO_SSEG <= LED_out[0];
            end
                
            1: begin
                IO_SSEG_SEL <= 4'b1101;
                IO_SSEG <= LED_out[1];            
            end
            
            2: begin
                IO_SSEG_SEL <= 4'b1011;
                IO_SSEG <= LED_out[2];
            end
            
            3: begin
                IO_SSEG_SEL <= 4'b0111;
                IO_SSEG <= LED_out[3];
            end                
        endcase        
    end    
endmodule
