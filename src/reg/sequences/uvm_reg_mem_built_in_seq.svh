//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2010 Synopsys, Inc.
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
// Class -- NODOCS -- uvm_reg_mem_built_in_seq
//
// Sequence that executes a user-defined selection
// of pre-defined register and memory test sequences.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto E.8.1
class uvm_reg_mem_built_in_seq extends uvm_reg_sequence;

   `uvm_object_utils(uvm_reg_mem_built_in_seq)

   // @uvm-ieee 1800.2-2017 auto E.8.3.1
   function new(string name="uvm_reg_mem_built_in_seq"); endfunction

   // Variable -- NODOCS -- model
   //
   // The block to be tested. Declared in the base class.
   //



   // Variable -- NODOCS -- tests
   //
   // The pre-defined test sequences to be executed.
   //
   bit [63:0] tests = UVM_DO_ALL_REG_MEM_TESTS;


   // Task -- NODOCS -- body
   //
   // Executes any or all the built-in register and memory sequences.
   // Do not call directly. Use seq.start() instead.
   
   // @uvm-ieee 1800.2-2017 auto E.8.3.2
   virtual task body(); endtask: body

endclass: uvm_reg_mem_built_in_seq
