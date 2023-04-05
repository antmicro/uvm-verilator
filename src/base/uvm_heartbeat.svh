//----------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
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

`ifndef UVM_HEARTBEAT_SVH
`define UVM_HEARTBEAT_SVH

typedef enum {
  UVM_ALL_ACTIVE,
  UVM_ONE_ACTIVE,
  UVM_ANY_ACTIVE,
  UVM_NO_HB_MODE
} uvm_heartbeat_modes;

typedef class uvm_heartbeat_callback;
typedef uvm_callbacks #(uvm_objection,uvm_heartbeat_callback) uvm_heartbeat_cbs_t /* @uvm-ieee 1800.2-2017 auto D.4.2*/   ;


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_heartbeat
//
//------------------------------------------------------------------------------
// Heartbeats provide a way for environments to easily ensure that their
// descendants are alive. A uvm_heartbeat is associated with a specific
// objection object. A component that is being tracked by the heartbeat
// object must raise (or drop) the synchronizing objection during
// the heartbeat window. 
//
// The uvm_heartbeat object has a list of participating objects. The heartbeat
// can be configured so that all components (UVM_ALL_ACTIVE), exactly one
// (UVM_ONE_ACTIVE), or any component (UVM_ANY_ACTIVE) must trigger the
// objection in order to satisfy the heartbeat condition.
//------------------------------------------------------------------------------

typedef class uvm_objection_callback;
// @uvm-ieee 1800.2-2017 auto 10.6.1
class uvm_heartbeat extends uvm_object;

  protected uvm_objection m_objection;
  protected uvm_heartbeat_callback m_cb;
  protected uvm_component   m_cntxt;
  protected uvm_heartbeat_modes   m_mode;
  protected uvm_component   m_hblist[$];
  protected uvm_event#(uvm_object)       m_event;
  protected bit             m_started;
  protected event           m_stop_event;

  // Function -- NODOCS -- new
  //
  // Creates a new heartbeat instance associated with ~cntxt~. The context
  // is the hierarchical location that the heartbeat objections will flow
  // through and be monitored at. The ~objection~ associated with the heartbeat 
  // is optional, if it is left ~null~ but it must be set before the heartbeat
  // monitor will activate.
  //
  //| uvm_objection myobjection = new("myobjection"); //some shared objection
  //| class myenv extends uvm_env;
  //|    uvm_heartbeat hb = new("hb", this, myobjection);
  //|    ...
  //| endclass

  // @uvm-ieee 1800.2-2017 auto 10.6.2.1
  function new(string name, uvm_component cntxt, uvm_objection objection=null); endfunction


  // Function -- NODOCS -- set_mode
  //
  // Sets or retrieves the heartbeat mode. The current value for the heartbeat
  // mode is returned. If an argument is specified to change the mode then the
  // mode is changed to the new value.

  // @uvm-ieee 1800.2-2017 auto 10.6.2.2
  function uvm_heartbeat_modes set_mode (uvm_heartbeat_modes mode = UVM_NO_HB_MODE); endfunction


  // Function -- NODOCS -- set_heartbeat 
  //
  // Sets up the heartbeat event and assigns a list of objects to watch. The
  // monitoring is started as soon as this method is called. Once the
  // monitoring has been started with a specific event, providing a new
  // monitor event results in an error. To change trigger events, you
  // must first <stop> the monitor and then <start> with a new event trigger.
  //
  // If the trigger event ~e~ is ~null~ and there was no previously set
  // trigger event, then the monitoring is not started. Monitoring can be 
  // started by explicitly calling <start>.

  // @uvm-ieee 1800.2-2017 auto 10.6.2.3
  function void set_heartbeat (uvm_event#(uvm_object) e, ref uvm_component comps[$]); endfunction

  // Function -- NODOCS -- add
  //
  // Add a single component to the set of components to be monitored.
  // This does not cause monitoring to be started. If monitoring is
  // currently active then this component will be immediately added
  // to the list of components and will be expected to participate
  // in the currently active event window.

  // @uvm-ieee 1800.2-2017 auto 10.6.2.4
  function void add (uvm_component comp); endfunction

  // Function -- NODOCS -- remove
  //
  // Remove a single component to the set of components being monitored.
  // Monitoring is not stopped, even if the last component has been
  // removed (an explicit stop is required).

  // @uvm-ieee 1800.2-2017 auto 10.6.2.5
  function void remove (uvm_component comp); endfunction


  // Function -- NODOCS -- start
  //
  // Starts the heartbeat monitor. If ~e~ is ~null~ then whatever event
  // was previously set is used. If no event was previously set then
  // a warning is issued. It is an error if the monitor is currently
  // running and ~e~ is specifying a different trigger event from the
  // current event.

  // @uvm-ieee 1800.2-2017 auto 10.6.2.6
  function void start (uvm_event#(uvm_object) e=null); endfunction

  // Function -- NODOCS -- stop
  //
  // Stops the heartbeat monitor. Current state information is reset so
  // that if <start> is called again the process will wait for the first
  // event trigger to start the monitoring.

  // @uvm-ieee 1800.2-2017 auto 10.6.2.7
  function void stop (); endfunction

  function void m_start_hb_process(); endfunction

  protected bit m_added;

  task m_hb_process; endtask
endclass


class uvm_heartbeat_callback extends uvm_objection_callback;
  int  cnt [uvm_object];
  time last_trigger [uvm_object];
  uvm_object target;
  uvm_coreservice_t cs = uvm_coreservice_t::get();

  function new(string name, uvm_object target); endfunction

  virtual function void raised (uvm_objection objection,
                                uvm_object obj,
                                uvm_object source_obj,
                                string description,
                                int count); endfunction virtual function void dropped (uvm_objection objection,
                                 uvm_object obj,
                                 uvm_object source_obj,
                                 string description,
                                 int count); endfunction

  function int objects_triggered; endfunction

endclass

`endif
