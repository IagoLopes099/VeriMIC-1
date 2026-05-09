`ifndef MBR_IF
`define MBR_IF

interface MBR_if #(
    parameter WORD = 8,
    parameter WIDTH = 32
)(
    input bit clk
);

    logic [WORD-1:0] data_in;
    logic load, rst;
    logic [WIDTH-1:0] data_out1 , data_out2;

endinterface

`endif 