module forwarding_unit (
    input  wire        ex_mem_regwrite,
    input  wire [4:0]  ex_mem_write_reg,
    input  wire        mem_wb_regwrite,
    input  wire [4:0]  mem_wb_write_reg,
    input  wire [4:0]  id_ex_rs,
    input  wire [4:0]  id_ex_rt,
    output reg  [1:0]  forward_a,
    output reg  [1:0]  forward_b
);

    always @* begin
        // Default: no forwarding, use ID/EX latch values
        forward_a = 2'b00;
        forward_b = 2'b00;

        // EX/MEM forwarding for operand A (rs)
        if (ex_mem_regwrite && (ex_mem_write_reg != 5'd0) &&
            (ex_mem_write_reg == id_ex_rs))
            forward_a = 2'b10;
        // MEM/WB forwarding for operand A (only if not already forwarded from EX/MEM)
        else if (mem_wb_regwrite && (mem_wb_write_reg != 5'd0) &&
                 (mem_wb_write_reg == id_ex_rs))
            forward_a = 2'b01;

        // Same logic for operand B (rt)
        if (ex_mem_regwrite && (ex_mem_write_reg != 5'd0) &&
            (ex_mem_write_reg == id_ex_rt))
            forward_b = 2'b10;
        else if (mem_wb_regwrite && (mem_wb_write_reg != 5'd0) &&
                 (mem_wb_write_reg == id_ex_rt))
            forward_b = 2'b01;
    end
endmodule