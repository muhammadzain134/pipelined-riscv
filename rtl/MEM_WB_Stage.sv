`timescale 1ns / 1ps

module MEM_WB_Stage(
input logic clk,
input logic rst,
// Data Signal Input 
input logic [31:0] dataR,
input logic [31:0] alu_result_exe,
input logic [4:0] rd_exe,
input logic [31:0] imm_exe,
input logic pc_exe,
// Control Signal Input
input logic MemtoReg_exe, 
input logic RegWrite_exe,
input logic jump_exe,
input logic lui_exe,
// Control Signal Output
output logic MemtoReg_mem, 
output logic RegWrite_mem,
output logic lui_mem,
output logic jump_mem,
// Data Signal Output 
output logic [31:0] dataR_mem,
output logic [31:0] alu_result_exe_mem,
output logic [4:0] rd_mem,
output logic [31:0] imm_mem,
output logic pc_mem
    );
    always_ff @ (posedge clk, posedge rst) begin
        if(rst)begin
            dataR_mem <= 0;
            alu_result_exe_mem <= 0;
            rd_mem <= 0;
            imm_mem <= 0;
            pc_mem <= 0;
            
            MemtoReg_mem <= 0;
            RegWrite_mem <= 0;
            lui_mem <= 0;
            jump_mem <= 0;
        end
        else begin
            dataR_mem <= dataR;
            alu_result_exe_mem <= alu_result_exe;
            rd_mem <= rd_exe;
            imm_mem <= imm_exe;
            pc_mem <= pc_exe;
            
            MemtoReg_mem <= MemtoReg_exe;
            RegWrite_mem <= RegWrite_exe;
            lui_mem <= lui_exe;
            jump_mem <= jump_exe;
        end
    end
endmodule
