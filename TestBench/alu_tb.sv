`include "..//RTL//alu.v"
`timescale 1ns/100ps

module alu_tb;

    localparam WIDTH = 32;

    reg inv_a_tb, en_a_tb, en_b_tb ,inc_tb, carry_in_tb;
    reg [1:0] sel_tb;
    reg [WIDTH-1:0] in_a_tb, in_b_tb;
    wire [WIDTH-1:0] alu_out_tb; 
    wire carry_out_tb, is_zero_tb, is_neg_tb ;

    alu 
    #( 
        .WIDTH( WIDTH ) 
    ) 
    alu_inst 
    (
        .inv_a(inv_a_tb), 
        .en_a(en_a_tb), 
        .en_b(en_b_tb),
        .inc(inc_tb), 
        .carry_in(carry_in_tb), 
        .sel(sel_tb),
        .in_a(in_a_tb), 
        .in_b(in_b_tb), 
        .alu_out(alu_out_tb), 
        .carry_out(carry_out_tb), 
        .is_zero(is_zero_tb),
        .is_neg(is_neg_tb)
    );

    // OUTPUT EXPECTED
    task expect;
        input [WIDTH-1:0] exp_out;
        input exp_carry_out;

        if(alu_out_tb != exp_out || carry_out_tb != exp_carry_out) begin
            $display("FALHA NO TESTE");
        end
        else begin
            $display("No tempo %0d\nsel=%b\nA = %b\nB = %b\ninvA = %b\nEnA = %b\nEnB = %b\ninc = %b\ncarry_in = %b\nalu_out = %b\ncarry_out = %b\nis_zero = %b\nis_neg = %b\n",
             $time, sel_tb, in_a_tb, in_b_tb, inv_a_tb, en_a_tb, en_b_tb, inc_tb, carry_in_tb, alu_out_tb, carry_out_tb, is_zero_tb, is_neg_tb);
        end
        
    endtask

    initial begin
        inv_a_tb = 1'b0;
        en_a_tb = 1'b0;
        en_b_tb = 1'b0;
        inc_tb = 1'b0;
        carry_in_tb = 1'b0;
        sel_tb = 2'b00;
        in_a_tb = {WIDTH{1'b0}};
        in_b_tb = {WIDTH{1'b0}};

        #10 expect( 0, 1'b0);

        inv_a_tb = 1'b0;
        en_a_tb = 1'b1;
        en_b_tb = 1'b1;
        inc_tb = 1'b0;
        carry_in_tb = 1'b0;
        sel_tb = 2'b11;
        in_a_tb = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        in_b_tb = 32'b0000_0000_0000_0000_0000_0000_0000_0001;


        #10 expect( 0, 1'b1);
        

        $display("TESTE CONCLUIDO!");
        $finish;
    end

endmodule