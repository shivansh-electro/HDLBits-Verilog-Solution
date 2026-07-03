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
    input areset,
    output out); //

    
    parameter A = 0 , B = 1 , C = 2 , D = 3;
    reg [1:0]state , next_state;
    
    always@(*) begin
        case(state)
            A : next_state = in ? B : A;
            B : next_state = in ? B : C;
            C : next_state = in ? D : A;
            D : next_state = in ? B : C;
            default : next_state = A;
        endcase
    end
    
    always@(posedge clk or posedge areset) begin
        if(areset) state <= A;
        else state <= next_state;
    end
        
    
    assign out = (state == D);
endmodule

