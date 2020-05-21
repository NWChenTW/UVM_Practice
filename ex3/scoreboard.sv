class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    function new(string name = "scoreaborad", uvm_comoponent parent = null);
        super.new(name, parent);
    endfunction //new()

    bit[`LENGTH-1:0]    ref_pattern;
    bit[`LENGTH-1:0]    act_pattern;
    bit                 exp_out;
    
    uvm_analysis_imp = new("m_analysis_imp", this);
    if (!uvm_config_db#(bit[`LENGTH-1:0])::get(this, "*", "ref_pattern", ref_pattern))
        `uvm_fatal("SCBD", "Did not get ref_pattern!")
    endfunction

    virtual function write(Item item);
        act_pattern = act_pattern << 1 | item.in;

        `uvm_info("SCBD", $sformatf("in=%0d out=%0d ref=0b%0b act=0b%0b", item.in, item.out, ref_pattern, act_pattern), UVM_LOW)
        if (item.out != exp_out) begin
            `uvm_error("SCBD", $sformatf("ERROR! out=%0d exp=%0d", item.out, exp_out))
        end else begin
            `uvm_info("SCBD", $sformatf("PASS! out=%0d exp=%0d", item.out, exp_out), UVM_HIGH)
        end

        if (!(ref_pattern ^ act_pattern)) begin
            `uvm_info("SCBD", $sformatf("Pattern found to match, next out should be 1"), UVM_LOW)
            exp_out = 1;
        end else begin
            exp_out = 0;
        end
    endfunction
endclass