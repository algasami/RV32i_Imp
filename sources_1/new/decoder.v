module decoder(
    input [31:0] instr, // instruction

    output reg [16:0] opcode, // opcode + function3 + function7
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [31:0] imm
    );


    always @(*) begin
        case(instr[6:0])
            7'b0110011: begin // R type
                opcode = {instr[31:25], instr[14:12], instr[6:0]}; // pass to ALU
                rd = instr[11:7];
                rs1 = instr[19:25];
                rs2 = instr[24:20];
            end

            7'b0010011: begin // I type
                case(instr[14:12]) // srli, srai or slli
                        3'b001, 3'b101: begin
                            opcode = {7'b0000000, instr[14:12], instr[6:0]}; // pass to ALU
                            rd = instr[11:7];
                            rs1 = instr[19:15];
                            imm[4:0] = instr[24:20];
                        end
                    default: begin
                        opcode = {7'b0000000, instr[14:12], instr[6:0]}; // pass to ALU
                        rd = instr[11:7];
                        rs1 = instr[19:15];
                        imm[11:0] = instr[31:20];
                    end
                endcase
            end

            7'b1101111: begin // J type
                opcode = {7'b0000000, 3'b000, instr[6:0]}; // pass to ALU
                imm[19:12] = instr[19:12];
                imm[11] = instr[20];
                imm[10:1] = instr[30:21];
                imm[20] = instr[31];
                rd = instr[11:7];
            end
        endcase // opcode
    end
endmodule