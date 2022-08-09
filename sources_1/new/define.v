`define ON          1'b1
`define OFF         1'b0
`define NULL3       {3{`OFF}}
`define NULL7       {7{`OFF}}
`define ADD_OP      0
`define SUB_OP      1
`define AND_OP      2
`define OR_OP       3
`define XOR_OP      4
`define SHL_OP      5
`define SHR_OP      6
`define LT_OP       7
`define SGT_OP      8


// DECODER

`define RTYPE           7'b0110011
`define ITYPE           7'b0010011
`define STYPE           7'b0100011
`define BTYPE           7'b1100011
`define UTYPE_LUI       7'b0110111
`define UTYPE_AUIPC     7'b0010111
`define UJTYPE          7'b1101111

// IF/IM/PC

`define instr_addr_bus  31:0
`define instr_bus       31:0