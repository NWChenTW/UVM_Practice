// Example Practice from https://www.chipverify.com/uvm/uvm-scoreboard

class my_scoreboard extends uvm_scoreboard;
    `uvm_component_utils (my_scoreboard)
    function new(string name = "my_scoreboard", uvm_component parent = null);
        super.new (name, parent);
    endfunction //new()

    uvm_analysis_imp #(apb_pkt, my_scoreboard) apb_export;

    function void build_phase (uvm_phase phase);
        apb_export = new ("apb_export", this);
    endfunction

    virtual function void write (apb_pkt data);
        `uvm_info ("write", $sformatf("Data received = 0x%0h", data), UVM_MEDIUM)
    endfunction

    virtual task run_phase (uvm_phase phase);

    endtask

    virtual function void check_phase (uvm_phase phase);

    endfunction

endclass