// 
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2004-2010 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2015-2018 NVIDIA Corporation
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
// Title -- NODOCS -- Shared Register and Memory Access Test Sequences
//------------------------------------------------------------------------------
// This section defines sequences for testing registers and memories that are
// shared between two or more physical interfaces, i.e. are associated with
// more than one <uvm_reg_map> instance.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_reg_shared_access_seq
//
// Verify the accessibility of a shared register
// by writing through each address map
// then reading it via every other address maps
// in which the register is readable and the backdoor,
// making sure that the resulting value matches the mirrored value.
//
// If bit-type resource named
// "NO_REG_TESTS" or "NO_REG_SHARED_ACCESS_TEST"
// in the "REG::" namespace
// matches the full name of the register,
// the register is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.r0.get_full_name()},
//|                            "NO_REG_TESTS", 1, this);
//
// Registers that contain fields with unknown access policies
// cannot be tested.
//
// The DUT should be idle and not modify any register during this test.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.4.1.1
class uvm_reg_shared_access_seq extends uvm_reg_sequence;

   // Variable -- NODOCS -- rg
   // The register to be tested
   uvm_reg rg;

   `uvm_object_utils(uvm_reg_shared_access_seq)

   // @uvm-ieee 1800.2-2017 auto E.4.1.3
   function new(string name="uvm_reg_shared_access_seq"); endfunction


   virtual task body(); endtask: body
endclass: uvm_reg_shared_access_seq


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_mem_shared_access_seq
//------------------------------------------------------------------------------
//
// Verify the accessibility of a shared memory
// by writing through each address map
// then reading it via every other address maps
// in which the memory is readable and the backdoor,
// making sure that the resulting value matches the written value.
//
// If bit-type resource named
// "NO_REG_TESTS", "NO_MEM_TESTS",
// "NO_REG_SHARED_ACCESS_TEST" or "NO_MEM_SHARED_ACCESS_TEST"
// in the "REG::" namespace
// matches the full name of the memory,
// the memory is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.mem0.get_full_name()},
//|                            "NO_MEM_TESTS", 1, this);
//
// The DUT should be idle and not modify the memory during this test.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.4.2.1
class uvm_mem_shared_access_seq extends uvm_reg_sequence;

   // variable -- NODOCS -- mem
   // The memory to be tested
   uvm_mem mem;

   `uvm_object_utils(uvm_mem_shared_access_seq)

   // @uvm-ieee 1800.2-2017 auto E.4.2.3
   function new(string name="uvm_mem_shared_access_seq"); endfunction

   virtual task body(); endtask: body
endclass: uvm_mem_shared_access_seq



//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_reg_mem_shared_access_seq
//------------------------------------------------------------------------------
//
// Verify the accessibility of all shared registers
// and memories in a block
// by executing the <uvm_reg_shared_access_seq>
// and <uvm_mem_shared_access_seq>
// sequence respectively on every register and memory within it.
//
// If bit-type resource named
// "NO_REG_TESTS", "NO_MEM_TESTS",
// "NO_REG_SHARED_ACCESS_TEST" or "NO_MEM_SHARED_ACCESS_TEST"
// in the "REG::" namespace
// matches the full name of the block,
// the block is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.get_full_name(),".*"},
//|                            "NO_REG_TESTS", 1, this);
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.4.3.1
class uvm_reg_mem_shared_access_seq extends uvm_reg_sequence;

   // Variable -- NODOCS -- model
   //
   // The block to be tested
   //
   //| uvm_reg_block model; 


   // Variable -- NODOCS -- reg_seq
   //
   // The sequence used to test one register
   //
   protected uvm_reg_shared_access_seq reg_seq;
   

   // Variable -- NODOCS -- mem_seq
   //
   // The sequence used to test one memory
   //
   protected uvm_mem_shared_access_seq mem_seq;
   
   `uvm_object_utils(uvm_reg_mem_shared_access_seq)

   // @uvm-ieee 1800.2-2017 auto E.4.3.3.1
   function new(string name="uvm_reg_mem_shared_access_seq"); endfunction



   // @uvm-ieee 1800.2-2017 auto E.4.3.3.2
   virtual task body(); endtask: body


   // Task -- NODOCS -- do_block
   //
   // Test all of the registers and memories in a block
   //
   protected virtual task do_block(uvm_reg_block blk); endtask: do_block


   //
   // task -- NODOCS -- reset_blk
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


endclass: uvm_reg_mem_shared_access_seq
