// 
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2004-2010 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2014-2018 NVIDIA Corporation
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 


//------------------------------------------------------------------------------
// Title -- NODOCS -- Memory Walking-Ones Test Sequences
//
// This section defines sequences for applying a "walking-ones"
// algorithm on one or more memories.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_mem_single_walk_seq
//
// Runs the walking-ones algorithm on the memory given by the <mem> property,
// which must be assigned prior to starting this sequence.
//
// If bit-type resource named
// "NO_REG_TESTS", "NO_MEM_TESTS", or "NO_MEM_WALK_TEST"
// in the "REG::" namespace
// matches the full name of the memory,
// the memory is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.mem0.get_full_name()},
//|                            "NO_MEM_TESTS", 1, this);
//
// The walking ones algorithm is performed for each map in which the memory
// is defined.
//
//| for (k = 0 thru memsize-1)
//|   write addr=k data=~k
//|   if (k > 0) {
//|     read addr=k-1, expect data=~(k-1)
//|     write addr=k-1 data=k-1
//|   if (k == last addr)
//|     read addr=k, expect data=~k
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.6.1.1
class uvm_mem_single_walk_seq extends uvm_reg_sequence #(uvm_sequence #(uvm_reg_item));

   `uvm_object_utils(uvm_mem_single_walk_seq)


   // Variable -- NODOCS -- mem
   //
   // The memory to test; must be assigned prior to starting sequence.

   uvm_mem mem;


   // Function -- NODOCS -- new
   //
   // Creates a new instance of the class with the given name.

   // @uvm-ieee 1800.2-2017 auto E.6.1.3.1
   function new(string name="uvm_mem_walk_seq"); endfunction


   // Task -- NODOCS -- body
   //
   // Performs the walking-ones algorithm on each map of the memory
   // specified in <mem>.

   // @uvm-ieee 1800.2-2017 auto E.6.1.3.2
   virtual task body(); endtask: body

endclass: uvm_mem_single_walk_seq



//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_mem_walk_seq
//
// Verifies the all memories in a block
// by executing the <uvm_mem_single_walk_seq> sequence on
// every memory within it.
//
// If bit-type resource named
// "NO_REG_TESTS", "NO_MEM_TESTS", or "NO_MEM_WALK_TEST"
// in the "REG::" namespace
// matches the full name of the block,
// the block is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.get_full_name(),".*"},
//|                            "NO_MEM_TESTS", 1, this);
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.6.2.1
class uvm_mem_walk_seq extends uvm_reg_sequence #(uvm_sequence #(uvm_reg_item));

   // Variable -- NODOCS -- model
   //
   // The block to be tested. Declared in the base class.
   //
   //| uvm_reg_block model; 


   // Variable -- NODOCS -- mem_seq
   //
   // The sequence used to test one memory
   //
   protected uvm_mem_single_walk_seq mem_seq;

   `uvm_object_utils(uvm_mem_walk_seq)

   // @uvm-ieee 1800.2-2017 auto E.6.3.1
   function new(string name="uvm_mem_walk_seq"); endfunction



   // @uvm-ieee 1800.2-2017 auto E.6.3.2
   virtual task body(); endtask: body


   // Task -- NODOCS -- do_block
   //
   // Test all of the memories in a given ~block~
   //
   protected virtual task do_block(uvm_reg_block blk); endtask: do_block


   // Task -- NODOCS -- reset_blk
   //
   // Reset the DUT that corresponds to the specified block abstraction class.
   //
   // Currently empty.
   // Will rollback the environment's phase to the ~reset~
   // phase once the new phasing is available.
   //
   // In the meantime, the DUT should be reset before executing this
   // test sequence or this method should be implemented
   // in an extension to reset the DUT.
   //
   virtual task reset_blk(uvm_reg_block blk);
   endtask

endclass: uvm_mem_walk_seq
