module executeTB;
    reg [1:0] wb_ctl;
    reg[2:0]  m_ctl;
    reg regdst, alusrc;
    reg [1:0] aluop;
    reg [31:0] npcout, rdata1, rdata2, s_extendout;
    reg [4:0] instrout_2016, instrout_1511;

    wire [1:0] wb_ctlout;
    wire branch, memread, memwrite, zero;
    wire [31:0] EX_MEM_NPC, alu_result, rdata2out;
    wire [4:0] five_bit_muxout;

    EXECUTE uut (
        .wb_ctl(wb_ctl),
        .m_ctl(m_ctl),
        .regdst(regdst),
        .alusrc(alusrc),
        .aluop(aluop),
        .npcout(npcout),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .s_extendout(s_extendout),
        .instrout_2016(instrout_2016),
        .instrout_1511(instrout_1511),
        .wb_ctlout(wb_ctlout),
        .branch(branch),
        .memread(memread),
        .memwrite(memwrite),
        .EX_MEM_NPC(EX_MEM_NPC),
        .zero(zero),
        .alu_result(alu_result),
        .rdata2out(rdata2out),
        .five_bit_muxout(five_bit_muxout)
    );

    initial begin
        $dumpfile("executeTB.vcd");
        $dumpvars(0, executeTB);  

        wb_ctl = 2'b10; m_ctl = 3'b001; 
        npcout = 32'd100; rdata1 = 32'd20; rdata2 = 32'd20; s_extendout = 32'd32;  // next pc || data in rs || data in rt || add instruction
        instrout_2016 = 5'd5; instrout_1511 = 5'd10; // rt and rd registers
        aluop = 2'b10; alusrc = 0; regdst = 1; // R type || use rt || rd as destination register
        #15;

        alusrc = 0; regdst = 0; // choose value stored in rt || select rt (instrout_2016) as destination register
        s_extendout = 32'd8; // sign extended immediate (not used for funct as i type instruction)
        aluop = 2'b01; //beq
        #15;

        $dumpflush;  
        $finish;      
    end
endmodule