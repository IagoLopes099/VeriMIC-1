module shifter #(
    parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] out_alu,
    input wire sll8, sra1,
    output reg [WIDTH-1:0] shifter_out
);

    always @(sll8, sra1) begin
        sll8 = 1'b0;
        sra1 = 1'b0;

        casez ({sll8,sra1})
            2'b1z : shifter_out =  out_alu << 8;
            2'b01 : shifter_out = out_alu >>> 1;
            default : shifter_out = out_alu;
        endcase

    end

endmodule