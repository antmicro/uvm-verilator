//
//------------------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2017 Intel Corporation
// Copyright 2010 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2015-2018 NVIDIA Corporation
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
//------------------------------------------------------------------------------


`ifndef UVM_QUEUE_SVH
`define UVM_QUEUE_SVH

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_queue #(T)
//
//------------------------------------------------------------------------------
// Implements a class-based dynamic queue. Allows queues to be allocated on
// demand, and passed and stored by reference.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 11.3.1
class uvm_queue #(type T=int) extends uvm_object;

  typedef uvm_queue this_type;

  `uvm_object_param_utils(uvm_queue)
  `uvm_type_name_decl("uvm_queue")

  static local this_type m_global_queue;
  protected T queue[$];

  // Function -- NODOCS -- new
  //
  // Creates a new queue with the given ~name~.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.1
  function new (string name=""); endfunction


  // Function -- NODOCS -- get_global_queue
  //
  // Returns the singleton global queue for the item type, T. 
  //
  // This allows items to be shared amongst components throughout the
  // verification environment.

  static function this_type get_global_queue (); endfunction


  // Function -- NODOCS -- get_global
  //
  // Returns the specified item instance from the global item queue. 

  // @uvm-ieee 1800.2-2017 auto 11.3.2.3
  static function T get_global (int index); endfunction


  // Function -- NODOCS -- get
  //
  // Returns the item at the given ~index~.
  //
  // If no item exists by that key, a new item is created with that key
  // and returned.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.4
  virtual function T get (int index); endfunction
  

  // Function -- NODOCS -- size
  //
  // Returns the number of items stored in the queue.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.5
  virtual function int size (); endfunction


  // Function -- NODOCS -- insert
  //
  // Inserts the item at the given ~index~ in the queue.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.6
  virtual function void insert (int index, T item); endfunction


  // Function -- NODOCS -- delete
  //
  // Removes the item at the given ~index~ from the queue; if ~index~ is
  // not provided, the entire contents of the queue are deleted.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.7
  virtual function void delete (int index=-1); endfunction


  // Function -- NODOCS -- pop_front
  //
  // Returns the first element in the queue (index=0),
  // or ~null~ if the queue is empty.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.8
  virtual function T pop_front(); endfunction


  // Function -- NODOCS -- pop_back
  //
  // Returns the last element in the queue (index=size()-1),
  // or ~null~ if the queue is empty.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.9
  virtual function T pop_back(); endfunction


  // Function -- NODOCS -- push_front
  //
  // Inserts the given ~item~ at the front of the queue.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.10
  virtual function void push_front(T item); endfunction


  // Function -- NODOCS -- push_back
  //
  // Inserts the given ~item~ at the back of the queue.

  // @uvm-ieee 1800.2-2017 auto 11.3.2.11
  virtual function void push_back(T item); endfunction

  // Task -- NODOCS -- wait_until_not_empty
  //
  // Blocks until not empty

  // @uvm-ieee 1800.2-2017 auto 11.3.2.12
  virtual task wait_until_not_empty(); endtask

  virtual function void do_copy (uvm_object rhs); endfunction virtual function string convert2string(); endfunction

endclass


`endif // UVM_QUEUE_SVH
