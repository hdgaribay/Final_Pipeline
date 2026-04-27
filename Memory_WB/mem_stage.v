module mem_stage(                                  
    input  wire        clk,                        
    input  wire [1:0]  wb_ctlout,                   // [1]=RegWrite, [0]=MemtoReg
    input  wire        branch, memread, memwrite,
    input  wire        zero,
    input  wire [31:0] alu_result, rdata2out,
    input  wire [4:0]  five_bit_muxout,
    output wire        MEM_PCSrc,                
    output wire        MEM_WB_regwrite,            
    output wire [31:0] write_data_out,              
    output wire [4:0]  mem_write_reg                
);
 
    // internal wires
    wire [31:0] read_data_in;                       
    wire [31:0] latched_read_data, latched_alu;     
    wire        latched_memtoreg;                   
 
    // AND gate: branch & zero: PCSrc
    AND AND_4 (
        .membranch(branch),
        .zero     (zero),
        .PCSrc    (MEM_PCSrc)
    );
 
    // Data memory
    data_memory data_memory4 (
        .clk       (clk),                         
        .addr      (alu_result),
        .write_data(rdata2out),
        .memwrite  (memwrite),
        .memread   (memread),
        .read_data (read_data_in)
    );
 
    // MEM/WB pipeline latch
    mem_wb mem_wb4 (
        .clk           (clk),                       
        .control_wb_in (wb_ctlout),
        .read_data_in  (read_data_in),
        .alu_result_in (alu_result),
        .write_reg_in  (five_bit_muxout),
        .regwrite      (MEM_WB_regwrite),
        .memtoreg      (latched_memtoreg),
        .read_data     (latched_read_data),
        .mem_alu_result(latched_alu),
        .mem_write_reg (mem_write_reg)
    );
 
 
    wb_mux wb_mux_i(
        .read_data     (latched_read_data),
        .mem_alu_result(latched_alu),
        .sel           (latched_memtoreg),
        .writedata     (write_data_out)
    );
 
endmodule