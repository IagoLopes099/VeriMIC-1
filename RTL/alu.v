module alu #(
    parameter WIDTH = 32
)(
    input wire inv_a, en_a, en_b, inc, carry_in,
    input wire [1:0] sel, //01
    input wire [WIDTH-1:0] in_a, in_b,
    output reg [WIDTH-1:0] alu_out,
    output reg carry_out, is_zero, is_neg
);

    reg [WIDTH:0] temporary_sum;   
    reg [WIDTH-1:0] a, b; 
    reg carry_in_temp; 

    always @(*) begin : inputs_logic

        a = (en_a) ? in_a : {WIDTH{1'b0}};
        a = (!inv_a) ? a : ~a; 

        b = (en_b) ? in_b : {WIDTH{1'b0}};
        carry_in_temp = (!inc) ? carry_in : (carry_in + 1'b1); 

    end

    always @(*) begin : alu_logic_operations // change later to perform signed operations
        carry_out = 1'b0;
        is_zero = 1'b0;
        is_neg = 1'b0;

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
                carry_out = temporary_sum[WIDTH];
            end 

        endcase 

        if(alu_out == 0)
            is_zero = 1'b1;

        // expression to define is_neg
    end

endmodule