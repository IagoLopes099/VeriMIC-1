
module controller_top;
    logic clk_top;
    initial clk_top = 0;
    always #50 clk_top = ~clk_top;

    localparam WIDTH_TOP = 32;
    localparam WORD_TOP  = 8;
    localparam WIDTH_MICROINSTRUCTION_TOP = 36;

    controller_if #(
        .WIDTH(WIDTH_TOP),
        .WORD(WORD_TOP),
        .WIDTH_MICROINSTRUCTION(WIDTH_MICROINSTRUCTION_TOP)
    ) inter (clk_top); // Interface

    controller #(
        .WIDTH(WIDTH_TOP),
        .WORD(WORD_TOP),
        .WIDTH_MICROINSTRUCTION(WIDTH_MICROINSTRUCTION_TOP)
    ) controller_inst ( // DUT
        .clk(inter.clk),
        .rst(inter.rst),
        .microinstruction(inter.microinstruction),
        .MPC(inter.MPC),
        .carry_out(inter.carry_out),
        .memory_bus_in_MBR(inter.memory_bus_in_MBR),
        .memory_bus_in_MDR(inter.memory_bus_in_MDR),
        .memory_bus_out_MDR(inter.memory_bus_out_MDR),
        .memory_bus_out_MAR(inter.memory_bus_out_MAR)
    );

    controller_tb #(
        .WIDTH(WIDTH_TOP),
        .WORD(WORD_TOP),
        .WIDTH_MICROINSTRUCTION(WIDTH_MICROINSTRUCTION_TOP)
    ) tb (inter); // TB

endmodule
