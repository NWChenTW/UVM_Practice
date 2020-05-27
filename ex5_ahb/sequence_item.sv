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

    rand byte unsigned  m_num_txfr;
    rand bit [31:0]     m_start_addr;
    rand e_hburst       m_hburst;
    rand bit            m_hmastlock;
    rand e_hprot        m_hprot;
    rand e_hsize        m_hsize;

    rand e_htrans       m_htrans;
    rand e_hwrite       m_hwrite;
    rand ahb_addr_data  m_addr_data_q[$];
    e_hresp             m_hresp;

    `uvm_object_utils_begin(ahb_pkt)
        `uvm_field_int (m_start_addr, UVM_PRINT)
        `uvm_field_int (m_num_txfr, UVM_PRINT|UVM_DEC)
        `uvm_field_enum (e_hburst, m_hburst, UVM_PRINT)
        `uvm_field_int (m_hmastlock, UVM_PRINT)
        `uvm_field_enum (e_hprot, m_hprot, UVM_PRINT)
        `uvm_field_enum (e_hsize, m_hsize, UVM_PRINT)
        `uvm_field_enum (e_htrans, m_htrans, UVM_PRINT)
        `uvm_field_enum (e_hwrite, m_hwrite, UVM_PRINT)
        `uvm_field_enum (e_hresp, m_hresp, UVM_PRINT)
        `uvm_field_queue_object (m_addr_data_q, UVM_PRINT)
    `uvm_object_utils_end

    constraint c_default {  !(m_htrans inside {SEQ, IDLE, BUSY});
                            m_start_addr % 4 == 0;
                            soft m_hsize inside {[1:2]}; 
                        }

    constraint c_addr_data_q {
        if (m_hburst == SINGLE) { m_addr_data_q.size() == 1; m_num_txfr == 1; }
        if (m_hburst == INCR) { m_addr_data_q.size() == m_num_txfr; }
        if (m_hburst == INCR4 || m_hburst == WRAP4) { m_addr_data_q.size() == 4; m_num_txfr = 4; }
        if (m_hburst == INCR8 || m_hburst == WRAP8) { m_addr_data_q.size() == 8; m_num_txfr = 8; }
        if (m_hburst == INCR16 || m_hburst == WRAP16) { m_addr_data_q.size() == 16; m_num_txfr = 16; }
    }
    
    function void post_randomize();
        int l_next_addr = m_start_addr;

        foreach (m_addr_data_q[i]) begin
            m_addr_data_q[i] = ahb_addr_data::type_id::create($sformatf("m_addr_data_q[%0d]", i));
            if (m_hburst inside {INCR, INCR4, INCR8, INCR16}) begin
                m_addr_data_q[i].randomize() with { m_addr == m_start_addr + i * (2 ** m_hsize); };
            end
            
            if (m_hburst inside {WRAP4, WRAP8, WRAP16}) begin
                byte l_hburst;
                byte l_wrap_bd;
                case(m_hburst)
                    WRAP4   : l_hburst = 4;
                    WRAP8   : l_hburst = 8;
                    WRAP16  : l_hburst = 16;
                endcase
                l_wrap_bd = l_hburst * 2 ** m_hsize;

                `uvm_info(get_type_name(), $sformatf("[post_randomize] %s start=0x%0h next_addr=0x%0h wrap_bd=0x%0h",
                                                        m_hburst.name(), m_start_addr, l_next_addr, l_wrap_bd), UVM_HIGH)
                
                if (((l_next_addr % l_wrap_bd) == 0) && (l_next_addr != m_start_addr))
                    l_next_addr = l_next_addr - l_wrap_bd;

                    `uvm_info(get_type_name(), $sformatf("[pose_randomize] %s start=0x%0h next_addr=0x%0h wrap_bd=0x%0h",
                                                            m_hburst.name(), m_start_addr, l_next_addr, l_wrap_bd), UVM_HIGH)
                    
                    m_addr_data_q[i].randomize() with { m_addr == l_next_addr; };
                    l_next_addr = m_addr_data_q[i].m_addr + (2 ** m_hsize);
                    `uvm_info(get_type_name(), $sformatf("[pose_randomize] %s start=0x%0h next_addr=0x%0h wrap_bd=0x%0h addr=0x%0h",
                                                            m_hburst.name(), m_start_addr, l_next_addr, l_wrap_bd, m_addr_data_q[i].m_addr), UVM_MEDIUM)
            end
        end
    endfunction


    virtual function string convert2string();
        foreach (m_addr_data_q[i])begin
            return $sformatf("addr=0x%h write=0x%0h data=0x%0h", m_addr_data_q[i].m_addr, m_hwrite, m_addr_data_q[i].m_data);
        end
    endfunction
endclass //className

class ahb_addr_data extends uvm_object;
    rand bit [31:0] m_addr;
    rand bit [31:0] m_data;

    `uvm_object_utils_begin(ahb_addr_data)
        `uvm_field_int  (m_addr, UVM_PRINT);
        `uvm_field_int  (m_data, UVM_PRINT);
    `uvm_object_utils_end

    function new (string name = "ahb_addr_data");
        super.new(name);
    endfunction
endclass