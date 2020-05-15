

class my_driver extends uvm_driver #(my_data);
    `uvm_component_utils(my_driver)

    virtual dut_if vif;

    function new (string name, uvm_component parent);
        super.new = (name, parent);      
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        if (!uvm_config_db #(virtual dut_if)::get (this, "", "vif", vif))begin
            `uvm_fatal (get_type_name(), "Didn't get handle to virtual interface dut_if")
        end        
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase (phase);
        forever begin
            `uvm_info (get_type_name(), $sformatf ("Waiting for data from sequencer"), UVM_MEDIUM)
            seq_item_port.get_next_item (data_obj);
            drive_item (data_obj);
            seq_item_port.item_done();
        end
    endtask 

    virtual task drive_item (my_data data_obj);

    endtask
endclass
    
