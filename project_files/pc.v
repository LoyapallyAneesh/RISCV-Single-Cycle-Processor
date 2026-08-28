`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2026 19:43:06
// Design Name: 
// Module Name: pc
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


module pc(
    input  wire  clk,
    input  wire  reset,
    input  wire [31:0] next_pc,
    output reg  [31:0] current_pc
);
 always @(posedge clk) begin
        if (reset)
            current_pc <= 32'b0;
        else
            current_pc <= next_pc;
    end

endmodule