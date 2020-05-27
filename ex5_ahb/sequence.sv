class ahb_seq extends uvm_sequence;
    `uvm_object_utils(ahb_seq)
    function new(string name = "ahb_seq");
        super.new(name);
    endfunction //new()

    int m_loop = 3;

    virtual task body();
        `uvm_info(get_type_name(), $sformatf("Start Sequence"), UVM_MEDIUM)
        repqet (m_loop) begin
            ahb_pkt m_ahb_pkt = ahb_pkt::type_id::create("m_ahb_pkt");
            start_item(m_ahb_pkt);
            m_ahb_pkt.randomize() with { m_hwrite == WRITE; };
            finish_item(m_ahb_pkt);
            m_ahb_pkt.print();
        end
        #100;
        `uvm_info(get_type_name(), $sformatf("End Sequence"), UVM_MEDIUM)
    endtask
endclass //ahb_seq extends 
