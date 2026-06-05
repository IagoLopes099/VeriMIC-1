
module registerFile_top;
    logic clk_top;
    initial clk_top = 0;
    always #50 clk_top = ~clk_top;

    localparam WIDTH_TOP = 32;
    localparam WORD_TOP = 8;

    registerFile_if #( .WIDTH(WIDTH_TOP), .WORD(WORD_TOP)) inter (clk_top); // Interface

    registerFile #( .WIDTH(WIDTH_TOP), .WORD(WORD_TOP)) regFile_inst ( // DUT
        .write(inter.write),
        .read(inter.read),
        .memory_bus_in_MBR(inter.memory_bus_in_MBR),
        .memory_bus_in_MDR(inter.memory_bus_in_MDR),
        .memory_bus_out_MDR(inter.memory_bus_out_MDR),
        .memory_bus_out_MAR(inter.memory_bus_out_MAR),
        .memory_bus_out_PC(inter.memory_bus_out_PC),
        .clk(inter.clk),
        .rst(inter.rst),
        .sel_bus_b(inter.sel_bus_b),
        .sel_bus_c(inter.sel_bus_c),
        .bus_c(inter.bus_c),
        .bus_b(inter.bus_b),
        .bus_a(inter.bus_a) 
    );

    registerFile_tb #( .WIDTH(WIDTH_TOP), .WORD(WORD_TOP)) tb (inter); // TB


endmodule