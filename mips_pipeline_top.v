module mips_pipeline_top (
    input  wire clk
);

    wire rst = 1'b0;

    // IF/ID
    wire [31:0] if_id_instr;
    wire [31:0] if_id_npc;

    // ID/EX
    wire [1:0]  id_ex_wb;       // {RegWrite, MemtoReg}
    wire [2:0]  id_ex_mem;      // {Branch, MemRead, MemWrite}
    wire [3:0]  id_ex_execute;  // {RegDst, ALUOp[1], ALUOp[0], ALUSrc}
    wire [31:0] id_ex_npc;
    wire [31:0] id_ex_readdat1;
    wire [31:0] id_ex_readdat2;
    wire [31:0] id_ex_sign_ext;
    wire [4:0]  id_ex_instr_2016;     // rt
    wire [4:0]  id_ex_instr_1511;     // rd
    wire [4:0]  id_ex_instr_2521;     // rs

    // EX/MEM
    wire [1:0]  ex_mem_wb;
    wire        ex_mem_branch;
    wire        ex_mem_memread;
    wire        ex_mem_memwrite;
    wire [31:0] ex_mem_npc;
    wire        ex_mem_zero;
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rdata2;
    wire [4:0]  ex_mem_write_reg;

    // MEM/WB feedback
    wire        mem_pcsrc;
    wire        wb_reg_write;
    wire [31:0] wb_write_data;
    wire [4:0]  wb_write_reg;

    
    wire        stall_pc;       // 1 = allow PC update, 0 = freeze
    wire        stall_ifid;     // 1 = allow IF/ID update, 0 = freeze

    
    
    
    fetch IF_stage (
        .clk           (clk),
        .rst           (rst),
        .pc_write_en   (stall_pc),      
        .ifid_write_en (stall_ifid),    
        .ex_mem_pc_src (mem_pcsrc),
        .ex_mem_npc    (ex_mem_npc),
        .if_id_instr   (if_id_instr),
        .if_id_npc     (if_id_npc)
    );

    
    
    
    decode ID_stage (
        .clk                    (clk),
        .rst                    (rst),
        // write-back loop
        .wb_reg_write           (wb_reg_write),
        .wb_write_reg_location  (wb_write_reg),
        .mem_wb_write_data      (wb_write_data),
        // from IF/ID
        .if_id_instr            (if_id_instr),
        .if_id_npc              (if_id_npc),
        // hazard inputs (from ID/EX latch)
        .id_ex_memread          (id_ex_mem[1]),         
        .id_ex_rt_for_haz       (id_ex_instr_2016),    
        // hazard outputs (back up to fetch)
        .stall_pc               (stall_pc),            
        .stall_ifid             (stall_ifid),          
        // ID/EX latch outputs
        .id_ex_wb               (id_ex_wb),
        .id_ex_mem              (id_ex_mem),
        .id_ex_execute          (id_ex_execute),
        .id_ex_npc              (id_ex_npc),
        .id_ex_readdat1         (id_ex_readdat1),
        .id_ex_readdat2         (id_ex_readdat2),
        .id_ex_sign_ext         (id_ex_sign_ext),
        .id_ex_instr_bits_20_16 (id_ex_instr_2016),
        .id_ex_instr_bits_15_11 (id_ex_instr_1511),
        .id_ex_instr_bits_25_21 (id_ex_instr_2521)     
    );


    EXECUTE EX_stage (
        // controls
        .clk                 (clk),
        .wb_ctl              (id_ex_wb),
        .m_ctl               (id_ex_mem),
        .regdst              (id_ex_execute[3]),
        .alusrc              (id_ex_execute[0]),
        .aluop               (id_ex_execute[2:1]),
        // datapath in
        .npcout              (id_ex_npc),
        .rdata1              (id_ex_readdat1),
        .rdata2              (id_ex_readdat2),
        .s_extendout         (id_ex_sign_ext),
        .instrout_2016       (id_ex_instr_2016),
        .instrout_1511       (id_ex_instr_1511),
        // forwarding inputs 
        .id_ex_rs            (id_ex_instr_2521),
        .ex_mem_regwrite_in  (ex_mem_wb[1]),       // RegWrite bit of WB ctl
        .ex_mem_write_reg_in (ex_mem_write_reg),
        .mem_wb_regwrite_in  (wb_reg_write),
        .mem_wb_write_reg_in (wb_write_reg),
        .mem_wb_write_data   (wb_write_data),
        // EX/MEM latch outputs
        .wb_ctlout           (ex_mem_wb),
        .branch              (ex_mem_branch),
        .memread             (ex_mem_memread),
        .memwrite            (ex_mem_memwrite),
        .EX_MEM_NPC          (ex_mem_npc),
        .zero                (ex_mem_zero),
        .alu_result          (ex_mem_alu_result),
        .rdata2out           (ex_mem_rdata2),
        .five_bit_muxout     (ex_mem_write_reg)
    );



    mem_stage MEM_WB_stage (
        .clk             (clk),
        .wb_ctlout       (ex_mem_wb),
        .branch          (ex_mem_branch),
        .memread         (ex_mem_memread),
        .memwrite        (ex_mem_memwrite),
        .zero            (ex_mem_zero),
        .alu_result      (ex_mem_alu_result),
        .rdata2out       (ex_mem_rdata2),
        .five_bit_muxout (ex_mem_write_reg),
        .MEM_PCSrc       (mem_pcsrc),
        .MEM_WB_regwrite (wb_reg_write),
        .write_data_out  (wb_write_data),
        .mem_write_reg   (wb_write_reg)
    );

endmodule