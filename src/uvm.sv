//
//----------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2010-2011 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2013-2018 NVIDIA Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`include "uvm_pkg.sv"

import uvm_pkg::*;
`include "uvm_macros.svh"

class Complex extends uvm_component;
    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("RESULT", "new uvm_class created", UVM_LOW);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("RESULT", "build phase completed", UVM_LOW);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("RESULT", "connect phase completed", UVM_LOW);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("RESULT", "end of elaboration phase completed", UVM_LOW);
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("RESULT", "start of simulation phase completed", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info("RESULT", "run phase phase completed", UVM_LOW);
    endtask

    virtual function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("RESULT", "extract phase completed", UVM_LOW);
    endfunction

    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("RESULT", "check phase completed", UVM_LOW);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("RESULT", "report phase completed", UVM_LOW);
    endfunction
endclass

module top;
   initial begin
      Complex obj;
      obj = new("C");
      run_test();
   end
endmodule
