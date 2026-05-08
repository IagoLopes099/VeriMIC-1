
module shifter_top; // FIle to instantiate the TestBench and DUT through the an interface
    logic clk_top;
    initial clk_top = 0;
    always #50 clk_top = ~clk_top;

    localparam WIDTH_TOP = 32;
    
    shifter_if #( .WIDTH(WIDTH_TOP) ) inter (clk_top); // interface

    shifter #( .WIDTH(WIDTH_TOP) ) shifter_inst ( // DUT
        .clk(inter.clk),
        .shifter_in(inter.shifter_in),
        .sll8(inter.sll8),
        .sra1(inter.sra1),
        .shifter_out(inter.shifter_out)
    ); 

    shifter_tb #(WIDTH_TOP) tb (inter); // TB

endmodule