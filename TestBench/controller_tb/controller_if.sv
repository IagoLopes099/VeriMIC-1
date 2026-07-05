`ifndef CONTROLLER_IF
`define CONTROLLER_IF

interface controller_if #(
    parameter WIDTH = 32,
    parameter WORD  = 8,
    parameter WIDTH_MICROINSTRUCTION = 36
)(
    input bit clk
);
    logic [9:0] rst;

    // MICROINSTRUCTION CONTROLLER
    logic [WIDTH_MICROINSTRUCTION-1:0] microinstruction;
    logic [8:0] MPC; 

    logic carry_out;

    // MEMORY
    logic [WORD-1:0]  memory_bus_in_MBR;
    logic [WIDTH-1:0] memory_bus_in_MDR;
    logic [WIDTH-1:0] memory_bus_out_MDR;
    logic [WIDTH-1:0] memory_bus_out_MAR;

    modport TEST ( 
        input  clk, MPC, carry_out, memory_bus_out_MDR, memory_bus_out_MAR,
        output rst, microinstruction, memory_bus_in_MBR, memory_bus_in_MDR
    );

    modport DUT ( 
        input  clk, rst, microinstruction, memory_bus_in_MBR, memory_bus_in_MDR,
        output MPC, carry_out, memory_bus_out_MDR, memory_bus_out_MAR
    );

endinterface

`endif
