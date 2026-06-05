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

        if (!rst) begin // fills all with 0s
            data_out1 <= {WIDTH{1'b0}};
            data_out2 <= {WIDTH{1'b0}}; 
        end
        else if (load) begin // put input properly into the ouput 
            data_out1 <= {{WIDTH-WORD{1'b0}},data_in}; // fills the remaining bits with 0s
            data_out2 <= {{WIDTH-WORD{data_in[WORD-1]}},data_in}; // fills the remaining bits with the MSB from word
        end
        else begin// hold the old value
            data_out1 <= data_out1;
            data_out2 <= data_out2;
        end

    end

endmodule