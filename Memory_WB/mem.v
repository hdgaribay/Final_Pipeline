module data_memory (
    input  wire        clk,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    input  wire        memread, memwrite,
    output reg  [31:0] read_data
);
    reg [31:0] DMEM [0:255];
    integer i;

    initial begin
        read_data = 0;
        // initialize all to zero
        for (i = 0; i < 256; i = i + 1)
            DMEM[i] = 32'b0;
        $readmemb("data.mem", DMEM);
        for (i = 0; i < 6; i = i + 1)
            $display("\tDMEM[%0d] = %0d", i, DMEM[i]);
    end

    always @(*) begin
        if (memread)
            read_data = DMEM[addr];
        else
            read_data = 32'b0;
    end

    always @(posedge clk) begin
        if (memwrite)
            DMEM[addr] <= write_data;
    end
endmodule