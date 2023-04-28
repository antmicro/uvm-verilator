//
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011 AMD
// Copyright 2014-2018 NVIDIA Corporation
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

// Title -- NODOCS -- Pool Classes
// This section defines the <uvm_pool #(KEY, T)> class and derivative.

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_pool #(KEY,T)
//
//------------------------------------------------------------------------------
// Implements a class-based dynamic associative array. Allows sparse arrays to
// be allocated on demand, and passed and stored by reference.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 11.2.1
class uvm_void1;
endclass

class uvm_object1;
endclass

class uvm_pool1 #(type T1=uvm_void1) extends uvm_object1;
endclass

class uvm_object_string_pool1 #(type T1=uvm_object1) extends uvm_pool1 #(T1);
endclass

typedef uvm_object_string_pool1 #() uvm_event_pool1;

class uvm_reg_block1;
   uvm_object_string_pool1 #(string) hdl_paths_pool1;
endclass

class uvm_pool #(type KEY=int, T=uvm_void) extends uvm_object;
  function new (string name=""); endfunction


endclass
