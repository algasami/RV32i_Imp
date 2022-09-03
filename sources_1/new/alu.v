`include "define.v"

`define sizebus 31:0
`define opbus 6:0
`define f7bus 16:10
`define f3bus 9:7
module alu(input [`sizebus] a, input [`sizebus] b, input [16:0] op,output reg[`sizebus] y);

    wire [`sizebus] addResult;  assign addResult = a + b;
    wire [`sizebus] subResult;  assign subResult = a - b;
    wire [`sizebus] ultResult;  assign ultResult = (a < b) ? 32'd1 : 0;
    wire [`sizebus] sltResult;  assign sltResult = ($signed(a) < $signed(b)) ? 32'd1 : 0;
    wire [`sizebus] xorResult;  assign xorResult = a ^ b;
    wire [`sizebus] orResult;   assign orResult = a | b;
    wire [`sizebus] andResult;  assign andResult = a & b;
    always@(*)begin
        case(op[`opbus])
            `RTYPE: begin
                case(op[`f3bus])
                    3'b000: begin
                        case(op[`f7bus])
                            7'b0000000: y = addResult;
                            7'b0100000: y = subResult;
                        endcase
                    end
                    3'b001: y = a << b[4:0];
                    3'b010: y = sltResult;
                    3'b011: y = ultResult;
                    3'b100: y = xorResult;
                    3'b101: begin
                        case(op[`f7bus])
                            7'b0000000: y = a >> b;
                            7'b0100000: y = $signed(a) >>> b;
                        endcase
                    end
                    3'b110: y = orResult;
                    3'b111: y = andResult;
                endcase
            end
            `ITYPE: begin
                case(op[`f3bus])
                    3'b000: y = addResult;
                    3'b010: y = sltResult;
                    3'b011: y = ultResult;
                    3'b100: y = xorResult;
                    3'b110: y = orResult;
                    3'b111: y = andResult;
                endcase
            end
            `STYPE: begin
                case (op[`f3bus])
                    3'b000: y[a +: 8] = b[7:0]; // byte
                    3'b001: y[a +: 16] = b[15:0]; // half
                    3'b010: y[a +: 32] = b[31:0]; // word
                    // 3'b011: y[63:0] = b[63:0]; // dword
                endcase
            end
            `UJTYPE: begin
                y = a + 32'h4;
            end
            `BTYPE: begin
                y = 0;
                case (op[`f3bus])
                    3'b000: if(a == b) y = 1;                   //0
                    3'b001: if(a != b) y = 1;                   //1
                    3'b100: if($signed(a) < $signed(b)) y = 1;  //4
                    3'b101: if($signed(a) >= $signed(b)) y = 1; //5
                    3'b110: if(a < b) y = 1;                    //6
                    3'b111: if(a >= b) y = 1;                   //7
                endcase
            end
            default: y = addResult;
        endcase
    end
endmodule
