
module main_memory #(
    parameter WIDTH = 32,
    parameter WORD = 8,
    parameter MEM_FILE = "../Memory/main_memory.mem"
) (
    input wire clk,
    input wire read, write, fetch,

    input wire [WIDTH-1:0] pc,
    input wire [WIDTH-1:0] mar,
    input wire [WIDTH-1:0] mdr_in,

    output reg [WIDTH-1:0] mdr_out,
    output reg [WORD-1:0] mbr,

);
    // linear array of bytes 0 to 536870911
    wire [WORD-1:0] ram [0:((2**WIDTH)/WORD)-1];

    initial $readmemh(MEM_FILE, ram);

    wire [WIDTH-1:0] byte_addr;
    assign byte_addr = mar << 2;

    // little endian
    always @(posedge clk) begin
        if(read) begin
            mdr_out <= {ram[byte_addr],
                    ram[byte_addr + 1],
                    ram[byte_addr + 2],
                    ram[byte_addr + 3]};
        end

        if(write) begin
            ram[byte_addr]     <= mdr_in[31:24];
            ram[byte_addr + 1] <= mdr_in[23:16];
            ram[byte_addr + 2] <= mdr_in[15:8];
            ram[byte_addr + 3] <= mdr_in[7:0];
        end

        if(fetch) begin
            mbr <= ram[pc];
        end
    end

endmodule