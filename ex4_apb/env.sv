class base_env extends uvm_env;
    `uvm_comoponent_utils(base_env)
    function new(string name = "base_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    apb_agent           m_apb_agent;
    base_scoreboard     m_base_scbd;

    virtual function void build_phase(phase);
        super.build_phase(phase);
        m_apb_agent = apb_agent::type_id::create("m_apb_agent", this);
        m_base_scbd = base_scoreboard::type_id::create("m_base_scbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        m_apb_agent.m_mon.m_analysis_port.connect(m_base_scbd.m_analysis_imp);
    endfunction
endclass //base_env extends uvm_env;
