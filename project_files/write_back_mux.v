`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2026 05:59:07
// Design Name: 
// Module Name: write_back_mux
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


module write_back_mux(
    input  wire [31:0] alu_result,
    input  wire [31:0] memory_data,
    input  wire [31:0] pc,
    input  wire [31:0] immediate,
    input  wire mem_to_reg,
    input  wire jal,
    input  wire lui,

    output reg  [31:0] write_back_data

);
always @(*) begin
 // Default: ALU result
        write_back_data = alu_result;
// Load instruction
        if (mem_to_reg)
            write_back_data = memory_data;
// JAL / JALR
        if (jal)
            write_back_data = pc + 32'd4;
// LUI
        if (lui)
            write_back_data = immediate;
    end

endmodule
