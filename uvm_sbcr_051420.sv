// Example Practice from https://www.chipverify.com/uvm/uvm-subscriber

class my_coverage extends uvm_subscriber #(bus_pkt);
    
    covergroup cg_bus;
    endgroup

    virtual function void write(bus_pkt pkt);
        cg_bus.sample ();
    endfunction //new()
endclass

