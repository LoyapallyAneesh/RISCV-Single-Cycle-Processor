`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2026 05:34:05
// Design Name: 
// Module Name: instruction_memory
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


module instruction_memory(
    input  wire [31:0] address,
    output wire [31:0] instruction
);
// 256 words-Each word is 32 bits
reg [31:0] memory [0:255];

// Word-aligned instruction access
assign instruction = memory[address[9:2]];

endmodule
