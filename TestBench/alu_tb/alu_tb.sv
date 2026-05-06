
module alu_tb #(
    parameter WIDTH = 32
)(
    alu_if aluif
);  
    logic full_op = {aluif.sel, aluif.en_a, aluif.en_b, aluif.inv_a, aluif.inc};

    logic [WIDTH:0] exp_out_temp;

    logic [WIDTH-1:0] expected_out;
    logic exp_is_neg, exp_is_zero, exp_overflow;

    always_comb begin : golden_model_reference
        case(full_op)
            6'b01_10_00 : expected_out = aluif.in_a;        // A
            6'b01_01_00 : expected_out = aluif.in_b;        // B
            6'b01_10_10 : expected_out = ~aluif.in_a;       // ~A
            6'b10_11_00 : expected_out = ~aluif.in_b;       // ~B
            6'b11_11_00 : begin                             // A + B
                exp_out_temp = aluif.in_a + aluif.in_b;
                expected_out = exp_out_temp[WIDTH-1:0];
                exp_overflow = exp_out_temp[WIDTH];
            end                                             // A + B + 1
            6'b11_11_01 : begin 
                exp_out_temp = aluif.in_a + aluif.in_b + 1'b1;
                expected_out = exp_out_temp[WIDTH-1:0];
                exp_overflow = exp_out_temp[WIDTH];
            end
            6'b11_10_01 : begin                             // A + 1
                exp_out_temp = aluif.in_a + 1'b1;
                expected_out = exp_out_temp[WIDTH-1:0];
                exp_overflow = exp_out_temp[WIDTH];
            end
            6'b11_01_01 : begin                             // B + 1
                exp_out_temp = aluif.in_b + 1'b1;
                expected_out = exp_out_temp[WIDTH-1:0];
                exp_overflow = exp_out_temp[WIDTH];
            end
            6'b11_11_11 : expected_out = aluif.in_b - aluif.in_a;   // B - A
            6'b11_01_10 : expected_out = aluif.in_b - 1'b1;         // B - 1
            6'b11_10_11 : expected_out = -aluif.in_a;               // -A
            6'b00_11_00 : expected_out = aluif.in_a & aluif.in_b;   // A AND B
            6'b01_11_00 : expected_out = aluif.in_a | aluif.in_b;   // A OR B
            6'b01_00_00 : expected_out = 0;                         // 0
            6'b11_00_01 : expected_out = 1;                         // 1
            6'b11_00_10 : expected_out = -1;                        // -1
            default : expected_out = aluif.alu_out;
        endcase 

        exp_is_neg = (aluif.alu_out[WIDTH-1]);
        exp_is_zero = (!aluif.alu_out);
    end
    
    task exp;

        if(aluif.alu_out !== expected_out || aluif.is_neg !== exp_is_neg || aluif.is_zero !== exp_is_zero) begin
            $display("Error at a time: %0d [ opcode : %b, en_A : %b, en_B : %b, inv_A : %b, inc : %b, is_neg : %b, is_zero : %b",
                     $time, aluif.sel, aluif.en_a, aluif.en_b, aluif.inv_a, aluif.inc, aluif.is_neg, aluif.is_zero);
            $display("A : %b, B : %b, AlU_out : %b]", aluif.in_a, aluif.in_b, aluif.alu_out);

            if(aluif.alu_out !== expected_out ) begin
                $display("ALU_out should be : %b", expected_out);
            end

            if(aluif.is_neg !== exp_is_neg) begin
                $display("Flag is_neg should be : %b", exp_is_neg);
            end

            if(aluif.is_zero !== exp_is_zero) begin
                $display("Flag is_zero should be : %b", exp_is_zero);
            end

            $finish;
        end 
        else begin
            $display("At a time: %0d [ opcode : %b, en_A : %b, en_B : %b, inv_A : %b, inc : %b, ",
                     $time, aluif.sel, aluif.en_a, aluif.en_b, aluif.inv_a, aluif.inc);
            $display("A : %b, B : %b, AlU_out : %b]", aluif.in_a, aluif.in_b, aluif.alu_out);
        end

    endtask

    initial begin
        aluif.in_a = 0;
        aluif.in_b = 0;
        aluif.inc = 0;
        aluif.inv_a = 0;
        aluif.en_a = 0;
        aluif.en_b = 0;
        aluif.sel = 0;

        #25;

        repeat (20) begin
            aluif.in_a = $urandom;
            aluif.in_b = $urandom;
          	if(aluif.inc)
              	aluif.sel = 2'b11;
            else
          		aluif.sel = $urandom_range(0,3);
            aluif.inv_a = $urandom_range(0,1);
            aluif.en_a = $urandom_range(0,1);
            aluif.en_b = $urandom_range(0,1);

            #25;
            exp();

        end

        $display("Test Passed");
        $finish;
    end

endmodule