`include "main_memory.v"
`include "control_store.v"
`include "controller.v"

module MIC_1_top(
    input wire clk,
    input wire [9:0] rst,
    output overflow
);
    localparam WIDTH_TOP = 32;
    localparam WORD_TOP = 8;
    localparam MICROINSTRUCTION_WIDTH_TOP = 36;

    wire [MICROINSTRUCTION_WIDTH_TOP-1:0] microinstruction_top;
    wire [8:0] mpc_top;
    wire [WIDTH_TOP-1:0]    bus_MBR_ram,
                            bus_MDR_ram_in,
                            bus_MDR_ram_out,
                            bus_MAR_ram,
                            bus_PC_ram;

    main_memory #(  .WIDTH(WIDTH_TOP),
                    .WORD(WORD_TOP),
                    .MEM_FILE("../Memory/main_memory.mem")
    ) ram (
        .clk(clk),
        .read(microinstruction_top[5]),
        .write(microinstruction_top[6]),
        .fetch(microinstruction_top[4]),
        .pc(bus_PC_ram),
        .mar(bus_MAR_ram),
        .mdr_in(bus_MDR_ram_in),
        .mdr_out(bus_MDR_ram_out),
        .mbr(bus_MBR_ram)
    );


    control_store #(    .MICROINSTRUCTION_WIDTH(MICROINSTRUCTION_WIDTH_TOP),
                        .MEM_FILE("../Memory/microprogram.mem")
    ) rom (
        .clk(clk),
        .mpc(mpc_top),
        .microinstruction(microinstruction_top)
    );

    
    controller #(   .WIDTH(WIDTH_TOP), 
                    .WORD(WORD_TOP),
                    .MICROINSTRUCTION_WIDTH(MICROINSTRUCTION_WIDTH_TOP)
    ) core (
        .clk(clk),
        .rst(rst),
        .microinstruction(microinstruction_top),
        .MPC(mpc_top),
        .memory_bus_in_MBR(bus_MBR_ram), 
        .memory_bus_in_MDR(bus_MDR_ram_out), // came from ram
        .memory_bus_out_MDR(bus_MDR_ram_in), // go to ram
        .memory_bus_out_MAR(bus_MAR_ram),
        .memory_bus_out_PC(bus_PC_ram),
        .carry_out()
    );




endmodule