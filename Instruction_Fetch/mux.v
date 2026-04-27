module mux(
    input wire [31:0] a_true,  
    input wire [31:0] b_false, 
    input wire sel,           
    output wire [31:0] y       
);
    assign y = (sel) ? a_true : b_false; // if PCSrc=1 choose ex_mem_npc, else choose next_pc

endmodule