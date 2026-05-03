module ifIdLatch (
    input  wire        clk,
    input  wire        rst,
    input  wire        write_en,    
    input  wire [31:0] instr_in,
    input  wire [31:0] npc_in,
    output reg  [31:0] instr_out,
    output reg  [31:0] npc_out
);

initial begin
    instr_out = 32'h80000000;  // NOP
    npc_out = 32'd0;
end

always @(posedge clk) begin
    if (rst) begin
        instr_out <= 32'h80000000;
        npc_out <= 32'd0;
    end else if (write_en) begin
        instr_out <= instr_in;
        npc_out <= npc_in;
    end
end
endmodule