`timescale  1ns / 1ns

import uvm_pkg::*; 

`include "umv_macros.svh"
`include "registerFileMem_interface.sv"

module registerFileMem_top();
    localparam WIDTH_TOP = 32;
    localparam WORD_TOP = 8;

    logic clock;
    initial clk = 0;
    always #5 clk = ~clk;


    registerFile_interface #( .WIDTH(WIDTH_TOP), .WORD(WORD_TOP)) inter (clock); // Interface

    registerFile #( .WIDTH(WIDTH_TOP), .WORD(WORD_TOP)) regFile_inst ( // DUT
        .write(inter.write),
        .read(inter.read),
        .fetch(inter.fetch),
        .memory_bus_in_MBR(inter.memory_bus_in_MBR),
        .memory_bus_in_MDR(inter.memory_bus_in_MDR),
        .memory_bus_out_MDR(inter.memory_bus_out_MDR),
        .memory_bus_out_MAR(inter.memory_bus_out_MAR),
        .memory_bus_out_PC(inter.memory_bus_out_PC),
        .clk(inter.clock),
        .rst(inter.rst),
        .sel_bus_b(inter.sel_bus_b),
        .sel_bus_c(inter.sel_bus_c),
        .bus_c(inter.bus_c),
        .bus_b(inter.bus_b),
        .bus_a(inter.bus_a) 
    );

    

    initial begin
        #5000
        $display("Ran out of clock cycle!");
        $finish;
    end

endmodule

