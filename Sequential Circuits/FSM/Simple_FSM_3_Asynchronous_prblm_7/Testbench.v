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
reg clk, areset,in;
wire out;
top_module dut(clk,in,areset,out); //module initialization
task bits_to_send(input [7:0]byte);
integer i;
begin
for(i = 7;i>=0;i=i-1) begin
@(posedge clk);
in = byte[i];
end
@(posedge clk);
in = 0;
areset = 1'b1;
end
endtask
always #2.5 clk = ~clk;

initial begin
clk =1'b0; in  = 1'b0;
areset = 1'b1;
#10;
areset = 1'b0;
bits_to_send(8'b10101010);
#20;
$finish;
end
endmodule
