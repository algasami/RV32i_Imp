`timescale 1ns / 1ps



module org_tb
#(

localparam STORE_0      = 32'b000000000110_00000_000_00001_0010011,
localparam STORE_1      = 32'b000000000111_00000_000_00010_0010011,
localparam ADD_S_3      = 32'b0100000_00010_00001_000_00011_0110011,
localparam STORE_S_4    = 32'b0000000_00011_00100_010_00000_0100011
)();
    reg [31:0] instr;
    wire [31:0] result;
    reg clk = 1'b0;
    reg reset = 1'b0;

    initial begin

        instr = STORE_0;
        $display("Starting org_tb");
        forever begin
            #10 clk = ~clk; // 20 units per cycle
        end

    end

    initial begin
        #40 instr = STORE_0;
        #40 instr = STORE_1;
        #40 instr = ADD_S_3;
        #40 instr = STORE_S_4;
        #40 $stop;
    end

    org mock(clk,reset,instr,result);
endmodule
