`include "define.v"

`define opbus 6:0
`define f7bus 16:10
`define f3bus 9:7
module alu(input [31:0] a, input [31:0] b, input [16:0] op,output reg[31:0] y);
    always@(*)begin
        case(op[`opbus]) // opcode
            `RTYPE: begin
                case(op[`f3bus])
                    3'b000: begin
                        case(op[`f7bus])
                            7'b0000000: y = a + b;
                            7'b0100000: y = a - b;
                        endcase
                    end
                    3'b001: y = a << (b[4:0]);
                    3'b010: y = $signed(a) < $signed(b);
                    3'b011: y = a < b;
                    3'b100: y = a ^ b;
                    3'b101: begin
                        case(op[`f7bus])
                            7'b0000000: y = a >> b;
                            7'b0100000: y = $signed(a) >>> b;
                        endcase
                    end
                    3'b110: y = a | b;
                    3'b111: y = a & b;
                endcase
            end
            `ITYPE: begin
                case(op[`f3bus])
                    3'b000: y = a + b;
                    3'b010: y = $signed(a) < $signed(b);
                    3'b011: y = a < b;
                    3'b100: y = a ^ b;
                    3'b110: y = a | b;
                    3'b111: y = a & b;
                endcase
            end
            default: y = 0;
        endcase
    end
endmodule

// `ADD_OP: y = a + b;
// `SUB_OP: y = a - b;
// `AND_OP: y = a & b;
// `OR_OP : y = a | b;
// `XOR_OP: y = a ^ b;
// `SHL_OP: y = a << b;
// `SHR_OP: y = a >> b;
// `LT_OP:  y = (a < b) ? 32'd1 : 32'd0;
// `SLT_OP:  y = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
// default: y = 0;
