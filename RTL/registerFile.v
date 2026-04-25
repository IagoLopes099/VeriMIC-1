`include "register.v"
`include "registerMBR.v"

module registerFile #(
    parameter WIDTH = 32,
    parameter WORD = 8
)(

    // memory
    input write ,read,
    input [WORD-1:0] memory_bus_in_MBR, 
    input [WIDTH-1:0] memory_bus_in_MDR,
    output [WIDTH-1:0] memory_bus_out_MDR,
    output [WIDTH-1:0] memory_bus_out_MAR,
    output [WIDTH-1:0] memory_bus_out_SP,


    input wire clk,
    input wire [9:0] rst,
    input wire [3:0] sel_bus_b,
    input wire [8:0] sel_bus_c, // REGISTER INPUTS FROM C BUS (H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR)
    input wire [WIDTH-1:0] bus_c,
    output reg [WIDTH-1:0] bus_b,
    output [WIDTH-1:0] bus_a
);  
    // CONECTIONS WIRE TO AND FROM MDR REGISTER
    wire [WIDTH-1:0] out_mem_MDR;
    reg [WIDTH-1:0] in_mem_MDR;

    // REGISTER OUTPUTS TO B BUS (OPC, TOS, CPP, LV, SP, PC, MDR , MBR, MBRU)
    wire [WIDTH-1:0] muxb_in0, muxb_in1, muxb_in2, muxb_in3, muxb_in4, muxb_in5, muxb_in6, muxb_in7, muxb_in8;

    // WIRE OUTPUT H TO A BUS
    wire [WIDTH-1:0] wire_out_H;

    // REGISTER FILE H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR
    register #( .WIDTH( WIDTH ) ) H (.clk(clk), .load(sel_bus_c[8]), .rst(rst[9]), .data_in(bus_c), .data_out(wire_out_H));

    register #( .WIDTH( WIDTH ) ) OPC (.clk(clk), .load(sel_bus_c[7]) , .rst(rst[8]), .data_in(bus_c), .data_out(muxb_in8)); 
    register #( .WIDTH( WIDTH ) ) TOS (.clk(clk), .load(sel_bus_c[6]), .rst(rst[7]), .data_in(bus_c), .data_out(muxb_in7));
    register #( .WIDTH( WIDTH ) ) CPP (.clk(clk), .load(sel_bus_c[5]), .rst(rst[6]), .data_in(bus_c), .data_out(muxb_in6));
    register #( .WIDTH( WIDTH ) ) LV (.clk(clk), .load(sel_bus_c[4]), .rst(rst[5]), .data_in(bus_c), .data_out(muxb_in5));
    register #( .WIDTH( WIDTH ) ) SP (.clk(clk), .load(sel_bus_c[3]), .rst(rst[4]), .data_in(bus_c), .data_out(muxb_in4));

    register #( .WIDTH( WIDTH ) ) PC (.clk(clk), .load(sel_bus_c[2]), .rst(rst[3]), .data_in(bus_c), .data_out(muxb_in1));

    register #( .WIDTH( WIDTH ) )
    MDR 
    (
        .clk(clk), 
        .load(( sel_bus_c[1] || read) ? 1'b1 : 1'b0), 
        .rst(rst[2]), 
        .data_in(in_mem_MDR), 
        .data_out(out_mem_MDR)
    );

    register #( .WIDTH( WIDTH ) ) MAR (.clk(clk), .load(sel_bus_c[0]), .rst(rst[1]) ,.data_in(bus_c), .data_out(memory_bus_out_MAR)); 

    // SPECIAL REGISTER
    registerMBR #( .WIDTH( WIDTH ), .WORD( WORD ) ) 
    MBR 
    (   
        .clk(clk),
        .rst(rst[0]),
        .load(1'b0), // change later when you go put the memory path
        .data_in(memory_bus_in_MBR), //  change later when you go put the memory path
        .data_out1(muxb_in2),
        .data_out2(muxb_in3)
    );    

    // MUX TO KNOW WHO WILL CONTROLLER THE INPUT FROM MDR REGISTER    
    always @(*) begin : MUX_controller_in_MDR

        casez({sel_bus_c[1], read})
            2'bz1 : in_mem_MDR = bus_c;
            2'b10 : in_mem_MDR = memory_bus_in_MDR;
            default : in_mem_MDR = bus_c;
        endcase
    end

    // BUS FROM REGISTER MDR TO B BUS AND MEMORY
    assign out_mem_MDR = memory_bus_out_MDR;
    assign out_mem_MDR = muxb_in0;

    // BUS FROM REGISTER H TO ALU A 
    assign bus_a = wire_out_H;

    always @(*) begin : decoder_output_registers_b_bus // (OPC,TOS,CPP,LV,SP,MBRU,MBR,PC,MDR) [8 -> 0]

        case (sel_bus_b)
            4'b0000 : bus_b = muxb_in0; // 0
            4'b0001 : bus_b = muxb_in1; // 1
            4'b0010 : bus_b = muxb_in2; // 2
            4'b0011 : bus_b = muxb_in3; // 3
            4'b0100 : bus_b = muxb_in4; // 4
            4'b0101 : bus_b = muxb_in5; // 5
            4'b0110 : bus_b = muxb_in6; // 6
            4'b0111 : bus_b = muxb_in7; // 7
            4'b1000 : bus_b = muxb_in8; // 8
        endcase

    end

endmodule