module ifIdLatch(
    input wire clk,
    input wire rst,
    input wire [31:0] pc_in,
    input wire [31:0] instr_in,
    output reg [31:0] pc_out,
    output reg [31:0] instr_out
);
    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 32'b0; 
            instr_out <= 32'b0; 
        end else begin
            pc_out <= pc_in; // pass through pc+4
            instr_out <= instr_in; //pass through instr. from instr. mem
        end
    end
endmodule