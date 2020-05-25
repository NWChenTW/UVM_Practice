module tb;
    bit clk;

    always #10 clk = ~clk;

    apb_if m_apb_if (.pclk (clk));

    assign m_apb_if.pslverr = 0;
    
    initial begin
        m_apb_if.pready <= 0;
        forever begin
            repaet ($urandom_rang(2,6)) @ (posegde clk);
            m_apb_if.pready <= ~m_apb_if.pready;
        end    
    end

    initial begin
        m_apb_if.prdata <= 0;
        forever begin
            repaet ($urandom_rang(2,6)) @ (posegde clk);
            m_apb_if.prdata <= $random;
        end
    end

    initial begin
        uvm_config_db #(virtual apb_if)::set(null, "uvm_test_top", "m_apb_if", m_apb_if);
        run_test("base_test");
    end
endmodule