

module reg_top; // FILE to instantiate the TestBench and DUT through the an interface
    logic clk_top;
    initial clk_top = 0;
    always #50 clk_top = ~clk_top;

    localparam WIDTH_TOP = 32;

    reg_if #( .WIDTH(WIDTH_TOP) ) inter (clk_top); // interface

    register #( .WIDTH(WIDTH_TOP) ) register_inst (
        .data_in(inter.data_in),
        .clk(inter.clk),
        .rst(inter.rst),
        .load(inter.load),
        .data_out(inter.data_out)
    );  

    register_tb #(WIDTH_TOP) tb (inter); // TB

endmodule