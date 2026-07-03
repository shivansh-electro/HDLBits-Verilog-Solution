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


module stimulus();
reg clk, areset;
reg bump_left, 
    bump_right;

wire  walk_left, 
      walk_right;
top_module dut(clk,areset,bump_left,bump_right,walk_left,walk_right); //module initialization
always #2.5 clk = ~clk;
initial begin
clk =1'b0;  bump_left = 1'b0; bump_right = 1'd0;   
areset = 1'b1;
#10;
areset = 1'b0;
bump_left = 1'b0; bump_right = 1'd0;  
#10;
bump_left = 1'b0; bump_right = 1'd1;  
#10;
bump_left = 1'b1; bump_right = 1'd0;  
#10;
bump_left = 1'b1; bump_right = 1'd1;  
#10;
$finish;
end
endmodule
