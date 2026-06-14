`timescale 1ns / 1ps



module top(

    );
    logic clk, rst;
    int tick;
    
    localparam INSTR_SIZE = 16;
    localparam OPCODE_SIZE = 5;
    localparam REG_COUNT = 16; 
    localparam REG_SIZE = $clog2(REG_COUNT);
    localparam MEM_SIZE = 128;
    localparam ADDR_WIDTH = $clog2(MEM_SIZE);
    localparam OPERAND_SIZE = ADDR_WIDTH;
    
    logic req_read, req_write;
    logic data_ready;
    logic [INSTR_SIZE-1:0] mem2exe_data;
    logic data_req_read;
    logic [ADDR_WIDTH-1:0] addr_data_read;
    logic [INSTR_SIZE-1:0] data_read;
    logic [ADDR_WIDTH-1:0] addr_w;
    logic [INSTR_SIZE-1:0] data_w;
    logic valid_f;
    logic [INSTR_SIZE-1:0] instr;
    logic state_fetch_ff; // 0 - initial, 1 - ready
    logic state_fetch_next;
    logic ready;
    logic req_force;
    assign req_force = state_fetch_ff ? ready : req_read;
    fetch f(clk, rst, data_req_read, addr_data_read, req_force, req_write, addr_w, data_w, valid_f, instr, mem2exe_data, data_ready);
    
    
    logic [OPCODE_SIZE-1:0] opcode;
    logic [OPERAND_SIZE-1:0] op1;
    logic [OPERAND_SIZE-1:0] op2;
    logic valid_d;
    decode_i decoder(clk, rst, valid_f, instr, valid_d, opcode, op1, op2);
   
    execute executor(
     .clk(clk),
     .rst(rst),
     .exe2mem_req_read_o(data_req_read),
     .exe2mem_req_write_o(req_write),
     .exe2mem_addr_w_o(addr_w), 
     .exe2mem_addr_r_o(addr_data_read), 
     .exe2mem_data_w_o(data_w), 
     .mem2exe_data_ready_i(data_ready),
     .mem2exe_op_data_i(mem2exe_data), 
     .valid_i(valid_d), 
     .opcode(opcode), 
     .op1(op1), 
     .op2(op2), 
     .ready(ready));
    
    retire wb(clk, rst, ready);  
    
   
    always @(posedge clk or negedge rst) begin
        if(rst)
            state_fetch_ff <= '0;
        else if(state_fetch_next) 
            state_fetch_ff <= 1;
      end
    
    initial begin 
        clk = 0;
        rst = 1;
        #10
        rst = 0;
    end
    
    initial begin
        state_fetch_next = 0;
        req_read = 0;
        #20
        req_read = 1;
        #20
        req_read = 0;
        state_fetch_next = 1;
    end
    
    always begin
        clk = ~clk;
        tick++;
        #10;
    end
    
    
endmodule
