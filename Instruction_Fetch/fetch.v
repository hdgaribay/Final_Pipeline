module fetch (
    input  wire        clk,
    input  wire        rst,
    input  wire        ex_mem_pc_src,
    input  wire [31:0] ex_mem_npc,
    input  wire pc_write_en,
    input  wire ifid_write_en,
    output wire [31:0] if_id_instr,
    output wire [31:0] if_id_npc
);
    // internal wires
    wire [31:0] pc_out;
    wire [31:0] pc_mux;
    wire [31:0] next_pc;
    wire [31:0] instr_data;
    
    mux m0 (
        .y(pc_mux),
        .a_true(ex_mem_npc),
        .b_false(next_pc),
        .sel(ex_mem_pc_src)
    );

    pc pc0 (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_mux),
        .pc_out(pc_out),
        .write_en(pc_write_en)
    );

    incrementer in0 (
        .pc_in(pc_out),
        .pc_out(next_pc)
    );


    instrMem inMem0 (
        .addr(pc_out),
        .data(instr_data)
    );

    ifIdLatch ifIdLatch0 (
    .clk       (clk),
    .rst       (rst),
    .write_en  (ifid_write_en),
    .instr_in  (instr_data),
    .npc_in    (next_pc),
    .instr_out (if_id_instr),
    .npc_out   (if_id_npc)
);

endmodule