`timescale 1ns / 1ps

module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging 
); 

    // State parameters
    parameter walk_Left  = 3'd0;
    parameter walk_Right = 3'd1;
    parameter fall_left  = 3'd2; 
    parameter fall_right = 3'd3; 
    parameter dig_right  = 3'd4; 
    parameter dig_left   = 3'd5;
    
    reg [2:0] state, next_state;
    
    // Next State Logic (Changed to standard Verilog always block)
    always @(*) begin
        case (state)
            walk_Left : begin
                if(~ground) next_state = fall_left;
                else if(dig && ground) next_state = dig_left;
                else if (bump_left) next_state = walk_Right;              
                else next_state = state;
            end
            walk_Right: begin
                if(~ground) next_state = fall_right;
                else if(dig && ground) next_state = dig_right;
                else if(bump_right) next_state = walk_Left;                
                else next_state = state;
            end
            fall_right : begin
                if(ground)  next_state = walk_Right;
                else next_state = state;
            end
            fall_left : begin
                if(ground)  next_state = walk_Left;
                else next_state = state;
            end
            dig_right : begin
                if(~ground) next_state = fall_right;
                else next_state = state;
            end
            dig_left : begin
                if(~ground) next_state = fall_left;
                else next_state = state;
            end
            default: next_state = walk_Left;
        endcase
    end
    
    // State Register (Sequential Logic)
    always @(posedge clk or posedge areset) begin
        if(areset) state <= walk_Left;
        else state <= next_state;
    end
    
    // Output Logic (Changed always_comb to standard Verilog always @(*))
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        digging    = 1'b0;
        
        case (state)
            walk_Left:   walk_left  = 1'b1;
            walk_Right:  walk_right = 1'b1;
            fall_right:  aaah       = 1'b1;
            fall_left:   aaah       = 1'b1;
            dig_right:   digging    = 1'b1;
            dig_left:    digging    = 1'b1;
            default: begin
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah       = 1'b0;
                digging    = 1'b0;
            end
        endcase
    end
            
endmodule
