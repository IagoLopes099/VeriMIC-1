
module MBR_top;
    localparam WORD_TOP = 8;
    localparam WIDTH_TOP = 32;
    
    logic clk_top;
    initial clk_top = 0;
    always #50 clk_top = ~clk_top;

    MBR_if #( .WORD(WORD_TOP), .WIDTH(WIDTH_TOP) ) inter (clk_top); // interface

    registerMBR #( .WORD(WORD_TOP), .WIDTH(WIDTH_TOP) ) MBR_inst ( // DUT
        .data_in(inter.data_in),
        .clk(inter.clk),
        .load(inter.load), 
        .rst(inter.rst),
        .data_out1(inter.data_out1),
        .data_out2(inter.data_out2)
    );

    MBR_tb #( .WORD(WORD_TOP), .WIDTH(WIDTH_TOP) ) tb (inter); // TB

endmodule