class base_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(base_scoreboard);
    function new(string name = "base_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction //new()

    uvm_analysis_imp #(ahb_pkt, base_scoreboard)    m_analysis_imp;
    ahb_pkt                                         m_ahb_pkt_q[$];

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
    endfunction

    virtual function write(ahb_pkt l_ahb_pkt);
        `uvm_info(get_type_name(), $sformatf("[write] Got packet %s", l_ahb_pkt.convert2string()), UVM_MEDIUM)
        m_ahb_pkt_q.push_back(l_ahb_pkt);
    endfunction
endclass //className