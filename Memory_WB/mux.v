module mux(
input [31:0] read_data,
input [31:0] mem_alu_result,
input sel,
output [31:0] writedata
);
assign writedata = sel ? read_data : mem_alu_result;
endmodule