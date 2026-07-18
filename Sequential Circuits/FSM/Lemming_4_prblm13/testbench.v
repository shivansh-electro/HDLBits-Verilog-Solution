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

    // 1. Inputs to DUT declared as reg
    reg clk;
    reg areset;
    reg bump_left;
    reg bump_right;
    reg ground;
    reg dig;
    
    // 2. Outputs from DUT declared as wire
    wire walk_left;
    wire walk_right;
    wire aaah;
    wire digging;

    // 3. Instantiate the Design Under Test (DUT)
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

    // 4. Clock Generation (50MHz Clock -> 20ns period)
    always begin
        #10 clk = ~clk;
    end

    // Integer for counting test cycles loop
    integer i;

    // 5. Stimulus Block
    initial begin
        // Initialize all inputs
        clk = 0;
        areset = 0;
        bump_left = 0;
        bump_right = 0;
        ground = 1; // Start safe on solid ground
        dig = 0;

        // ---- TEST 1: Asynchronous Reset ----
        $display("[Time %0t] Applying System Reset...", $time);
        areset = 1;
        #15 areset = 0; // De-assert reset mid-cycle
        
        @(posedge clk);
        #1; // Wait a fraction after edge for signals to stabilize
        if (walk_left) 
            $display("[PASS] Reset successful. Lemming walking left.");
        else 
            $display("[FAIL] Reset missed. Expected walk_left.");

        // ---- TEST 2: Safe Fall (10 Cycles) ----
        $display("[Time %0t] Test 2: Triggering a safe 10-cycle fall...", $time);
        ground = 0; // Ground drops out
        
        // Wait exactly 10 clock cycles
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
        end
        
        #1;
        $display("[Time %0t] Falling... aaah output status: %b", $time, aaah);
        
        ground = 1; // Hits the ground
        @(posedge clk);
        #1;
        if (walk_left && !aaah) 
            $display("[PASS] Lemming survived the 10-cycle fall safely.");
        else 
            $display("[FAIL] Lemming did not resume walking after safe fall.");

        #40; // Walk for a bit

        // ---- TEST 3: Lethal Fall (22 Cycles -> Splatter) ----
        $display("[Time %0t] Test 3: Triggering a lethal 22-cycle fall...", $time);
        ground = 0; // Ground drops out again
        
        // Wait exactly 22 clock cycles to exceed the 20-cycle threshold
        for (i = 0; i < 22; i = i + 1) begin
            @(posedge clk);
        end
        
        ground = 1; // Hits the ground after an extended drop
        @(posedge clk);
        #1;
        if (!walk_left && !walk_right && !aaah && !digging)
            $display("[PASS] Lemming splatted successfully. All action outputs are 0.");
        else
            $display("[FAIL] Lemming survived a lethal 22-cycle fall!");

        // ---- TEST 4: Verification of Permanent Death State ----
        $display("[Time %0t] Test 4: Verifying splatter state is permanent...", $time);
        bump_left = 1; // Attempt to make it change direction or move
        dig = 1;
        #40;
        if (!walk_left && !walk_right && !aaah && !digging)
            $display("[PASS] Splatter state is permanent. Inputs ignored.");
        else
            $display("[FAIL] Lemming revived itself from death state without a reset.");

        // ---- TEST 5: Recovery Via Reset ----
        $display("[Time %0t] Test 5: Re-applying reset to reincarnate Lemming...", $time);
        bump_left = 0;
        dig = 0;
        areset = 1;
        #20;
        areset = 0;
        @(posedge clk);
        #1;
        if (walk_left)
            $display("[PASS] Reincarnation successful. Walking left again.");
        else
            $display("[FAIL] Reset failed to clear Splatter state.");

        // Finish Simulation
        #100;
        $display("[Time %0t] Simulation Completed.", $time);
        $finish;
    end

endmodule


