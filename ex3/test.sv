class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    env                 e0;
    bit[`LENGTH-1:0]    pattern = 4'b1011;
    gen_item_seq        seq;
    virtual des_if      vif;

    virtual function void build_phase(uvm_phase phase);
        sper.build_phase(phase);

        e0 = env::type_id::create("e0", this);

        if(!uvm_config_db#(virtual des_if)::get(this, "", "des_vif", vif))
            `uvm_fatal("TEST", "Did not get vif")
        uvm_config_db#(virtual des_if)::set(this, "e0.a0.*", "des_vif", vif);

        uvm_config_db#(bit[`LENGTH-1:0])::set(this, "*", "ref_pattern", pattern);

        seq = gen_item_seq::type_id::create("seq");
        seq.randomize();
    endfunction

    virtual task run_phase (uvm_phase phase);
        vif.rstn    <= 0;
        vif.in      <= 0;
        repeat(5) @ (posedge vif.clk);
        vif.rstn    <= 1;
        repeat(10) @ (posedge vif.clk);
    endtask //run_phas (uvm_phase phase);
endclass

class test_1011 extends base_test;
    `uvm_component_utils(test_1011)
    function new(string name="test_1011", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        pattern = 4'b1011;
        super.build_phase(phase);
        seq.randomize() with { num inside {[300:500]}; };
    endfunction
endclass

