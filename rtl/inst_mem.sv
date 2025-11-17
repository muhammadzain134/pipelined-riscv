`timescale 1ns / 1ps

module inst_mem(
input logic [31:0] addr,
output logic [31:0] instr_out
    );
logic [31:0] ins_mem [31:0];

initial begin
  $readmemh("fib_im.mem", ins_mem);
end
assign instr_out = ins_mem[addr[31:2]];         
endmodule
