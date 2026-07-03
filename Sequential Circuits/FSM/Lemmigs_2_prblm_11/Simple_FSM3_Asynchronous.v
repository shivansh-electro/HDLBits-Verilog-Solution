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
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    parameter left = 0 , right = 1 , fall_left = 2 , fall_right = 3;
    reg [1:0]state,next_state;
    
    always@(*)begin
        case(state) 
            left : begin
                if(~ground) next_state = fall_left;
                else if (ground & bump_left) next_state = right;
                else next_state = left;
            end
            right : begin
                if(~ground) next_state = fall_right;
                else if (ground & bump_right) next_state = left;
                else next_state = right;
            end
            fall_right : begin
                if(ground) next_state = right;                
                else next_state = fall_right;
            end
            fall_left : begin
                if(ground) next_state = left;              
                else next_state = fall_left;
            end
            default : next_state = state;
        endcase
    end              
           
    always @(posedge clk ,posedge areset) begin
        if(areset) state <= left;
        else state<=next_state;
    end
    assign walk_left = (state==left);
    assign walk_right = (state==right);
    assign aaah = (state == fall_right) | (state == fall_left) ;
            

endmodule




