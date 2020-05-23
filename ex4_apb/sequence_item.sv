class apb_pkt extends uvm_sequence_item;
    function new(string name = "apb_pkt");
        super.new (name);
    endfunction //new()

    rand bit [15:0] m_addr;
    rand bit [31:0] m_wdata;
         bit [31:0] m_rdata;
    rand bit        m_write;

    `uvm_object_utils_begin(apb_pkt)
        `uvm_field_int (m_addr, UVM_DEFAULT)
        `uvm_field_int (m_wdata,UVM_DEFAULT)
        `uvm_field_int (m_rdata,UVM_DEFAULT)
        `uvm_field_int (m_write,UVM_DEFAULT)
    `uvm_object_utils_end

    virtual function string convert2string();
        return $sformatf("addr=0x%0h write=0x%0h wdata=0x%0h rdata=0x%0h", m_addr, m_write, m_wdata, m_rdata);
    endfunction
endclass //apb_pkt extends uvm_sequence_item