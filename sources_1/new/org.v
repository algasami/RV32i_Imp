`include "define.v"

module org(
    input clk,
    input reset);
    wire    [31:0] INSTR;
    wire    [4:0] RS1_ADDR, RS2_ADDR,W_ADDR;
    wire    [16:0] OPCODE;
    wire    [31:0] IMM;
    wire    [31:0] RS1, RS2, WCHAR;
    wire    RS1_ENABLE;
    wire    RS2_ENABLE;
    wire    W_ENABLE;
    wire    IMM_ENABLE;
    wire    UJ_ENABLE;
    wire    JMP_ENABLE;
    wire    BRANCH_ENABLE;
    wire    CHIP_ENABLE;
    reg     [31:0] A,B;
    wire    [`instr_addr_bus] PC;
    reg     [`instr_addr_bus] JMP;

    always@(*) begin
        if(RS1_ENABLE == `ON) A = RS1;
        else begin
            // * Reserved for future mux
            if(UJ_ENABLE == `ON) A = PC;
        end
    end

    always@(*) begin
        if(RS2_ENABLE == `ON) B = RS2;
        else begin
            // * Reserved for future mux
            if(IMM_ENABLE == `ON) B = IMM;
        end
    end


    always@(*) begin
        if(UJ_ENABLE == `ON && JMP_ENABLE == `ON)
            JMP = WCHAR;
        else if(BRANCH_ENABLE == `ON && JMP_ENABLE == `ON && WCHAR != 0)
            JMP = PC + IMM;
        else
            JMP = {32{`OFF}};
    end

    instructionFetcher if_mod(
        .clk(clk),
        .rst(reset),
        .je(JMP_ENABLE),
        .jmp(JMP),
        .ce(CHIP_ENABLE),
        .pc(PC)
    );
    instructionMemory im_mod(
        .ce(CHIP_ENABLE),
        .addr(PC),
        .instr(INSTR)
    );

    decoder d_mod(
        .clk(clk),
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
        .imm_enable(IMM_ENABLE),
        .uj_enable(UJ_ENABLE),
        .jmp_enable(JMP_ENABLE),
        .branch_enable(BRANCH_ENABLE)
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
        .a(A),
        .b(B),
        .op(OPCODE),
        .y(WCHAR)
    );
endmodule
