//
//----------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2014 Intel Corporation
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2014 Cisco Systems, Inc.
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

`ifndef UVM_OBJECTION_SVH
`define UVM_OBJECTION_SVH

typedef class uvm_objection_context_object;
typedef class uvm_objection;

typedef class uvm_objection_callback;
typedef uvm_callbacks #(uvm_objection,uvm_objection_callback) uvm_objection_cbs_t;
typedef class uvm_cmdline_processor;

class uvm_objection_events;
  int waiters;
  event raised;
  event dropped;
  event all_dropped;
endclass

//------------------------------------------------------------------------------
// Title -- NODOCS -- Objection Mechanism
//------------------------------------------------------------------------------
// The following classes define the objection mechanism and end-of-test
// functionality, which is based on <uvm_objection>.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_objection
//
//------------------------------------------------------------------------------
// Objections provide a facility for coordinating status information between
// two or more participating components, objects, and even module-based IP.
//
// Tracing of objection activity can be turned on to follow the activity of
// the objection mechanism. It may be turned on for a specific objection
// instance with <uvm_objection::trace_mode>, or it can be set for all 
// objections from the command line using the option +UVM_OBJECTION_TRACE.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 10.5.1
// @uvm-ieee 1800.2-2017 auto 10.5.1.1
class uvm_objection extends uvm_report_object;
  `uvm_register_cb(uvm_objection, uvm_objection_callback)

  protected bit     m_trace_mode;
  protected int     m_source_count[uvm_object];
  protected int     m_total_count [uvm_object];
  protected time    m_drain_time  [uvm_object];
  protected uvm_objection_events m_events [uvm_object];
  /*protected*/ bit     m_top_all_dropped;


     
  static uvm_objection m_objections[$];

  //// Drain Logic

  // The context pool holds used context objects, so that
  // they're not constantly being recreated.  The maximum
  // number of contexts in the pool is equal to the maximum
  // number of simultaneous drains you could have occuring,
  // both pre and post forks.
  //
  // There's the potential for a programmability within the
  // library to dictate the largest this pool should be allowed
  // to grow, but that seems like overkill for the time being.


  // These are the active drain processes, which have been
  // forked off by the background process.  A raise can
  // use this array to kill a drain.
`ifndef UVM_USE_PROCESS_CONTAINER   

`else

`endif
   
  // These are the contexts which have been scheduled for
  // retrieval by the background process, but which the
  // background process hasn't seen yet.


  // Once a context is seen by the background process, it is
  // removed from the scheduled list, and placed in the forked
  // list.  At the same time, it is placed in the scheduled
  // contexts array.  A re-raise can use the scheduled contexts
  // array to detect (and cancel) the drain.



  // Once the forked drain has actually started (this occurs
  // ~1 delta AFTER the background process schedules it), the
  // context is removed from the above array and list, and placed
  // in the forked_contexts list.  


  protected bit m_prop_mode = 1;
  protected bit m_cleared; /* for checking obj count<0 */


  // Function -- NODOCS -- new
  //
  // Creates a new objection instance. Accesses the command line
  // argument +UVM_OBJECTION_TRACE to turn tracing on for
  // all objection objects.

  // @uvm-ieee 1800.2-2017 auto 10.5.1.2
  function new(string name=""); endfunction


  // Function -- NODOCS -- trace_mode
  //
  // Set or get the trace mode for the objection object. If no
  // argument is specified (or an argument other than 0 or 1)
  // the current trace mode is unaffected. A trace_mode of
  // 0 turns tracing off. A trace mode of 1 turns tracing on.
  // The return value is the mode prior to being reset.

   function bit trace_mode (int mode=-1); endfunction

  // Function- m_report
  //
  // Internal method for reporting count updates

  function void m_report(uvm_object obj, uvm_object source_obj, string description, int count, string action); endfunction


  // Function- m_get_parent
  //
  // Internal method for getting the parent of the given ~object~.
  // The ultimate parent is uvm_top, UVM's implicit top-level component. 

  function uvm_object m_get_parent(uvm_object obj); endfunction


  // Function- m_propagate
  //
  // Propagate the objection to the objects parent. If the object is a
  // component, the parent is just the hierarchical parent. If the object is
  // a sequence, the parent is the parent sequence if one exists, or
  // it is the attached sequencer if there is no parent sequence. 
  //
  // obj : the uvm_object on which the objection is being raised or lowered
  // source_obj : the root object on which the end user raised/lowered the 
  //   objection (as opposed to an anscestor of the end user object)a
  // count : the number of objections associated with the action.
  // raise : indicator of whether the objection is being raised or lowered. A
  //   1 indicates the objection is being raised.

  function void m_propagate (uvm_object obj,
                             uvm_object source_obj,
                             string description,
                             int count,
                             bit raise,
                             int in_top_thread); endfunction


  // Group -- NODOCS -- Objection Control


  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.2
  function void set_propagate_mode (bit prop_mode); endfunction : set_propagate_mode


  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.1
  function bit get_propagate_mode(); endfunction : get_propagate_mode
   
  // Function -- NODOCS -- raise_objection
  //
  // Raises the number of objections for the source ~object~ by ~count~, which
  // defaults to 1.  The ~object~ is usually the ~this~ handle of the caller.
  // If ~object~ is not specified or ~null~, the implicit top-level component,
  // <uvm_root>, is chosen.
  //
  // Raising an objection causes the following.
  //
  // - The source and total objection counts for ~object~ are increased by
  //   ~count~. ~description~ is a string that marks a specific objection
  //   and is used in tracing/debug.
  //
  // - The objection's <raised> virtual method is called, which calls the
  //   <uvm_component::raised> method for all of the components up the 
  //   hierarchy.
  //

  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.3
  virtual function void raise_objection (uvm_object obj=null,
                                         string description="",
                                         int count=1); endfunction


  // Function- m_raise

  function void m_raise (uvm_object obj,
                         uvm_object source_obj,
                         string description="",
                         int count=1); endfunction
  

  // Function -- NODOCS -- drop_objection
  //
  // Drops the number of objections for the source ~object~ by ~count~, which
  // defaults to 1.  The ~object~ is usually the ~this~ handle of the caller.
  // If ~object~ is not specified or ~null~, the implicit top-level component,
  // <uvm_root>, is chosen.
  //
  // Dropping an objection causes the following.
  //
  // - The source and total objection counts for ~object~ are decreased by
  //   ~count~. It is an error to drop the objection count for ~object~ below
  //   zero.
  //
  // - The objection's <dropped> virtual method is called, which calls the
  //   <uvm_component::dropped> method for all of the components up the 
  //   hierarchy.
  //
  // - If the total objection count has not reached zero for ~object~, then
  //   the drop is propagated up the object hierarchy as with
  //   <raise_objection>. Then, each object in the hierarchy will have updated
  //   their ~source~ counts--objections that they originated--and ~total~
  //   counts--the total number of objections by them and all their
  //   descendants.
  //
  // If the total objection count reaches zero, propagation up the hierarchy
  // is deferred until a configurable drain-time has passed and the 
  // <uvm_component::all_dropped> callback for the current hierarchy level
  // has returned. The following process occurs for each instance up
  // the hierarchy from the source caller:
  //
  // A process is forked in a non-blocking fashion, allowing the ~drop~
  // call to return. The forked process then does the following:
  //
  // - If a drain time was set for the given ~object~, the process waits for
  //   that amount of time.
  //
  // - The objection's <all_dropped> virtual method is called, which calls the
  //   <uvm_component::all_dropped> method (if ~object~ is a component).
  //
  // - The process then waits for the ~all_dropped~ callback to complete.
  //
  // - After the drain time has elapsed and all_dropped callback has
  //   completed, propagation of the dropped objection to the parent proceeds
  //   as described in <raise_objection>, except as described below.
  //
  // If a new objection for this ~object~ or any of its descendants is raised
  // during the drain time or during execution of the all_dropped callback at
  // any point, the hierarchical chain described above is terminated and the
  // dropped callback does not go up the hierarchy. The raised objection will
  // propagate up the hierarchy, but the number of raised propagated up is
  // reduced by the number of drops that were pending waiting for the 
  // all_dropped/drain time completion. Thus, if exactly one objection
  // caused the count to go to zero, and during the drain exactly one new
  // objection comes in, no raises or drops are propagated up the hierarchy,
  //
  // As an optimization, if the ~object~ has no set drain-time and no
  // registered callbacks, the forked process can be skipped and propagation
  // proceeds immediately to the parent as described. 

  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.4
  virtual function void drop_objection (uvm_object obj=null,
                                        string description="",
                                        int count=1); endfunction


  // Function- m_drop

  function void m_drop (uvm_object obj,
                        uvm_object source_obj,
                        string description="",
                        int count=1,
                        int in_top_thread=0); endfunction



  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.5
  virtual function void clear(uvm_object obj=null); endfunction

  // m_execute_scheduled_forks
  // -------------------------

  // background process; when non
  static task m_execute_scheduled_forks(); endtask


  // m_forked_drain
  // -------------

  task m_forked_drain (uvm_object obj,
                       uvm_object source_obj,
                       string description="",
                       int count=1,
                       int in_top_thread=0); endtask


  // m_init_objections
  // -----------------

  // Forks off the single background process
  static function void m_init_objections(); endfunction

  // Function -- NODOCS -- set_drain_time
  //
  // Sets the drain time on the given ~object~ to ~drain~.
  //
  // The drain time is the amount of time to wait once all objections have
  // been dropped before calling the all_dropped callback and propagating
  // the objection to the parent. 
  //
  // If a new objection for this ~object~ or any of its descendants is raised
  // during the drain time or during execution of the all_dropped callbacks,
  // the drain_time/all_dropped execution is terminated. 

  // AE: set_drain_time(drain,obj=null)?
  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.7
  function void set_drain_time (uvm_object obj=null, time drain); endfunction
  

  //----------------------
  // Group -- NODOCS -- Callback Hooks
  //----------------------

  // Function -- NODOCS -- raised
  //
  // Objection callback that is called when a <raise_objection> has reached ~obj~.
  // The default implementation calls <uvm_component::raised>.

  // @uvm-ieee 1800.2-2017 auto 10.5.1.4.1
  virtual function void raised (uvm_object obj,
                                uvm_object source_obj,
                                string description,
                                int count); endfunction


  // Function -- NODOCS -- dropped
  //
  // Objection callback that is called when a <drop_objection> has reached ~obj~.
  // The default implementation calls <uvm_component::dropped>.

  // @uvm-ieee 1800.2-2017 auto 10.5.1.4.2
  virtual function void dropped (uvm_object obj,
                                 uvm_object source_obj,
                                 string description,
                                 int count); endfunction


  // Function -- NODOCS -- all_dropped
  //
  // Objection callback that is called when a <drop_objection> has reached ~obj~,
  // and the total count for ~obj~ goes to zero. This callback is executed
  // after the drain time associated with ~obj~. The default implementation 
  // calls <uvm_component::all_dropped>.

  // @uvm-ieee 1800.2-2017 auto 10.5.1.4.3
  virtual task all_dropped (uvm_object obj,
                            uvm_object source_obj,
                            string description,
                            int count); endtask


  //------------------------
  // Group -- NODOCS -- Objection Status
  //------------------------

  // Function -- NODOCS -- get_objectors
  //
  // Returns the current list of objecting objects (objects that
  // raised an objection but have not dropped it).

  // @uvm-ieee 1800.2-2017 auto 10.5.1.5.1
  function void get_objectors(ref uvm_object list[$]); endfunction



  // @uvm-ieee 1800.2-2017 auto 10.5.1.5.2
  task wait_for(uvm_objection_event objt_event, uvm_object obj=null); endtask


   task wait_for_total_count(uvm_object obj=null, int count=0); endtask
   

  // Function -- NODOCS -- get_objection_count
  //
  // Returns the current number of objections raised by the given ~object~.

  // @uvm-ieee 1800.2-2017 auto 10.5.1.5.3
  function int get_objection_count (uvm_object obj=null); endfunction
  

  // Function -- NODOCS -- get_objection_total
  //
  // Returns the current number of objections raised by the given ~object~ 
  // and all descendants.

  // @uvm-ieee 1800.2-2017 auto 10.5.1.5.4
  function int get_objection_total (uvm_object obj=null); endfunction
  

  // Function -- NODOCS -- get_drain_time
  //
  // Returns the current drain time set for the given ~object~ (default: 0 ns).

  // @uvm-ieee 1800.2-2017 auto 10.5.1.3.6
  function time get_drain_time (uvm_object obj=null); endfunction


  // m_display_objections

  protected function string m_display_objections(uvm_object obj=null, bit show_header=1); endfunction function string convert2string(); endfunction
  
  
  // Function -- NODOCS -- display_objections
  // 
  // Displays objection information about the given ~object~. If ~object~ is
  // not specified or ~null~, the implicit top-level component, <uvm_root>, is
  // chosen. The ~show_header~ argument allows control of whether a header is
  // output.

  function void display_objections(uvm_object obj=null, bit show_header=1); endfunction


  // Below is all of the basic data stuff that is needed for a uvm_object
  // for factory registration, printing, comparing, etc.

  typedef uvm_object_registry#(uvm_objection,"uvm_objection") type_id;
`ifdef VERILATOR
  static function uvm_objection type_id_create (string name="",
                                                uvm_component parent=null,
                                                string contxt=""); endfunction
`endif
  static function type_id get_type(); endfunction

  function uvm_object create (string name=""); endfunction virtual function string get_type_name (); endfunction

  function void do_copy (uvm_object rhs); endfunction

endclass

// TODO: change to plusarg
//`define UVM_DEFAULT_TIMEOUT 9200s

typedef class uvm_cmdline_processor;


`ifdef UVM_ENABLE_DEPRECATED_API
//------------------------------------------------------------------------------
//
// Class- uvm_test_done_objection DEPRECATED
//
// Provides built-in end-of-test coordination
//------------------------------------------------------------------------------

class uvm_test_done_objection extends uvm_objection;

   protected static uvm_test_done_objection m_inst;
  protected bit m_forced;

  // For communicating all objections dropped and end of phasing




  // Function- new DEPRECATED
  //
  // Creates the singleton test_done objection. Users must not call
  // this method directly.

  function new(string name="uvm_test_done"); endfunction


  // Function- qualify DEPRECATED
  //
  // Checks that the given ~object~ is derived from either <uvm_component> or
  // <uvm_sequence_base>.

  virtual function void qualify(uvm_object obj=null,
                                bit is_raise,
                                string description); endfunction

  // Below are basic data operations needed for all uvm_objects
  // for factory registration, printing, comparing, etc.

  typedef uvm_object_registry#(uvm_test_done_objection,"uvm_test_done") type_id;
  static function type_id get_type(); endfunction

  function uvm_object create (string name=""); endfunction virtual function string get_type_name (); endfunction

  static function uvm_test_done_objection get(); endfunction

endclass
`endif // UVM_ENABLE_DEPRECATED_API


// Have a pool of context objects to use
class uvm_objection_context_object;
    uvm_object obj;
    uvm_object source_obj;
    string description;
    int    count;
    uvm_objection objection;

    // Clears the values stored within the object,
    // preventing memory leaks from reused objects
    function void clear(); endfunction : clear
endclass

// Typedef - Exists for backwards compat
typedef uvm_objection uvm_callbacks_objection;
   
//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_objection_callback
//
//------------------------------------------------------------------------------
// The uvm_objection is the callback type that defines the callback 
// implementations for an objection callback. A user uses the callback
// type uvm_objection_cbs_t to add callbacks to specific objections.
//
// For example:
//
//| class my_objection_cb extends uvm_objection_callback;
//|   function new(string name);
//|     super.new(name);
//|   endfunction
//|
//|   virtual function void raised (uvm_objection objection, uvm_object obj, 
//|       uvm_object source_obj, string description, int count);
//|       `uvm_info("RAISED","%0t: Objection %s: Raised for %s", $time, objection.get_name(),
//|       obj.get_full_name());
//|   endfunction
//| endclass
//| ...
//| initial begin
//|   my_objection_cb cb = new("cb");
//|   uvm_objection_cbs_t::add(null, cb); //typewide callback
//| end


// @uvm-ieee 1800.2-2017 auto 10.5.2.1
class uvm_objection_callback extends uvm_callback;
  function new(string name=""); endfunction

  // Function -- NODOCS -- raised
  //
  // Objection raised callback function. Called by <uvm_objection::raised>.

  // @uvm-ieee 1800.2-2017 auto 10.5.2.2.1
  virtual function void raised (uvm_objection objection, uvm_object obj, 
      uvm_object source_obj, string description, int count);
  endfunction

  // Function -- NODOCS -- dropped
  //
  // Objection dropped callback function. Called by <uvm_objection::dropped>.

  // @uvm-ieee 1800.2-2017 auto 10.5.2.2.2
  virtual function void dropped (uvm_objection objection, uvm_object obj, 
      uvm_object source_obj, string description, int count);
  endfunction

  // Function -- NODOCS -- all_dropped
  //
  // Objection all_dropped callback function. Called by <uvm_objection::all_dropped>.

  // @uvm-ieee 1800.2-2017 auto 10.5.2.2.3
  virtual task all_dropped (uvm_objection objection, uvm_object obj, 
      uvm_object source_obj, string description, int count);
  endtask

endclass


`endif
