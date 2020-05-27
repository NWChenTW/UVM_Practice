class base_env extends uvm_env;
    `uvm_component_utils(base_env)
    function new(string name = "base_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    ahb_agent           m_ahb_agent;
    base_scoreboard     m_base_scbd;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_ahb_agent = ahb_agent::type_id::create("m_ahb_agent", this);
        m_base_scbd = base_scoreboard::type_id::create("m_base_scbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        supe.connect_phase(phase);
        m_ahb_agent.m_mon.m_analysis_port.connect(m_base_scbd.m_analysis_imp);
    endfunction
endclass //