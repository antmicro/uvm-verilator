//
//----------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2010 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2015 NVIDIA Corporation
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


//------------------------------------------------------------------------------
// Title -- NODOCS -- Analysis Ports
//------------------------------------------------------------------------------
//
// This section defines the port, export, and imp classes used for transaction
// analysis.
//
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_analysis_port
//
// Broadcasts a value to all subscribers implementing a <uvm_analysis_imp>.
// 
//| class mon extends uvm_component;
//|   uvm_analysis_port#(trans) ap;
//|
//|   function new(string name = "sb", uvm_component parent = null);
//|      super.new(name, parent);
//|      ap = new("ap", this);
//|   endfunction
//|
//|   task run_phase(uvm_phase phase);
//|       trans t;
//|       ...
//|       ap.write(t);
//|       ...
//|   endfunction
//| endclass
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 12.2.10.1.1
class uvm_analysis_port # (type T = int)
  extends uvm_port_base # (uvm_tlm_if_base #(T,T));

  function new (string name, uvm_component parent); endfunction virtual function string get_type_name(); endfunction


  // @uvm-ieee 1800.2-2017 auto 12.2.10.1.2
  function void write (input T t); endfunction

endclass



//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_analysis_imp
//
// Receives all transactions broadcasted by a <uvm_analysis_port>. It serves as
// the termination point of an analysis port/export/imp connection. The component
// attached to the ~imp~ class--called a ~subscriber~-- implements the analysis
// interface.
//
// Will invoke the ~write(T)~ method in the parent component.
// The implementation of the ~write(T)~ method must not modify
// the value passed to it.
//
//| class sb extends uvm_component;
//|   uvm_analysis_imp#(trans, sb) ap;
//|
//|   function new(string name = "sb", uvm_component parent = null);
//|      super.new(name, parent);
//|      ap = new("ap", this);
//|   endfunction
//|
//|   function void write(trans t);
//|       ...
//|   endfunction
//| endclass
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 12.2.10.2
class uvm_analysis_imp #(type T=int, type IMP=int)
  extends uvm_port_base #(uvm_tlm_if_base #(T,T));
  `UVM_IMP_COMMON(`UVM_TLM_ANALYSIS_MASK,"uvm_analysis_imp",IMP)
  function void write (input T t); endfunction
endclass



//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_analysis_export
//
// Exports a lower-level <uvm_analysis_imp> to its parent.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 12.2.10.3.1
class uvm_analysis_export #(type T=int)
  extends uvm_port_base #(uvm_tlm_if_base #(T,T));


  // @uvm-ieee 1800.2-2017 auto 12.2.10.3.2
  function new (string name, uvm_component parent = null); endfunction virtual function string get_type_name(); endfunction
  
  // analysis port differs from other ports in that it broadcasts
  // to all connected interfaces. Ports only send to the interface
  // at the index specified in a call to set_if (0 by default).
  function void write (input T t); endfunction

endclass
