// 
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Intel Corporation
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
//------------------------------------------------------------------------------

// Class -- NODOCS -- uvm_get_to_lock_dap
// Provides a 'Get-To-Lock' Data Access Policy.
//
// The 'Get-To-Lock' Data Access Policy allows for any number of 'sets',
// until the value is retrieved via a 'get'.  Once 'get' has been called, 
// it is illegal to 'set' a new value.
//
// The UVM uses this policy to protect the ~starting phase~ and ~automatic objection~
// values in <uvm_sequence_base>.
//

class uvm_get_to_lock_dap#(type T=int) extends uvm_set_get_dap_base#(T);

   // Used for self-references
   typedef uvm_get_to_lock_dap this_type;
   
   // Parameterized Utils
   `uvm_object_param_utils(uvm_get_to_lock_dap)
   
   // Stored data
   local T m_value;

   // Lock state
   local bit m_locked;

   // Function -- NODOCS -- new
   // Constructor
   function new(string name="unnamed-uvm_get_to_lock_dap#(T)"); endfunction : new

   // Group -- NODOCS -- Set/Get Interface
   
   // Function -- NODOCS -- set
   // Updates the value stored within the DAP.
   //
   // ~set~ will result in an error if the value has
   // already been retrieved via a call to ~get~.
   virtual function void set(T value); endfunction : set

   // Function -- NODOCS -- try_set
   // Attempts to update the value stored within the DAP.
   //
   // ~try_set~ will return a 1 if the value was successfully
   // updated, or a '0' if the value cannot be updated due
   // to ~get~ having been called.  No errors will be reported
   // if ~try_set~ fails.
   virtual function bit try_set(T value); endfunction : try_set
   
   // Function -- NODOCS -- get
   // Returns the current value stored within the DAP, and 'locks' the DAP.
   //
   // After a 'get', the value contained within the DAP cannot
   // be changed.
   virtual  function T get(); endfunction : get

   // Function -- NODOCS -- try_get
   // Retrieves the current value stored within the DAP, and 'locks' the DAP.
   //
   // ~try_get~ will always return 1.
   virtual function bit try_get(output T value); endfunction : try_get

   // Group -- NODOCS -- Introspection
   //
   // The ~uvm_get_to_lock_dap~ cannot support the standard UVM
   // instrumentation methods (~copy~, ~clone~, ~pack~ and
   // ~unpack~), due to the fact that they would potentially 
   // violate the access policy.
   //  
   // A call to any of these methods will result in an error.

   virtual function void do_copy(uvm_object rhs); endfunction : do_copy

   virtual function void do_pack(uvm_packer packer); endfunction : do_pack

   virtual function void do_unpack(uvm_packer packer); endfunction : do_unpack

   // Group- Reporting
   
   // Function- convert2string
   virtual function string convert2string(); endfunction : convert2string
   
   // Function- do_print
   virtual function void do_print(uvm_printer printer); endfunction : do_print

endclass // uvm_get_to_lock_dap
