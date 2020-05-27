class ahb_driver extends uvm_driver #(ahb_pkt);
    `uvm_comoponent_utils(ahb_driver)
    function  new(string name = "ahb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual ahb_if  m_vif;
    ahb_cfg         m_cfg;
    semaphore       m_sema4;
    semaphore       m_sub_sema4;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_vif = m_cfg.m_ahb_vif;
        m_sema4 = new(1);
        m_sub_sema4 = new(1);
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
            drive_txfr("T1");
            drive_txfr("T2");
        join
    endtask

    virtual task automatic drive_txfr(string tag);
        forever begin
            m_sema4.get(1);
            seq_item_port.get_next_item(req);
            drive_pkt(tag, req);
            m_sema4.put(1);
            seq_item_port.item_done();
        end
    endtask

    virtual task automatic drive_pkt(string tag, REQ l_req);
        foreach (l_req.m_addr_data_q[i]) begin
            m_sub_sema4.get(1);      
            `uvm_info(get_type_name(), $sformatf("[drive] %s Iter%0d addr_phase for pkt addr=0x%0h", tag, i, l_req.m_addr_data_q[i].m_addr), UVM_HIGH)
            while (!m_vif.cb.hreadyout) begin
                @(m_vif.vb);
            end
            m_vif.haddr     = l_req.m_addr_data_q[i].m_addr;
            m_vif.hburst    = l_req.m_hburst;
            m_vif.hmastlock = l_req.m_hmastlock;
            m_vif.hprot     = l_req.m_hprot;
            m_vif.hsize     = l_req.m_hsize;
            m_vif.hwrite    = req.m_hwrite;
            m_vif.hsel      = 1;
            
            if (l_req.m_htrans == NONSEQ) begin
                if (i == 0) 
                    m_vif.htrans = NONSEQ;
                else
                    m_vif.htrans = SEQ;
            end
            else begin
                m_vif.htrans = l_req.m_htrans;
            end

            do begin
                @ (m_vifcb);
            end while (!m_vif.cb.hreadyout);
                seq_item_port.item_done();
            
            m_sub_sema4.put(1);

            `uvm_info(get_type_name(), $sformatf("[drive] %s Iter%0d data_phase for pkt addr=0x%0h", tag, i, l_req.m_addr_data_q[i].m_addr), UVM_HIGH)
            if (l_req.m_hwrite)
                m_vif.hwdata = l_req.m_addr_data_q[i].m_data;
            else
                l_req.m_addr_data_q[i].m_data = m_vif.hrdata;
        end
        m_vif.htrans = IDLE;
    endtask //automatic
endclass