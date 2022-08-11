`include "define.v"

// thanks to kim
module instructionFetcher (
    input clk,
    input rst,
    input je,
    input [`instr_addr_bus] jmp,
    output reg ce,
    output reg [`instr_addr_bus] pc
);
    always @(posedge clk) begin
        if(rst == `ON)
            ce <= `OFF;
        else
            ce <= `ON;
        if(ce == `OFF)
            pc <= 32'h3000_0000;
        else begin
            if(je == `ON) pc <= jmp;
            else pc <= pc + 3'h4;
        end
    end
endmodule

module instructionMemory (
    input ce,
    input [`instr_addr_bus] addr,
    output reg [`instr_bus] instr
);
    reg [`instr_bus] instr_mem [4:0]; // 2 ^ 17 = 131072
    initial $readmemh("instr.txt",instr_mem);
    always @(*)	begin
        if(ce == `OFF)
            instr = {32{`OFF}};
        else
            instr = instr_mem[addr[18:2]]; // 16 - 0 + 1 = 17 => 2 ^ 17 expressions
    end
endmodule