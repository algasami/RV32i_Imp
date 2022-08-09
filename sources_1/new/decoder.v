`include "define.v"

module decoder
    (
    input [31:0] instr, // instruction

    output reg [16:0] opcode,
    output reg [4:0] waddr,
    output reg [4:0] rs1addr,
    output reg [4:0] rs2addr,
    output reg [31:0] imm,
    output reg rs1_enable,
    output reg rs2_enable,
    output reg w_enable,
    output reg imm_enable
    );


    always @(*) begin
        case(instr[6:0])
            `RTYPE: begin // R type
                rs1addr = instr[19:15];
                rs2addr = instr[24:20];
                waddr = instr[11:7];
                rs1_enable = `ON;
                rs2_enable = `ON;
                w_enable = `ON;
                imm_enable = `OFF;
                opcode = {instr[31:25],instr[14:12],instr[6:0]};
            end

            `ITYPE: begin // I type
                case(instr[14:12])
                    3'b001: begin // SLLI
                        /*
                            * SRLI, SRAI, SLLI
                            * |imm[11:5]    imm[4:0]    rs1addr|    func3    waddr    opcode    inst
                            * |f7           shamt       rs1addr|    001,101  waddr    0010011   SLLI
                        */

                        // TODO: MAKE ME SLLI
                    end
                    3'b101: begin // SRLI or SRAI
                        case(instr[31:25])
                            7'b0000000: begin
                                // TODO: MAKE ME SRLI
                            end
                            7'b0100000: begin
                                // TODO: MAKE ME SRAI
                            end
                        endcase
                    end

                    3'b000,3'b010,3'b011,3'b100,3'b110,3'b111: begin
                        imm[31:0] = {32{`OFF}};
                        imm[11:0] = instr[31:20];
                        rs1addr = instr[19:15];
                        waddr = instr[11:7];
                        imm_enable = `ON;
                        rs1_enable = `ON;
                        rs2_enable = `OFF;
                        w_enable = `ON;
                        opcode = {`NULL7,instr[14:12],instr[6:0]};
                    end
                endcase
            end

            `STYPE: begin
                // TODO: FINISH ME
                rs1addr = 0;
                waddr = instr[19:15] + {instr[31:25],instr[11:7]};
                rs2addr = instr[24:20];
                imm_enable = `OFF;
                rs1_enable = `ON;
                rs2_enable = `ON;
                w_enable = `ON;
                opcode = {`NULL7, instr[14:12], instr[6:0]};
            end

            `UJTYPE: begin // UJ type
                // * imm[20|10:1|11|19:12]
                imm[19:12] = instr[19:12];
                imm[11] = instr[20];
                imm[10:1] = instr[30:21];
                imm[20] = instr[31];
                waddr = instr[11:7];
            end

            `UTYPE_AUIPC,`UTYPE_LUI: begin // UTYPE type
                imm[31:12] = instr[31:12];
                waddr = instr[11:7];
            end
        endcase
    end
endmodule