
module control_store #(
    parameter MICROINSTRUCTION_WIDTH = 36,
    parameter MEM_FILE = "../Memory/microprogram.mem"
)(
    input clk,
    input [8:0] mpc,
    output reg [MICROINSTRUCTION_WIDTH-1:0] microinstruction
);

    // memory rom that will guard the microprogram in bits format
    logic [MICROINSTRUCTION_WIDTH-1:0] rom [0:511];  

    initial $readmemb(MEM_FILE, rom);

    always @(posedge clk) microinstruction <= rom[mpc];

endmodule