module alu(input [31:0] a, input [31:0] b, input [2:0] op,output reg[31:0] y);
    always@(*)begin
        case(op)
            3'b000: y = a + b;
            3'b001: y = a - b;
            3'b010: y = a & b;
            3'b011: y = a | b;
            3'b100: y = a ^ b;
            default: y = 0;
        endcase
    end
endmodule