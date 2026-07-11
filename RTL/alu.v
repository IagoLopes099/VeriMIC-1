module alu #(
    parameter WIDTH = 32
)(
    input wire inv_a, en_a, en_b, inc,
    input wire [1:0] sel,
    input wire signed [WIDTH-1:0] in_a, in_b,
    output reg signed [WIDTH-1:0] alu_out,
    output is_zero,  is_neg, overflow
);
    // OPCODES
    localparam AND      = 2'b00;
    localparam NOT_B    = 2'b01;
    localparam OR       = 2'b10;
    localparam ADD      = 2'b11;


    reg [WIDTH:0] temporary_sum;   
    reg [WIDTH-1:0] a, b; 


    assign is_zero = ~|alu_out;         // NOR (reduction)
    assign is_neg = alu_out[WIDTH-1];   // MSB 


    always @(*) begin : inputs_logic

        a = (en_a) ? in_a : {WIDTH{1'b0}};
        a = (!inv_a) ? a : ~a; 

        b = (en_b) ? in_b : {WIDTH{1'b0}};
        
    end

    always @(*) begin : alu_logic_operations
        overflow = 1'b0;

        casez({sel[0], sel[1]}) 

            AND : begin
                alu_out = a & b;
            end

            OR : begin
                alu_out = a | b;
            end  

            NOT_B : begin
                alu_out = ~b;
            end 

            ADD : begin 
                temporary_sum = a + b + inc;
                alu_out = temporary_sum[WIDTH-1:0];
                overflow = temporary_sum[WIDTH];
            end 
        endcase 

    end

endmodule