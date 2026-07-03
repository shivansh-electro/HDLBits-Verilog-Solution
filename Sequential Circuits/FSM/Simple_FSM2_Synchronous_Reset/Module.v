`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 10:15:39 AM
// Design Name: 
// Module Name: logic_gates
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk,
    input reset,    // Asynchronous reset to OFF
    input j,
    input k,
    output out); //  

    parameter OFF=0, ON=1; 
    reg state, next_state;

    always @(*) begin
        case(state)
            ON : next_state = k ? OFF : ON ;
            OFF : next_state = j ? ON:OFF;
            default : next_state = OFF;
        endcase
    end

    always @(posedge clk) begin
        // State flip-flops with asynchronous reset
        if(reset) state <= OFF;
        else state <= next_state;
    end

    // Output logic
    assign out = (state == ON);

endmodule


