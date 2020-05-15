class my_virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils (my_virtual_sequencer)

    function new (string name = "my_virtual_sequencer", uvm_component parent);
        super.new (name, parent);
    endfunction

    apb_sequencer   m_apb_seqr;
    reg_sequencer   m_reg_seqr;
    wb_sequencer    m_wb_seqr;
    pcie_sequencer  m_pcie_seqr;
endclass