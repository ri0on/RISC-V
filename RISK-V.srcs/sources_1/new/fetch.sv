`timescale 1ns / 1ps


module fetch(
    input logic clk, rst,
    input logic data_req_read,
    input logic [ADDR_WIDTH-1:0] addr_data_read,
    input logic req_read,
    input logic req_write,
    input logic [ADDR_WIDTH-1:0] addr_w,
    input logic [INSTR_SIZE-1:0] data_w,
    output logic valid_o,
    output [INSTR_SIZE-1:0] instr_o,
    output [INSTR_SIZE-1:0] data_o,
    output logic data_ready_o
    );
    
    
    logic [INSTR_SIZE-1:0] mem [MEM_SIZE-1:0];
    initial begin
        $readmemb("data.mem", mem);
    end
    
    logic [ADDR_WIDTH-1:0] addr_next;
    logic [ADDR_WIDTH-1:0] addr;
    
    always @(posedge clk or negedge rst) begin
        if(rst) begin
            addr <= '0;   
        end
        else if(req_read)
            addr <= addr_next; 
            
    end
    assign addr_next = addr + 1;
    
    logic [INSTR_SIZE-1:0] instr;
    
    logic valid;
    always @(posedge clk or negedge rst) begin
        if(rst) begin
            valid <= 0;
            instr <= '0;
        end
        else if(req_read) begin
            instr <= mem[addr];
            valid <= 1;
        end
        else begin
            valid <= 0;
        end        
    end
    
    assign valid_o = valid;
    
    logic [INSTR_SIZE-1:0] data_ff;
    logic data_ready;
    always @(posedge clk) begin
        if(req_write)
            mem[addr_w] <= data_w;
        else if(data_req_read) begin
            data_ff <= mem[addr_data_read];
            data_ready <= data_req_read;
        end
    end
    assign data_ready_o = data_ready;
    
    assign data_o = data_ff;    
    assign instr_o = instr;
endmodule
