`timescale 1ns / 1ps

module branch_unit(
input  logic [2:0] funct3,
input  logic branch,
input  logic Zero,
input  logic Negative,
input  logic Overflow,
input  logic carry_out,
output logic PCSrc
    );
always_comb begin
    PCSrc = 0;
    if (branch) begin 
        case (funct3)
            3'b000: PCSrc = (Zero);                  // beq
            3'b001: PCSrc = (!Zero);                 // bne
            3'b100: PCSrc = (Negative != Overflow);  // blt (signed)
            3'b101: PCSrc = !(Negative != Overflow); // bge (signed)
            3'b110: PCSrc = (!carry_out);             // bltu
            3'b111: PCSrc = (carry_out);             // bgeu
            default: PCSrc = 0;
        endcase
     end
end
endmodule
