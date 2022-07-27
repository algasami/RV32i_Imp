module decoder
    #(
        localparam rtype = 7'b0110011,
        localparam itype = 7'b0010011,
        localparam stype = 7'b0100011,
        localparam btype = 7'b1100011,
        localparam utype_lui = 7'b0110111,
        localparam utype_auipc = 7'b0010111,
        localparam ujtype = 7'b1101111,
        localparam null3 = {3{1'b0}},
        localparam null7 = {7{1'b0}}
    )
    (
    input [31:0] instr, // instruction

    output reg [16:0] opcode, // func7 + func3 + opcode
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [31:0] imm
    );


    always @(*) begin
        case(instr[6:0])
            rtype: begin // R type
                opcode = {instr[31:25], instr[14:12], instr[6:0]}; // pass to ALU
                rd = instr[11:7];
                rs1 = instr[19:15];
                rs2 = instr[24:20];
            end

            itype: begin // I type
                case(instr[14:12])
                        3'b001, 3'b101: begin
                            /*
                             * SRLI, SRAI, SLLI
                             * |imm[11:5]    imm[4:0]    rs1|    func3    rd    opcode    inst
                             * |f7           shamt       rs1|    001,101  rd    0010011   SLLI
                            */
                            opcode = {null7, instr[14:12], instr[6:0]};
                            rd = instr[11:7];
                            rs1 = instr[19:15];
                            imm[11:0] = {instr[31:25],instr[24:20]};
                        end
                    default: begin
                        opcode = {null7, instr[14:12], instr[6:0]};
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                        imm[11:0] = instr[31:20];
                    end
                endcase
            end

            ujtype: begin // UJ type
                opcode = {null7, null3, instr[6:0]};
                // * imm[20|10:1|11|19:12]
                imm[19:12] = instr[19:12];
                imm[11] = instr[20];
                imm[10:1] = instr[30:21];
                imm[20] = instr[31];
                rd = instr[11:7];
            end

            utype_auipc,utype_lui: begin // UTYPE type
                opcode = {null7, null3, instr[6:0]};
                imm[31:12] = instr[31:12];
                rd = instr[11:7];
            end
        endcase
    end
endmodule