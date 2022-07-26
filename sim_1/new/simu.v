`timescale 1ns/1ns

module alu_tb;
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] op;
    wire [31:0] out;
    
    alu _alu(a, b, op, out);
    
    initial begin
        a = 32'h0; b = 32'h0; op = 3'h0;        // add
    end
    
    initial begin
        #1000 a = 32'h0; b = 32'h0; op = 3'h1;  // sub
        #1000 a = 32'h0; b = 32'h0; op = 3'h2;  // and
        #1000 a = 32'h0; b = 32'h0; op = 3'h3;  // or
        #1000 a = 32'h0; b = 32'h0; op = 3'h4;  // xor
    end
    
    always begin
        #1 a = a + 32'h1; b = b + 32'h1;
    end
    
    initial #5000 $stop;
    
endmodule