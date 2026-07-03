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


module Simple_FSM_1_sychronous_Reset(
    input clk,
    input areset,    // Asynchronous reset to state B
    input in,
    output out,current_state);//  

    parameter A=0, B=1; 
    reg state, next_state;

    always @(*) begin    // This is a combinational always block
        case (state)
            A : next_state = in ? A:B;
            B : next_state = in ? B:A;
        endcase  
    end

    always @(posedge clk) begin    // This is a sequential always block
        if(areset) state <= B;
        else state <=next_state;
    end

    // Output logic
    assign out = (state == B);
    assign current_state = state;
    
endmodule

