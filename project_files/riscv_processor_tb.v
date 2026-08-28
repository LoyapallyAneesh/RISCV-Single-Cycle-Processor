`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2026 17:29:20
// Design Name: 
// Module Name: riscv_processor_tb
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


module riscv_processor_tb();
reg clk;
reg reset;
riscv_processor DUT (
        .clk(clk),
        .reset(reset)
);

// CLOCK GENERATION-10 ns clock period
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
 end

// LOAD PROGRAM
initial begin
        // ADDI x1, x0, 5 - x1 = 5
        DUT.IMEM.memory[0] = 32'h00500093;
        // ADDI x2, x0, 10- x2 = 10
        DUT.IMEM.memory[1] = 32'h00A00113;
        // ADD x3, x1, x2 - x3 = 15
        DUT.IMEM.memory[2] = 32'h002081B3;
        // SUB x4, x2, x1 - x4 = 5
        DUT.IMEM.memory[3] = 32'h40110233;
        // SW x3, 0(x0) - memory[0] = 15
        DUT.IMEM.memory[4] = 32'h00302023;
        // LW x5, 0(x0) - x5 = 15
        DUT.IMEM.memory[5] = 32'h00002283;
        // -----------------------------------------------
        // BEQ x3, x5, +8
        // PC = 24
        // Target = 24 + 8 = 32
        // Skips instruction at PC = 28
        // -----------------------------------------------
        DUT.IMEM.memory[6] = 32'h00518463;
        // ADDI x6, x0, 99
        // This instruction should be skipped
        DUT.IMEM.memory[7] = 32'h06300313;
        // ADDI x6, x0, 42 - x6 = 42
        DUT.IMEM.memory[8] = 32'h02A00313;
        // -----------------------------------------------
        // JAL x7, +8
        // PC = 36
        // x7 = PC + 4 = 40
        // Target = 36 + 8 = 44
        // Skips instruction at PC = 40
        // -----------------------------------------------
        DUT.IMEM.memory[9] = 32'h008003EF;
        // ADDI x8, x0, 99
        // This instruction should be skipped
        DUT.IMEM.memory[10] = 32'h06300413;
        // ADDI x9, x0, 77 - x9 = 77
        DUT.IMEM.memory[11] = 32'h04D00493;
        // JAL x0, 0 - Infinite loop
        DUT.IMEM.memory[12] = 32'h0000006F;
    end
// RESET
initial begin
   reset = 1'b1;
   #20;
   reset = 1'b0;
end
// MONITOR
initial begin
        $monitor(
            "Time=%0t | PC=%h | Instruction=%h | x1=%0d x2=%0d x3=%0d x4=%0d x5=%0d x6=%0d x7=%0d x8=%0d x9=%0d",
            $time,
            DUT.current_pc,
            DUT.instruction,

            DUT.REG_FILE.registers[1],
            DUT.REG_FILE.registers[2],
            DUT.REG_FILE.registers[3],
            DUT.REG_FILE.registers[4],
            DUT.REG_FILE.registers[5],
            DUT.REG_FILE.registers[6],
            DUT.REG_FILE.registers[7],
            DUT.REG_FILE.registers[8],
            DUT.REG_FILE.registers[9]
        );
    end

// TEST
initial begin
 // Wait until reset is released
  #20;
// Execute enough clock cycles
  repeat(12)
     @(posedge clk);
     // Give nonblocking assignments time to settle
        #1;
     // CHECK REGISTER VALUES
        $display("");
        $display("========================================");
        $display("       RISC-V PROCESSOR TEST");
        $display("========================================");
     // x1
        if (DUT.REG_FILE.registers[1] == 32'd5)
            $display("PASS: x1 = 5");
        else
            $display("FAIL: x1 = %0d, expected 5",
                     DUT.REG_FILE.registers[1]);
     // x2
        if (DUT.REG_FILE.registers[2] == 32'd10)
            $display("PASS: x2 = 10");
        else
            $display("FAIL: x2 = %0d, expected 10",
                     DUT.REG_FILE.registers[2]);
     // x3
        if (DUT.REG_FILE.registers[3] == 32'd15)
            $display("PASS: x3 = 15");
        else
            $display("FAIL: x3 = %0d, expected 15",
                     DUT.REG_FILE.registers[3]);
     // x4
        if (DUT.REG_FILE.registers[4] == 32'd5)
            $display("PASS: x4 = 5");
        else
            $display("FAIL: x4 = %0d, expected 5",
                     DUT.REG_FILE.registers[4]);
     // x5
        if (DUT.REG_FILE.registers[5] == 32'd15)
            $display("PASS: x5 = 15");
        else
            $display("FAIL: x5 = %0d, expected 15",
                     DUT.REG_FILE.registers[5]);
     // x6
        if (DUT.REG_FILE.registers[6] == 32'd42)
            $display("PASS: x6 = 42");
        else
            $display("FAIL: x6 = %0d, expected 42",
                     DUT.REG_FILE.registers[6]);
     // x7
        if (DUT.REG_FILE.registers[7] == 32'd40)
            $display("PASS: x7 = 40");
        else
            $display("FAIL: x7 = %0d, expected 40",
                     DUT.REG_FILE.registers[7]);
     // x8 should remain 0 because JAL skipped it
        if (DUT.REG_FILE.registers[8] == 32'd0)
            $display("PASS: x8 was skipped");
        else
            $display("FAIL: x8 = %0d, expected 0",
                     DUT.REG_FILE.registers[8]);
     // x9
        if (DUT.REG_FILE.registers[9] == 32'd77)
            $display("PASS: x9 = 77");
        else
            $display("FAIL: x9 = %0d, expected 77",
                     DUT.REG_FILE.registers[9]);
// CHECK DATA MEMORY
        if (DUT.DMEM.memory[0] == 32'd15)
            $display("PASS: memory[0] = 15");
        else
            $display("FAIL: memory[0] = %0d, expected 15",
                     DUT.DMEM.memory[0]);
// FINISH
        $display("");
        $display("========================================");
        $display("          TEST COMPLETE");
        $display("========================================");

        $finish;

    end


endmodule
