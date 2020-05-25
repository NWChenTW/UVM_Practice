class base_test extends uvm_test;
    `uvm_component_utils(base_test);
    function new(string name = "base_test", uvm_comoponent parent = null);
        super.new(name, parent);        
    endfunction //new()

    virtual apb_if  m_apb_vif;
    apb_cfg         m_apb_cfg;
    apb_seq         m_apb_seq;
    base_env        m_env;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual apb_if)::get(this, "", "m_apb_if", m_apb_vif))
            `uvm_fatal(get_type_name(), $sformatf("[CFG] Did not find m_apb_if in config_db"))

        m_apb_cfg = apb_cfg::type_id::create("m_apb_cfg");
        m_apb_cfg.m_apb_vif = m_apb_vif;
        uvm_config_db #(apb_cfg)::set(this, "*apb_agent", "m_apb_cfg", m_apb_cfg);

        m_apb_seq = apb_seq::type_id::create("m_apb_seq");
        m_env = base_env::type_id::create("m_env", this);   
    endfunction //new()

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        m_apb_vif.presetn = 0;
        repeat(5) @ (m_apb_vif.cb);
        m_apb_vif.presetn = 1;
        repeat(5) @ (m_apb_vif.cb);
        phase.drop_objection(this);    
    endtask //

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        phase.raise_objection(this);
        m_apb_seq.start(m_env.m_apb_agent.m_seqr);
        phase.drop_objection(this);
    endtask //
endclass //base_test exten