`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/18/2026 11:43:07 AM
// Design Name: 
// Module Name: testbench
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

module tb_top_module();

    // 1. Interface Signals (Inputs declared as reg, Outputs as wire)
    reg clk;
    reg areset;
    reg bump_left;
    reg bump_right;
    reg ground;
    reg dig;
    
    wire walk_left;
    wire walk_right;
    wire aaah;
    wire digging;

    // 2. Instantiate the Design Under Test (DUT)
    top_module uut (
        .clk(clk),
        .areset(areset),
        .bump_left(bump_left),
        .bump_right(bump_right),
        .ground(ground),
        .dig(dig),
        .walk_left(walk_left),
        .walk_right(walk_right),
        .aaah(aaah),
        .digging(digging)
    );

    // 3. Clock Generation (50MHz Clock -> 20ns period)
    always begin
        #10 clk = ~clk;
    end

    // 4. Stimulus Block
    initial begin
        // Initialize all inputs
        clk = 0;
        areset = 0;
        bump_left = 0;
        bump_right = 0;
        ground = 1; // Start on solid ground
        dig = 0;

        // ---- Test Scenario 1: Asynchronous Reset ----
        $display("[Time %0t] Applying Reset...", $time);
        areset = 1;
        #15; // Reset held during clock edge
        areset = 0;
        
        // Wait for next stable clock cycle
        @(posedge clk);
        #1; // Minor delay to check output after clock edge
        $display("[Time %0t] State should be walk_Left. walk_left=%b", $time, walk_left);

        // ---- Test Scenario 2: Bump Left to turn Right ----
        #20;
        bump_left = 1;
        @(posedge clk);
        #1;
        bump_left = 0;
        $display("[Time %0t] State should be walk_Right. walk_right=%b", $time, walk_right);

        // ---- Test Scenario 3: Bump Right to turn Left ----
        #20;
        bump_right = 1;
        @(posedge clk);
        #1;
        bump_right = 0;
        $display("[Time %0t] State should be walk_Left. walk_left=%b", $time, walk_left);

        // ---- Test Scenario 4: Digging Left ----
        #20;
        dig = 1;
        @(posedge clk);
        #1;
        dig = 0;
        $display("[Time %0t] State should be dig_left. digging=%b", $time, digging);

        // ---- Test Scenario 5: Fall while Digging ----
        #20;
        ground = 0; // Ground vanishes!
        @(posedge clk);
        #1;
        $display("[Time %0t] State should be fall_left. aaah=%b", $time, aaah);

        // ---- Test Scenario 6: Land on Ground ----
        #40; // Fall for two clock cycles
        ground = 1;
        @(posedge clk);
        #1;
        $display("[Time %0t] State should be walk_Left. walk_left=%b", $time, walk_left);

        // Finish Simulation
        #100;
        $display("[Time %0t] Simulation Completed Successfully.", $time);
        $finish;
    end

endmodule

