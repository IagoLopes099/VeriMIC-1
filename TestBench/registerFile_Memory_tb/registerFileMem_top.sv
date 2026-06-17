`include "umv_macros.svh"

import uvm_pkg::*; 

module registerFileMem_top();
    localparam WIDTH_TOP = 32;
    localparam WORD_TOP = 8;


    registerFile #( .WIDTH(WIDTH_TOP), .WORD(WORD_TOP)) regFile_inst();

endmodule

