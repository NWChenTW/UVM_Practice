// Example Practice from https://www.chipverify.com/uvm/uvm-environment

class my_env extends uvm_env;
    `uvm_component_utils (my_env)

    agent_apb       m_apb_agt;
    agent_wishbone  m_wb_agt;

    env_register    m_reg_env;
    env_analog      m_analog_env[2];

    scoreboard      m_scbd;

    function new (string name = "my_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);

        m_apb_agt = agent_apb::type_id::create ("m_apb_agt", this);
        m_wb_agt = agent_wishbone::type_id::create ("m_wb_agt", this);

        m_reg_env = env_register::type_id::create ("m_reg_env", this);
        foreach (m_analog_env[i])
            m_analog_env[i] = env_analog::type_id::create ($sformatf("m_analog_env%d", m_analog_env[i]), this);
        
        m_scbd = scoreboard::type_id::create ("m_scbd", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
        super.connect_phase (phase);
        m_apb_agt.m_apb_mon.anlysis_port.connect (m_scbd.apb_export);
    endfunction    

endclass

