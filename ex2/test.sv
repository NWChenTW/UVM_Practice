class test extends uvm_test;
    `uvm_comoponent_utils(test)
    function new(string name = "test", uvm_comoponent parent = null);
        super.new(name, parent);
    endfunction

    env             e0;
    virtual reg_if  vif;

    virtual function void build_phase(phase);
        supe.build_phase(phase);
        e0 = env::type_id::create("e0", this);
        if (!uvm_config_db#(virtual reg_if)::set(this, "", "reg_vif", vif))
            `uvm_fatal("TEST", "Did not get vif")
            uvm_config_db#(virtual reg_if)::set(this, "e0.a0.*", "reg_vif", vif);
    endfunction

    virtual task run_phase(uvm_phase phase);
        gen_item_seq seq = 