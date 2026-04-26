module incrementer(
input wire [31:0] pc_in,
output wire [31:0] pc_out
);

assign pc_out = pc_in + 32'd4; // increment pc by 4 (byte addressed)
endmodule