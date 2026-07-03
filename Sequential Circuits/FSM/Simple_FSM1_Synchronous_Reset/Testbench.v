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
reg clk,in,areset;
wire out,current_state;
Simple_FSM_1_sychronous_Reset dut(clk,in,areset,out,current_state); //module initialization
always #2.5 clk = ~clk;
task bits_to_send(input [3:0]data_bits);
integer i;
begin
for(i = 0 ;  i<4 ; i = i+1)
begin
@(posedge clk);
in = data_bits[i];
end
@(posedge clk);
areset = 1'b1;
end
endtask

initial begin
clk = 1'b1;

areset = 1'b1;
in = 1'b0;
#10;
areset = 1'b0;
bits_to_send(4'b1010);
end
endmodule
