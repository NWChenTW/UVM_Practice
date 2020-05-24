class apb_driver extends uvm_driver #(apb_pkt);
    `uvm_component_utils(apb_driver)
    function new(string name="apb_drive", uvm_component parent = null);
        super.new (name, parent);
    endfunction

    virtual apb_if  m_vif;
    apb_cfg         m_cfg;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_vif = m_cfg.m_apb_vif;
    endfunction

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        m_vif.paddr     = 0;
        m_vif.psel      = 0;
        m_vif.pwdata    = 0;
        m_vif.penable   = 0;
        m_vif.pwrite    = 0;
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);

        forever begin
            seq_item_port.get_next_item(req);
            drive_item(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_item(REQ req);
        m_vif.paddr     = req.m_addr;
        m_vif.psel      = 1;
        m_vif.pwrite    = req.m_write;
        m_vif.pwdata    = req.m_wdata;
        m_vif.penable   = 0;

        @(m_vif.cb);
        m_vif.penable   = 1;
        
        do begin
            @(m_vif.cb);
        end while (! m_vif.cb.pready);
            
        if (! req.m_write)
            req.m_rdata = m_vif.cb.prdata;
        end
    endtask //drive_item
endclass