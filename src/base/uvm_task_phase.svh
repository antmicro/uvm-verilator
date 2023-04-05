//
//----------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011 AMD
// Copyright 2013-2015 NVIDIA Corporation
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
// Class -- NODOCS -- uvm_task_phase
//
//------------------------------------------------------------------------------
// Base class for all task phases.
// It forks a call to <uvm_phase::exec_task()>
// for each component in the hierarchy.
//
// The completion of the task does not imply, nor is it required for, 
// the end of phase. Once the phase completes, any remaining forked 
// <uvm_phase::exec_task()> threads are forcibly and immediately killed.
//
// By default, the way for a task phase to extend over time is if there is
// at least one component that raises an objection.  
//| class my_comp extends uvm_component;
//|    task main_phase(uvm_phase phase);
//|       phase.raise_objection(this, "Applying stimulus")
//|       ...
//|       phase.drop_objection(this, "Applied enough stimulus")
//|    endtask
//| endclass
// 
//   
// There is however one scenario wherein time advances within a task-based phase
// without any objections to the phase being raised. If two (or more) phases 
// share a common successor, such as the <uvm_run_phase> and the 
// <uvm_post_shutdown_phase> sharing the <uvm_extract_phase> as a successor, 
// then phase advancement is delayed until all predecessors of the common 
// successor are ready to proceed.  Because of this, it is possible for time to 
// advance between <uvm_component::phase_started> and <uvm_component::phase_ended>
// of a task phase without any participants in the phase raising an objection.
//

// @uvm-ieee 1800.2-2017 auto 9.6.1
virtual class uvm_task_phase extends uvm_phase;



  // @uvm-ieee 1800.2-2017 auto 9.6.2.1
  function new(string name=""); endfunction



  // @uvm-ieee 1800.2-2017 auto 9.6.2.2
  virtual function void traverse(uvm_component comp,
                                 uvm_phase phase,
                                 uvm_phase_state state); endfunction

  function void m_traverse(uvm_component comp,
                           uvm_phase phase,
                           uvm_phase_state state);
  endfunction



  // @uvm-ieee 1800.2-2017 auto 9.6.2.3
  virtual function void execute(uvm_component comp,
                                          uvm_phase phase);
  endfunction
endclass
