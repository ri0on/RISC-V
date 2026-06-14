`timescale 1ns / 1ps

import headers::*;

module decode_i(
    input logic clk, rst,
    input logic valid_i,
    input logic [INSTR_SIZE-1:0] instr,
    
    output logic valid_o,
    output logic [OPCODE_SIZE-1:0] opcode_o,//номер инструкции
    output logic [OPERAND_SIZE-1:0] op1_o,
    output logic [OPERAND_SIZE-1:0] op2_o
    );
        logic [OPCODE_SIZE-1:0] opcode;
        logic [OPERAND_SIZE-1:0] op1;
        logic [OPERAND_SIZE-1:0] op2;
        
        always_comb begin
            opcode = instr[OPCODE_SIZE-1:0];
            op1 = 0;
            op2 = 0;
            if(opcode <= 2'd1) begin
                op1 = instr[OPCODE_SIZE+OPERAND_SIZE-1:OPCODE_SIZE];
                op2 = instr[OPCODE_SIZE+OPERAND_SIZE+REG_SIZE-1:OPCODE_SIZE+OPERAND_SIZE];
            end
            else if (opcode <= 'd4) begin
                op1 = instr[OPCODE_SIZE+REG_SIZE-1:OPCODE_SIZE];
            end
            else if (opcode <= 'd23) begin
                op1 = instr[OPCODE_SIZE+REG_SIZE-1:OPCODE_SIZE];
                op2 = instr[OPCODE_SIZE+OPERAND_SIZE+REG_SIZE-1:OPCODE_SIZE+OPERAND_SIZE];
            end
            else if (opcode <= 'd27) begin
                op1 = instr[OPCODE_SIZE+OPERAND_SIZE-1:OPCODE_SIZE];
            end
            else begin
            end
        end
        
        logic valid;
        always @(posedge clk) begin
            opcode_o <= opcode;
            op1_o <= op1;
            op2_o <= op2;
            valid <= valid_i;  
        end
        assign valid_o = valid;
endmodule
