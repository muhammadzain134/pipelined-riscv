`timescale 1ns / 1ps

module IF_ID_Stage(
input logic clk,
input logic rst,
input logic FlushD,
input logic [31:0] pc_in,
input logic [31:0] instr_in,
input logic IF_ID_Write,
output logic [31:0] pc_out,
output logic [31:0] instr_out
    );
    
    always_ff @(posedge clk, posedge rst)begin
        if (rst || FlushD)begin
             pc_out <= 0;
             instr_out <= 0;   
        end
        else if (IF_ID_Write) begin 
            pc_out <= pc_in;
            instr_out <= instr_in; 
        end
    end
    
endmodule
