`ifndef UVM_PROCESS
`define UVM_PROCESS

class pro1cess;
    typedef enum { FINISHED, RUNNING, WAITING, SUSPENDED, KILLED } state;
    static function pro1cess self();
       return null;
    endfunction
    function state status();
       return FINISHED;
    endfunction
    function void kill();
    endfunction
    task await();
    endtask
    function void suspend();
    endfunction
    function void resume();
    endfunction
    function void srandom(int seed);
    endfunction
    function string get_randstate();
       return "";
    endfunction
    function void set_randstate(string s);
    endfunction
endclass // pro1cess

`endif
