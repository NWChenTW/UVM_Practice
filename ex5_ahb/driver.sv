class ahb_driver extends uvm_driver #(ahb_pkt);
    `uvm_comoponent_utils(ahb_driver)
    function  new(string name = "ahb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual ahb_if  m_vif;
    ahb_cfg         m_cfg;
    semaphore       m_sema4;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_vif = m_cfg.m_ahb_vif;
        m_sema4 = new(1);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this);
        m_vif.haddr     = 0;
        m_vif.hburst    = 0;
        m_vif.hmastlock = 0;
        m_vif.hprot     = 0;
        m_vif.hsize     = 0;
        m_vif.htrans    = 0;
        m_vif.hwdata    = 0;
        m_vif.hwrite    = 0;
        m_vif.hsel      = 0;
        phase.drop_objection(this);
    endtask //reset_phaseuvm_phase phase

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);

        fork
            drive("T1");
            drive("T2");
        join
    endtask

    virtual task automatic drive(string tag);
        forever begin
            m_sema4.get(1);
            seq_item_port.get_next_item(req);
            `uvm_info(get_type_name(), $sformatf("[drive] %s addr_phase for pkt addr=0x%0h", tag, req.m_haddr), UVM_MEDIUM)
            while (!m_vif.cb.hreadyout) begin
                @(m_vif.vb);
            end
            m_vif.haddr     = req.m_haddr;
            m_vif.hburst    = req.m_hburst;
            m_vif.hmastlock = req.m_hmastlock;
            m_vif.hprot     = req.m_hprot;
            m_vif.hsize     = req.m_hsize;
            m_vif.htrans    = req.m_htrans;
            m_vif.hwrite    = req.m_hwrite;
            m_vif.hsel      = 1;
            do begin
                @(m_vif.cb);
                    m_vif.htrans = IDLE;
            end while (!m_vif.cb.hreadyout);
                seq_item_port.item_done();
            m_sema4.put(1);

            `uvm_info(get_type_name(), $sformatf("[drive] %s data_phase for pkt addr=0x%0h", tag, req.m_haddr), UVM_MEDIUM)
            if (req.m_hwrite)
                m_vif.hwdata = req.m_hwdata;
            else
                req.m_hrdata = m_vif.hrdata;
        end
    endtask //automatic
endclass