package headers;

//decode
localparam INSTR_SIZE = 16;
localparam OPCODE_SIZE = 5;
localparam OPERAND_SIZE = 7;
localparam REG_SIZE = 4;
//execute
localparam DATA_SIZE = 16;
localparam REG_COUNT = 16; 
localparam MEM_SIZE = 128;
localparam ADDR_WIDTH = $clog2(MEM_SIZE);


endpackage
