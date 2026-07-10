module shifter #(
    parameter WIDTH = 32
)( 
    input wire clk,
    input wire signed [WIDTH-1:0] shifter_in,
    input wire sll8, sra1,
    output [WIDTH-1:0] shifter_out
);

    assign shifter_out =    (sll8) ? shifter_in << 8 : 
                            (sra1) ? shifter_in >>> 1 : shifter_in;

endmodule