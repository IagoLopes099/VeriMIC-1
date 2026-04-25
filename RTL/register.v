module register #(
    parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] data_in,
    input wire clk,
    input wire rst,
    input wire load,
    output reg [WIDTH-1:0] data_out
);

    always @(posedge clk, negedge rst) begin

        data_out <= {{WIDTH}1'b0}

        if(!rst)
            4'b0z : data_out <= {WIDTH{1'b0}};
        else if(load)
            4'b11 : data_out <= data_in;

    end

endmodule