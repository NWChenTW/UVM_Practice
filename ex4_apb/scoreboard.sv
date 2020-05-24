class base_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(base_scoreboard)
    function new(string name = "base_scoreaboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp #(apb_pkt, base_scoreboard) m_analysis_imp;
    apb_pkt m_apb_pkt_q[$];

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
    endfunction

    virtual function write(apb_pkt l_apb_pkt);
        `uvm_info(get_type_name(), $sformatf("[write] Got packet %s", l_apb_pkt.convert2string()),UVM_MEDIUM)
        m_apb_pkt_q.push_back(l_apb_pkt);
    endfunction
endclass