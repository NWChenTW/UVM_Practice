class Item extends uvm_sequence_item;
    `uvm_object_utils(Item)
    rand bit in;
    bit out;

    virtual function string conver2str();
        return $sformatf("in=%0d, out=%0d", in, out);
    endfunction

    function new(string name = "Item");
        super.new(name);
    endfunction

    constraint c1 {in dist {0:/20, 1:/80};  }
endclass