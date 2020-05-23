class  apb_cfg extends uvm_object;
    `uvm_object_utils(apb_cfg)
    function new(string name = "apb_cfg");
        super.new(name);
    endfunction //new()

    virtual apb_if m_apb_vif;
    bit     m_vld_val_only;
endclass // apb_cfg extends uvm_object