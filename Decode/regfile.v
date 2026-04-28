module regfile (
    input  wire        clk,
    input  wire        rst,
    input  wire        regwrite,
    input  wire [4:0]  rs,
    input  wire [4:0]  rt,
    input  wire [4:0]  rd,
    input  wire [31:0] writedata,
    output wire [31:0] A_readdat1,
    output wire [31:0] B_readdat2
);
    reg [31:0] REG [0:31];
    initial begin
        REG[0] = 'h002300AA;  
        REG[1] = 'h10654321;
        REG[2] = 'h00100022;
        REG[3] = 'h8C123456;
        REG[4] = 'h8F123456;
        REG[5] = 'hAD654321;
        REG[6] = 'h60000066;
        REG[7] = 'h13012345;
        REG[8] = 'hAC654321;
        REG[9] = 'h12012345;
    end
    assign A_readdat1 = (rs == 5'd0)                             ? 32'd0     :
                        (regwrite && (rs == rd) && (rd != 5'd0)) ? writedata :
                                                                   REG[rs];

    assign B_readdat2 = (rt == 5'd0)                             ? 32'd0     :
                        (regwrite && (rt == rd) && (rd != 5'd0)) ? writedata :
                                                                   REG[rt];
    always @(posedge clk) begin
        if (!rst && regwrite && (rd != 5'd0)) begin
            REG[rd] <= writedata;
        end
    end
endmodule