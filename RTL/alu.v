module alu #(
    parameter WIDTH = 32
)(
    input wire inv_a, en_a, en_b, inc, carry_in,
    input wire [1:0] sel,
    input wire [WIDTH-1:0] in_a, in_b,
    output reg [WIDTH-1:0] alu_out,
    output reg carry_out, is_zero, is_neg
);

    reg [WIDTH:0] temporary_sum;    

    always @(*) begin : alu_logic // change later to perform signed operations
        carry_out = 1'b0;
        is_zero = 1'b0;
        is_neg = 1'b0;

        casez({inc, inv_a, en_b, en_a, sel[1], sel[0]}) 

            6'b0z11_00 : begin : A_OR_B
                alu_out = in_a | in_b;
            end

            6'b0z11_01 : begin : A_AND_B
                alu_out = in_a & in_b;
            end  

            6'b0z1z_10 : begin : B
                alu_out = in_b;
            end 

            6'b0z11_11 : begin : A_PLUS_B // change later to match exactly the especifications behavior
                temporary_sum = in_a + in_b + carry_in;
                alu_out = temporary_sum[WIDTH-1:0];
                carry_out = temporary_sum[WIDTH];
            end 

            6'b1zz0_zz : begin : INC_A
                alu_out = in_a + carry_in; // change later to receive the bit 1 from carry_in
            end 

            default :
                alu_out = 'b0;
        endcase 

        if(alu_out == 0)
            is_zero = 1'b1;

        // expression to define is_neg
    end

endmodule