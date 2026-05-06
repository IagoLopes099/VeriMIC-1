
module alu_top;
    
    localparam WIDTH_TOP = 32;

    alu_if #( .WIDTH(WIDTH_TOP) ) inter(); // interface

    alu # ( .WIDTH(WIDTH_TOP) ) alu_inst ( // DUT
        .inv_a(inter.inv_a),
        .en_a(inter.en_a),
        .en_b(inter.en_b),
        .inc(inter.inc),
        .sel(inter.sel),
        .in_a(inter.in_a),
        .in_b(inter.in_b),
        .alu_out(inter.alu_out),
        .overflow(inter.overflow),
        .is_zero(inter.is_zero),
        .is_neg(inter.is_neg)
    );

    alu_tb #(WIDTH_TOP) tb (inter); // TB

endmodule