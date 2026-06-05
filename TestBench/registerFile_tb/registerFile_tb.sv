`ifndef DECODER
    `ifndef SELECTOR 
        `ifndef A_BUS   
            `define DECODER
            `define SELECTOR
            `define A_BUS
        `endif
    `endif
`endif


module registerFile_tb #(
    parameter WIDTH = 32,
    parameter WORD = 8
)(
    registerFile_if.TEST regFileif
);  

    localparam MEMORY_SIZE = 134217728;
    logic [WIDTH-1:0] memory_tb [MEMORY_SIZE]; // memory block RAM

    logic [WIDTH-1:0] regs [11]; // MAR, MDR, PC, MBR, MBRU, SP, LV, CPP, TOS, OPC, H

    logic [WORD-1:0] aux;

    // clk, bus_b, bus_a, memory_bus_out_MAR, memory_bus_out_MDR, memory_bus_out_PC,                -- INPUTS
    // rst, bus_c, sel_bus_b, sel_bus_c, write, read , memory_bus_in_MBR, memory_bus_in_MDR         -- OUTPUT
    logic [WIDTH-1:0] exp_bus_b, exp_bus_a, exp_mem_MAR, exp_mem_MDR, exp_mem_PC;

    logic write_tb, read_tb;
    
    `ifdef DECODER 
    always @(posedge regFileif.clk) begin : golden_model_decoder_refence
        case (regFileif.sel_bus_b)
            0 : exp_bus_b <= regs[1]; // MDR
            1 : exp_bus_b <= regs[2]; // PC
            2 : exp_bus_b <= regs[3]; // MBR
            3 : exp_bus_b <= regs[4]; // MBRU
            4 : exp_bus_b <= regs[5]; // SP
            5 : exp_bus_b <= regs[6]; // LV
            6 : exp_bus_b <= regs[7]; // CPP
            7 : exp_bus_b <= regs[8]; // TOS
            8 : exp_bus_b <= regs[9]; // OPC
        endcase 
    end

    /*
    always @(posedge regFileif.clk) begin : golden_model_memory_reference
        if (regFileif.read) begin
            
        end
        else if (regFileif.write) begin

        end
    end
    */

    `endif


    `ifdef A_BUS
        always @(posedge regFileif.clk) begin : golden_model_A_BUS_refence
            exp_bus_a <= regs[9]; // H
        end 
    `endif


    `ifdef SELECTOR
    always @(posedge regFileif.clk) begin : golden_model_selector_refence
        if (sel_bus_c[0])
            exp
        else if (sel_bus_c[1])

    end 
    `endif





    task exp_bus_A;
        if(exp_bus_a !== regFileif.bus_a) begin
            $display("Error at a time : %0d", $time);
            $display("bus_A : %b",regFileif.bus_a);
            $display("And should be : %b", exp_bus_a);
            $finish;
        end

        else begin

            $display("At a time : %0d, bus_A : %b", $time, regFileif.bus_a);
        end
    endtask

    task exp_bus_B;

        if(exp_bus_b !== regFileif.bus_b) begin
            $display("Error at a time : %0d", $time);
            $display("bus_B : %b, sel_bus_b : %b",regFileif.bus_b, regFileif.sel_bus_b);
            $display("And should be : %b", exp_bus_b);
            $finish;
        end

        else begin

            $display("At a time : %0d, bus_B : %b, sel_bus_b : %b", $time, regFileif.bus_b, regFileif.sel_bus_b);

        end
    endtask

    task exp_bus; // BUS_B AND BUS_A 
        
        exp_bus_A();
        exp_bus_B();

    endtask


    task exp_memory; 
        if  (exp_mem_MAR !== regFileif.memory_bus_out_MAR ||
             exp_mem_MDR !== regFileif.memory_bus_out_MDR || exp_mem_PC !== regFileif.memory_bus_out_PC) begin 
            
            $display("Error at a time : %0d", $time);

            if (exp_mem_MAR !== regFileif.memory_bus_out_MAR) begin : CHECK_MAR
                $display("memory_bus_out_MAR : %b", regFileif.memory_bus_out_MAR);
                $display("And should be : %b", exp_mem_MAR);
            end

            if (exp_mem_MDR !== regFileif.memory_bus_out_MDR) begin : CHECK_MDR
                $display("memory_bus_out_MDR : %b", regFileif.memory_bus_out_MDR);
                $display("And should be : %b", exp_mem_MDR);
            end

            if (exp_mem_PC !== regFileif.memory_bus_out_PC) begin : CHECK_UPC
                $display("memory_bus_out_PC : %b", regFileif.memory_bus_out_PC);
                $display("And should be : %b", exp_mem_PC);
            end


            $finish;
        end
    endtask


    integer list_regs[7] = {0,1,4,5,6,7,8};


    initial begin

        /*
        for (integer i = 0 ; i < MEMORY_SIZE ; i++) begin : Initialization_MEMORY
            memory_tb[i] = $urandom;
        end
        */

        for (integer i = 0; i < 11; i++) begin : Initialization_REGISTERS
            regs[i] = 0;
        end
        
        regFileif.rst = 0; // full reset 
        regFileif.sel_bus_c = 0; // reset decoder

        repeat (2) @(posedge regFileif.clk);
        
        regFileif.rst = 9'b111_111_111; // disable reset

        aux = $urandom;

        for (integer i = 0 ; i < 11 ; i++) begin 
            
            // generating random numbers to registers vector
            if (i < 3 || i > 4)
                regs[i] = $urandom;
            else begin 
                if (i == 3)  // MBR
                    regs[i] = {{WIDTH-WORD{1'b0}},aux};
                else if (i == 4)  // MBRU
                    regs[i] = {{WIDTH-WORD{aux[WORD-1]}},aux};
            end

            $display("regs[%d] : %b",i, regs[i]);
        end

        for (integer i = 0 ; i < 10 ; i++) begin
            
            // putting the values by C bus in real registers
            if (i < 3) begin
                regFileif.bus_c = regs[i];
                regFileif.sel_bus_c[i] = 1'b1;
            end
            else if (i > 3) begin
                regFileif.bus_c = regs[i+1];
                regFileif.sel_bus_c[i-1] = 1'b1;
            end
            else if (i == 3) begin
                regFileif.memory_bus_in_MBR = regs[i][WORD-1:0];

            end

            $display("Bus_C : %b, sel_bus_c : %b",regFileif.bus_c, regFileif.sel_bus_c);

            #1; @(posedge regFileif.clk); // rising edge to safe in registers
            
            regFileif.sel_bus_c = 0;
            
            @(posedge regFileif.clk);
            
        end

        // $display("regs[%d] : %b, Bus_C : %b, sel_bus_c : %b",i, regs[i], regFileif.bus_c, regFileif.sel_bus_c);

        repeat (100) begin

            @(negedge regFileif.clk);
            
            regFileif.sel_bus_b = $urandom_range(0,8);

            @(negedge regFileif.clk);

            exp_bus_B();

        end

        $display("Test Passed");
        $finish;
    end

endmodule