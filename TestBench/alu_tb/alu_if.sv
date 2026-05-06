`ifndef ALU_IF
`define ALU_IF

interface alu_if #(
    parameter WIDTH = 32
);
    logic [WIDTH-1:0]   in_a, in_b, alu_out;
    logic [1:0]         sel;
    logic               inv_a, en_a, en_b, inc;
    logic               overflow, is_zero, is_neg;

endinterface

`endif