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
reg clk,j,k,reset;
wire out;
top_module dut(clk,reset,j,k,out); //module initialization
always #2.5 clk = ~clk;
initial begin
clk = 1'b1;

reset = 1'b1;
j = 1'b0; k = 1'b0;
#10;
reset = 1'b0;
j = 1'b0; k = 1'b0;
#10;
j = 1'b0; k = 1'b1;
#10;
j = 1'b1; k = 1'b0;
#10;
j = 1'b1; k = 1'b1;
#30;
$finish;
end
endmodule
