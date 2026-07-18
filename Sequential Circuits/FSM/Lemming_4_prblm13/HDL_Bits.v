`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2026 11:52:24 AM
// Design Name: 
// Module Name: HDL_Bits
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
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
); 

    // State Encoding
    parameter LEFT     = 3'b000;
    parameter RIGHT    = 3'b001;
    parameter FALL_L   = 3'b010;
    parameter FALL_R   = 3'b011;
    parameter DIG_L    = 3'b100;
    parameter DIG_R    = 3'b101;
    parameter SPLATTER = 3'b110;

    reg [2:0] state, next_state;
    reg [4:0] fall_counter; // 5 bits are enough to count up to 21+ safely

    // 1. State Transition Counter Logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            fall_counter <= 5'd0;
        end else if (next_state == FALL_L || next_state == FALL_R) begin
            // Saturate counter at 21 to prevent overflow from resetting the logic
            if (fall_counter < 5'd21) 
                fall_counter <= fall_counter + 1'b1;
        end else begin
            fall_counter <= 5'd0;
        end
    end

    // 2. Next State Logic (Combinational)
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground)        next_state = FALL_L;
                else if (dig)       next_state = DIG_L;
                else if (bump_left) next_state = RIGHT;
                else                next_state = LEFT;
            end
            
            RIGHT: begin
                if (!ground)         next_state = FALL_R;
                else if (dig)        next_state = DIG_R;
                else if (bump_right) next_state = LEFT;
                else                 next_state = RIGHT;
            end
            
            FALL_L: begin
                if (ground) begin
                    if (fall_counter >= 5'd21) next_state = SPLATTER;
                    else                       next_state = LEFT;
                end else begin
                    next_state = FALL_L;
                end
            end
            
            FALL_R: begin
                if (ground) begin
                    if (fall_counter >= 5'd21) next_state = SPLATTER;
                    else                       next_state = RIGHT;
                end else begin
                    next_state = FALL_R;
                end
            end
            
            DIG_L: begin
                if (!ground) next_state = FALL_L;
                else         next_state = DIG_L;
            end
            
            DIG_R: begin
                if (!ground) next_state = FALL_R;
                else         next_state = DIG_R;
            end
            
            SPLATTER: begin
                next_state = SPLATTER; // Dead forever until reset
            end
            
            default: next_state = LEFT;
        endcase
    end

    // 3. State Register Logic (Sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end
    end

    // 4. Output Assignments (Moore Machine Logic)
    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_L || state == FALL_R);
    assign digging    = (state == DIG_L  || state == DIG_R);

endmodule

