module instrMem (
    input  wire [31:0] addr,
    output wire  [31:0] data
);
    reg [31:0] mem [0:255]; // array of 23 words, each 32 bits wide

    integer i;
    initial begin
        for (i = 0; i<256;i=i+1)
            mem[i] = 32'h80000000;
        $readmemb("instr.mem",mem);
    end

assign data = mem[addr[31:2]]; //read instruction using word index (byte address/4)

endmodule