class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)
    function  new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    apb_cfg                     m_cfg;
    apb_driver                  m_drv;
    apb_monitor                 m_mon;
    uvm_sequencer #(apb_pkt)    m_seqr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(apb_cfg)::get(this, "*", "m_apb_cfg", m_cfg))
            `uvm_fatal(get_type_name(), $sformatf("[CFG] Did not find m_apb_cfg in config_db"))

        if (get_is_active()) begin
            m_drv = apb_driver::type_id::create("m_drv", this);
            m_seqr = uvm_sequencer#(apb_pkt)::type_id::create("m_seqr", this);
        end

        m_mon = apb_monitor::type_id::create("m_mon", this);

        m_drv.m_cfg = m_cfg;
        m_mon.m_cfg = m_cfg;

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(get_is_active) begin
            m_drv.seq_item_port.connect(m_seqr.seq_item_export);
        end
    endfunction
endclass