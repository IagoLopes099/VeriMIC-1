`include "..//RTL//alu.v"
`timescale 1ns/100ps

module alu_tb;

    localparam WIDTH = 32;

    reg carry_in_tb;
    reg [5:0] ir; // (f0, f1, ena, enb, inva, inc) 
    reg [WIDTH-1:0] in_a_tb, in_b_tb;
    wire [WIDTH-1:0] alu_out_tb; 
    wire carry_out_tb, is_zero_tb, is_neg_tb ;

    integer i;

    alu 
    #( 
        .WIDTH( WIDTH ) 
    ) 
    alu_inst 
    (
        .inv_a(ir[1]), 
        .en_a(ir[3]), 
        .en_b(ir[2]),
        .inc(ir[0]), 
        .carry_in(carry_in_tb), 
        .sel({ir[5:4]}),
        .in_a(in_a_tb), 
        .in_b(in_b_tb), 
        .alu_out(alu_out_tb), 
        .carry_out(carry_out_tb), 
        .is_zero(is_zero_tb),
        .is_neg(is_neg_tb)
    );


    task startProgram;
        begin
            $display("b = %b\na =%b", in_b_tb, in_a_tb);
            $display("Start of program");
        end
    endtask

    // OUTPUT EXPECTED
    task expect;
        input [WIDTH-1:0] exp_out;
        input exp_carry_out;

        if(alu_out_tb != exp_out || carry_out_tb != exp_carry_out) begin
            $display("FALHA NO TESTE");

            if(alu_out_tb != exp_out) begin
                $display("alu out deveria ser: %b", exp_out);
                $display("mas e: %b", alu_out_tb);
            end

            if(carry_out_tb != exp_carry_out) begin
                $display("carry out deveria ser: %b", exp_carry_out);
                $display("mas e: %b", carry_out_tb); 

            end
        end
        else begin
            
            $display("============================================================");
            $display("Cycle %d", i);
            $display("No tempo %0d", $time);
            $display("b = %b", in_b_tb);
            $display("a = %b", in_a_tb);
            
            $display("sel = %b", ir[5:4]);
            $display("inv_a = %b", ir[1]);
            $display("en_a = %b", ir[3]);
            $display("en_b = %b", ir[2]);
            $display("inc = %b", ir[0]);
            $display("carry_in = %b", carry_in_tb);

            $display("s = %b", alu_out_tb);
            $display("co = %b", carry_out_tb);
        end
        
    endtask

    

    initial begin
        ir = 6'b000000;
        carry_in_tb = 1'b0;
        in_a_tb = {WIDTH{1'b0}};
        in_b_tb = {WIDTH{1'b0}};
        i = 0;

        startProgram;
        #10 expect( 0, 1'b0);
        
        // CYCLO 1
        i++;
        ir = 6'b111100;
        carry_in_tb = 1'b0;
        in_a_tb = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        in_b_tb = 32'b0000_0000_0000_0000_0000_0000_0000_0001;


        #20 expect( 0, 1'b1);
        
        // CYCLO 2
        i++;
        ir = 6'b110101;
        carry_in_tb = 1'b0;
        in_a_tb = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        in_b_tb = 32'b0000_0000_0000_0000_0000_0000_0000_0001;


        #30 expect( 32'b00000000000000000000000000000010, 1'b0);

        // CYCLO 3
        i++;
        ir = 6'b110100;
        carry_in_tb = 1'b0;
        in_a_tb = 32'b00000000000000000000000000000000;
        in_b_tb = 32'b00000000000000000000000000000001;


        #40 expect( 32'b00000000000000000000000000000001, 1'b0);

        // CYCLO 4
        i++;
        ir = 6'b011100;
        carry_in_tb = 1'b0;
        in_a_tb = 32'b11111111111111111111111111111111;
        in_b_tb = 32'b00000000000000000000000000000001;


        #50 expect( 32'b11111111111111111111111111111111, 1'b0);

        $display("TESTE CONCLUIDO!");
        $finish;
    end

endmodule