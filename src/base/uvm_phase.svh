//
//----------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2012-2017 Cisco Systems, Inc.
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

`ifdef UVM_ENABLE_DEPRECATED_API
  typedef class uvm_test_done_objection;
`endif

typedef class uvm_sequencer_base;

typedef class uvm_domain;
typedef class uvm_task_phase;

typedef class uvm_phase_cb;


   
//------------------------------------------------------------------------------
//
// Section -- NODOCS -- Phasing Definition classes
//
//------------------------------------------------------------------------------
//
// The following class are used to specify a phase and its implied functionality.
//
  
//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase
//
//------------------------------------------------------------------------------
//
// This base class defines everything about a phase: behavior, state, and context.
//
// To define behavior, it is extended by UVM or the user to create singleton
// objects which capture the definition of what the phase does and how it does it.
// These are then cloned to produce multiple nodes which are hooked up in a graph
// structure to provide context: which phases follow which, and to hold the state
// of the phase throughout its lifetime.
// UVM provides default extensions of this class for the standard runtime phases.
// VIP Providers can likewise extend this class to define the phase functor for a
// particular component context as required.
//
// This base class defines everything about a phase: behavior, state, and context.
//
// To define behavior, it is extended by UVM or the user to create singleton
// objects which capture the definition of what the phase does and how it does it.
// These are then cloned to produce multiple nodes which are hooked up in a graph
// structure to provide context: which phases follow which, and to hold the state
// of the phase throughout its lifetime.
// UVM provides default extensions of this class for the standard runtime phases.
// VIP Providers can likewise extend this class to define the phase functor for a
// particular component context as required.
//
// *Phase Definition*
//
// Singleton instances of those extensions are provided as package variables.
// These instances define the attributes of the phase (not what state it is in)
// They are then cloned into schedule nodes which point back to one of these
// implementations, and calls its virtual task or function methods on each
// participating component.
// It is the base class for phase functors, for both predefined and
// user-defined phases. Per-component overrides can use a customized imp.
//
// To create custom phases, do not extend uvm_phase directly: see the
// three predefined extended classes below which encapsulate behavior for
// different phase types: task, bottom-up function and top-down function.
//
// Extend the appropriate one of these to create a uvm_YOURNAME_phase class
// (or YOURPREFIX_NAME_phase class) for each phase, containing the default
// implementation of the new phase, which must be a uvm_component-compatible
// delegate, and which may be a ~null~ implementation. Instantiate a singleton
// instance of that class for your code to use when a phase handle is required.
// If your custom phase depends on methods that are not in uvm_component, but
// are within an extended class, then extend the base YOURPREFIX_NAME_phase
// class with parameterized component class context as required, to create a
// specialized functor which calls your extended component class methods.
// This scheme ensures compile-safety for your extended component classes while
// providing homogeneous base types for APIs and underlying data structures.
//
// *Phase Context*
//
// A schedule is a coherent group of one or mode phase/state nodes linked
// together by a graph structure, allowing arbitrary linear/parallel
// relationships to be specified, and executed by stepping through them in
// the graph order.
// Each schedule node points to a phase and holds the execution state of that
// phase, and has optional links to other nodes for synchronization.
//
// The main operations are: construct, add phases, and instantiate
// hierarchically within another schedule.
//
// Structure is a DAG (Directed Acyclic Graph). Each instance is a node
// connected to others to form the graph. Hierarchy is overlaid with m_parent.
// Each node in the graph has zero or more successors, and zero or more
// predecessors. No nodes are completely isolated from others. Exactly
// one node has zero predecessors. This is the root node. Also the graph
// is acyclic, meaning for all nodes in the graph, by following the forward
// arrows you will never end up back where you started but you will eventually
// reach a node that has no successors.
//
// *Phase State*
//
// A given phase may appear multiple times in the complete phase graph, due
// to the multiple independent domain feature, and the ability for different
// VIP to customize their own phase schedules perhaps reusing existing phases.
// Each node instance in the graph maintains its own state of execution.
//
// *Phase Handle*
//
// Handles of this type uvm_phase are used frequently in the API, both by
// the user, to access phasing-specific API, and also as a parameter to some
// APIs. In many cases, the singleton phase handles can be
// used (eg. <uvm_run_phase::get()>) in APIs. For those APIs that need to look
// up that phase in the graph, this is done automatically.

// @uvm-ieee 1800.2-2017 auto 9.3.1.2
class uvm_phase extends uvm_object;

  //`uvm_object_utils(uvm_phase)

  `uvm_register_cb(uvm_phase, uvm_phase_cb)


  //--------------------
  // Group -- NODOCS -- Construction
  //--------------------
  

  // @uvm-ieee 1800.2-2017 auto 9.3.1.3.1
  extern function new(string name="uvm_phase",
                      uvm_phase_type phase_type=UVM_PHASE_SCHEDULE,
                      uvm_phase parent=null);


  // @uvm-ieee 1800.2-2017 auto 9.3.1.3.2
  extern function uvm_phase_type get_phase_type();

  // @uvm-ieee 1800.2-2017 auto 9.3.1.3.3
  extern virtual function void set_max_ready_to_end_iterations(int max);

  // @uvm-ieee 1800.2-2017 auto 9.3.1.3.4
  // @uvm-ieee 1800.2-2017 auto 9.3.1.3.6
  extern virtual function int get_max_ready_to_end_iterations();

  // @uvm-ieee 1800.2-2017 auto 9.3.1.3.5
  extern static function void set_default_max_ready_to_end_iterations(int max);

  extern static function int get_default_max_ready_to_end_iterations();

  //-------------
  // Group -- NODOCS -- State
  //-------------


  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.1
  extern function uvm_phase_state get_state();



  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.2
  extern function int get_run_count();



  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.3
  extern function uvm_phase find_by_name(string name, bit stay_in_scope=1);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.4
  extern function uvm_phase find(uvm_phase phase, bit stay_in_scope=1);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.5
  extern function bit is(uvm_phase phase);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.6
  extern function bit is_before(uvm_phase phase);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.4.7
  extern function bit is_after(uvm_phase phase);


  //-----------------
  // Group -- NODOCS -- Callbacks
  //-----------------


  // @uvm-ieee 1800.2-2017 auto 9.3.1.5.1
  virtual function void exec_func(uvm_component comp, uvm_phase phase); endfunction



  // @uvm-ieee 1800.2-2017 auto 9.3.1.5.2
  virtual task exec_task(uvm_component comp, uvm_phase phase); endtask



  //----------------
  // Group -- NODOCS -- Schedule
  //----------------


  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.1
  extern function void add(uvm_phase phase,
                           uvm_phase with_phase=null,
                           uvm_phase after_phase=null,
                           uvm_phase before_phase=null,
                           uvm_phase start_with_phase=null,
                           uvm_phase end_with_phase=null
                        );



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.2
  extern function uvm_phase get_parent();



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.3
  extern virtual function string get_full_name();



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.4
  extern function uvm_phase get_schedule(bit hier = 0);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.5
  extern function string get_schedule_name(bit hier = 0);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.6
  extern function uvm_domain get_domain();



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.7
  extern function uvm_phase get_imp();



  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.8
  extern function string get_domain_name();


  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.9
  extern function void get_adjacent_predecessor_nodes(ref uvm_phase pred[]);


  // @uvm-ieee 1800.2-2017 auto 9.3.1.6.10
  extern function void get_adjacent_successor_nodes(ref uvm_phase succ[]);

  //-----------------------
  // Group -- NODOCS -- Phase Done Objection
  //-----------------------
  //
  // Task-based phase nodes within the phasing graph provide a <uvm_objection>
  // based interface for prolonging the execution of the phase.  All other
  // phase types do not contain an objection, and will report a fatal error
  // if the user attempts to ~raise~, ~drop~, or ~get_objection_count~.
   
  // Function- m_report_null_objection
  // Simplifies the reporting of ~null~ objection errors
  extern function void m_report_null_objection(uvm_object obj,
                                               string description,
                                               int count,
                                               string action);


  // @uvm-ieee 1800.2-2017 auto 9.3.1.7.2
  extern virtual function void raise_objection (uvm_object obj, 
                                                string description="",
                                                int count=1);


  // @uvm-ieee 1800.2-2017 auto 9.3.1.7.3
  extern virtual function void drop_objection (uvm_object obj, 
                                               string description="",
                                               int count=1);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.7.4
  extern virtual function int get_objection_count( uvm_object obj=null );
   
  //-----------------------
  // Group -- NODOCS -- Synchronization
  //-----------------------
  // The functions 'sync' and 'unsync' add soft sync relationships between nodes
  //
  // Summary of usage:
  //| my_phase.sync(.target(domain)
  //|              [,.phase(phase)[,.with_phase(phase)]]);
  //| my_phase.unsync(.target(domain)
  //|                [,.phase(phase)[,.with_phase(phase)]]);
  //
  // Components in different schedule domains can be phased independently or in sync
  // with each other. An API is provided to specify synchronization rules between any
  // two domains. Synchronization can be done at any of three levels:
  //
  // - the domain's whole phase schedule can be synchronized
  // - a phase can be specified, to sync that phase with a matching counterpart
  // - or a more detailed arbitrary synchronization between any two phases
  //
  // Each kind of synchronization causes the same underlying data structures to
  // be managed. Like other APIs, we use the parameter dot-notation to set
  // optional parameters.
  //
  // When a domain is synced with another domain, all of the matching phases in
  // the two domains get a 'with' relationship between them. Likewise, if a domain
  // is unsynched, all of the matching phases that have a 'with' relationship have
  // the dependency removed. It is possible to sync two domains and then just
  // remove a single phase from the dependency relationship by unsyncing just
  // the one phase.



  // @uvm-ieee 1800.2-2017 auto 9.3.1.8.1
  extern function void sync(uvm_domain target,
                            uvm_phase phase=null,
                            uvm_phase with_phase=null);


  // @uvm-ieee 1800.2-2017 auto 9.3.1.8.2
  extern function void unsync(uvm_domain target,
                              uvm_phase phase=null,
                              uvm_phase with_phase=null);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.8.3
  extern task wait_for_state(uvm_phase_state state, uvm_wait_op op=UVM_EQ);

   
  //---------------
  // Group -- NODOCS -- Jumping
  //---------------
  
  // Force phases to jump forward or backward in a schedule
  //
  // A phasing domain can execute a jump from its current phase to any other.
  // A jump passes phasing control in the current domain from the current phase
  // to a target phase. There are two kinds of jump scope:
  //
  // - local jump to another phase within the current schedule, back- or forwards
  // - global jump of all domains together, either to a point in the master
  //   schedule outwith the current schedule, or by calling jump_all()
  //
  // A jump preserves the existing soft synchronization, so the domain that is
  // ahead of schedule relative to another synchronized domain, as a result of
  // a jump in either domain, will await the domain that is behind schedule.
  //
  // *Note*: A jump out of the local schedule causes other schedules that have
  // the jump node in their schedule to jump as well. In some cases, it is
  // desirable to jump to a local phase in the schedule but to have all
  // schedules that share that phase to jump as well. In that situation, the
  // jump_all static function should be used. This function causes all schedules
  // that share a phase to jump to that phase.
 

  // @uvm-ieee 1800.2-2017 auto 9.3.1.9.1
  extern function void jump(uvm_phase phase);


  // @uvm-ieee 1800.2-2017 auto 9.3.1.9.2
  extern function void set_jump_phase(uvm_phase phase) ;
  

  // @uvm-ieee 1800.2-2017 auto 9.3.1.9.3
  extern function void end_prematurely() ;

  // Function- jump_all
  //
  // Make all schedules jump to a specified ~phase~, even if the jump target is local.
  // The jump happens to all phase schedules that contain the jump-to ~phase~,
  // i.e. a global jump. 
  //
  extern static function void jump_all(uvm_phase phase);



  // @uvm-ieee 1800.2-2017 auto 9.3.1.9.4
  extern function uvm_phase get_jump_target();



  //--------------------------
  // Internal - Implementation
  //--------------------------

  // Implementation - Construction
  //------------------------------
  protected uvm_phase_type m_phase_type;
  protected uvm_phase      m_parent;     // our 'schedule' node [or points 'up' one level]
  uvm_phase                m_imp;        // phase imp to call when we execute this node

  // Implementation - State
  //-----------------------
  local uvm_phase_state    m_state;
  local int                m_run_count; // num times this phase has executed
  local process            m_phase_proc;
  local static int         m_default_max_ready_to_end_iters = 20;    // 20 is the initial value defined by 1800.2-2017 9.3.1.3.5
`ifndef UVM_ENABLE_DEPRECATED_API
  local
`endif
  int                      max_ready_to_end_iters = get_default_max_ready_to_end_iterations();
  int                      m_num_procs_not_yet_returned;
  extern function uvm_phase m_find_predecessor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function uvm_phase m_find_successor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function uvm_phase m_find_predecessor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function uvm_phase m_find_successor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null);
  extern function void m_print_successors();

  // Implementation - Callbacks
  //---------------------------
  // Provide the required component traversal behavior. Called by execute()
  virtual function void traverse(uvm_component comp,
                                 uvm_phase phase,
                                 uvm_phase_state state);
  endfunction
  // Provide the required per-component execution flow. Called by traverse()
  virtual function void execute(uvm_component comp,
                                 uvm_phase phase);
  endfunction

  // Implementation - Schedule
  //--------------------------
  protected bit  m_predecessors[uvm_phase];
  protected bit  m_successors[uvm_phase];
  protected uvm_phase m_end_node;
  // Track the currently executing real task phases (used for debug)
  static protected bit m_executing_phases[uvm_phase];
  function uvm_phase get_begin_node(); if (m_imp != null) return this; return null; endfunction
  function uvm_phase get_end_node();   return m_end_node; endfunction

  // Implementation - Synchronization
  //---------------------------------
  local uvm_phase m_sync[$];  // schedule instance to which we are synced

`ifdef UVM_ENABLE_DEPRECATED_API
  // In order to avoid raciness during static initialization,
  // the creation of the "phase done" objection has been
  // delayed until the first call to get_objection(), and all
  // internal APIs have been updated to call get_objection() instead
  // of referring to phase_done directly.
  //
  // So as to avoid potential null handle dereferences in user code
  // which was accessing the phase_done variable directly, the variable
  // was renamed, and made local.  This takes a difficult to debug
  // run-time error, and converts it into an easy to catch compile-time
  // error.
  //
  // Code which is broken due to the protection of phase_done should be
  // refactored to use the get_objection() method.  Note that this also
  // opens the door to virtual get_objection() code, as described in
  // https://accellera.mantishub.io/view.php?id=6260
  uvm_objection phase_done;
`else // !`ifdef UVM_ENABLE_DEPRECATED_API
  local uvm_objection phase_done;
`endif
   
  local int unsigned m_ready_to_end_count;

  function int unsigned get_ready_to_end_count();
     return m_ready_to_end_count;
  endfunction

  extern local function void get_predecessors_for_successors(output bit pred_of_succ[uvm_phase]);
  extern local task m_wait_for_pred();

  // Implementation - Jumping
  //-------------------------
  local bit                m_jump_bkwd;
  local bit                m_jump_fwd;
  local uvm_phase          m_jump_phase;
  local bit                m_premature_end;
  extern function void clear(uvm_phase_state state = UVM_PHASE_DORMANT);
  extern function void clear_successors(
                             uvm_phase_state state = UVM_PHASE_DORMANT,
                             uvm_phase end_state=null);

  // Implementation - Overall Control
  //---------------------------------
  local static mailbox #(uvm_phase) m_phase_hopper = new();

  extern static task m_run_phases();
  extern local task  execute_phase();
  extern local function void m_terminate_phase();
  extern local function void m_print_termination_state();
  extern local task wait_for_self_and_siblings_to_drop();
  extern function void kill();
  extern function void kill_successors();

  // TBD add more useful debug
  //---------------------------------
  protected static bit m_phase_trace;
  local static bit m_use_ovm_run_semantic;


  function string convert2string(); endfunction

  local function string m_aa2string(bit aa[uvm_phase]); endfunction

  function bit is_domain(); endfunction

  virtual function void m_get_transitive_children(ref uvm_phase phases[$]); endfunction
  
  
  // @uvm-ieee 1800.2-2017 auto 9.3.1.7.1
  function uvm_objection get_objection();
     uvm_phase imp;
     uvm_task_phase tp;
     imp = get_imp();
     // Only nodes with a non-null uvm_task_phase imp have objections
     if ((get_phase_type() != UVM_PHASE_NODE) || (imp == null) || !$cast(tp, imp)) begin
	return null;
     end
     if (phase_done == null) begin
`ifdef UVM_ENABLE_DEPRECATED_API       
	   if (get_name() == "run") begin
              phase_done = uvm_test_done_objection::get();
	   end
	   else begin
 `ifdef VERILATOR
              phase_done = uvm_objection::type_id_create({get_name(), "_objection"});
 `else
              phase_done = uvm_objection::type_id::create({get_name(), "_objection"});
 `endif
	   end
`else // !UVM_ENABLE_DEPRECATED_API
 `ifdef VERILATOR
        phase_done = uvm_objection::type_id_create({get_name(), "_objection"});
 `else
	phase_done = uvm_objection::type_id::create({get_name(), "_objection"});
 `endif
`endif // UVM_ENABLE_DEPRECATED_API
     end
     
     return phase_done;
  endfunction // get_objection

  
endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_state_change
//
//------------------------------------------------------------------------------
//
// Phase state transition descriptor.
// Used to describe the phase transition that caused a
// <uvm_phase_cb::phase_state_changed()> callback to be invoked.
//

// @uvm-ieee 1800.2-2017 auto 9.3.2.1
class uvm_phase_state_change extends uvm_object;

  `uvm_object_utils(uvm_phase_state_change)

  // Implementation -- do not use directly
  /* local */ uvm_phase       m_phase;
  /* local */ uvm_phase_state m_prev_state;
  /* local */ uvm_phase       m_jump_to;
  
  function new(string name = "uvm_phase_state_change"); endfunction



  // @uvm-ieee 1800.2-2017 auto 9.3.2.2.1
  virtual function uvm_phase_state get_state(); endfunction
  

  // @uvm-ieee 1800.2-2017 auto 9.3.2.2.2
  virtual function uvm_phase_state get_prev_state(); endfunction


  // @uvm-ieee 1800.2-2017 auto 9.3.2.2.3
  function uvm_phase jump_to(); endfunction

endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_cb
//
//------------------------------------------------------------------------------
//
// This class defines a callback method that is invoked by the phaser
// during the execution of a specific node in the phase graph or all phase nodes.
// User-defined callback extensions can be used to integrate data types that
// are not natively phase-aware with the UVM phasing.
//

// @uvm-ieee 1800.2-2017 auto 9.3.3.1
class uvm_phase_cb extends uvm_callback;


  // @uvm-ieee 1800.2-2017 auto 9.3.3.2.1
  function new(string name="unnamed-uvm_phase_cb"); endfunction : new
   

  // @uvm-ieee 1800.2-2017 auto 9.3.3.2.2
  virtual function void phase_state_change(uvm_phase phase,
                                           uvm_phase_state_change change);
  endfunction
endclass

//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_cb_pool
//
//------------------------------------------------------------------------------
//
// Convenience type for the uvm_callbacks#(uvm_phase, uvm_phase_cb) class.
//
typedef uvm_callbacks#(uvm_phase, uvm_phase_cb) uvm_phase_cb_pool /* @uvm-ieee 1800.2-2017 auto D.4.1*/   ;


//------------------------------------------------------------------------------
//                               IMPLEMENTATION
//------------------------------------------------------------------------------

typedef class uvm_cmdline_processor;

`define UVM_PH_TRACE(ID,MSG,PH,VERB) \
   `uvm_info(ID, {$sformatf("Phase '%0s' (id=%0d) ", \
       PH.get_full_name(), PH.get_inst_id()),MSG}, VERB)

//-----------------------------
// Implementation - Construction
//-----------------------------

// new

function uvm_phase::new(string name="uvm_phase",
                        uvm_phase_type phase_type=UVM_PHASE_SCHEDULE,
                        uvm_phase parent=null);
endfunction


// add
// ---
// TBD error checks if param nodes are actually in this schedule or not

function void uvm_phase::add(uvm_phase phase,
                             uvm_phase with_phase=null,
                             uvm_phase after_phase=null,
                             uvm_phase before_phase=null,
                             uvm_phase start_with_phase=null,
                             uvm_phase end_with_phase=null
                          );
endfunction


// get_parent
// ----------

function uvm_phase uvm_phase::get_parent(); endfunction


// get_imp
// -------

function uvm_phase uvm_phase::get_imp(); endfunction


// get_schedule
// ------------

function uvm_phase uvm_phase::get_schedule(bit hier=0); endfunction


// get_domain
// ----------

function uvm_domain uvm_phase::get_domain(); endfunction


// get_domain_name
// ---------------
  
function string uvm_phase::get_domain_name(); endfunction


// get_schedule_name
// -----------------
  
function string uvm_phase::get_schedule_name(bit hier=0); endfunction


// get_full_name
// -------------

function string uvm_phase::get_full_name(); endfunction


// get_phase_type
// --------------

function uvm_phase_type uvm_phase::get_phase_type(); endfunction

// set_max_ready_to_end_iterations
// -------------------------------

function void uvm_phase::set_max_ready_to_end_iterations(int max);
  max_ready_to_end_iters = max;
endfunction

// get_max_ready_to_end_iterations
// -------------------------------

function int uvm_phase::get_max_ready_to_end_iterations();
  return max_ready_to_end_iters;
endfunction

// set_default_max_ready_to_end_iterations
// ---------------------------------------

function void uvm_phase::set_default_max_ready_to_end_iterations(int max);
  m_default_max_ready_to_end_iters = max;
endfunction

// get_default_max_ready_to_end_iterations
// ---------------------------------------

function int uvm_phase::get_default_max_ready_to_end_iterations();
  return m_default_max_ready_to_end_iters;
endfunction


//-----------------------
// Implementation - State
//-----------------------

// get_state
// ---------

function uvm_phase_state uvm_phase::get_state(); endfunction

// get_run_count
// -------------

function int uvm_phase::get_run_count(); endfunction


// m_print_successors
// ------------------

function void uvm_phase::m_print_successors(); endfunction


// m_find_predecessor
// ------------------

function uvm_phase uvm_phase::m_find_predecessor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null); endfunction


// m_find_predecessor_by_name
// --------------------------

function uvm_phase uvm_phase::m_find_predecessor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null); endfunction


// m_find_successor
// ----------------

function uvm_phase uvm_phase::m_find_successor(uvm_phase phase, bit stay_in_scope=1, uvm_phase orig_phase=null); endfunction


// m_find_successor_by_name
// ------------------------

function uvm_phase uvm_phase::m_find_successor_by_name(string name, bit stay_in_scope=1, uvm_phase orig_phase=null); endfunction


// find
// ----

function uvm_phase uvm_phase::find(uvm_phase phase, bit stay_in_scope=1); endfunction


// find_by_name
// ------------

function uvm_phase uvm_phase::find_by_name(string name, bit stay_in_scope=1); endfunction


// is
// --
  
function bit uvm_phase::is(uvm_phase phase); endfunction

  
// is_before
// ---------

function bit uvm_phase::is_before(uvm_phase phase); endfunction


// is_after
// --------
  
function bit uvm_phase::is_after(uvm_phase phase); endfunction


// execute_phase
// -------------

task uvm_phase::execute_phase();
endtask

function void uvm_phase::get_adjacent_predecessor_nodes(ref uvm_phase pred[]); endfunction : get_adjacent_predecessor_nodes

function void uvm_phase::get_adjacent_successor_nodes(ref uvm_phase succ[]); endfunction : get_adjacent_successor_nodes

// Internal implementation, more efficient than calling get_predessor_nodes on all
// of the successors returned by get_adjacent_successor_nodes
function void uvm_phase::get_predecessors_for_successors(output bit pred_of_succ[uvm_phase]); endfunction


// m_wait_for_pred
// ---------------

task uvm_phase::m_wait_for_pred(); endtask


//---------------------------------
// Implementation - Synchronization
//---------------------------------

function void uvm_phase::m_report_null_objection(uvm_object obj,
                                               string description,
                                               int count,
                                               string action); endfunction : m_report_null_objection
                        
   
// raise_objection
// ---------------

function void uvm_phase::raise_objection (uvm_object obj, 
                                                   string description="",
                                                   int count=1); endfunction


// drop_objection
// --------------

function void uvm_phase::drop_objection (uvm_object obj, 
                                                  string description="",
                                                  int count=1); endfunction

// get_objection_count
// -------------------

function int uvm_phase::get_objection_count (uvm_object obj=null); endfunction : get_objection_count

// sync
// ----

function void uvm_phase::sync(uvm_domain target,
                              uvm_phase phase=null,
                              uvm_phase with_phase=null); endfunction


// unsync
// ------

function void uvm_phase::unsync(uvm_domain target,
                                uvm_phase phase=null,
                                uvm_phase with_phase=null); endfunction


// wait_for_state
//---------------
  
task uvm_phase::wait_for_state(uvm_phase_state state, uvm_wait_op op=UVM_EQ); endtask


//-------------------------
// Implementation - Jumping
//-------------------------

// set_jump_phase
// ----
//
// Specify a phase to transition to when phase is complete.

function void uvm_phase::set_jump_phase(uvm_phase phase) ; endfunction

// end_prematurely
// ----
//
// Set a flag to cause the phase to end prematurely.  

function void uvm_phase::end_prematurely() ; endfunction

// jump
// ----
//
// Note that this function does not directly alter flow of control.
// That is, the new phase is not initiated in this function.
// Rather, flags are set which execute_phase() uses to determine
// that a jump has been requested and performs the jump.

function void uvm_phase::jump(uvm_phase phase);
   set_jump_phase(phase) ;
   end_prematurely() ;
endfunction


// jump_all
// --------
function void uvm_phase::jump_all(uvm_phase phase); endfunction


// get_jump_target
// ---------------
  
function uvm_phase uvm_phase::get_jump_target(); endfunction


// clear
// -----
// for internal graph maintenance after a forward jump
function void uvm_phase::clear(uvm_phase_state state = UVM_PHASE_DORMANT); endfunction


// clear_successors
// ----------------
// for internal graph maintenance after a forward jump
// - called only by execute_phase()
// - depth-first traversal of the DAG, calliing clear() on each node
// - do not clear the end phase or beyond 
function void uvm_phase::clear_successors(uvm_phase_state state = UVM_PHASE_DORMANT, 
    uvm_phase end_state=null);
endfunction


//---------------------------------
// Implementation - Overall Control
//---------------------------------
// wait_for_self_and_siblings_to_drop
// -----------------------------
// This task loops until this phase instance and all its siblings, either
// sync'd or sharing a common successor, have all objections dropped.
task uvm_phase::wait_for_self_and_siblings_to_drop() ; endtask

// kill
// ----

function void uvm_phase::kill(); endfunction


// kill_successors
// ---------------

// Using a depth-first traversal, kill all the successor phases of the
// current phase.
function void uvm_phase::kill_successors(); endfunction


// m_run_phases
// ------------

// This task contains the top-level process that owns all the phase
// processes.  By hosting the phase processes here we avoid problems
// associated with phase processes related as parents/children
task uvm_phase::m_run_phases(); endtask


// terminate_phase
// ---------------

function void uvm_phase::m_terminate_phase(); endfunction


// print_termination_state
// -----------------------

function void uvm_phase::m_print_termination_state(); endfunction

   
