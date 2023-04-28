//
//------------------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2013-2018 NVIDIA Corporation
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


//-----------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_barrier
//
// The uvm_barrier class provides a multiprocess synchronization mechanism. 
// It enables a set of processes to block until the desired number of processes
// get to the synchronization point, at which time all of the processes are
// released.
//-----------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 10.3.1
class uvm_barrier extends uvm_object;







  `uvm_object_utils(uvm_barrier)

  // Function -- NODOCS -- new
  //
  // Creates a new barrier object.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.1
  function new (string name="", int threshold=0); endfunction


  // Task -- NODOCS -- wait_for
  //
  // Waits for enough processes to reach the barrier before continuing. 
  //
  // The number of processes to wait for is set by the <set_threshold> method.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.2
  virtual task wait_for(); endtask

  
  // Function -- NODOCS -- reset
  //
  // Resets the barrier. This sets the waiter count back to zero. 
  //
  // The threshold is unchanged. After reset, the barrier will force processes
  // to wait for the threshold again. 
  //
  // If the ~wakeup~ bit is set, any currently waiting processes will
  // be activated.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.3
  virtual function void reset (bit wakeup=1); endfunction


  // Function -- NODOCS -- set_auto_reset
  //
  // Determines if the barrier should reset itself after the threshold is
  // reached. 
  //
  // The default is on, so when a barrier hits its threshold it will reset, and
  // new processes will block until the threshold is reached again. 
  //
  // If auto reset is off, then once the threshold is achieved, new processes
  // pass through without being blocked until the barrier is reset.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.4
  virtual function void set_auto_reset (bit value=1); endfunction


  // Function -- NODOCS -- set_threshold
  //
  // Sets the process threshold. 
  //
  // This determines how many processes must be waiting on the barrier before
  // the processes may proceed. 
  //
  // Once the ~threshold~ is reached, all waiting processes are activated. 
  //
  // If ~threshold~ is set to a value less than the number of currently
  // waiting processes, then the barrier is reset and waiting processes are
  // activated.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.6
  virtual function void set_threshold (int threshold); endfunction


  // Function -- NODOCS -- get_threshold
  //
  // Gets the current threshold setting for the barrier.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.5
  virtual function int get_threshold (); endfunction

  
  // Function -- NODOCS -- get_num_waiters
  //
  // Returns the number of processes currently waiting at the barrier.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.7
  virtual function int get_num_waiters (); endfunction


  // Function -- NODOCS -- cancel
  //
  // Decrements the waiter count by one. This is used when a process that is
  // waiting on the barrier is killed or activated by some other means.

  // @uvm-ieee 1800.2-2017 auto 10.3.2.8
  virtual function void cancel (); endfunction



  virtual function void do_print (uvm_printer printer); endfunction

  virtual function void do_copy (uvm_object rhs); endfunction  

endclass
