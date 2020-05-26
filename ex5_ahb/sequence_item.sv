typedef enum bit [1:0] { IDLE, BUSY, NONSEQ, SEQ } e_htrans;
typedef enum bit [2:0] { BYTE, HALF_WORD, WORD, WORD_2, WORD_4, WORD_8, WORD_16, WORD_32} e_hsize;
typedef enum bit [2:0] { SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16, INCR16 } e_hburst;
typedef enum bit [3:0] { OPCODE_FETCH, DATA_ACCESS, USER_ACCESS, PRIVELEGED, NON_BUFFERABLE, BUFFERABLE, NON_CACHEABLE, CACHEABLE } e_hprot;
typedef enum bit { OKAY, ERROR } e_hresp;
typedef enum bit { READ, WRITE } e_hwrite;

class ahb_pkt extends uvm_sequence_item;
    function new(string name = "ahb_pkt");
        super.new(name);
    endfunction //new()

    rand bit [15:0]     m_haddr;
    rand e_hburst       m_hburst;
    rand bit            m_hmastlock;
    rand e_hprot        m_hprot;
    rand e_hsize        m_hsize;

    rand e_htrans       m_htrans;
    rnad bit [31:0]     m_hwdata;
    rand e_hwrite       m_hwrite;

    bit [31:0]          m_hrdata;
    e_hresp             m_hresp;

    `uvm_object_utils_begin(ahb_pkt)
        `uvm_field_int (m_haddr, UVM_PRINT)
        `uvm_field_enum (e_hburst, m_hburst, UVM_PRINT)
        `uvm_field_int (m_hmastlock, UVM_PRINT)
        `uvm_field_enum (e_hprot, m_hprot, UVM_PRINT)
        `uvm_field_enum (e_hsize, m_hsize, UVM_PRINT)
        `uvm_field_enum (e_htrans, m_htrans, UVM_PRINT)
        `uvm_field_int (m_hwdata, UVM_PRINT)
        `uvm_field_enum (e_hwrite, m_hwrite, UVM_PRINT)
        `uvm_field_int (m_hrdata, UVM_PRINT)
        `uvm_field_enum (e_hresp, m_hresp, UVM_PRINT)
    `uvm_object_utils_end

    constraint c_default {  m_htrans == NONSEQ;
                            m_hsize == WORD;
                            m_hburst == SINGLE; }
    
    virtual function string convert2string();
        return $sformatf("addr=0x%h write=0x%0h wdata=0x%0h rdata=0x%0h", m_haddr, m_hwrite, m_hwdata, m_hrdata);
    endfunction
endclass //className