//
//----------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2011 AMD
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
//
// Class -- NODOCS -- uvm_bottomup_phase
//
//------------------------------------------------------------------------------
// Virtual base class for function phases that operate bottom-up.
// The pure virtual function execute() is called for each component.
// This is the default traversal so is included only for naming.
//
// A bottom-up function phase completes when the <execute()> method
// has been called and returned on all applicable components
// in the hierarchy.

// @uvm-ieee 1800.2-2017 auto 9.5.1
virtual class uvm_bottomup_phase extends uvm_phase;


  // @uvm-ieee 1800.2-2017 auto 9.5.2.1
  function new(string name=""); endfunction



  // @uvm-ieee 1800.2-2017 auto 9.5.2.2
  virtual function void traverse(uvm_component comp,
                                 uvm_phase phase,
                                 uvm_phase_state state);
  endfunction



  // @uvm-ieee 1800.2-2017 auto 9.5.2.3
  virtual function void execute(uvm_component comp,
                                          uvm_phase phase); endfunction

endclass
