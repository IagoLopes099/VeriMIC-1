
class registerFileMem_agent extends uvm_agent;

    `uvm_component_utils(registerFileMem_agent)

    // CONSTRUCT 
    function new (string name = "registerFileMem_agent", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("AGENT_CLASS", "Inside Constructor!", UVM_HIGH);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase();
        `uvm_info("AGENT_CLASS", "Build Phase!", UVM_HIGH);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase();
        `uvm_info("AGENT_CLASS", "Connect Phase!", UVM_HIGH);
    endfunction

    task run_phase (uvm_phase phase)
        super.run_phase(phase);

        // logic
    endtask


endclass