`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2026 09:43:44 AM
// Design Name: 
// Module Name: Simple_FSM3_Asynchronous
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
    input in,
    input reset,
    output reg out); //
    parameter A=2'b00,B=2'b01,C=2'b10,D=2'b11;
    reg [1:0]state,next_state;
    always@(*)begin
        case(state)
            A:next_state=(in)? B:A;
            B:next_state=(in)? B:C;
            C:next_state=(in)? D:A;
            D:next_state=(in)? B:C;
            default: next_state = A;
            endcase
    end
    // State transition logic
    always@(posedge clk)begin
        if(reset)begin
            state<=A;
        end
        else begin
            state<=next_state;
        end
    end
    
    // State flip-flops with synchronous reset
    always@(*)begin
        case(state)
            A,B,C:out = 1'b0;
            D:out = 1'b1;
        endcase
   end
    // Output logic

endmodule


