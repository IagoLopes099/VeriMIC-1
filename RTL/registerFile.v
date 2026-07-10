`include "register.v"
`include "registerMBR.v"

module registerFile #(
    parameter WIDTH = 32,
    parameter WORD = 8
)(
 
    // memory
    input write ,read, fetch,
    input [WORD-1:0] memory_bus_in_MBR, 
    input [WIDTH-1:0] memory_bus_in_MDR,
    output [WIDTH-1:0] memory_bus_out_MDR,
    output [WIDTH-1:0] memory_bus_out_MAR,
    output [WIDTH-1:0] memory_bus_out_PC,
    output [WORD-1:0] memory_bus_out_MBR, // SPECIAL OUTPUT TO MPC

    // decoder and selector (B AND C BUS)
    input wire clk,
    input wire [9:0] rst,
    input wire [3:0] sel_bus_b,
    input wire [8:0] sel_bus_c, // REGISTER INPUTS FROM C BUS (H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR)
    input wire [WIDTH-1:0] bus_c,
    output reg [WIDTH-1:0] bus_b,
    output [WIDTH-1:0] bus_a
);  

    // CONECTIONS WIRE TO AND FROM MDR REGISTER
    wire [WIDTH-1:0] out_MDR;
    wire [WIDTH-1:0] in_MDR;

    // CONECTIONS WIRE FROM OUT PC TO MEMORY AND B BUS IN DEMUX
    wire [WIDTH-1:0] out_PC;

    // REGISTER OUTPUTS TO B BUS (OPC, TOS, CPP, LV, SP, PC, MDR , MBR, MBRU)
    wire [WIDTH-1:0] muxb_MDR_OUT, muxb_PC_OUT, muxb_MBR_OUT, muxb_MBRU_OUT, muxb_SP_OUT, muxb_LV_OUT, muxb_CPP_OUT, muxb_TOS_OUT, muxb_OPC_OUT;

    // REGISTER FILE H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR
    register #( .WIDTH( WIDTH ) ) H (.clk(clk), .load(sel_bus_c[8]), .rst(rst[9]), .data_in(bus_c), .data_out(bus_a));

    register #( .WIDTH( WIDTH ) ) OPC (.clk(clk), .load(sel_bus_c[7]) , .rst(rst[8]), .data_in(bus_c), .data_out(muxb_OPC_OUT)); 
    register #( .WIDTH( WIDTH ) ) TOS (.clk(clk), .load(sel_bus_c[6]), .rst(rst[7]), .data_in(bus_c), .data_out(muxb_TOS_OUT));
    register #( .WIDTH( WIDTH ) ) CPP (.clk(clk), .load(sel_bus_c[5]), .rst(rst[6]), .data_in(bus_c), .data_out(muxb_CPP_OUT));
    register #( .WIDTH( WIDTH ) ) LV (.clk(clk), .load(sel_bus_c[4]), .rst(rst[5]), .data_in(bus_c), .data_out(muxb_LV_OUT));
    register #( .WIDTH( WIDTH ) ) SP (.clk(clk), .load(sel_bus_c[3]), .rst(rst[4]), .data_in(bus_c), .data_out(muxb_SP_OUT));

    register #( .WIDTH( WIDTH ) ) PC (.clk(clk), .load(sel_bus_c[2]), .rst(rst[3]), .data_in(bus_c), .data_out(out_PC));

    register #( .WIDTH( WIDTH ) )
    MDR 
    (
        .clk(clk), 
        .load(( sel_bus_c[1] || read) ? 1'b1 : 1'b0), 
        .rst(rst[2]), 
        .data_in(in_MDR), 
        .data_out(out_MDR)
    );

    register #( .WIDTH( WIDTH ) ) MAR (.clk(clk), .load(sel_bus_c[0]), .rst(rst[1]) ,.data_in(bus_c), .data_out(memory_bus_out_MAR)); 

    // SPECIAL REGISTER
    registerMBR #( .WIDTH( WIDTH ), .WORD( WORD ) ) 
    MBR 
    (   
        .clk(clk),
        .rst(rst[0]),
        .load(1'b1), // ever will be 1, because it's only path to the memory for word
        .data_in(memory_bus_in_MBR),
        .MBR_out(muxb_MBR_OUT),
        .MBRU_out(muxb_MBRU_OUT)
    );    

    // MUX TO KNOW WHO WILL CONTROLLER THE INPUT FROM MDR REGISTER    
    assign in_MDR = (read) ? memory_bus_in_MDR : bus_c;

    // DEMUX FROM OUT MDR TO MEMORY AND B BUS
    assign memory_bus_out_MDR = (write) ? out_MDR : 'b0;
    assign muxb_MDR_OUT = out_MDR;

    // DEMUX FROM OUT PC TO MEMORY AND B BUS
    assign  memory_bus_out_PC = (fetch) ? out_PC : 'b0;
    assign  muxb_PC_OUT = out_PC;

    always @(*) begin : decoder_output_registers_b_bus // (OPC,TOS,CPP,LV,SP,MBRU,MBR,PC,MDR) [8 -> 0]

        case (sel_bus_b)
            4'b0000 : bus_b = muxb_MDR_OUT; // 0 MDR
            4'b0001 : bus_b = muxb_PC_OUT; // 1 PC
            4'b0010 : bus_b = muxb_MBR_OUT; // 2 MBR
            4'b0011 : bus_b = muxb_MBRU_OUT; // 3 MBRU
            4'b0100 : bus_b = muxb_SP_OUT; // 4 SP
            4'b0101 : bus_b = muxb_LV_OUT; // 5 LV
            4'b0110 : bus_b = muxb_CPP_OUT; // 6 CPP
            4'b0111 : bus_b = muxb_TOS_OUT; // 7 TOS
            4'b1000 : bus_b = muxb_OPC_OUT; // 8 OPC
        endcase

    end

    assign memory_bus_out_MBR = muxb_MBR_OUT[8:0];

endmodule