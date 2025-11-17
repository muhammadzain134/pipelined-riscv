`timescale 1ns / 1ps

module EX_MEM_Stage(
input logic clk,
input logic rst,
input logic FlushM,
// Data Signal Input 
input logic [31:0] alu_result,
input logic [31:0] data2_decode,
input logic [31:0] pc_target,
input logic [4:0] rd_decode,
input logic [2:0] funct3_decode,
input logic [31:0] imm_out_decode,
input logic pc_decode,
// Control Signal Input
input logic RegWrite_decode,
input logic MemRead_decode,
input logic MemWrite_decode,
input logic MemtoReg_decode,
input logic branch_decode,
input logic lui_decode,
input logic jalr_decode,
input logic jump_decode,

input logic carry_out,
input logic Zero,
input logic Negative,
input logic Overflow,
// Control Signal Output
output logic RegWrite_exe, 
output logic MemRead_exe, 
output logic MemWrite_exe,
output logic MemtoReg_exe, 
output logic branch_exe,
output logic lui_exe,
output logic jalr_exe,
output logic jump_exe,

output logic Zero_exe, 
output logic carry_out_exe, 
output logic Negative_exe, 
output logic Overflow_exe,
// Data Signal Input 
output logic [31:0] alu_result_exe,
output logic [31:0] data2_decode_exe,
output logic [31:0] pc_target_exe,
output logic [4:0] rd_exe,
output logic [2:0] funct3_exe,
output logic [31:0] imm_exe,
output logic pc_exe
    );
    always_ff @ (posedge clk, posedge rst) begin
        if(rst || FlushM)begin
            alu_result_exe <= 0;
            data2_decode_exe <= 0;
            pc_target_exe <= 0;
            rd_exe <= 0;
            funct3_exe <= 0;
            imm_exe <= 0;
            pc_exe <= 0;
            
            RegWrite_exe <= 0;
            MemRead_exe <= 0;
            MemWrite_exe <= 0;
            branch_exe <= 0;
            MemtoReg_exe <= 0;
            jump_exe <= 0;
            jalr_exe <= 0;
            lui_exe <= 0;
            
            Zero_exe <= 0;
            carry_out_exe <= 0;
            Negative_exe <= 0;
            Overflow_exe <= 0;
        end
        else begin
            alu_result_exe <= alu_result;
            data2_decode_exe <= data2_decode;
            pc_target_exe <= pc_target;
            rd_exe <= rd_decode;
            funct3_exe <= funct3_decode;
            imm_exe <= imm_out_decode;
            pc_exe <= pc_decode;
            
            RegWrite_exe <= RegWrite_decode;
            MemRead_exe <= MemRead_decode;
            MemWrite_exe <= MemWrite_decode;
            branch_exe <= branch_decode;
            MemtoReg_exe <= MemtoReg_decode;
            jump_exe <= jump_decode;
            jalr_exe <= jalr_decode;
            lui_exe <= lui_decode;
            
            Zero_exe <= Zero;
            carry_out_exe <= carry_out;
            Negative_exe <= Negative;
            Overflow_exe <= Overflow;
            
        end
    end
   
endmodule
