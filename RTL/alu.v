module alu #(
    parameter WIDTH = 32
)(
    input wire inv_a, en_a, en_b, inc,
    input wire [1:0] sel,
    input wire signed [WIDTH-1:0] in_a, in_b,
    output reg signed [WIDTH-1:0] alu_out,
    output reg overflow, is_zero, is_neg
);

    reg [WIDTH:0] temporary_sum;   
    reg [WIDTH-1:0] a, b; 
    reg carry_in_temp; 

    always @(*) begin : inputs_logic

        a = (en_a) ? in_a : {WIDTH{1'b0}};
        a = (!inv_a) ? a : ~a; 

        b = (en_b) ? in_b : {WIDTH{1'b0}};
        carry_in_temp = (inc) ? 1'b1 : 1'b0; 

    end

    always @(*) begin : alu_logic_operations

        casez({sel[0], sel[1]}) 

            2'b00 : begin : A_and_B
                alu_out = a & b;
            end

            2'b10 : begin : A_or_B
                alu_out = a | b;
            end  

            2'b01 : begin : NOT_B
                alu_out = ~b;
            end 

            2'b11 : begin : A_plus_B // change later to match exactly the especifications behavior
                temporary_sum = a + b + carry_in_temp;
                alu_out = temporary_sum[WIDTH-1:0];
                overflow = temporary_sum[WIDTH];
            end 
        endcase 

        is_zero = (alu_out == 0) ? 1'b1 : 1'b0;
        is_neg = (alu_out[WIDTH]) ? 1'b1 : 1'b0;

    end

endmodule