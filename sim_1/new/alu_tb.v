/**
 * Original Author: Willwho
*/
`timescale 1ns / 1ps


module alu_tb();
    reg [16:0] full_op; // func7(7)+func3(3)+op(7)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    alu cpu(in1, in2,full_op, out);

    initial begin
    full_op = 17'b0; in1 = 32'b0; in2 = 32'b0;

    #1 full_op = 17'b00000000000110011; in1 = 32'hff; in2=32'hff00; // add ff + ff00 = ffff
    #1 full_op = 17'b01000000000110011; in1 = 32'hff; in2=32'hcc; // sub ff - cc = 33
    #1 full_op = 17'b01000000000010011; in1 = 32'hff; in2=32'hcc; // subi should be error
    #1 full_op = 17'b00000000010110011; in1 = 32'hff; in2=32'd4; // sll ff << 4 = ff0
    #1 full_op = 17'b00000000100110011; in1 = 32'hff; in2=32'hf; // slt ff < f = 0
    #1 full_op = 17'b00000000100110011; in1 = 32'hff; in2=32'hfff; // slt ff < fff = 1
    #1 full_op = 17'b00000000100110011; in1 = 32'd1; in2=-32'd1; // slt 1 < -1 = 0
    #1 full_op = 17'b00000000100110011; in1 = -32'd10; in2=-32'd1; // slt -10 < -1 = 1
    #1 full_op = 17'b00000000110110011; in1 = -32'd1; in2=32'd1; // sltu -1(ffffffff) < 1(00000001) = 0
    #1 full_op = 17'b00000000110110011; in1 = -32'd10; in2=-32'd1; // sltu -10(fffffff6) < -1(ffffffff) = 1
    #1 full_op = 17'b00000001000110011; in1 = 32'hff00f0f0; in2=32'h00ffff00; // xor ff00f0f0 ^ 00ffff00 = 0000f0f0
    #1 full_op = 17'b00000001010110011; in1 = 32'hff00f0f0; in2=32'd8; // srl ff00ffff >> 8 = 00ff00f0
    #1 full_op = 17'b01000001010110011; in1 = 32'hff00f0f0; in2=32'd8; // sra ff00ffff >> 8 = ffff00f0
    #1 full_op = 17'b01000001010110011; in1 = 32'hff00f0f0; in2=32'd16; // sra ff00ffff >> 16 = ffffff00
    #1 full_op = 17'b00000001100110011; in1 = 32'h00ff00ff; in2=32'hff0000ff; // or 00ff00ff | ff0000ff = ffff00ff
    #1 full_op = 17'b00000001110110011; in1 = 32'h00ff00ff; in2=32'hff0000ff; // and 00ff00ff & ff0000ff = 000000ff
    #1 $stop;
    end

endmodule