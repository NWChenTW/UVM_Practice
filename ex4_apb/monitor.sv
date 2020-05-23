class apb_monitor extends uvm_monitor;
    `uvm_componenet_utils(monitor)
    function new(string name="apb_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    apb_cfg                         m_cfg;
    virtual apb_if                  m_vif;
    uvm_analysis_port #(apb_pkt)    m_analysis_port;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_port = new("m_analysis_port", this);
        m_vif = m_cfg.m_apb_vif;
    endfunction

    virtual task main_phase(uvm_phase phase);
        super.main_phase(phase);
        forever begin
            @(m_vif.cb);
            if (m_vif.psel & m_vif.penable & m_vif.cb.pready & m_vif.presetn) begin
                apb_pkt m_apb_pkt = apb_pkt::type_id::create("m_apb_pkt");
                m_apb_pkt.m_addr = m_vif.paddr;
                m_apb_pkt.m_write = m_vif.pwrite;

                if (m_cfg.m_vld_val_only) begin
                    if (m_apb_pkt.m_write)
                        m_apb_pkt.m_wdata = m_vif.pwdata;
                    else
                        m_apb_pkt.m_rdata = m_vif.prdata;
                end
                else begin
                    m_apb_pkt.m_wdata = m_vif.pwdata;
                    m_apb_pkt.m_rdata = m_vif.prdata;            
                end

                m_analysis_port.write (m_apb_pkt);
            end
        end
    endtask
endclass    