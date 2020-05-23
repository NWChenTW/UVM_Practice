class apb_driver extends uvm_driver #(apb_pkt);
    `uvm_component_utils(apb_driver)
    function new(string name="apb_drive", uvm_component parent = null);
        super.new (name, parent);
    endfunction

    virtual apb_if  m_vif;
    apb_cfg         m_cfg;

    vi