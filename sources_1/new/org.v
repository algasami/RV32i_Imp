`include "define.v"

module org(
    input clk,
    input reset,
    input [31:0] tb_instr,
    output [31:0] tb_result
);
    wire    [31:0] INSTR;
    wire    [4:0] RS1_ADDR, RS2_ADDR,W_ADDR;
    wire    [16:0] OPCODE;
    wire    [31:0] IMM;
    wire    [31:0] RS1, RS2, WCHAR;
    wire    RS1_ENABLE;
    wire    RS2_ENABLE;
    wire    W_ENABLE;
    wire    IMM_ENABLE;
    reg     [31:0] MUX_RESULT;

    assign INSTR = tb_instr;
    assign tb_result = WCHAR;

    always@(*) begin
        if(IMM_ENABLE == `ON)begin
            MUX_RESULT = IMM;
        end
        else begin
            MUX_RESULT = RS2;
        end
    end

    decoder d_mod(
        // input
        .instr(INSTR),
        // output
        .opcode(OPCODE),
        .waddr(W_ADDR),
        .rs1addr(RS1_ADDR),
        .rs2addr(RS2_ADDR),
        .imm(IMM),
        .rs1_enable(RS1_ENABLE),
        .rs2_enable(RS2_ENABLE),
        .w_enable(W_ENABLE),
        .imm_enable(IMM_ENABLE)
    );
    regfile reg_mod(
        .clk(clk),
        .rst(reset),

        .writepass(W_ENABLE),
        .rs1pass(RS1_ENABLE),
        .rs2pass(RS2_ENABLE),

        .waddr(W_ADDR),
        .wdata(WCHAR),

        .rs1addr(RS1_ADDR),
        .rs2addr(RS2_ADDR),

        .rs1(RS1),
        .rs2(RS2)
    );

    alu alu_mod(
        .a(RS1),
        .b(MUX_RESULT),
        .op(OPCODE),
        .y(WCHAR)
    );
endmodule
