`timescale 1ns / 1ps

module top(
    input logic clk,
    input logic rst
);

//----------------------------------------------------------------------------------------------
// Signal Declarations
//----------------------------------------------------------------------------------------------

// PC & Instruction
logic [31:0] pc, pc_4, pc_target, pc_next, pc_jal;
logic [31:0] instr;

// Control Signals
logic [1:0]  ALUOp;
logic        RegWrite, ALUSrc, MemtoReg, MemWrite, MemRead;

// Register File
logic [4:0]  rs1, rs2, rd, rd_mem;
logic [31:0] data1, data2, write_data;

// Immediate & Decode
logic [31:0] imm_out, imm_out_decode, pc_decode, pc_target_exe;

// ALU
logic [3:0]  alu_ctrl;
logic [31:0] alu_in2, alu_in1, alu_result;
logic        carry_out, Zero, Overflow, Negative;

// Instruction Partition
logic [6:0]  opcode, funct7;
logic [2:0]  funct3;

// Data Memory
logic [31:0] ram_rword, dataR, wordW;
logic [3:0]  mask;
logic        not_align, jump, jalr, RegWrite_mem;
logic [31:0] jump_addr;

// Execution Stage
logic [31:0] alu_result_exe;
logic        branch, lui, PCSrc, jump_exe, jalr_exe;
logic        PCWrite, IF_ID_Write, FlushD, FlushE, FlushM;

//--------------------------------------------------------------------------------------------
// PC Logic
//--------------------------------------------------------------------------------------------

assign pc_4      = pc + 4;
assign pc_target = pc_decode + imm_out_decode;
assign pc_jal    = (jump_exe || PCSrc) ? pc_target_exe : pc_4;
assign pc_next   = (jalr_exe) ? (alu_result_exe & ~32'd1) : pc_jal;

program_counter PC (
    .clk(clk),
    .rst(rst),
    .pc_next(pc_next),
    .PCWrite(PCWrite),
    .pc(pc)
);

inst_mem IM (
    .addr(pc),
    .instr_out(instr)
);

// IF/ID Stage
logic [31:0] pc_fetch, instr_fetch;

IF_ID_Stage FD (
    .clk(clk),
    .rst(rst),
    .FlushD(FlushD),
    .pc_in(pc),
    .instr_in(instr),
    .IF_ID_Write(IF_ID_Write),
    .pc_out(pc_fetch),
    .instr_out(instr_fetch)
);

//------------------------------------------------------------------------------------------
// Instruction Decode
//------------------------------------------------------------------------------------------

assign opcode = instr_fetch[6:0];
assign rd     = instr_fetch[11:7];
assign funct3 = instr_fetch[14:12];
assign rs1    = instr_fetch[19:15];
assign rs2    = instr_fetch[24:20];
assign funct7 = instr_fetch[31:25];

main_control CTRL (
    .opcode(opcode),
    .ALUOp(ALUOp),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .jump(jump),
    .jalr(jalr),
    .branch(branch),
    .lui(lui)
);

reg_file RF (
    .clk(clk),
    .rs1(rs1),
    .rs2(rs2),
    .rsW(rd_mem),
    .dataW_reg(write_data),
    .RegWEn(RegWrite_mem),
    .data1(data1),
    .data2(data2)
);

imm_gen IMM (
    .instr(instr_fetch),
    .opcode(opcode),
    .imm_out(imm_out)
);

// Decode Stage Signals
logic [31:0] data1_decode, data2_decode;
logic [2:0]  funct3_decode;
logic [6:0]  funct7_decode;
logic [4:0]  rd_decode, rs2_decode, rs1_decode;
logic [1:0]  ALUOp_decode;
logic        RegWrite_decode, ALUSrc_decode, MemRead_decode, MemWrite_decode, MemtoReg_decode;
logic        branch_decode, lui_decode, jalr_decode, jump_decode;

hazard_detection HDU (
    .rs1(rs1),
    .rs2(rs2),
    .branch(PCSrc),
    .jump(jump_exe),
    .rd_decode(rd_decode),
    .MemRead_decode(MemRead_decode),
    .IF_ID_Write(IF_ID_Write),
    .PCWrite(PCWrite),
    .FlushD(FlushD),
    .FlushE(FlushE),
    .FlushM(FlushM)
);

ID_EX_Stage DE (
    .clk(clk),
    .rst(rst),
    .FlushE(FlushE),
    .pc_fetch(pc_fetch),
    .data1(data1),
    .data2(data2),
    .imm_out(imm_out),
    .funct3(funct3),
    .funct7(funct7),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .ALUOp(ALUOp),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .branch(branch),
    .lui(lui),
    .jump(jump),
    .jalr(jalr),
    .pc_decode(pc_decode),
    .data1_decode(data1_decode),
    .data2_decode(data2_decode),
    .imm_out_decode(imm_out_decode),
    .funct3_decode(funct3_decode),
    .funct7_decode(funct7_decode),
    .rd_decode(rd_decode),
    .ALUOp_decode(ALUOp_decode),
    .RegWrite_decode(RegWrite_decode),
    .ALUSrc_decode(ALUSrc_decode),
    .MemRead_decode(MemRead_decode),
    .MemWrite_decode(MemWrite_decode),
    .MemtoReg_decode(MemtoReg_decode),
    .branch_decode(branch_decode),
    .lui_decode(lui_decode),
    .jump_decode(jump_decode),
    .jalr_decode(jalr_decode),
    .rs1_decode(rs1_decode),
    .rs2_decode(rs2_decode)
);

//-------------------------------------------------------------------------------------
// Execute Stage
//-------------------------------------------------------------------------------------

// ALU Control
ALU_control ALUCTRL (
    .funct7(funct7_decode),
    .funct3(funct3_decode),
    .ALUOp(ALUOp_decode),
    .control_sig(alu_ctrl)
);

// Forwarding Logic
logic [1:0]  fwd_A, fwd_B;
logic [31:0] data1_mux, data2_mux;

always_comb begin
    case(fwd_A)
        0: data1_mux = data1_decode;
        1: data1_mux = alu_result_exe;
        2: data1_mux = write_data;
    endcase
    case(fwd_B)
        0: data2_mux = data2_decode;
        1: data2_mux = alu_result_exe;
        2: data2_mux = write_data;
    endcase
end

// ALU Inputs
assign alu_in2 = (ALUSrc_decode) ? imm_out_decode : data2_mux;
assign alu_in1 = (lui_decode)    ? pc_decode     : data1_mux;

alu_logic ALU (
    .a(alu_in1),
    .b(alu_in2),
    .alu_op(alu_ctrl),
    .result(alu_result),
    .carry_out(carry_out),
    .Zero(Zero),
    .Negative(Negative),
    .Overflow(Overflow)
);

// Forwarding Unit
logic [31:0] data2_decode_exe, imm_exe;
logic [4:0]  rd_exe;
logic [2:0]  funct3_exe;
logic        RegWrite_exe, MemRead_exe, MemWrite_exe, branch_exe;
logic        Zero_exe, carry_out_exe, Negative_exe, Overflow_exe;
logic        MemtoReg_exe, lui_exe;
logic        pc_exe;

fwd_logic fwd_unit (
    .rs1_decode(rs1_decode),
    .rs2_decode(rs2_decode),
    .rd_exe(rd_exe),
    .rd_mem(rd_mem),
    .RegWrite_mem(RegWrite_mem),
    .RegWrite_exe(RegWrite_exe),
    .fwd_A(fwd_A),
    .fwd_B(fwd_B)
);

EX_MEM_Stage EM (
    .clk(clk),
    .rst(rst),
    .FlushM(FlushM),
    .alu_result(alu_result),
    .data2_decode(data2_mux),
    .pc_target(pc_target),
    .rd_decode(rd_decode),
    .funct3_decode(funct3_decode),
    .RegWrite_decode(RegWrite_decode),
    .MemRead_decode(MemRead_decode),
    .MemWrite_decode(MemWrite_decode),
    .branch_decode(branch_decode),
    .lui_decode(lui_decode),
    .carry_out(carry_out),
    .Zero(Zero),
    .Negative(Negative),
    .Overflow(Overflow),
    .MemtoReg_decode(MemtoReg_decode),
    .jalr_decode(jalr_decode),
    .jump_decode(jump_decode),
    .imm_out_decode(imm_out_decode),
    .pc_decode(pc_decode),
    .alu_result_exe(alu_result_exe),
    .data2_decode_exe(data2_decode_exe),
    .pc_target_exe(pc_target_exe),
    .rd_exe(rd_exe),
    .RegWrite_exe(RegWrite_exe),
    .MemRead_exe(MemRead_exe),
    .MemWrite_exe(MemWrite_exe),
    .MemtoReg_exe(MemtoReg_exe),
    .funct3_exe(funct3_exe),
    .branch_exe(branch_exe),
    .Zero_exe(Zero_exe),
    .carry_out_exe(carry_out_exe),
    .Negative_exe(Negative_exe),
    .Overflow_exe(Overflow_exe),
    .jump_exe(jump_exe),
    .jalr_exe(jalr_exe),
    .lui_exe(lui_exe),
    .imm_exe(imm_exe),
    .pc_exe(pc_exe)
);

//-------------------------------------------------------------------------------------------
// Memory Stage
//-------------------------------------------------------------------------------------------

branch_unit BU (
    .funct3(funct3_exe),
    .PCSrc(PCSrc),
    .Zero(Zero_exe),
    .Negative(Negative_exe),
    .Overflow(Overflow_exe),
    .carry_out(carry_out_exe),
    .branch(branch_exe)
);

load_store_format LS (
    .mem_read(MemRead_exe),
    .mem_write(MemWrite_exe),
    .funct3(funct3_exe),
    .addr(alu_result_exe),
    .rword(ram_rword),
    .rs2(data2_decode_exe),
    .dataR(dataR),
    .wordW(wordW),
    .be(mask),
    .not_align(not_align)
);

data_mem DM (
    .clk(clk),
    .rst(rst),
    .addr(alu_result_exe),
    .we(MemWrite_exe),
    .be(mask),
    .dataWM(wordW),
    .dataR(ram_rword)
);

// MEM/WB Stage
logic [31:0] dataR_mem, alu_result_mem, imm_mem;
logic        MemtoReg_mem, lui_mem, jump_mem, pc_mem;

MEM_WB_Stage MW (
    .clk(clk),
    .rst(rst),
    .dataR(dataR),
    .alu_result_exe(alu_result_exe),
    .rd_exe(rd_exe),
    .jump_exe(jump_exe),
    .RegWrite_exe(RegWrite_exe),
    .pc_exe(pc_exe),
    .MemtoReg_exe(MemtoReg_exe),
    .imm_exe(imm_exe),
    .lui_exe(lui_exe),
    .dataR_mem(dataR_mem),
    .alu_result_exe_mem(alu_result_mem),
    .rd_mem(rd_mem),
    .pc_mem(pc_mem),
    .RegWrite_mem(RegWrite_mem),
    .MemtoReg_mem(MemtoReg_mem),
    .imm_mem(imm_mem),
    .jump_mem(jump_mem),
    .lui_mem(lui_mem)
);

//------------------------------------------------------------------------------------------------
// Write Back
//-------------------------------------------------------------------------------------------------

assign write_data = jump_mem ? (pc_4 - 8) :
                    MemtoReg_mem ? dataR_mem  :
                    lui_mem ? imm_mem    :
                    alu_result_mem;

endmodule
