
class registerFileMem_sequencer extends uvm_sequencer#(registerFileMem_sequence_item);

    `uvm_component_utils(registerFileMem_sequencer)

    // CONSTRUCT 
    function new (string name = "registerFileMem_sequencer", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("SEQUENCER_CLASS", "Inside Constructor!", UVM_HIGH);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase();
        `uvm_info("SEQUENCER_CLASS", "Build Phase!", UVM_HIGH);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase();
        `uvm_info("SEQUENCER_CLASS", "Connect Phase!", UVM_HIGH);
    endfunction

    task run_phase (uvm_phase phase)
        super.run_phase(phase);

        // logic
    endtask


endclass