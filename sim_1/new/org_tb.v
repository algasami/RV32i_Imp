`timescale 1ns / 1ps



module org_tb();
    reg clk = 1'b0;
    reg reset = 1'b1;

    initial begin
        $display("Starting org_tb");
        forever begin
            #10 clk = ~clk; // 20 units per cycle
        end

    end

    initial begin
        #80 reset = 1'b0;
        #200 $stop;
    end

    org mock(clk,reset);
endmodule
