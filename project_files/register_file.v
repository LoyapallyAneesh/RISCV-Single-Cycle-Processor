`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2026 21:15:30
// Design Name: 
// Module Name: register_file
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


module register_file(
    input  wire clk,
    input  wire reset,
// Read register addresses
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
// Write register
    input  wire [4:0]  rd,
    input  wire [31:0] write_data,
    input  wire reg_write,
 // Read data
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);
// 32 registers, each 32 bits
reg [31:0] registers [0:31];
integer i;
// Reset
always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end
        else begin
            // x0 must always remain zero
            registers[0] <= 32'b0;
            // Write only when RegWrite = 1 and destination is not x0
            if (reg_write && (rd != 5'b00000))
                registers[rd] <= write_data;
        end
    end
// read
assign read_data1 = (rs1 == 5'b00000) ? 32'b0 : registers[rs1];
assign read_data2 = (rs2 == 5'b00000) ? 32'b0 : registers[rs2];

endmodule