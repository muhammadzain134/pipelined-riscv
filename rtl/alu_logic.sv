`timescale 1ns / 1ps

module alu_logic(
input logic signed [31:0] a,
input logic signed [31:0] b,
input logic [3:0] alu_op,
output logic signed  [31:0] result,
output logic carry_out,
output logic Zero,
output logic Negative,
output logic Overflow
    );
logic [32:0] temp_result; 
logic [31:0] a_u, b_u;
assign a_u = a;
assign b_u = b;
    always_comb begin
        carry_out = 0;
        Overflow = 0;
        case (alu_op)
            4'b0000: begin // ADD
                temp_result = {1'b0, a} + {1'b0, b};
                result = temp_result[31:0];
                carry_out = temp_result[32];
                Overflow = (a[31] == b[31]) && (result[31] != a[31]);
            end
            4'b1000: begin // SUB
                temp_result = {1'b0, a} - {1'b0, b};
                result = temp_result[31:0];
                carry_out = (a_u >= b_u); // Borrow bit
                Overflow = (a[31] != b[31]) && (result[31] != a[31]);
            end
            4'b0001: result = a << b[4:0]; // shift left
            4'b0010: result = (a < b) ? 32'h1 : 32'd0;// set less than
            4'b0011: result = (a < b) ? 32'd1 : 32'd0; // set less than unsigned
            4'b0100: result = a ^ b; // XOR
            4'b0101: result = a >> b[4:0]; // shift right logical
            4'b1101: result = a >>> b[4:0]; // shift right arithmatic
            4'b0110: result = a | b; // or 
            4'b0111: result = a & b;// and
            default: begin
                result = 32'd0;
            end
        endcase
        Negative = result[31];
        Zero = (result == 32'd0);
    end
 
endmodule
