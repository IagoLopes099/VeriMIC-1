module registerMBR #(
    parameter WORD = 8,
    parameter WIDTH = 32
)(
    input wire [WORD-1:0] data_in,
    input wire clk,
    input wire [1:0] load, 
    input wire rst,
    output reg [WIDTH-1:0] data_out1 , data_out2
);

    always @(posedge clk, negedge rst) begin

        casez({!rst,load})
            3'b1zz : data_out <= {{WDITH}1'b0}; // fills all with 0s
            3'b01z : data_out1 <= {{WIDTH-WORD}1'b0,data_in}; // fills the remaining bits with 0s
            3'b001 : data_out2 <= {{WIDTH-WORD}data_in[WORD-1],data_in}; // fills the remaining bits with the MSB from word
            default : data_out1 <= {{WIDTH-WORD}1'b0}; // keep the last result
        endcase

    end

endmodule