`timescale 1ns / 1ps

module ID_EX_Stage(
input logic clk,
input logic rst,
input logic FlushE,
// Data Signal Input 
input logic [31:0] pc_fetch,
input logic [31:0] data1,
input logic [31:0] data2,
input logic [31:0] imm_out,
input logic [2:0] funct3, 
input logic [6:0]funct7,
input logic [4:0] rd,
input logic [4:0] rs1,
input logic [4:0] rs2,

// Control Signal Input
input logic [1:0] ALUOp, 
input logic RegWrite, 
input logic ALUSrc, 
input logic MemRead, 
input logic MemWrite, 
input logic MemtoReg,
input logic branch,
input logic lui,
input logic jump,
input logic jalr,
// Control Signal Output
output logic [1:0] ALUOp_decode,
output logic RegWrite_decode, 
output logic ALUSrc_decode, 
output logic MemRead_decode, 
output logic MemWrite_decode, 
output logic MemtoReg_decode, 
output logic branch_decode, 
output logic lui_decode,
output logic jump_decode,
output logic jalr_decode,
// Data Signal Input 
output logic [31:0] pc_decode,
output logic [31:0] data1_decode, 
output logic [31:0] data2_decode, 
output logic [31:0] imm_out_decode,
output logic [2:0] funct3_decode,
output logic [6:0] funct7_decode,
output logic [4:0] rd_decode,
output logic [4:0] rs1_decode,
output logic [4:0] rs2_decode

    );
    
    always_ff @(posedge clk, posedge rst)begin
        if(rst || FlushE)begin 
            data1_decode <= 0;
            data2_decode <= 0;
            imm_out_decode <= 0;
            funct3_decode <= 0;
            funct7_decode <= 0;
            rd_decode <= 0;
            pc_decode <= 0;
            rs1_decode <= 0;
            rs2_decode <= 0;
            
            ALUOp_decode <= 0;
            MemWrite_decode <= 0;
            RegWrite_decode <= 0;
            ALUSrc_decode <= 0;
            MemRead_decode <= 0;
            MemtoReg_decode <= 0;
            branch_decode <= 0;
            lui_decode <= 0;
            jump_decode <= 0;
            jalr_decode <= 0;
        end
        else begin
            data1_decode <= data1;
            data2_decode <= data2;
            imm_out_decode <= imm_out;
            funct3_decode <= funct3;
            funct7_decode <= funct7;
            rd_decode <= rd;
            pc_decode <= pc_fetch;
            rs1_decode <= rs1;
            rs2_decode <= rs2;
            
            ALUOp_decode <= ALUOp;
            MemWrite_decode <= MemWrite;
            RegWrite_decode <= RegWrite;
            ALUSrc_decode <= ALUSrc;
            MemRead_decode <= MemRead;
            MemtoReg_decode <= MemtoReg;
            branch_decode <= branch;
            lui_decode <= lui;
            jump_decode <= jump;
            jalr_decode <= jalr;
        end   
    end
    
endmodule