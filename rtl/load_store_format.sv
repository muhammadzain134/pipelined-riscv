`timescale 1ns / 1ps

module load_store_format(
input logic mem_read,
input logic mem_write,
input logic [2:0] funct3,
input logic [31:0] addr,      
input logic [31:0] rword,     // 32b word fetched from RAM at addr[31:2]
input logic [31:0] rs2,     // register rs2 for stores
output logic [31:0] dataR,     // formatted load data to WB
output logic [31:0] wordW,     // aligned write word into RAM
output logic [3:0] be,     // byte enable
output logic not_align  
    );

logic [1:0] mask;  
assign mask = addr[1:0];


always_comb begin
    dataR = 32'd0;
    wordW = 32'd0;
    be = 4'b0000;
    not_align = 1'b0;
    // Load
    if (mem_read) begin
        case (funct3)
            3'b000: begin // LB
                case (mask)
                    2'd0: dataR = {{24{rword[7]}},  rword[7:0]};
                    2'd1: dataR = {{24{rword[15]}}, rword[15:8]};
                    2'd2: dataR = {{24{rword[23]}}, rword[23:16]};
                    2'd3: dataR = {{24{rword[31]}}, rword[31:24]};
                endcase
            end
            3'b100: begin // LBU
                case (mask)
                    2'd0: dataR = {24'd0, rword[7:0]};
                    2'd1: dataR = {24'd0, rword[15:8]};
                    2'd2: dataR = {24'd0, rword[23:16]};
                    2'd3: dataR = {24'd0, rword[31:24]};
                endcase
            end
            3'b001: begin // LH
                if (mask[0]) begin
                    // misaligned halfword
                    dataR = 32'd0;
                    not_align = 1'b1; // uncomment if you want to flag/kill
                end else begin
                    dataR = (mask[1]==1'b0) ? {{16{rword[15]}}, rword[15:0]}
                                           : {{16{rword[31]}}, rword[31:16]};
                end
            end
            3'b101: begin // LHU
                if (mask[0]) begin
                    dataR = 32'd0;
                    not_align = 1'b1;
                end else begin
                    dataR = (mask[1]==1'b0) ? {16'd0, rword[15:0]}
                                           : {16'd0, rword[31:16]};
                end
            end
            3'b010: begin // LW
                if (mask != 2'b00) begin
                    dataR = 32'd0;
                    not_align = 1'b1;
                end else begin
                    dataR = rword;
                end
            end
            default: dataR = 32'd0;
        endcase
    end

    // Store
    if (mem_write) begin
        case (funct3)
            3'b000: begin // SB
                wordW = {4{rs2[7:0]}}; // replicate byte into all lanes
                case (mask)
                    2'd0: be = 4'b0001;
                    2'd1: be = 4'b0010;
                    2'd2: be = 4'b0100;
                    2'd3: be = 4'b1000;
                endcase
            end
            3'b001: begin // SH
                if (mask[0]) begin
                    wordW = 32'd0;
                    not_align = 1'b1;
                    be = 4'b0000;
                end 
                else begin
                    wordW = {2{rs2[15:0]}}; // replicate halfword
                    be = (mask[1]==1'b0) ? 4'b0011 : 4'b1100;
                end
            end
            3'b010: begin // SW
                if (mask != 2'b00) begin
                    wordW = 32'd0;
                    not_align = 1'b1;
                    be = 4'b0000;
                end 
                else begin
                    wordW = rs2;
                    be = 4'b1111;
                end
            end
            default: begin
                wordW = 32'd0;
                be = 4'b0000;
            end
        endcase
    end
end

endmodule

