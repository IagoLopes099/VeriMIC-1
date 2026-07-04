
class registerFileMem_driver extends uvm_driver#(registerFileMem_sequence_item);

    `uvm_component_utils(registerFileMem_driver)

    // CONSTRUCT 
    function new (string name = "registerFileMem_driver", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("DRIVER_CLASS", "Inside Constructor!", UVM_HIGH);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase();
        `uvm_info("DRIVER_CLASS", "Build Phase!", UVM_HIGH);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase();
        `uvm_info("DRIVER_CLASS", "Connect Phase!", UVM_HIGH);
    endfunction

    task run_phase (uvm_phase phase)
        super.run_phase(phase);

        // logic
    endtask


endclass