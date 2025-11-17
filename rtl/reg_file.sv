`timescale 1ns / 1ps

module reg_file(
input logic clk,
input logic [4:0] rs1,
input logic [4:0] rs2,
input logic [4:0] rsW,
input logic [31:0] dataW_reg,
input logic RegWEn,
output logic [31:0] data1,
output logic [31:0] data2
    );
logic [31:0] mem [31:0];

initial begin
  $readmemb("fib_rf.mem", mem);
end
 
assign data1 = mem[rs1];
assign data2 = mem[rs2];
    
    always_ff @(negedge clk)begin
        if(RegWEn && rsW != 5'd0)begin
            mem[rsW] <= dataW_reg;
        end
    end     
   
endmodule
