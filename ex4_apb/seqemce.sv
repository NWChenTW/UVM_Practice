class apb_seq extends uvm_sequence;
    `uvm_object_utils(apb_seq)
    function new(string name = "apb_seq");
        super.new(name);
    endfunction //new()

    virtual task body();
        `uvm_info(get_type_name(), $sfomatf("Start Sequence"), UVM_MEDUIM)
        repeat(10) begin
            apb_pkt m_apb_pkt = apb_pkt::type_id::create("m_apb_pkt");
            start_item(m_apb_pkt);
            m_apb_pkt.randomize();
            finish_item(m_apb_pkt);
        end
        `uvm_info(get_type_name(), $sfomatf("End Sequence"), UVM_MEDUIM)
    endtask
endclass //className