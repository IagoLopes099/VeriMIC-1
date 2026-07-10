module registerMBR #(
    parameter WORD = 8,
    parameter WIDTH = 32
)(
    input wire [WORD-1:0] data_in,
    input wire clk,
    input wire load, 
    input wire rst,
    output reg [WIDTH-1:0] MBR_out , MBRU_out
);

    always @(posedge clk) begin

        if (!rst) begin // fills all with 0s
            MBR_out <= {WIDTH{1'b0}};
            MBRU_out <= {WIDTH{1'b0}}; 
        end
        else if (load) begin // put input properly into the ouput 
            MBR_out <= {{WIDTH-WORD{data_in[WORD-1]}},data_in}; // fills the remaining bits with the MSB from word
            MBRU_out <= {{WIDTH-WORD{1'b0}},data_in}; // fills the remaining bits with 0s
        end
        else begin// hold the old value
            MBR_out <= MBR_out;
            MBRU_out <= MBRU_out;
        end

    end

endmodule