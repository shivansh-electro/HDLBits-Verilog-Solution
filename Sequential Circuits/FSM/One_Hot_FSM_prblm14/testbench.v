`timescale 1ns / 1ps

module tb_top_module();

    // 1. Interface Signals
    reg clk;
    reg rst_n;
    reg in;
    reg [9:0] current_state;
    
    wire [9:0] next_state;
    wire out1;
    wire out2;

    // 2. Instantiate the Design Under Test (DUT)
    top_module uut (
        .in(in),
        .state(current_state),
        .next_state(next_state),
        .out1(out1),
        .out2(out2)
    );

    // 3. Clock Generation (50MHz Clock -> 20ns period)
    always begin
        #10 clk = ~clk;
    end

    // 4. Emulate the FSM State Register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset to State 0 (One-hot encoded bit 0 active)
            current_state <= 10'b0000000001; 
        end else begin
            current_state <= next_state;
        end
    end

    // 5. Stimulus Block
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        in = 0;

        // ---- Test Scenario 1: Apply System Reset ----
        $display("[Time %0t] Applying asynchronous reset...", $time);
        #15 rst_n = 1; // De-assert active-low reset mid-cycle
        
        @(posedge clk);
        #1;
        $display("[Time %0t] Initialized. State = %b (Expected Bit 0 to be 1)", $time, current_state);

        // ---- Test Scenario 2: Navigate Path to State 7 & Out2 ----
        // Sequence of 'in' high pulses: State 0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7
        $display("[Time %0t] Feeding 7 consecutive 1s to reach State 7...", $time);
        in = 1;
        repeat (7) begin
            @(posedge clk);
        end
        
        #1;
        $display("[Time %0t] Reached State vector: %b. out2 status = %b", $time, current_state, out2);
        
        // Hold in State 7
        @(posedge clk);
        #1;
        $display("[Time %0t] Retaining State 7. out2 status = %b", $time, out2);

        // ---- Test Scenario 3: Fall back to State 0 ----
        $display("[Time %0t] Driving 'in' low to fall back to State 0...", $time);
        in = 0;
        @(posedge clk);
        #1;
        $display("[Time %0t] State vector: %b (Expected back at State 0)", $time, current_state);

        // ---- Test Scenario 4: Navigate Path to State 9 (Both Out1 & Out2) ----
        // State 0 -(1)-> 1 -(1)-> 2 -(1)-> 3 -(1)-> 4 -(1)-> 5 -(1)-> 6 -(0)-> 9
        $display("[Time %0t] Driving sequence 1-1-1-1-1-1-0 to hit State 9...", $time);
        in = 1;
        repeat (6) begin
            @(posedge clk);
        end
        in = 0; // Transition from 6 to 9 on 0
        @(posedge clk);
        
        #1;
        $display("[Time %0t] State vector: %b. out1 = %b, out2 = %b", $time, current_state, out1, out2);

        // ---- Test Scenario 5: Turn 9 back to 1 via High input ----
        in = 1;
        @(posedge clk);
        #1;
        $display("[Time %0t] From State 9 fed a 1. State vector: %b (Expected State 1)", $time, current_state);

        // Finish Simulation
        #100;
        $display("[Time %0t] FSM Testing Completed.", $time);
        $finish;
    end

endmodule
