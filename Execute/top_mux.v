module top_mux(
    output wire [31:0] y,
    input wire [31:0] a,   
    input wire [31:0] b,   
    input wire alusrc
);
    assign y = alusrc ? a : b;
endmodule