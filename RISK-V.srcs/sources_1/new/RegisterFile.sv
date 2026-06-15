`timescale 1ns / 1ps


import headers::*;

module RegisterFile(
    input logic clk, rst,
    input logic read_req1,
    input logic write_req1,
    input logic [DATA_SIZE-1:0] data_i,
    input logic [ADDR_WIDTH-1:0] addr1,
    input logic read_req2,
    input logic [ADDR_WIDTH-1:0] addr2,
    
    output logic [DATA_SIZE-1:0] data1_o,
    output logic [DATA_SIZE-1:0] data2_o,
    
    output logic regfile_data_ready1,
    output logic regfile_data_ready2
    );
        logic [REG_COUNT-1:0] regs [DATA_SIZE-1:0];
        logic [DATA_SIZE-1:0] data1;
        logic [DATA_SIZE-1:0] data2;
        always @(posedge clk or negedge rst) begin
            if(rst) begin
                for(int i = 0; i < REG_COUNT; i++) begin 
                    regs[i] <= '0;
                end
            end
            else begin
                if(read_req1) begin
                    data1_o <= data1;
                    regfile_data_ready1 <= read_req1;
                end
                if(read_req2) begin
                    data2_o <= data2;
                    regfile_data_ready2 <= read_req2;
                end
                if(write_req1) begin
                    regs[addr1] <= data_i;
                end
            end
        end
       assign data1 = regs[addr1];
       assign data2 = regs[addr2];
endmodule
