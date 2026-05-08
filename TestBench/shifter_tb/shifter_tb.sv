
module shifter_tb #(
    parameter WIDTH = 32
)(
    shifter_if shifterif
);

    logic [WIDTH-1:0] expected;


    always @(posedge shifterif.clk) begin : golden_model_reference
        if (shifterif.sll8) begin
            expected <= shifterif.shifter_in << 8; // logic operation (8 to left)
        end 
        else if (shifterif.sra1) begin
            expected <= shifterif.shifter_in / 2; // arithmetic operation (divided by 2)
        end
        else begin
            expected <= shifterif.shifter_in;
        end
    end


    task exp;
        if(shifterif.shifter_out !== expected) begin
            $display("Error at a time: %0d, sll8 : %b, sra1 : %b, shifter_in : %b, shifter_out %b",
                     $time, shifterif.sll8, shifterif.sra1, shifterif.shifter_in, shifterif.shifter_out );
            $display("Shifter_out should be : %b", expected);
            $finish;
        end
        else begin
            $display("At a time: %0d, sll8 : %b, sra1 : %b, shifter_in : %b, shifter_out %b",
                     $time, shifterif.sll8, shifterif.sra1, shifterif.shifter_in, shifterif.shifter_out );
            
        end
    endtask


    initial begin
        shifterif.sll8 = 1'b0;
        shifterif.sra1 = 1'b0;
        shifterif.shifter_in = 'b0;

        repeat (2) @(posedge shifterif.clk);

        repeat (20) begin
            @(negedge shifterif.clk);

            shifterif.sll8 = $urandom_range(0,1);
            shifterif.sra1 = $urandom_range(0,1);
            shifterif.shifter_in = $urandom;

            @(negedge shifterif.clk);
            exp();
        end

        $display("Test Passed");
        $finish;
    end
    

endmodule