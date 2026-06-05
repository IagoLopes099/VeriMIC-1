`ifndef REGISTERFILE_IF
`define REGISTERFILE_IF

interface registerFile_if #(
    parameter WORD = 8,
    parameter WIDTH = 32
)(
    input bit clk
);

    // memory signals and bus
    logic write ,read;
    logic [WORD-1:0] memory_bus_in_MBR;
    logic [WIDTH-1:0] memory_bus_in_MDR;
    logic [WIDTH-1:0] memory_bus_out_MDR;
    logic [WIDTH-1:0] memory_bus_out_MAR;
    logic [WIDTH-1:0] memory_bus_out_PC;

    // FILE REGISTER signals and bus
    logic [9:0] rst; // reset
    logic [3:0] sel_bus_b; // decoder
    logic [8:0] sel_bus_c; // seletor REGISTER INPUTS FROM C BUS (H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR)
    logic [WIDTH-1:0] bus_c, bus_b, bus_a; 

    modport TEST (
        input clk, bus_b, bus_a, memory_bus_out_MAR, memory_bus_out_MDR, memory_bus_out_PC,
        output rst, bus_c, sel_bus_b, sel_bus_c, write, read , memory_bus_in_MBR, memory_bus_in_MDR
    ); 

    modport DUT (
        input clk, rst, sel_bus_b, sel_bus_c, bus_c , write, read , memory_bus_in_MBR, memory_bus_in_MDR, 
        output bus_b, bus_a, memory_bus_out_MAR, memory_bus_out_MDR, memory_bus_out_PC
    );


endinterface

`endif