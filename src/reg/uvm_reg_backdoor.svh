//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2004-2018 Synopsys, Inc.
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

typedef class uvm_reg_cbs;


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_reg_backdoor
//
// Base class for user-defined back-door register and memory access.
//
// This class can be extended by users to provide user-specific back-door access
// to registers and memories that are not implemented in pure SystemVerilog
// or that are not accessible using the default DPI backdoor mechanism.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 19.5.1
virtual class uvm_reg_backdoor extends uvm_object;


   `uvm_object_abstract_utils(uvm_reg_backdoor)


   // @uvm-ieee 1800.2-2017 auto 19.5.2.1
   function new(string name = ""); endfunction: new

   

   // @uvm-ieee 1800.2-2017 auto 19.5.2.2
   protected task do_pre_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.3
   protected task do_post_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.4
   protected task do_pre_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.5
   protected task do_post_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.6
   extern virtual task write(uvm_reg_item rw);



   // @uvm-ieee 1800.2-2017 auto 19.5.2.7
   extern virtual task read(uvm_reg_item rw);

   

   // @uvm-ieee 1800.2-2017 auto 19.5.2.8
   extern virtual function void read_func(uvm_reg_item rw);



   // @uvm-ieee 1800.2-2017 auto 19.5.2.9
   extern virtual function bit is_auto_updated(uvm_reg_field field);



   // @uvm-ieee 1800.2-2017 auto 19.5.2.10
   extern virtual local task wait_for_change(uvm_object element);

  
   /*local*/ extern function void start_update_thread(uvm_object element);
   /*local*/ extern function void kill_update_thread(uvm_object element);
   /*local*/ extern function bit has_update_threads();



   // @uvm-ieee 1800.2-2017 auto 19.5.2.11
   virtual task pre_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.12
   virtual task post_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.13
   virtual task pre_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 19.5.2.14
   virtual task post_write(uvm_reg_item rw); endtask


   string fname;
   int lineno;

`ifdef UVM_USE_PROCESS_CONTAINER

`else

`endif 

   `uvm_register_cb(uvm_reg_backdoor, uvm_reg_cbs)


endclass: uvm_reg_backdoor


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------


// is_auto_updated

function bit uvm_reg_backdoor::is_auto_updated(uvm_reg_field field); endfunction


// wait_for_change

task uvm_reg_backdoor::wait_for_change(uvm_object element); endtask


// start_update_thread

function void uvm_reg_backdoor::start_update_thread(uvm_object element); endfunction


// kill_update_thread

function void uvm_reg_backdoor::kill_update_thread(uvm_object element); endfunction


// has_update_threads

function bit uvm_reg_backdoor::has_update_threads(); endfunction


// write

task uvm_reg_backdoor::write(uvm_reg_item rw); endtask


// read

task uvm_reg_backdoor::read(uvm_reg_item rw); endtask


// read_func

function void uvm_reg_backdoor::read_func(uvm_reg_item rw); endfunction
