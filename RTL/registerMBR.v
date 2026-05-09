module registerMBR #(
    parameter WORD = 8,
    parameter WIDTH = 32
)(
    input wire [WORD-1:0] data_in,
    input wire clk,
    input wire load, 
    input wire rst,
    output reg [WIDTH-1:0] data_out1 , data_out2
);

    always @(posedge clk) begin

        casez({!rst,load})
            2'b1z : begin
                data_out1 <= {WIDTH{1'b0}};
                data_out2 <= {WIDTH{1'b0}}; 
            end // fills all with 0s

            2'b01 : data_out1 <= {{WIDTH-WORD{1'b0}},data_in}; // fills the remaining bits with 0s
            2'b00 : data_out2 <= {{WIDTH-WORD{data_in[WORD-1]}},data_in}; // fills the remaining bits with the MSB from word
        endcase

    end

endmodule