class ahb_cfg extends uvm_object;
    `uvm_object_utils(ahb_cfg)
    function new(string name = "ahb_cfg");
        super.new(name);
    endfunction

    virtual ahb_if  m_ahb_vif;
    bit             m_vld_val_only;
endclass