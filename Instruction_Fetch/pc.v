module pc(
input wire clk,
input wire rst,
input wire [31:0] pc_in,
input  wire write_en,
output reg [31:0] pc_out
);

initial pc_out = 32'd0;   // start at address 0

always @(posedge clk) begin
    if (rst)
        pc_out <= 32'd0; //clear on async reset
    else if (write_en)
        pc_out <= pc_in; // pass pc value through to output
end
endmodule