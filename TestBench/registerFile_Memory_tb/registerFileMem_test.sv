class our_test extends uvm_test;

    `uvm_component_utils(our_test)

    // CONSTRUCT 
    function new (string name = "our_test", uvm_component parent = null);
        super.new(name, parent);
        
    endfunction

endclass