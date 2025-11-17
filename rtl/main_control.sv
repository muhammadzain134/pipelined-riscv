`timescale 1ns / 1ps

module main_control(
input logic [6:0] opcode,
output logic [1:0] ALUOp,
output logic RegWrite,
output logic ALUSrc,
output logic MemRead,
output logic MemWrite,
output logic MemtoReg,
output logic jump,
output logic jalr,
output logic branch,
output logic lui
    );
    always_comb begin
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        MemtoReg = 0;
        ALUSrc = 0;
        jump =0;
        branch = 0;
        jalr = 0;
        case(opcode)
            51: begin
             ALUOp = 2'b10; // R-type
             ALUSrc = 0;
             RegWrite = 1;
             branch = 0;
             lui = 0;
            end
            19: begin
             ALUOp = 2'b11; // I-type
             ALUSrc = 1;
             RegWrite = 1;
             branch = 0;
             lui = 0;
             end
            3: begin  // load
             ALUOp = 2'b00; 
             ALUSrc = 1;
             RegWrite = 1;
             MemRead  = 1;
             MemtoReg = 1;
             branch = 0;
             lui = 0;
            end
            35:begin  // store
             ALUOp = 2'b00; 
             ALUSrc = 1;
             MemWrite = 1;
             branch = 0;
             lui = 0;
            end
            111: begin // JAL
             RegWrite = 1;
             ALUSrc = 0;  
             MemRead = 0;
             MemWrite = 0;
             MemtoReg = 0;
             ALUOp = 2'b00;
             jump = 1;
             jalr = 0;
             branch = 0; 
             lui = 0;
            end
            103: begin // JALR
             RegWrite = 1;
             ALUSrc = 1;
             MemRead = 0;
             MemWrite = 0;
             MemtoReg = 0;
             ALUOp = 2'b11;
             jump = 1;
             jalr = 1;
             branch = 0; 
             lui = 0;
            end
            99: begin // Branchs
             ALUOp = 2'b01;   
             ALUSrc = 0;      
             RegWrite = 0;    
             MemRead  = 0;
             MemWrite = 0;
             MemtoReg = 0;
             jump = 0;        
             jalr = 0;
             branch = 1;
             lui = 0;
            end
            55: begin // LUI
             RegWrite = 1;
             ALUSrc   = 0;
             MemRead  = 0;
             MemWrite = 0;
             MemtoReg = 0;
             ALUOp = 2'b00; 
             jump = 0;
             jalr = 0;
             branch = 0;
             lui = 1;
            end
            23: begin // AUIPC
             RegWrite = 1;
             ALUSrc = 1;
             MemRead = 0;
             MemWrite = 0;
             MemtoReg = 0;
             ALUOp = 2'b00; 
             jump = 0;
             jalr = 0;
             branch = 0;
             lui = 1;
            end

        endcase   
    end

endmodule
