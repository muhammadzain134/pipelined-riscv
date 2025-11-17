`timescale 1ns / 1ps

module data_mem (
input logic clk,
input logic rst,
input logic [31:0] addr,
input logic we,             // write enable (MemWrite)
input logic [3:0] be,
input logic [31:0] dataWM,   // aligned write word 
output logic [31:0] dataR   // raw 32-bit word
    );
    
    logic [31:0] data_mem [0:1023];
    
    initial begin
      $readmemb("fib_dm.mem", data_mem);
    end
        
    // Read
    assign dataR = data_mem[addr[31:2]];    
        
    // Write
    always_ff @(posedge clk) begin
        if (we) begin
            if (be[0]) data_mem[addr[31:2]][7:0] <= dataWM [7:0];
            if (be[1]) data_mem[addr[31:2]][15:8] <= dataWM [15:8];
            if (be[2]) data_mem[addr[31:2]][23:16] <= dataWM[23:16];
            if (be[3]) data_mem[addr[31:2]][31:24] <= dataWM[31:24];
        end
    end
endmodule


