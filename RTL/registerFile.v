`include "register.v"

module registerFile #(
    parameter WIDTH = 32,
    parameter WORD = 8
)(
    // input wire msi,
    input wire clk,
    input wire [9:0] rst
    input wire [3:0] sel_bus_b,
    input wire [8:0] sel_bus_c, // REGISTER INPUTS FROM C BUS (H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR)
    input wire [WIDTH-1:0] bus_c,
    output reg [WIDTH-1:0] bus_a, bus_b
);  
    wire wire_out_PC;
    wire wire_out_MDR; 

    // REGISTER OUTPUTS TO B BUS (OPC, TOS, CPP, LV, SP, PC, MDR , MBR, MBRU)
    reg [WIDTH-1:0] muxb_in0, muxb_in1, muxb_in2, muxb_in3, muxb_in4, muxb_in5, muxb_in6, muxb_in7, muxb_in8;

    
    // REGISTER FILE H, OPC, TOS, CPP, LV, SP, PC, MDR e MAR
    register #( .WIDTH( WIDTH ) ) H (.clk(clk), .load(sel_bus_c[8]), .rst(rst[9]), .data_in(bus_c), .data_out(bus_a));

    register #( .WIDTH( WIDTH ) ) OPC (.clk(clk), .load(sel_bus_c[7]) , .rst(rst[8]), .data_in(bus_c), .data_out(muxb_in8)); 
    register #( .WIDTH( WIDTH ) ) TOS (.clk(clk), .load(sel_bus_c[6]), .rst(rst[7]), .data_in(bus_c), .data_out(muxb_in7));
    register #( .WIDTH( WIDTH ) ) CPP (.clk(clk), .load(sel_bus_c[5]), .rst(rst[6]), .data_in(bus_c), .data_out(muxb_in6));
    register #( .WIDTH( WIDTH ) ) LV (.clk(clk), .load(sel_bus_c[4]), .rst(rst[5]), .data_in(bus_c), .data_out(muxb_in5));
    register #( .WIDTH( WIDTH ) ) SP (.clk(clk), .load(sel_bus_c[3]), .rst(rst[4]), .data_in(bus_c), .data_out(muxb_in4));

    register #( .WIDTH( WIDTH ) ) PC (.clk(clk), .load(sel_bus_c[2]), .rst(rst[3]), .data_in(bus_c), .data_out(muxb_in1));

    register #( .WIDTH( WIDTH ) ) MDR (.clk(clk), .load(sel_bus_c[1]), .rst(rst[2]), .data_in(bus_c), .data_out(muxb_in0));

    register #( .WIDTH( WIDTH ) ) MAR (.clk(clk), .load(sel_bus_c[0]), .rst(rst[1]) ,.data_in(bus_c), .data_out(1'b0)); 

    // SPECIAL REGISTER
    register #( .WIDTH( WIDTH ), .WORD( WORD ) ) 
    MBR 
    (   
        .clk(clk),
        .rst(rst[0]),
        .load(1'b0), // change later when you go put the memory path
        .data_in(1'b0), //  change later when you go put the memory path
        .data_out1(muxb_in2),
        .data_out2(muxb_in3)
    );


    assign bus_b = wire_out_PC;
    assign bus_b = wire_out_MDR;

    integer i = 0;

    always @(*) begin : decoder_output_registers

        case (sel_bus_b)
            4'b0000 : bus_b = muxb_in0;
            4'b0001 : bus_b = muxb_in1;
            4'b0010 : bus_b = muxb_in2;
            4'b0011 : bus_b = muxb_in3;
            4'b0100 : bus_b = muxb_in4;
            4'b0101 : bus_b = muxb_in5;
            4'b0110 : bus_b = muxb_in6;
            4'b0111 : bus_b = muxb_in7;
            4'b1000 : bus_b = muxb_in8;
            default: 
        endcase

    end

endmodule