# RISCV-Single-Cycle-Processor
A modular 32-bit RISC-V single-cycle processor implemented in Verilog HDL. The processor follows a classic RISC-V Datapath architecture, with separate instruction and data memories, a register file, immediate generator, ALU, control/decoder logic, next pc generation, and write-back logic.

The design is written in a modular manner so that individual blocks can be simulated and verified independently and can later be combined into a complete module.
# Architecture
The processor implements a single cycle Datapath, meaning that each instruction is completed within one clock cycle.
Although the processor uses a clock, the majority of the Datapath is combinational. The clock is primarily used to update sequential state such as:
Program Counter, Register File writes, Data Memory writes.
 
# The current implementation supports instruction classes:
R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
I-type: ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU
Load / Store: LW, SW
Branch: BEQ, BNE
Jump: JAL, JALR
Upper Immediate: LUI
