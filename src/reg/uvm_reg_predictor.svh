//
// -------------------------------------------------------------
// Copyright 2014 Semifore
// Copyright 2004-2011 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2014-2018 NVIDIA Corporation
// Copyright 2012 Accellera Systems Initiative
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//


//------------------------------------------------------------------------------
// TITLE -- NODOCS -- Explicit Register Predictor
//------------------------------------------------------------------------------
//
// The <uvm_reg_predictor> class defines a predictor component,
// which is used to update the register model's mirror values
// based on transactions explicitly observed on a physical bus. 
//------------------------------------------------------------------------------

class uvm_predict_s;
   bit addr[uvm_reg_addr_t];
   uvm_reg_item reg_item;
endclass

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_reg_predictor
//
// Updates the register model mirror based on observed bus transactions
//
// This class converts observed bus transactions of type ~BUSTYPE~ to generic
// registers transactions, determines the register being accessed based on the
// bus address, then updates the register's mirror value with the observed bus
// data, subject to the register's access mode. See <uvm_reg::predict> for details.
//
// Memories can be large, so their accesses are not predicted.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 19.3.1
class uvm_reg_predictor #(type BUSTYPE=int) extends uvm_component;

  `uvm_component_param_utils(uvm_reg_predictor#(BUSTYPE))

  // Variable -- NODOCS -- bus_in
  //
  // Observed bus transactions of type ~BUSTYPE~ are received from this
  // port and processed.
  //
  // For each incoming transaction, the predictor will attempt to get the
  // register or memory handle corresponding to the observed bus address. 
  //
  // If there is a match, the predictor calls the register or memory's
  // predict method, passing in the observed bus data. The register or
  // memory mirror will be updated with this data, subject to its configured
  // access behavior--RW, RO, WO, etc. The predictor will also convert the
  // bus transaction to a generic <uvm_reg_item> and send it out the
  // ~reg_ap~ analysis port.
  //
  // If the register is wider than the bus, the
  // predictor will collect the multiple bus transactions needed to
  // determine the value being read or written.
  //
  uvm_analysis_imp bus_in;


  // Variable -- NODOCS -- reg_ap
  //
  // Analysis output port that publishes <uvm_reg_item> transactions
  // converted from bus transactions received on ~bus_in~.
  uvm_analysis_port reg_ap;


  // Variable -- NODOCS -- map
  //
  // The map used to convert a bus address to the corresponding register
  // or memory handle. Must be configured before the run phase.
  // 
  uvm_reg_map map;


  // Variable -- NODOCS -- adapter
  //
  // The adapter used to convey the parameters of a bus operation in 
  // terms of a canonical <uvm_reg_bus_op> datum.
  // The <uvm_reg_adapter> must be configured before the run phase.
  //
  uvm_reg_adapter adapter;



  // @uvm-ieee 1800.2-2017 auto 19.3.3.1
  function new (string name, uvm_component parent); endfunction

  // This method is documented in uvm_object
`ifdef UVM_ENABLE_DEPRECATED_API
  static string type_name = "";
  virtual function string get_type_name(); endfunction
`else // !`ifdef UVM_ENABLE_DEPRECATED_API
  // TODO:  Is it better to replace this with:
  //| `uvm_type_name_decl($sformatf("uvm_reg_predictor #(%s)", BUSTYPE::type_name())
  static function string type_name(); endfunction // type_name
  virtual function string get_type_name(); endfunction : get_type_name

`endif // !`ifdef UVM_ENABLE_DEPRECATED_API

  // @uvm-ieee 1800.2-2017 auto 19.3.3.2
  virtual function void pre_predict(uvm_reg_item rw);
  endfunction

  local uvm_predict_s m_pending[uvm_reg];


  // Function- write
  //
  // not a user-level method. Do not call directly. See documentation
  // for the ~bus_in~ member.
  //
  virtual function void write(BUSTYPE tr); endfunction

  
  // Function -- NODOCS -- check_phase
  //
  // Checks that no pending register transactions are still queued.

  // @uvm-ieee 1800.2-2017 auto 19.3.3.3
  virtual function void check_phase(uvm_phase phase); endfunction

endclass
