`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 10:24:00 AM
// Design Name: 
// Module Name: stimulus
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


`timescale 1ns / 1ps

module tb_top_module;

    // 1. Inputs to the Design Under Test (DUT) declared as regs
    reg clk;
    reg areset;
    reg bump_left;
    reg bump_right;
    reg ground;

    // 2. Outputs from the DUT declared as wires
    wire walk_left;
    wire walk_right;
    wire aaah;

    // 3. Instantiate the Unit Under Test (UUT)
    top_module uut (
        .clk(clk),
        .areset(areset),
        .bump_left(bump_left),
        .bump_right(bump_right),
        .ground(ground),
        .walk_left(walk_left),
        .walk_right(walk_right),
        .aaah(aaah)
    );

    // 4. Generate a 100MHz clock signal (10ns period)
    always begin
        #5 clk = ~clk;
    end

    // 5. Stimulus block to test all state transitions
    initial begin
        // Initialize all inputs
        clk = 0;
        areset = 0;
        bump_left = 0;
        bump_right = 0;
        ground = 1;       // Lemming starts safely on the ground
        
        // Apply Asynchronous Reset
        #10 areset = 1;   // Reset active
        #15 areset = 0;   // Reset released, state becomes 'left' (walking left)
        
        // Test 1: Hit left bump while walking left -> should change to 'right'
        #10 bump_left = 1;
        #10 bump_left = 0;
        
        // Test 2: Hit right bump while walking right -> should change to 'left'
        #10 bump_right = 1;
        #10 bump_right = 0;
        
        // Test 3: Ground disappears while walking left -> should fall ('fall_left')
        #10 ground = 0;
        
        // Test 4: Ground returns -> should resume walking left ('left')
        #20 ground = 1;
        
        // Move to the right state to test right fall
        #10 bump_left = 1;
        #10 bump_left = 0;
        
        // Test 5: Ground disappears while walking right -> should fall ('fall_right')
        #10 ground = 0;
        
        // Test 6: Ground returns -> should resume walking right ('right')
        #20 ground = 1;

        // Finish simulation
        #40 $finish;
    end

endmodule

