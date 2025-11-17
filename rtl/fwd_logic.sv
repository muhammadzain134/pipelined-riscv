`timescale 1ns / 1ps

module fwd_logic(
input logic [4:0] rs1_decode,
input logic [4:0] rs2_decode,
input logic [4:0] rd_exe,
input logic [4:0] rd_mem,

input logic RegWrite_mem,
input logic RegWrite_exe,

output logic [1:0] fwd_A,
output logic [1:0] fwd_B
    );

always_comb begin
fwd_A = 0;
fwd_B = 0;
// Operand A
if ((rd_exe!=0)&& (RegWrite_exe) && (rd_exe == rs1_decode))begin
    fwd_A = 1;
end
else if ((rd_mem!=0)&& (RegWrite_mem) && (rd_mem == rs1_decode)) begin
    fwd_A = 2;
end
else begin
    
end

// Operand B
if ((rd_exe!=0)&& (RegWrite_exe) && (rd_exe == rs2_decode))begin
    fwd_B = 1;
end
else if ((rd_mem!=0)&& (RegWrite_mem) && (rd_mem == rs2_decode)) begin 
    fwd_B = 2;
end
end
endmodule
