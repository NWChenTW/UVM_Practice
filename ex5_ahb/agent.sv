class ahb_agent extends uvm_agent;
    `uvm_component_utils(ahb_agent);
    function new(string name = "ahb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    ahb_cfg                     m_cfg;
    ahb_driver                  m_drv;
    ahb_monitor                 m_mon;
    uvm_sequencer #(ahb_pkt)    m_seqr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        if(!uvm_config_db #(ahb_cfg)::get(this, "", "m_ahb_cfg", m_cfg))
            `uvm_fatal(get_type_name(), $sformatf("[CFG] Did not find m_ahb_cfg in config_db"))
        
        if (get_is_active()) begin
            m_drv = ahb_driver::type_id::create("m_drv", this);
            m_seqr = uvm_sequencer#(ahb_pkt)::type_id::create("m_seqr", this);
        end

        m_mon = ahb_monitor::type_id::create("m_mon", this);

        m_drv.m_cfg = m_cfg;
        m_mon.m_cfg = m_cfg;
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if (get_is_active) begin
            m_drv.seq_item_port.connect(m_seqr.seq_item_export);
        end
    endfunction
endclass
