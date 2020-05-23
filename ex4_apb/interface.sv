interface apb_if (input pclk);
    logic           presetn;
    logic [31:0]    paddr;
    logic           psel;
    logic           penable;
    logic           pwrite;
    logic [31:0]    pwdata;
    logic           pready;
    logic [31:0]    prdata;
    logic           pslverr;

    clocking cb @ (posedge pclk);
        input pready, prdata, pslverr;
        output paddr, psel, penable, pwrite, pwdata;
    endclocking
endinterface //apb_if