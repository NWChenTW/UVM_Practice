// Example Practice from https://www.chipverify.com/uvm/how-to-create-and-use-a-sequence

class base_sequence extends uvm_sequence #(my_data);
    `uvm_object_utils (base_sequence)
    `uvm_declare_p_sequencer (my_sequencer)

    my_data data_obj;
    int unsigned n_times = 1;

    function new (string name = "base_sequence");
        super.new(name);
    endfunction

    virtual task pre_body();
        `uvm_info ("BASE_SEQ", $sformatf ("Optional code can be placed here in pre_body()"), UVM_MEDIUM)
        if (starting_phase != null)
            starting_phase.raise_objection (this);
    endtask

    virtual task body ();
        `uvm_info ("BASE_SEQ", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
        data_obj = my_data::type_id::create ("data_obj");

        repeat (n_times) begin
            start_item(data_obj);
            assert (data_obj.randomize());
            finish_item (data_obj);
        end
        `uvm_info (get_type_name (), $sformatf ("Sequence %s is over", this.get_name()), UVM_MEDIUM)
    endtask

    virtual task post_body ();
        `uvm_info ("BASE_SEQ", $sformatf ("Optional code can be placed here in post_body()"), UVM_MEDIUM)
        if (starting_phase != null)
            starting_phase.drop_objection (this);
    endtask