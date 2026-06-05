
module MBR_tb #(
    parameter WORD = 8,
    parameter WIDTH = 32
)(
    MBR_if MBRif
);

    logic [WIDTH-1:0] expected1, expected2;

    always @(posedge MBRif.clk) begin : golden_model_reference
        if (!MBRif.rst) begin
           expected1 <= 0;
           expected2 <= 0;
        end
        else if (MBRif.load) begin
            expected1 <= {{WIDTH-WORD{1'b0}},MBRif.data_in};
            expected2 <= {{WIDTH-WORD{MBRif.data_in[WORD-1]}},MBRif.data_in};
        end
        else begin
            expected1 <= MBRif.data_out1;
            expected2 <= MBRif.data_out2;
        end
    end


    task exp; 
        if (MBRif.data_out1 !== expected1 || MBRif.data_out2 !== expected2) begin
            $display("Error at a time %0d", $time);

            if (MBRif.data_out1 !== expected1) begin
                $display("Data_in : %b, rst : %b, load : %b, data_out1 : %b",
                        MBRif.data_in, MBRif.rst, MBRif.load, MBRif.data_out1);
                $display("Data_out1 Should be : %b", expected1);        
            end

            if (MBRif.data_out2 !== expected2) begin
                $display("Data_in : %b, rst : %b, load : %b, data_out2 : %b",
                        MBRif.data_in, MBRif.rst, MBRif.load, MBRif.data_out2);
                $display("Data_out2 Should be : %b", expected2);        
            end
            $finish;
        end
        else begin
            $display("Data_in : %b, rst : %b, load : %b, data_out1 : %b, data_out2 : %b",
                        MBRif.data_in, MBRif.rst, MBRif.load, MBRif.data_out1, MBRif.data_out2);

        end

    endtask


    initial begin
        MBRif.data_in = 0;
        MBRif.rst = 1'b0;
        MBRif.load = 1'b0;

        repeat (2) @(posedge MBRif.clk);

        MBRif.rst = 1'b1;

        repeat (40) begin 
            @(negedge MBRif.clk)

            MBRif.data_in = $urandom;
            MBRif.load = $urandom_range(0,1);

            @(negedge MBRif.clk)

            exp();
        end

        $display("Test Passed");
        $finish;
    end

endmodule