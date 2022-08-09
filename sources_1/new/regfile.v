`define regbus 31:0
`define addrbus 4:0
`define reglen 32
`define regcomb 5
`define on 1'b1
`define off 1'b0
`define regoff {`regcomb{`off}}
`define offword {32{`off}}


module regfile
    (
    input clk,
    input rst,

    input writepass,
    input [`addrbus] waddr,
    input [`regbus] wdata,

    input rs1pass,
    input [`addrbus] rs1addr,

    input rs2pass,
    input [`addrbus] rs2addr,

    output reg[`regbus] rs1,
    output reg[`regbus] rs2
    );
    reg[`regbus] regs[`reglen - 1:0]; // regs[n][0] = 1'b0
    always @(posedge clk) begin
        if (rst == `off) begin
            if (writepass == `on && waddr != `regoff)
                regs[waddr] <= wdata;
        end
    end

    always@(*) begin
        if(rs1pass == `on) begin
            if(rs1addr == `regoff) rs1 = `offword;
            else if(rs2addr == waddr && writepass == `on)
                rs1 = wdata;
            else begin
                if(regs[rs1addr][0] === 1'bX) rs1 = 0;
                else rs1 = regs[rs1addr];
            end
        end
        else rs1 = `offword;
    end

    always@(*) begin
        if(rs2pass == `on) begin
            if(rs2addr == `regoff) rs2 = `offword;
            else if(rs2addr == waddr && writepass == `on)
                rs2 = wdata;
            else begin
                if(regs[rs2addr][0] === 1'bX) rs2 = 0;
                else rs2 = regs[rs2addr];
            end
        end
        else rs2 = `offword;
    end

endmodule