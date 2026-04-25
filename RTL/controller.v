`include "registerFile.v"
`include "alu.v"
`include "shifter.v"

/* form of word 23 ->   [2] bits for shifter
                        [6] bits for ALU
                        [9] bits for C bus
                        [1] bit for write in memory
                        [1] bit for read from memory
                        [4] bits for B bus

change as necessary
*/ 


module controller #(
    parameter WIDTH = 32,
    parameter WORD = 8,
    parameter WIDTH_MICROINSTRUCTION = 23
)(
    input wire clk,
    input [WIDTH_MICROINSTRUCTION-1 :0] microinstruction,
    output carry_out, is_neg, is_zero,

    //memory
    input [WORD-1:0] memory_bus_in_MBR, 
    input [WIDTH-1:0] memory_bus_in_MDR,
    output [WIDTH-1:0] memory_bus_out_MDR,
    output [WIDTH-1:0] memory_bus_out_MAR,
    output [WIDTH-1:0] memory_bus_out_SP
);
    // intermediate wires
    wire [WIDTH-1:0]    alu_shifter_bus,
                        shifter_registerFile_bus,
                        registerFile_H_alu_a_bus,
                        registerFile_alu_b_bus;

    reg [9:0] rst = 9'b000_000_000;

    registerFile #( .WIDTH( WIDTH ), .WORD( WORD )) 
    registerFile_inst
    (   
        // memory
        .write(microinstruction[5]),
        .read(microinstruction[4]),
        .memory_bus_in_MBR(memory_bus_in_MBR), 
        .memory_bus_in_MDR(memory_bus_in_MDR),
        .memory_bus_out_MDR(memory_bus_out_MDR),
        .memory_bus_out_MAR(memory_bus_out_MAR),
        .memory_bus_out_SP(memory_bus_out_SP),

        .clk(clk),
        .rst(rst),
        .sel_bus_b(microinstruction[3:0]),
        .sel_bus_c(microinstruction[14:6]), 
        .bus_c(shifter_registerFile_bus), // (H, OPC, TOS, CPP, LV, SP, PC, MDR, MAR)
        .bus_a(registerFile_H_alu_a_bus), // (H)
        .bus_b(registerFile_alu_b_bus) // (OPC, TOS, CPP, LV, SP, MBRU, MBR, PC, MDR)
    );

    alu #( .WIDTH( WIDTH ) ) 
    alu_inst
    ( // order [f0, f1, ena, enb, inva, inc]
        .inv_a(microinstruction[16]),
        .en_a(microinstruction[18]), 
        .en_b(microinstruction[17]), 
        .inc(microinstruction[15]),
        .carry_in(1'b0), 
        .sel(microinstruction[20:19]),
        .in_a(registerFile_H_alu_a_bus), 
        .in_b(registerFile_alu_b_bus), 
        .alu_out(alu_shifter_bus),
        .carry_out(carry_out),
        .is_zero(is_zero),
        .is_neg(is_neg)
    );
    
    shifter #( .WIDTH( WIDTH ) )
    shifter_inst
    (
        .out_alu(alu_shifter_bus),
        .sll8(microinstruction[22]),
        .sra1(microinstruction[21]),
        .shifter_out(shifter_registerFile_bus)
    );





endmodule