module shifter #(
    parameter WIDTH = 32
)( 
    input wire clk,
    input wire [WIDTH-1:0] shifter_in,
    input wire sll8, sra1,
    output reg [WIDTH-1:0] shifter_out
);

    always @(posedge clk) begin

        casez ({sll8,sra1})
            2'b1z : shifter_out <=  shifter_in << 8;
            2'b01 : shifter_out <= shifter_in >>> 1;
            default : shifter_out <= shifter_in;
        endcase

    end

endmodule