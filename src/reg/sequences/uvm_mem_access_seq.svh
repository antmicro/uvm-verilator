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

//
// TITLE -- NODOCS -- Memory Access Test Sequence
//

//
// class -- NODOCS -- uvm_mem_single_access_seq
//
// Verify the accessibility of a memory
// by writing through its default address map
// then reading it via the backdoor, then reversing the process,
// making sure that the resulting value matches the written value.
//
// If bit-type resource named
// "NO_REG_TESTS", "NO_MEM_TESTS", or "NO_MEM_ACCESS_TEST"
// in the "REG::" namespace
// matches the full name of the memory,
// the memory is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.mem0.get_full_name()},
//|                            "NO_MEM_TESTS", 1, this);
//
// Memories without an available backdoor
// cannot be tested.
//
// The DUT should be idle and not modify the memory during this test.
//

// @uvm-ieee 1800.2-2017 auto E.5.1.1
class uvm_mem_single_access_seq extends uvm_reg_sequence;
endclass: uvm_mem_single_access_seq




//
// class -- NODOCS -- uvm_mem_access_seq
//
// Verify the accessibility of all memories in a block
// by executing the <uvm_mem_single_access_seq> sequence on
// every memory within it.
//
// If bit-type resource named
// "NO_REG_TESTS", "NO_MEM_TESTS", or "NO_MEM_ACCESS_TEST"
// in the "REG::" namespace
// matches the full name of the block,
// the block is not tested.
//
//| uvm_resource_db#(bit)::set({"REG::",regmodel.blk.get_full_name(),".*"},
//|                            "NO_MEM_TESTS", 1, this);
//

// @uvm-ieee 1800.2-2017 auto E.5.2.1
class uvm_mem_access_seq extends uvm_reg_sequence;

endclass: uvm_mem_access_seq
