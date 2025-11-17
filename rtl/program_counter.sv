`timescale 1ns / 1ps

module program_counter(
    input  logic clk,
    input  logic rst,
    input logic PCWrite,
    input  logic [31:0] pc_next,
    output logic [31:0] pc
);
    always_ff @(posedge clk, posedge rst) begin
        if (rst)
            pc <= 0;
        else if (PCWrite)
            pc <= pc_next;
    end
endmodule