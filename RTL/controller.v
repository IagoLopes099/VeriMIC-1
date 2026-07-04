`include "registerFile.v"
`include "alu.v"
`include "shifter.v"

/* form of word 36 ->   [9] bits for NEXT_ADDRESS
                        [3] bits for JAM (JAMZ, JAMN, JMPC)
                        [2] bits for shifter
                        [6] bits for ALU
                        [9] bits for C bus
                        [1] bit for write in memory
                        [1] bit for read from memory
                        [1] bit for fetch in memory
                        [4] bits for B bus

    NEXT_ADDRESS, JMPC, JAMN, JAMZ, SLL8, SRA1, F0, F1, ENA, ENB, INVA, INC, H, OPC, TOS, CPP, LV, SP, PC, MDR, MAR, WRITE, READ, FETCH, B_BUS
change as necessary
*/ 

module controller #(
    parameter WIDTH = 32,
    parameter WORD = 8,
    parameter WIDTH_MICROINSTRUCTION = 36
)(
    input wire clk,

    
    // MICROINSTRUCTION CONTROLLER
    input wire [WIDTH_MICROINSTRUCTION-1:0] microinstruction,
    output [8:0] MPC,


    output carry_out,

    //memory
    input wire [WORD-1:0] memory_bus_in_MBR, 
    input wire [WIDTH-1:0] memory_bus_in_MDR,
    output [WIDTH-1:0] memory_bus_out_MDR,
    output [WIDTH-1:0] memory_bus_out_MAR,
    output [WIDTH-1:0] memory_bus_out_SP
);
    // intermediate wires
    wire [WIDTH-1:0]    alu_shifter_bus,
                        shifter_registerFile_bus,
                        registerFile_H_alu_a_bus,
                        registerFile_alu_b_bus;

    wire [WORD-1:0] memory_bus_out_MBR_MPC;

    // flip_flops to save old value flags from alu
    reg is_neg, is_zero;

    wire alu_out_flag_Z, alu_out_flag_N; 

    wire [8:0] NEXT_ADDRESS;
    assign NEXT_ADDRESS = microinstruction[35:27];

    wire [2:0] JAM;
    assign JAM = microinstruction[26:24];

    reg [9:0] rst = 9'b000_000_000;

    registerFile #( .WIDTH( WIDTH ), .WORD( WORD )) 
    registerFile_inst
    (   
        // memory
        .fetch(microinstruction[4]),
        .write(microinstruction[6]),
        .read(microinstruction[5]),
        .memory_bus_in_MBR(memory_bus_in_MBR), 
        .memory_bus_in_MDR(memory_bus_in_MDR),
        .memory_bus_out_MDR(memory_bus_out_MDR),
        .memory_bus_out_MAR(memory_bus_out_MAR),
        .memory_bus_out_MBR(memory_bus_out_MBR_MPC),
        .clk(clk),
        .rst(rst),
        .sel_bus_b(microinstruction[3:0]),
        .sel_bus_c(microinstruction[15:7]), 
        .bus_c(shifter_registerFile_bus), // (H, OPC, TOS, CPP, LV, SP, PC, MDR, MAR)
        .bus_a(registerFile_H_alu_a_bus), // (H)
        .bus_b(registerFile_alu_b_bus) // (OPC, TOS, CPP, LV, SP, MBRU, MBR, PC, MDR)
    );

    alu #( .WIDTH( WIDTH ) ) 
    alu_inst
    ( // order [f0, f1, ena, enb, inva, inc]
        .inv_a(microinstruction[17]),
        .en_a(microinstruction[19]), 
        .en_b(microinstruction[18]), 
        .inc(microinstruction[16]),
        .sel(microinstruction[21:20]),
        .in_a(registerFile_H_alu_a_bus), 
        .in_b(registerFile_alu_b_bus), 
        .alu_out(alu_shifter_bus),
        .overflow(carry_out),
        .is_zero(alu_out_flag_Z),
        .is_neg(alu_out_flag_N)
    );
    
    shifter #( .WIDTH( WIDTH ) )
    shifter_inst
    (
        .clk(clk),
        .shifter_in(alu_shifter_bus),
        .sll8(microinstruction[23]),
        .sra1(microinstruction[22]),
        .shifter_out(shifter_registerFile_bus)
    );

    always @(posedge clk) begin
        is_neg <= alu_out_flag_N;
        is_zero <= alu_out_flag_Z;
    end

    // output from flip_flops flags alu, to MPC  
    assign MPC[8] = (is_zero & JAM[2]) | (is_neg & JAM[1]) | NEXT_ADDRESS[8];
    assign MPC[7:0] = NEXT_ADDRESS[7:0] | (JAM[0] ? memory_bus_out_MBR_MPC : 0);


endmodule