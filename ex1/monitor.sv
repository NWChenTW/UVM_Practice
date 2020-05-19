class monitor extends uvm_monitor;
    `uvn_component_utils (monitor)
    function new(string name="monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()

    uvm_analysis_port #(reg_item) mon_analysis_port;
    virtual reg_if vif;
    semaphore sema4;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        if(!uvm_config_db#(virtual reg_if)::get(this, "", "reg_if", vif))
            `uvm_fatal("MON", "Could not get vif")
            sema4 = new();
            mon_analysis_port = new ("mon_analysis_port", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        super.run_phase (phase);
        forever begin
            @(posedge vif.clk);
            if (vif.sel) begin
                reg_item item = new;
                item.addr   = vif.addr;
                item.wr     = vif.wr;
                item.wdata  = vif.wdata;

                if (!vif.wr) begin
                    @(posedge vif.clk);
                    item.rdata = vif.rdata;
                end
            
            `uvm_info(get_type_name(), $sformatf("Monitor found packet %s", item.convert2str()))
            mon_analysis_port.write(item);
            end
        end
    endtask
endclass 