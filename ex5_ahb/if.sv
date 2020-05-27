interface ahb_if (input hclk);
    logic           hresten;
    logic [31:0]    hadddr;
    logic [2:0]     hburst;
    logic           hmastlock;
    logic [3:0]     hprot;
    logic [2:0]     hsize;
    logic [1:0]     htrnas;
    logic [31:0]    hwdata;
    logic           hwrite;

    logic [31:0]    hrdata;
    logic           hreadyout;
    logic           hresp;

    logic           hsel;

    cloking cb @ (posedge hclk);
        input hreadyout, hrdata, hresp;
        ouput hadddr, hburst, hmastlock, hprot, hsize, htrnas, hwdata, hwrite, hsel;
    endclocking        
endinterface //ahb_if