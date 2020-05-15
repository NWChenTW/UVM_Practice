// Example Practice from https://www.chipverify.com/uvm/uvm-agent

class my_agent extends uvm_agent;
    `ucm_component_utils(my_agent)

    my_driver                   m_drv0;
    my_monitor                  m_mon0;
    uvm_sequencer #(my_data)    m_seqr0;
    agent_cfg                   m_agt_cfg;

    function new (string name = "my_agent", uvm_component parent = null);
        super.new (name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);

        uvm_config_db #(agent_cfg)::get (this,"*","agt_cfg", m_agt_cfg);

        if (get_is_active())begin
            m_seqr0 = uvm_sequencer#(my_data)::type_id::create("m_seqr0", this);
            m_drv0 = my_driver::type_id::create("m_drv0", this);
            m_drv0.vif = m_agt_cfg.vif
        end
        m_mon0 = my_monitor::type_id::create ("m_mon0", this);
        m_mon0.vif = m_agt_cfg.vif;
    endfunction

    virtual function void connect_phase (uvm_phase phase);
        if (get_is_active())
            m_drv0.seq_item_port.connect (m_seqr0.seq_item_export);
    endfunction
endclass