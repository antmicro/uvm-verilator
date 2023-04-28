//----------------------------------------------------------------------
// Copyright 2007-2017 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2014 Intel Corporation
// Copyright 2010-2017 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2013 Verilab
// Copyright 2010-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2013-2018 Cisco Systems, Inc.
// Copyright 2012 Accellera Systems Initiative
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

typedef uvm_config_db#(uvm_sequence_base) uvm_config_seq;
typedef class uvm_sequence_request;

// Utility class for tracking default_sequences
class uvm_sequence_process_wrapper;
    process pid;
    uvm_sequence_base seq;
endclass : uvm_sequence_process_wrapper

//------------------------------------------------------------------------------
//
// CLASS: uvm_sequencer_base
//
// The library implements some public API beyond what is documented
// in 1800.2.  It also modifies some API described erroneously in 1800.2.
//
//------------------------------------------------------------------------------
`ifndef UVM_ENABLE_DEPRECATED_API
virtual
`endif
// @uvm-ieee 1800.2-2017 auto 15.3.1
class uvm_sequencer_base extends uvm_component;

  typedef enum {SEQ_TYPE_REQ,
                SEQ_TYPE_LOCK} seq_req_t;

// queue of sequences waiting for arbitration
  protected uvm_sequence_request arb_sequence_q[$];

  protected bit                 arb_completed[int];

  protected uvm_sequence_base   lock_list[$];
  protected uvm_sequence_base   reg_sequences[int];
  protected int                 m_sequencer_id;
  protected int                 m_lock_arb_size;  // used for waiting processes
  protected int                 m_arb_size;       // used for waiting processes
  protected int                 m_wait_for_item_sequence_id,
                                m_wait_for_item_transaction_id;
  protected int                 m_wait_relevant_count = 0 ;
  protected int                 m_max_zero_time_wait_relevant_count = 10;
  protected time                m_last_wait_relevant_time = 0 ;







  // Function -- NODOCS -- new
  //
  // Creates and initializes an instance of this class using the normal
  // constructor arguments for uvm_component: name is the name of the
  // instance, and parent is the handle to the hierarchical parent.

  // @uvm-ieee 1800.2-2017 auto 15.3.2.1
  extern function new (string name="", uvm_component parent=null);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.2
  extern function bit is_child (uvm_sequence_base parent, uvm_sequence_base child);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.3
  extern virtual function int user_priority_arbitration(int avail_sequences[$]);


  // Task -- NODOCS -- execute_item
  //
  // Executes the given transaction ~item~ directly on this sequencer. A temporary
  // parent sequence is automatically created for the ~item~.  There is no capability to
  // retrieve responses. If the driver returns responses, they will accumulate in the
  // sequencer, eventually causing response overflow unless
  // <uvm_sequence_base::set_response_queue_error_report_enabled> is called.

  // @uvm-ieee 1800.2-2017 auto 15.3.2.5
  extern virtual task execute_item(uvm_sequence_item item);

  // Hidden array, keeps track of running default sequences
  protected uvm_sequence_process_wrapper m_default_sequences[uvm_phase];

  // Function -- NODOCS -- start_phase_sequence
  //
  // Start the default sequence for this phase, if any.
  // The default sequence is configured via resources using
  // either a sequence instance or sequence type (object wrapper).
  // If both are used,
  // the sequence instance takes precedence. When attempting to override
  // a previous default sequence setting, you must override both
  // the instance and type (wrapper) resources, else your override may not
  // take effect.
  //
  // When setting the resource using ~set~, the 1st argument specifies the
  // context pointer, usually ~this~ for components or ~null~ when executed from
  // outside the component hierarchy (i.e. in module).
  // The 2nd argument is the instance string, which is a path name to the
  // target sequencer, relative to the context pointer.  The path must include
  // the name of the phase with a "_phase" suffix. The 3rd argument is the
  // resource name, which is "default_sequence". The 4th argument is either
  // an object wrapper for the sequence type, or an instance of a sequence.
  //
  // Configuration by instances
  // allows pre-initialization, setting rand_mode, use of inline
  // constraints, etc.
  //
  //| myseq_t myseq = new("myseq");
  //| myseq.randomize() with { ... };
  //| uvm_config_db #(uvm_sequence_base)::set(null, "top.agent.myseqr.main_phase",
  //|                                         "default_sequence",
  //|                                         myseq);
  //
  // Configuration by type is shorter and can be substituted via
  // the factory.
  //
  //| uvm_config_db #(uvm_object_wrapper)::set(null, "top.agent.myseqr.main_phase",
  //|                                          "default_sequence",
  //|                                          myseq_type::type_id::get());
  //
  // The uvm_resource_db can similarly be used.
  //
  //| myseq_t myseq = new("myseq");
  //| myseq.randomize() with { ... };
  //| uvm_resource_db #(uvm_sequence_base)::set({get_full_name(), ".myseqr.main_phase",
  //|                                           "default_sequence",
  //|                                           myseq, this);
  //
  //| uvm_resource_db #(uvm_object_wrapper)::set({get_full_name(), ".myseqr.main_phase",
  //|                                            "default_sequence",
  //|                                            myseq_t::type_id::get(),
  //|                                            this );
  //
  //



  extern virtual function void start_phase_sequence(uvm_phase phase);

  // Function -- NODOCS -- stop_phase_sequence
  //
  // Stop the default sequence for this phase, if any exists, and it
  // is still executing.

  extern virtual function void stop_phase_sequence(uvm_phase phase);



  // Task -- NODOCS -- wait_for_grant
  //
  // This task issues a request for the specified sequence.  If item_priority
  // is not specified, then the current sequence priority will be used by the
  // arbiter.  If a lock_request is made, then the  sequencer will issue a lock
  // immediately before granting the sequence.  (Note that the lock may be
  // granted without the sequence being granted if is_relevant is not asserted).
  //
  // When this method returns, the sequencer has granted the sequence, and the
  // sequence must call send_request without inserting any simulation delay
  // other than delta cycles.  The driver is currently waiting for the next
  // item to be sent via the send_request call.

  // @uvm-ieee 1800.2-2017 auto 15.3.2.6
  extern virtual task wait_for_grant(uvm_sequence_base sequence_ptr,
                                     int item_priority = -1,
                                     bit lock_request = 0);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.7
  extern virtual task wait_for_item_done(uvm_sequence_base sequence_ptr,
                                         int transaction_id);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.8
  extern function bit is_blocked(uvm_sequence_base sequence_ptr);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.9
  extern function bit has_lock(uvm_sequence_base sequence_ptr);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.10
  extern virtual task lock(uvm_sequence_base sequence_ptr);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.11
  extern virtual task grab(uvm_sequence_base sequence_ptr);



  // Function: unlock
  //
  //| extern virtual function void unlock(uvm_sequence_base sequence_ptr);
  //
  // Implementation of unlock, as defined in P1800.2-2017 section 15.3.2.12.
  //
  // NOTE: unlock is documented in error as a virtual task, whereas it is
  // implemented as a virtual function.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 15.3.2.12
  extern virtual function void unlock(uvm_sequence_base sequence_ptr);


  // Function: ungrab
  //
  //| extern virtual function void ungrab(uvm_sequence_base sequence_ptr);
  //
  // Implementation of ungrab, as defined in P1800.2-2017 section 15.3.2.13.
  //
  // NOTE: ungrab is documented in error as a virtual task, whereas it is
  // implemented as a virtual function.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 15.3.2.13
  extern virtual function void  ungrab(uvm_sequence_base sequence_ptr);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.14
  extern virtual function void stop_sequences();



  // @uvm-ieee 1800.2-2017 auto 15.3.2.15
  extern virtual function bit is_grabbed();



  // @uvm-ieee 1800.2-2017 auto 15.3.2.16
  extern virtual function uvm_sequence_base current_grabber();



  // @uvm-ieee 1800.2-2017 auto 15.3.2.17
  extern virtual function bit has_do_available();



  // @uvm-ieee 1800.2-2017 auto 15.3.2.19
  extern function void set_arbitration(UVM_SEQ_ARB_TYPE val);



  // @uvm-ieee 1800.2-2017 auto 15.3.2.18
  extern function UVM_SEQ_ARB_TYPE get_arbitration();


  // Task -- NODOCS -- wait_for_sequences
  //
  // Waits for a sequence to have a new item available. Uses
  // <uvm_wait_for_nba_region> to give a sequence as much time as
  // possible to deliver an item before advancing time.

  extern virtual task wait_for_sequences();


  // Function -- NODOCS -- send_request
  //
  // Derived classes implement this function to send a request item to the
  // sequencer, which will forward it to the driver.  If the rerandomize bit
  // is set, the item will be randomized before being sent to the driver.
  //
  // This function may only be called after a <wait_for_grant> call.

  // @uvm-ieee 1800.2-2017 auto 15.3.2.20
  extern virtual function void send_request(uvm_sequence_base sequence_ptr,
                                            uvm_sequence_item t,
                                            bit rerandomize = 0);


  // @uvm-ieee 1800.2-2017 auto 15.3.2.21
  extern virtual function void set_max_zero_time_wait_relevant_count(int new_val) ;

  // Added in IEEE. Not in UVM 1.2
  // @uvm-ieee 1800.2-2017 auto 15.3.2.4
  extern virtual function uvm_sequence_base get_arbitration_sequence( int index );

  //----------------------------------------------------------------------------
  // INTERNAL METHODS - DO NOT CALL DIRECTLY, ONLY OVERLOAD IF VIRTUAL
  //----------------------------------------------------------------------------

  extern protected function void grant_queued_locks();


  extern protected task          m_select_sequence();
  extern protected function int  m_choose_next_request();
  extern           task          m_wait_for_arbitration_completed(int request_id);
  extern           function void m_set_arbitration_completed(int request_id);


  extern local task m_lock_req(uvm_sequence_base sequence_ptr, bit lock);


  // Task- m_unlock_req
  //
  // Called by a sequence to request an unlock.  This
  // will remove a lock for this sequence if it exists

  extern function void m_unlock_req(uvm_sequence_base sequence_ptr);


  extern local function void remove_sequence_from_queues(uvm_sequence_base sequence_ptr);
  extern function void m_sequence_exiting(uvm_sequence_base sequence_ptr);
  extern function void kill_sequence(uvm_sequence_base sequence_ptr);

  extern virtual function void analysis_write(uvm_sequence_item t);


  extern           function void   do_print (uvm_printer printer);


  extern virtual   function int    m_register_sequence(uvm_sequence_base sequence_ptr);
  extern protected
           virtual function void   m_unregister_sequence(int sequence_id);
  extern protected function
                 uvm_sequence_base m_find_sequence(int sequence_id);

  extern protected function void   m_update_lists();
  extern           function string convert2string();
  extern protected
           virtual function int    m_find_number_driver_connections();
  extern protected task            m_wait_arb_not_equal();
  extern protected task            m_wait_for_available_sequence();
  extern protected function int    m_get_seq_item_priority(uvm_sequence_request seq_q_entry);

  int m_is_relevant_completed;

`ifdef UVM_DISABLE_RECORDING
   `define UVM_DISABLE_AUTO_ITEM_RECORDING
`endif

// Macro: UVM_DISABLE_AUTO_ITEM_RECORDING
// Performs the same function as the 1800.2 define UVM_DISABLE_RECORDING,
// globally turning off automatic item recording when defined by the user.
// Provided for backward compatibility.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2

`ifdef UVM_DISABLE_AUTO_ITEM_RECORDING

`else

`endif


  // Access to following internal methods provided via seq_item_export

  // Function: disable_auto_item_recording
  //
  // Disables auto_item_recording
  //
  // This function is the implementation of the
  // uvm_sqr_if_base::disable_auto_item_recording() method detailed in
  // IEEE1800.2 section 15.2.1.2.10
  //
  // This function is implemented here to allow <uvm_push_sequencer#(REQ,RSP)>
  // and <uvm_push_driver#(REQ,RSP)> access to the call.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  virtual function void disable_auto_item_recording(); endfunction

  // Function: is_auto_item_recording_enabled
  //
  // Returns 1 is auto_item_recording is enabled,
  // otherwise 0
  //
  // This function is the implementation of the
  // uvm_sqr_if_base::is_auto_item_recording_enabled() method detailed in
  // IEEE1800.2 section 15.2.1.2.11
  //
  // This function is implemented here to allow <uvm_push_sequencer#(REQ,RSP)>
  // and <uvm_push_driver#(REQ,RSP)> access to the call.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  virtual function bit is_auto_item_recording_enabled(); endfunction

  static uvm_sequencer_base all_sequencer_insts[int unsigned];
endclass




//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------


// new
// ---

function uvm_sequencer_base::new (string name="", uvm_component parent=null); endfunction


// do_print
// --------

function void uvm_sequencer_base::do_print (uvm_printer printer); endfunction


// m_update_lists
// --------------

function void uvm_sequencer_base::m_update_lists(); endfunction


// convert2string
// ----------------

function string uvm_sequencer_base::convert2string(); endfunction



// m_find_number_driver_connections
// --------------------------------

function int  uvm_sequencer_base::m_find_number_driver_connections(); endfunction


// m_register_sequence
// -------------------

function int uvm_sequencer_base::m_register_sequence(uvm_sequence_base sequence_ptr); endfunction


// m_find_sequence
// ---------------

function uvm_sequence_base uvm_sequencer_base::m_find_sequence(int sequence_id); endfunction


// m_unregister_sequence
// ---------------------

function void uvm_sequencer_base::m_unregister_sequence(int sequence_id); endfunction


// user_priority_arbitration
// -------------------------

function int uvm_sequencer_base::user_priority_arbitration(int avail_sequences[$]); endfunction


// grant_queued_locks
// ------------------
// Any lock or grab requests that are at the front of the queue will be
// granted at the earliest possible time.  This function grants any queues
// at the front that are not locked out

function void uvm_sequencer_base::grant_queued_locks(); endfunction


// m_select_sequence
// -----------------

task uvm_sequencer_base::m_select_sequence(); endtask


// m_choose_next_request
// ---------------------
// When a driver requests an operation, this function must find the next
// available, unlocked, relevant sequence.
//
// This function returns -1 if no sequences are available or the entry into
// arb_sequence_q for the chosen sequence

function int uvm_sequencer_base::m_choose_next_request(); endfunction


// m_wait_arb_not_equal
// --------------------

task uvm_sequencer_base::m_wait_arb_not_equal(); endtask


// m_wait_for_available_sequence
// -----------------------------

task uvm_sequencer_base::m_wait_for_available_sequence(); endtask


// m_get_seq_item_priority
// -----------------------

function int uvm_sequencer_base::m_get_seq_item_priority(uvm_sequence_request seq_q_entry); endfunction


// m_wait_for_arbitration_completed
// --------------------------------

task uvm_sequencer_base::m_wait_for_arbitration_completed(int request_id); endtask


// m_set_arbitration_completed
// ---------------------------

function void uvm_sequencer_base::m_set_arbitration_completed(int request_id); endfunction


// is_child
// --------

function bit uvm_sequencer_base::is_child (uvm_sequence_base parent,
                                           uvm_sequence_base child); endfunction


// execute_item
// ------------

// Implementation artifact, extends virtual class uvm_sequence_base
// so that it can be constructed for execute_item
class m_uvm_sqr_seq_base extends uvm_sequence_base;
   function new(string name="unnamed-m_uvm_sqr_seq_base"); endfunction : new
endclass : m_uvm_sqr_seq_base
   
task uvm_sequencer_base::execute_item(uvm_sequence_item item); endtask


// wait_for_grant
// --------------

task uvm_sequencer_base::wait_for_grant(uvm_sequence_base sequence_ptr,
                                        int item_priority = -1,
                                        bit lock_request = 0); endtask


// wait_for_item_done
// ------------------

task uvm_sequencer_base::wait_for_item_done(uvm_sequence_base sequence_ptr,
                                            int transaction_id); endtask


// is_blocked
// ----------

function bit uvm_sequencer_base::is_blocked(uvm_sequence_base sequence_ptr); endfunction


// has_lock
// --------

function bit uvm_sequencer_base::has_lock(uvm_sequence_base sequence_ptr); endfunction


// m_lock_req
// ----------
// Internal method. Called by a sequence to request a lock.
// Puts the lock request onto the arbitration queue.

task uvm_sequencer_base::m_lock_req(uvm_sequence_base sequence_ptr, bit lock); endtask


// m_unlock_req
// ------------
// Called by a sequence to request an unlock.  This
// will remove a lock for this sequence if it exists

function void uvm_sequencer_base::m_unlock_req(uvm_sequence_base sequence_ptr); endfunction


// lock
// ----

task uvm_sequencer_base::lock(uvm_sequence_base sequence_ptr); endtask


// grab
// ----

task uvm_sequencer_base::grab(uvm_sequence_base sequence_ptr); endtask


// unlock
// ------

function void uvm_sequencer_base::unlock(uvm_sequence_base sequence_ptr); endfunction


// ungrab
// ------

function void  uvm_sequencer_base::ungrab(uvm_sequence_base sequence_ptr); endfunction


// remove_sequence_from_queues
// ---------------------------

function void uvm_sequencer_base::remove_sequence_from_queues(
                                       uvm_sequence_base sequence_ptr); endfunction


// stop_sequences
// --------------

function void uvm_sequencer_base::stop_sequences(); endfunction


// m_sequence_exiting
// ------------------

function void uvm_sequencer_base::m_sequence_exiting(uvm_sequence_base sequence_ptr); endfunction


// kill_sequence
// -------------

function void uvm_sequencer_base::kill_sequence(uvm_sequence_base sequence_ptr); endfunction


// is_grabbed
// ----------

function bit uvm_sequencer_base::is_grabbed(); endfunction


// current_grabber
// ---------------

function uvm_sequence_base uvm_sequencer_base::current_grabber(); endfunction


// has_do_available
// ----------------

function bit uvm_sequencer_base::has_do_available(); endfunction


// set_arbitration
// ---------------

function void uvm_sequencer_base::set_arbitration(UVM_SEQ_ARB_TYPE val); endfunction


// get_arbitration
// ---------------

function UVM_SEQ_ARB_TYPE uvm_sequencer_base::get_arbitration(); endfunction

// get_arbitration_sequence
// ---------------
function uvm_sequence_base uvm_sequencer_base::get_arbitration_sequence( int index); endfunction


// analysis_write
// --------------

function void uvm_sequencer_base::analysis_write(uvm_sequence_item t); endfunction


// wait_for_sequences
// ------------------

task uvm_sequencer_base::wait_for_sequences(); endtask



// send_request
// ------------

function void uvm_sequencer_base::send_request(uvm_sequence_base sequence_ptr,
                                               uvm_sequence_item t,
                                               bit rerandomize = 0); endfunction


// set_max_zero_time_wait_relevant_count
// ------------

function void uvm_sequencer_base::set_max_zero_time_wait_relevant_count(int new_val) ; endfunction


// start_phase_sequence
// --------------------

function void uvm_sequencer_base::start_phase_sequence(uvm_phase phase); endfunction

// stop_phase_sequence
// --------------------

function void uvm_sequencer_base::stop_phase_sequence(uvm_phase phase); endfunction : stop_phase_sequence

//------------------------------------------------------------------------------
//
// Class- uvm_sequence_request
//
//------------------------------------------------------------------------------

class uvm_sequence_request;
  bit        grant;
  int        sequence_id;
  int        request_id;
  int        item_priority;
  process    process_id;
  uvm_sequencer_base::seq_req_t  request;
  uvm_sequence_base sequence_ptr;
endclass
