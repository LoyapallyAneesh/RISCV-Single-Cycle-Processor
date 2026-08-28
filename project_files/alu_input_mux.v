`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2026 19:39:02
// Design Name: 
// Module Name: alu_input_mux
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


module alu_input_mux(
    input  wire [31:0] rs2_data,
    input  wire [31:0] immediate,
    input  wire  alu_src,
    output wire [31:0] alu_input_b
);

assign alu_input_b = (alu_src == 1'b0) ? rs2_data : immediate;

endmodule
