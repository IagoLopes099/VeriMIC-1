// interface to connect DUT and TestBench
`ifndef REG_IF
`define REG_IF

interface reg_if #( 
    parameter WIDTH = 32
)(
    input bit clk
); 

    logic [WIDTH-1:0] data_in, data_out;
    logic rst, load;

endinterface

`endif