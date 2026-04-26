module instrMem (
    input  wire [31:0] addr,
    output wire  [31:0] data
);
    reg [31:0] mem [0:9]; // array of 10 words, each 32 bits wide

    wire [31:0] word_index; // wire to index into mem
    assign word_index = addr[31:2];  // divide by 4 to obtain correct index

    initial begin
        mem[0] = 32'hA00000AA; 
        mem[1] = 32'h10000011; 
        mem[2] = 32'h20000022; 
        mem[3] = 32'h30000033;
        mem[4] = 32'h40000044; 
        mem[5] = 32'h50000055; 
        mem[6] = 32'h60000066; 
        mem[7] = 32'h70000077; 
        mem[8] = 32'h80000088; 
        mem[9] = 32'h90000099; 
    end

assign data = mem[addr[31:2]]; //read instruction using word index (byte address/4)

endmodule