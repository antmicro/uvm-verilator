// 
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2013 Semifore
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
// Title -- NODOCS -- Bit Bashing Test Sequences
//------------------------------------------------------------------------------
// This section defines classes that test individual bits of the registers
// defined in a register model.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_reg_single_bit_bash_seq
//
// Verify the implementation of a single register
// by attempting to write 1's and 0's to every bit in it,
// via every address map in which the register is mapped,
// making sure that the resulting value matches the mirrored value.
//
// If bit-type resource named
// "NO_REG_TESTS" or "NO_REG_BIT_BASH_TEST"
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

// @uvm-ieee 1800.2-2017 auto E.2.1.1
class uvm_reg_single_bit_bash_seq extends uvm_reg_sequence #(uvm_sequence #(uvm_reg_item));

   // Variable -- NODOCS -- rg
   // The register to be tested
   uvm_reg rg;

   `uvm_object_utils(uvm_reg_single_bit_bash_seq)

   // @uvm-ieee 1800.2-2017 auto E.2.1.3
   function new(string name="uvm_reg_single_bit_bash_seq"); endfunction

   virtual task body(); endtask: body


   task bash_kth_bit(uvm_reg         rg,
                     int             k,
                     string          mode,
                     uvm_reg_map     map,
                     uvm_reg_data_t  dc_mask); endtask: bash_kth_bit

endclass: uvm_reg_single_bit_bash_seq


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_reg_bit_bash_seq
//
//
// Verify the implementation of all registers in a block
// by executing the <uvm_reg_single_bit_bash_seq> sequence on it.
//
// If bit-type resource named
// "NO_REG_TESTS" or "NO_REG_BIT_BASH_TEST"
// in the "REG::" namespace
// matches the full name of the block,
// the block is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.get_full_name(),".*"},
//|                            "NO_REG_TESTS", 1, this);
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.2.2.1
class uvm_reg_bit_bash_seq extends uvm_reg_sequence #(uvm_sequence #(uvm_reg_item));

   // Variable -- NODOCS -- model
   //
   // The block to be tested. Declared in the base class.
   //
   //| uvm_reg_block model; 


   // Variable -- NODOCS -- reg_seq
   //
   // The sequence used to test one register
   //
   protected uvm_reg_single_bit_bash_seq reg_seq;
   
   `uvm_object_utils(uvm_reg_bit_bash_seq)

   // @uvm-ieee 1800.2-2017 auto E.2.2.3.1
   function new(string name="uvm_reg_bit_bash_seq"); endfunction



   // @uvm-ieee 1800.2-2017 auto E.2.2.3.2
   virtual task body(); endtask


   // Task -- NODOCS -- do_block
   //
   // Test all of the registers in a given ~block~
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

endclass: uvm_reg_bit_bash_seq
