`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2026 05:26:23
// Design Name: 
// Module Name: riscv_processor
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


module riscv_processor(
    input wire clk,
    input wire reset
);
// PC SIGNALS
    wire [31:0] current_pc;
    wire [31:0] next_pc;
    wire  pc_mux1;
    wire  pc_mux2;
    wire [31:0] pc_mux1_output;
    wire [31:0] pc_mux2_output;
// INSTRUCTION
    wire [31:0] instruction;
// INSTRUCTION FIELDS
    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];
// CONTROL SIGNALS
    wire       reg_write;
    wire       mem_read;
    wire       mem_write;
    wire       mem_to_reg;
    wire       alu_src;
    wire       branch;
    wire       branch_ne;
    wire       jal;
    wire       jalr;
    wire       lui;
    wire [3:0] alu_control;
// REGISTER FILE
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;
// IMMEDIATE
    wire [31:0] immediate;
// ALU
    wire [31:0] alu_input_b;
    wire [31:0] alu_result;
    wire zero;
// DATA MEMORY
    wire [31:0] memory_data;
// BRANCH / JUMP
    wire [31:0] branch_target;
    wire [31:0] jal_target;
    wire [31:0] jalr_target;
    wire branch_taken;

// PC
   pc PC_UNIT (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );
// INSTRUCTION MEMORY
   instruction_memory IMEM (
        .address(current_pc),
        .instruction(instruction)
    );
// DECODER
    riscv_decoder DECODER (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .branch_ne(branch_ne),
        .jal(jal),
        .jalr(jalr),
        .lui(lui),
        .alu_control(alu_control),
        .pc_mux1(pc_mux1),
        .pc_mux2(pc_mux2)
    );
// REGISTER FILE
   register_file REG_FILE (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );
// IMMEDIATE GENERATOR
   immediate_generator IMM_GEN (
        .instruction(instruction),
        .immediate(immediate)
    );
// ALU INPUT MUX
    alu_input_mux ALU_MUX (
        .rs2_data(read_data2),
        .immediate(immediate),
        .alu_src(alu_src),
        .alu_input_b(alu_input_b)
    );
// ALU
    alu ALU (
        .a(read_data1),
        .b(alu_input_b),
        .alu_control(alu_control),
        .result(alu_result),
        .zero(zero)
    );
// DATA MEMORY
   data_memory DMEM (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(memory_data)
    );
// BRANCH CONDITION
    branch_condition BRANCH_CONDITION (
        .branch(branch),
        .branch_ne(branch_ne),
        .zero(zero),
        .branch_taken(branch_taken)
    );
// PC MUX 1
    pc_mux1 pcmux1(
     .pc(current_pc),
    .rs1(read_data1),
    .pc_mux1_control(pc_mux1),
    .pc_mux1_output(pc_mux1_output)
    );
// PC MUX 2
     pc_mux2 pcmux2(
     .pc_mux2_control(pc_mux2),
    .branch_taken(branch_taken),
    .immediate(immediate),
    .pc_mux2_output(pc_mux2_output)
    );
 // NEXT PC
    pc_adder pc_value(
    .pc_mux1(pc_mux1_output),
    .pc_mux2(pc_mux2_output),
    .jalr(jalr),
    .pc_next(next_pc)
    );
// WRITE BACK MUX
    write_back_mux WB_MUX (
        .alu_result(alu_result),
        .memory_data(memory_data),
        .pc(current_pc),
        .immediate(immediate),
        .mem_to_reg(mem_to_reg),
        .jal(jal),
        .lui(lui),
        .write_back_data(write_back_data)
    );

endmodule
