`timescale 1ns/1ps

module fetch_tb;

    reg clk;
    reg rst;
    reg ex_mem_pc_src;
    reg [31:0] ex_mem_npc;
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    fetch dut (
        .clk(clk),
        .rst(rst),
        .ex_mem_pc_src(ex_mem_pc_src),
        .ex_mem_npc(ex_mem_npc),
        .if_id_instr(if_id_instr),
        .if_id_npc(if_id_npc)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        $dumpfile("fetch_tb.vcd");
        $dumpvars(0, fetch_tb);

        rst = 1; // assert reset
        ex_mem_pc_src = 0;
        ex_mem_npc = 32'd0;

        #12;
        rst = 0; // reset off 

        #40;

        ex_mem_pc_src = 1; // PCSrc high
        ex_mem_npc = 32'd4; // branch address
        #10;

        ex_mem_pc_src = 0; // PCSrc Low
        #40;

        $finish;
    end

endmodule