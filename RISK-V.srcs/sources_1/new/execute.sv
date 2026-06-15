`timescale 1ns / 1ps

import headers::*;

module execute(
    input logic clk, rst,
    
    output logic exe2mem_req_read_o,
    output logic exe2mem_req_write_o, 
    output logic [ADDR_WIDTH-1:0] exe2mem_addr_w_o,
    output logic [ADDR_WIDTH-1:0] exe2mem_addr_r_o,
    output logic [INSTR_SIZE-1:0] exe2mem_data_w_o,
    input logic mem2exe_data_ready_i,
    input logic [INSTR_SIZE-1:0] mem2exe_op_data_i,
    
    
    input logic valid_i,
    input logic [OPCODE_SIZE-1:0] opcode,
    input logic [OPERAND_SIZE-1:0] op1,
    input logic [OPERAND_SIZE-1:0] op2,
    output logic ready
    );
      logic [4:0] state_ff;
      /*
        wait instr - 0
        opcode read - 1
        wait mem - 2
          
      */
      logic [4:0] state_next;
      
      logic [OPCODE_SIZE-1:0] opcode_ff;
      logic [OPERAND_SIZE-1:0] op1_ff;
      logic [OPERAND_SIZE-1:0] op2_ff;
      
      always @(posedge clk or negedge rst) begin
        if(rst) begin
            opcode_ff <= '0;
            op1_ff <= '0;
            op2_ff <= '0;
        end
        else if(valid_i) begin
            opcode_ff <= opcode;
            op1_ff <= op1;
            op2_ff <= op2;
        end
            
      end 
    
      always @(posedge clk or negedge rst) begin
        if(rst)
            state_ff <= '0;
        else
            state_ff <= state_next;
      end
      
          
      logic [1:0] regfile_req_read; 
      logic [INSTR_SIZE-1:0] regfile_data_w;
      logic [INSTR_SIZE-1:0] regfile_data_r1;
      logic [INSTR_SIZE-1:0] regfile_data_r2;
      logic regfile_data_ready1;
      logic regfile_data_ready2;
      logic req_write;
      
      logic [ADDR_WIDTH-1:0] regfile_addr1;
      logic [ADDR_WIDTH-1:0] regfile_addr2;
      
       always_comb begin
           ready = 0;
           exe2mem_req_read_o = 0;
           exe2mem_req_write_o = 0;
           state_next = 0;
           req_write = 0;
           regfile_req_read = '0;
           regfile_data_w = '0;
           regfile_addr1 = '0;
           regfile_addr2 = '0;
           exe2mem_addr_r_o = '0;
           exe2mem_addr_w_o = '0;
           exe2mem_data_w_o = '0;
           case(state_ff)
                0: begin
                    if(valid_i)
                        state_next = 1; 
                end 
                1: begin 
                    case(opcode_ff)
                        '0: begin //load
                             exe2mem_req_read_o = 1;
                             exe2mem_addr_r_o = op1_ff;
                             state_next = 2;
                        end
                        1: begin //store
                            regfile_req_read[0] = 1;
                            regfile_addr1 = op2_ff;
                            state_next = 2;
                        end
                        default: begin
                         state_next = 0;
                         ready = 1;
                        end
                    endcase
                end
                2: begin
                    case(opcode_ff)
                        '0: begin // load
                            if(mem2exe_data_ready_i) begin
                                req_write = 1;
                                regfile_data_w = mem2exe_op_data_i;
                            
                                regfile_addr1 = op2_ff;
                            
                                state_next = 0;
                                ready = 1;
                            end
                        end
                         1: begin //store
                            exe2mem_req_write_o = 1;
                            exe2mem_data_w_o = regfile_data_r1;
                            exe2mem_addr_w_o = op1_ff;
                            state_next = 0;
                            ready = 1;
                        end
                    endcase 
                end
           endcase
       end
       
        RegisterFile RegisterFile_i(clk, rst, regfile_req_read[0], req_write, regfile_data_w, regfile_addr1, regfile_req_read[1], regfile_addr2, regfile_data_r1, regfile_data_r2, regfile_data_ready1, regfile_data_ready2);
        
        
endmodule
