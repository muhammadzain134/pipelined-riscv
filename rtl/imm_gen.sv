`timescale 1ns / 1ps

module imm_gen(
input logic [31:0] instr,
input logic [6:0] opcode,
output logic [31:0] imm_out
    );
    
    always_comb begin
        case (opcode)
         3,19,103: begin// for load and I type      
            imm_out = {{20{instr[31]}}, instr[31:20]};
         end
         35: begin // store
            imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};
         end
         111: begin // JAL
            imm_out = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        99: begin // B-type
            imm_out = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        end
        55,23: begin // LUI/AUIPC
            imm_out = {instr[31:12], 12'b0}; 
        end
        default: begin
            imm_out = 32'd0;
        end
        endcase
    end
endmodule
