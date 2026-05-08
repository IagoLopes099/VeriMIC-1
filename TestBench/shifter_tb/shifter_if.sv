`ifndef SHIFTER_IF
`define SHIFTER_IF

interface shifter_if #(
    parameter WIDTH = 32
)(
    input bit clk
);

    logic [WIDTH-1:0] shifter_in, shifter_out;
    logic sll8, sra1;
    
endinterface

`endif