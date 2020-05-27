module tb;
    bit clk;

    always #10 clk = ~clk;

    ahb_if m_ahb_if (.hclk(clk));

    assign m_ahb_if.hresp = 0;

    initial begin
        m_ahb_if.hreadyout <= 0;
        forever begin
            repeat ($urandom_range(2,6)) @ (posedge clk);
            m_ahb_if.hreadyout <= ~m_ahb_if.hreadyout;
        end
    end

    initial begin
        m_ahb_if.hrdata <= 0;
        forever begin
            repeat ($urandom_range(1,3)) @ (posedge clk);
            m_ahb_if.hrdata <= $random;
        end
    end

    initial begin
        uvm_config_db #(virtual ahb_if)::set(null, "uvm_test_top", "m_ahb_if", m_ahb_if);
        run_test("base_test");
    end
endmodule