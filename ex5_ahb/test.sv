class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);        
    endfunction //new()

    virtual ahb_if      m_ahb_vif;
    
    ahb_cfg             m_ahb_cfg;
    ahb_seq             m_ahb_seq;
    base_env            m_env;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db #(virtual ahb_if)::get(this, "", "m_ahb_if", m_ahb_vif))
            `uvm_fatal(get_type_name(), $sformatf("[CFG] Did not find m_ahb_if in config_db"))

        m_ahb_cfg = ahb_cfg::type_id::create("m_ahb_cfg");
        m_agb_cfg.m_ahb_vif = m_ahb_vif;
        uvm_config_db #(ahb_cfg)::set(this, "*ahb_agent", "m_ahb_cfg", m_ahb_cfg);

        m_ahb_seq = ahb_seq::type_id::create("m_ahb_seq");
        m_env = base_env::type_id::create("m_env", this);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        m_ahb_vif.hresetn = 0;
        repeat(5) @ (m_ahb_vif.cb);
        m_ahb_vif.hresetn = 1;
        repeat(5) @ (m_ahb_vif.cb)
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase)
        super.main_phase(phase);
        phase.raise_objection(this);
        m_ahb_seq.start(m_env.m_ahb_agent.m_seqr);
        phase.drop_objection(this);
    endtask //automatic
endclass //className extends superClass