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
    input areset, 
    input bump_left, 
    input bump_right, 
    output walk_left, 
    output walk_right
); 
    
    parameter L = 0, R = 1; 
    
    reg state, next_state; 
    
    always @(*) begin 
        case(state) 
            
            L : next_state = (bump_left || (bump_left && bump_right)) ? R : L; 
            R : next_state = (bump_right || (bump_left && bump_right)) ? L : R; 
            default : next_state = state; 
        endcase 
    end 
    
    always @(posedge clk, posedge areset) begin 
        if(areset) 
            state <= L; 
        else 
            state <= next_state; 
    end 
    
    assign walk_left  = (state == L); 
    assign walk_right = (state == R); 
endmodule



