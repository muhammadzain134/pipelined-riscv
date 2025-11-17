`timescale 1ns / 1ps

module hazard_detection(
input logic [4:0] rs1,
input logic [4:0] rs2,
input logic [4:0] rd_decode,
input logic branch,
input logic jump,

input logic MemRead_decode,

output logic IF_ID_Write,
output logic PCWrite,
output logic FlushD,
output logic FlushE,
output logic FlushM
    );

always_comb begin
    IF_ID_Write = 1;
    PCWrite = 1;
    FlushE = 0;
    FlushD = 0;
    FlushM = 0;
    
    if(MemRead_decode && (rd_decode != 0) && ((rd_decode == rs1) || (rd_decode == rs2))) begin
        IF_ID_Write = 0;
        PCWrite = 0;
        FlushE = 1;    
    end
    else begin
        IF_ID_Write = 1;
        PCWrite = 1;
        FlushE = 0; 
    end
    
    if(branch || jump) begin
        FlushD = 1;
        FlushE = 1;;
        FlushM = 1; 
    end
    else begin
        FlushE = 0;
        FlushD = 0; 
        FlushM = 0;    
    end  
end

endmodule
