`timescale 1ns/1ps
module memoryTB();
    reg         clk;
    reg  [31:0] alu_result, rdata2out;
    reg  [4:0]  five_bit_muxout;
    reg  [1:0]  wb_ctlout;
    reg         memwrite, memread, branch, zero;

    wire        MEM_PCSrc, MEM_WB_regwrite;
    wire [31:0] write_data_out;
    wire [4:0]  mem_write_reg;

    mem_stage uut (
        .clk            (clk),
        .wb_ctlout      (wb_ctlout),
        .branch         (branch),
        .memread        (memread),
        .memwrite       (memwrite),
        .zero           (zero),
        .alu_result     (alu_result),
        .rdata2out      (rdata2out),
        .five_bit_muxout(five_bit_muxout),
        .MEM_PCSrc      (MEM_PCSrc),
        .MEM_WB_regwrite(MEM_WB_regwrite),
        .write_data_out (write_data_out),
        .mem_write_reg  (mem_write_reg)
    );

    // clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
    $dumpfile("mem.vcd");
    $dumpvars(0, memoryTB);
    end
    initial begin
        $display("time | op       | addr | rdata2 | write_data_out | PCSrc");

        // Memory Read from address 4 (DMEM[4] = 0x4) (LW)
        alu_result      = 32'h00000004; // memory address to read from
        rdata2out       = 32'h12345678; // data being written to memory 
        five_bit_muxout = 5'h02; 
        wb_ctlout       = 2'b11;       // RegWrite=1, MemtoReg=1 (use ReadData)
        memwrite        = 0; // write to datamem control signal
        memread         = 1; //read from datamem control signal
        branch          = 0; 
        zero            = 0;
        #20;
        $display("%4t | load     | %h | %h | %h | %b",
                 $time, alu_result, rdata2out, write_data_out, MEM_PCSrc);

        // Memory Write 0x12345678 to address 4 (SW)
        memwrite = 1; 
        memread  = 0;
        #20;
        memwrite = 0;

        // Read back to verify the write (LW)
        memread = 1;
        #20;
        $display("%4t | readback | %h | %h | %h | %b",
                 $time, alu_result, rdata2out, write_data_out, MEM_PCSrc);

        // Branch taken (branch & zero both high: PCSrc=1) 
        branch  = 1;
        zero    = 1;
        memread = 0;
        #20;
        $display("%4t | branch   | %h | %h | %h | %b",
                 $time, alu_result, rdata2out, write_data_out, MEM_PCSrc);


// Test 5: R-type writeback
alu_result      = 32'h0000002A;   // 42 — the ALU's arithmetic result
rdata2out       = 32'h00000000;   // irrelevant for R-types 
five_bit_muxout = 5'h02;          // destination register $2
wb_ctlout       = 2'b10;          // RegWrite=1, MemtoReg=0 
memwrite        = 0;
memread         = 0;
branch          = 0;
zero            = 0;
#20;

$display("%4t | R-type   | alu=%h | write_data_out=%h | PCSrc=%b",
         $time, alu_result, write_data_out, MEM_PCSrc);

        $finish;
    end
endmodule