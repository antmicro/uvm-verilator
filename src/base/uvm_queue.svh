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
  function new (string name=""); endfunction

endclass


`endif // UVM_QUEUE_SVH
