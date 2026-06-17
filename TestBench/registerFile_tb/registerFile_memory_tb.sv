`ifndef _MEMORY_
    `define _MEMORY_
`endif 

module registerFile_tb #(
    parameter WIDTH = 32,
    parameter WORD = 8
)(
    registerFile_if.TEST regFileif
);  

    localparam MEMORY_SIZE = 536870912;
    logic [WORD-1:0] memory_tb [MEMORY_SIZE]; // memory block RAM
    logic [WIDTH-1:0] address;

    logic [WIDTH-1:0] regs [11]; // MAR, MDR, PC, MBR, MBRU, SP, LV, CPP, TOS, OPC, H

    logic [WORD-1:0] aux_word_MBR;

    // clk, bus_b, bus_a, memory_bus_out_MAR, memory_bus_out_MDR, memory_bus_out_PC,                -- INPUTS
    // rst, bus_c, sel_bus_b, sel_bus_c, write, read , memory_bus_in_MBR, memory_bus_in_MDR         -- OUTPUT
    logic [WIDTH-1:0] exp_bus_b, exp_bus_a, exp_mem_MAR, exp_mem_out_MDR, exp_mem_out_PC;

    logic write_tb, read_tb;
    

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

    always @(posedge regFileif.clk) begin : golden_model_A_BUS_refence
        exp_bus_a <= regs[10]; // H
    end 


    always @(posedge regFileif.clk) begin : golden_model_memory_reference
        if (regFileif.read && regFileif.sel_bus_b == 0) begin
            exp_bus_b <= memory_tb[address : address+3];
        end
        else if (regFileif.write) begin
            exp_mem_out_MDR <= regs[1];
        end
        else if (regFileif.fetch && regFileif.sel_bus_b == 2) begin
            exp_bus_b[8:0] <= memory_tb[address];
        end
    end




/*===========================================================================================*/

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
        if  (exp_mem_MAR !== regFileif.memory_bus_out_MAR || exp_bus_b !== regFileif.bus_b) begin 
            
            $display("Error at a time : %0d", $time);

            if (exp_mem_MAR !== regFileif.memory_bus_out_MAR) begin : CHECK_MAR
                $display("memory_bus_out_MAR : %b", regFileif.memory_bus_out_MAR);
                $display("And should be : %b", exp_mem_MAR);
                $finish;
            end

            if(exp_bus_b !== regFileif.bus_b) begin
                $display("Error at a time : %0d", $time);
                $display("bus_B : %b, sel_bus_b : %b",regFileif.bus_b, regFileif.sel_bus_b);
                $display("And should be : %b", exp_bus_b);
                $finish;
            end

        end
        else begin
            $display("At a time : %0d, bus_B : %b, sel_bus_b : %b", $time, regFileif.bus_b, regFileif.sel_bus_b);
            $display("At a time : %0d, Memory_out_MAR : %b", $time, egFileif.memory_bus_out_MAR);
        end

    endtask

/*===========================================================================================*/

    initial begin

        
        for (integer i = 0 ; i < MEMORY_SIZE ; i++) begin : Initialization_MEMORY
            memory_tb[i] = $urandom;
        end
        

        for (integer i = 0; i < 11; i++) begin : Initialization_REGISTERS
            regs[i] = 0;
        end
        
        regFileif.rst = 0; // full reset 
        regFileif.sel_bus_c = 0; // reset decoder

        // DISABLE MEMORY FLAGS
        regFileif.write = 0;
        regFileif.read = 0;
        regFileif.fetch = 0;


        repeat (2) @(posedge regFileif.clk);


        regFileif.rst = 10'b1111_111_111; // disable reset

        aux_word_MBR = $urandom;

        for (integer i = 0 ; i < 11 ; i++) begin // generating random numbers to registers vector

            if (i < 3 || i > 4)
                regs[i] = $urandom;
            else begin 
                if (i == 3)  // MBR
                    regs[i] = {{WIDTH-WORD{1'b0}},aux_word_MBR};
                else if (i == 4)  // MBRU
                    regs[i] = {{WIDTH-WORD{aux_word_MBR[WORD-1]}},aux_word_MBR};
            end

            $display("regs[%d] : %b",i, regs[i]);
        end


        for (integer i = 0 ; i < 10 ; i++) begin // putting the values by C bus in real registers
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

            @(posedge regFileif.clk); // rising edge to safe in registers
            
            regFileif.sel_bus_c = 0;
            
            @(posedge regFileif.clk);
            
        end


        repeat (100) begin
            
            `ifdef _MEMORY_
            @(negedge regFileif.clk);

            regFileif.bus_c = $urandom;
            regFileif.sel_bus_c = 0;
            @(negedge regFileif.clk);

            regFileif.bus_c = $urandom;
            regFileif.sel_bus_c = 2;
            @(negedge regFileif.clk);

            `endif

            @(negedge regFileif.clk);
            
            regFileif.sel_bus_b = $urandom_range(0,8);

            @(negedge regFileif.clk);

            regFileif.read = $urandom_range(0,1);

            @(negedge regFileif.clk);

            exp_memory();
            regFileif.write = $urandom_range(0,1);

            @(negedge regFileif.clk);
            
            exp_memory();
            regFileif.fetch = $urandom_range(0,1);

            @(negedge regFileif.clk);

            exp_memory();
            //exp_bus_B();
            //exp_bus_A();

        end

        $display("Test Passed");
        $finish;
    end

endmodule