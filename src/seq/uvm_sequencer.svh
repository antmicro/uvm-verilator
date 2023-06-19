//----------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010-2011 AMD
// Copyright 2014-2018 NVIDIA Corporation
// Copyright 2014 Cisco Systems, Inc.
// Copyright 2017 Verific
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

class uvm_seq_item_pull_imp1 #(type REQ=int, type RSP=REQ, type IMP=int);
   function new (string name, IMP imp);
   endfunction
endclass

class uvm_sequencer1 #(type REQ=int, RSP=REQ);

  typedef uvm_sequencer1 #( REQ , RSP) this_type;

  `uvm_component_param_utils(this_type)

  extern function new (string name);
  
  uvm_seq_item_pull_imp1 #(REQ, RSP, this_type) seq_item_export;

endclass  

function uvm_sequencer1::new (string name);
  seq_item_export = new ("seq_item_export", this);
endfunction

typedef uvm_sequencer1 #(int, int) uvm_default_sequencer_type1;
//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_sequencer #(REQ,RSP)
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 15.5.1
class uvm_sequencer #(type REQ=uvm_sequence_item, RSP=REQ)
                                   extends uvm_sequencer_param_base #(REQ, RSP);

  typedef uvm_sequencer #( REQ , RSP) this_type;

  `uvm_component_param_utils(this_type)




  // @uvm-ieee 1800.2-2017 auto 15.5.2.2
  extern function new (string name, uvm_component parent=null);
  

  // Function -- NODOCS -- stop_sequences
  //
  // Tells the sequencer to kill all sequences and child sequences currently
  // operating on the sequencer, and remove all requests, locks and responses
  // that are currently queued.  This essentially resets the sequencer to an
  // idle state.
  //
  extern virtual function void stop_sequences();

  extern virtual function string get_type_name();

  // Group -- NODOCS -- Sequencer Interface
  // This is an interface for communicating with sequencers.
  //
  // The interface is defined as:
  //| Requests:
  //|  virtual task          get_next_item      (output REQ request);
  //|  virtual task          try_next_item      (output REQ request);
  //|  virtual task          get                (output REQ request);
  //|  virtual task          peek               (output REQ request);
  //| Responses:
  //|  virtual function void item_done          (input RSP response=null);
  //|  virtual task          put                (input RSP response);
  //| Sync Control:
  //|  virtual task          wait_for_sequences ();
  //|  virtual function bit  has_do_available   ();
  //
  // See <uvm_sqr_if_base #(REQ,RSP)> for information about this interface.
   
  // Variable -- NODOCS -- seq_item_export
  //
  // This export provides access to this sequencer's implementation of the
  // sequencer interface.
  //

  uvm_seq_item_pull_imp1 #(REQ, RSP, this_type) seq_item_export;

  // Task -- NODOCS -- get_next_item
  // Retrieves the next available item from a sequence.
  //
  extern virtual task          get_next_item (output REQ t);

  // Task -- NODOCS -- try_next_item
  // Retrieves the next available item from a sequence if one is available.
  //
  extern virtual task          try_next_item (output REQ t);

  // Function -- NODOCS -- item_done
  // Indicates that the request is completed.
  //
  extern virtual function void item_done     (RSP item = null);

  // Task -- NODOCS -- put
  // Sends a response back to the sequence that issued the request.
  //
  extern virtual task          put           (RSP t);

  // Task -- NODOCS -- get
  // Retrieves the next available item from a sequence.
  //
  extern task                  get           (output REQ t);

  // Task -- NODOCS -- peek
  // Returns the current request item if one is in the FIFO.
  //
  extern task                  peek          (output REQ t);

  /// Documented here for clarity, implemented in uvm_sequencer_base

  // Task -- NODOCS -- wait_for_sequences
  // Waits for a sequence to have a new item available.
  //

  // Function -- NODOCS -- has_do_available
  // Returns 1 if any sequence running on this sequencer is ready to supply
  // a transaction, 0 otherwise.
  //
   
  //-----------------
  // Internal Methods
  //-----------------
  // Do not use directly, not part of standard

  extern function void         item_done_trigger(RSP item = null);
  function RSP                 item_done_get_trigger_data();
    return last_rsp(0);
  endfunction
  extern protected virtual function int m_find_number_driver_connections();

endclass  


typedef uvm_sequencer #(uvm_sequence_item) uvm_virtual_sequencer;



//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

function uvm_sequencer::new (string name, uvm_component parent=null);
  super.new(name, parent);
  seq_item_export = new ("seq_item_export", this);
endfunction


// Function- stop_sequences
//
// Tells the sequencer to kill all sequences and child sequences currently
// operating on the sequencer, and remove all requests, locks and responses
// that are currently queued.  This essentially resets the sequencer to an
// idle state.
//
function void uvm_sequencer::stop_sequences();
endfunction


function string uvm_sequencer::get_type_name();
  return "uvm_sequencer";
endfunction 


//-----------------
// Internal Methods
//-----------------

// m_find_number_driver_connections
// --------------------------------
// Counting the number of of connections is done at end of
// elaboration and the start of run.  If the user neglects to
// call super in one or the other, the sequencer will still
// have the correct value

function int uvm_sequencer::m_find_number_driver_connections();
   return 1;
endfunction


// get_next_item
// -------------

task uvm_sequencer::get_next_item(output REQ t);
endtask


// try_next_item
// -------------

task uvm_sequencer::try_next_item(output REQ t);
endtask


// item_done
// ---------

function void uvm_sequencer::item_done(RSP item = null);
endfunction


// put
// ---

task uvm_sequencer::put (RSP t);
endtask


// get
// ---

task uvm_sequencer::get(output REQ t);
endtask


// peek
// ----

task uvm_sequencer::peek(output REQ t);
endtask


// item_done_trigger
// -----------------

function void uvm_sequencer::item_done_trigger(RSP item = null);
endfunction
