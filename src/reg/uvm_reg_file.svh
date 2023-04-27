//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2015 NVIDIA Corporation
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



// @uvm-ieee 1800.2-2017 auto 18.3.1
class uvm_reg_file extends uvm_object;


   local uvm_reg_file   m_rf;
   local string            default_hdl_path = "RTL";
   local uvm_pool #(uvm_queue #(string)) hdl_paths_pool;


   `uvm_object_utils(uvm_reg_file)


   //----------------------
   // Group -- NODOCS -- Initialization
   //----------------------


   // @uvm-ieee 1800.2-2017 auto 18.3.2.1
   extern function                  new        (string name="");


   // @uvm-ieee 1800.2-2017 auto 18.3.2.2
   // Group -- NODOCS -- Introspection
   //---------------------

   //
   // Function -- NODOCS -- get_name
   // Get the simple name
   //
   // Return the simple object name of this register file.
   //

   //
   // Function -- NODOCS -- get_full_name
   // Get the hierarchical name
   //
   // Return the hierarchal name of this register file.
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string        get_full_name();


   // @uvm-ieee 1800.2-2017 auto 18.3.3.1

   // @uvm-ieee 1800.2-2017 auto 18.3.3.2
   extern virtual function uvm_reg_file  get_regfile     ();


   //----------------
   // Group -- NODOCS -- Backdoor
   //----------------


   // @uvm-ieee 1800.2-2017 auto 18.3.4.1
   extern function void clear_hdl_path    (string kind = "RTL");


   // @uvm-ieee 1800.2-2017 auto 18.3.4.2
   extern function void add_hdl_path      (string path, string kind = "RTL");


   // @uvm-ieee 1800.2-2017 auto 18.3.4.3
   extern function bit  has_hdl_path      (string kind = "");


   // @uvm-ieee 1800.2-2017 auto 18.3.4.4
   extern function void get_hdl_path      (ref string paths[$], input string kind = "");


   // @uvm-ieee 1800.2-2017 auto 18.3.4.5
   extern function void get_full_hdl_path (ref string paths[$],
                                           input string kind = "",
                                           input string separator = ".");


   // @uvm-ieee 1800.2-2017 auto 18.3.4.7
   extern function void   set_default_hdl_path (string kind);


   // @uvm-ieee 1800.2-2017 auto 18.3.4.6
   extern function string get_default_hdl_path ();


   extern virtual function void          do_print (uvm_printer printer);
   extern virtual function string        convert2string();
   extern virtual function uvm_object    clone      ();
   extern virtual function void          do_copy    (uvm_object rhs);
   extern virtual function bit           do_compare (uvm_object  rhs,
                                                     uvm_comparer comparer);
   extern virtual function void          do_pack    (uvm_packer packer);
   extern virtual function void          do_unpack  (uvm_packer packer);

endclass: uvm_reg_file


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

// new

function uvm_reg_file::new(string name=""); endfunction: new


// configure


// get_regfile

function uvm_reg_file uvm_reg_file::get_regfile(); endfunction


// clear_hdl_path

function void uvm_reg_file::clear_hdl_path(string kind = "RTL"); endfunction


// add_hdl_path

function void uvm_reg_file::add_hdl_path(string path, string kind = "RTL"); endfunction


// has_hdl_path

function bit  uvm_reg_file::has_hdl_path(string kind = ""); endfunction


// get_hdl_path

function void uvm_reg_file::get_hdl_path(ref string paths[$], input string kind = ""); endfunction


// get_full_hdl_path

function void uvm_reg_file::get_full_hdl_path(ref string paths[$],
                                              input string kind = "",
                                              input string separator = "."); endfunction


// get_default_hdl_path

function string uvm_reg_file::get_default_hdl_path(); endfunction


// set_default_hdl_path

function void uvm_reg_file::set_default_hdl_path(string kind); endfunction


// get_parent



// get_full_name

function string uvm_reg_file::get_full_name(); endfunction: get_full_name


//-------------
// STANDARD OPS
//-------------

// convert2string

function string uvm_reg_file::convert2string(); endfunction: convert2string


// do_print

function void uvm_reg_file::do_print (uvm_printer printer); endfunction



// clone

function uvm_object uvm_reg_file::clone(); endfunction

// do_copy

function void uvm_reg_file::do_copy(uvm_object rhs); endfunction


// do_compare

function bit uvm_reg_file::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction


// do_pack

function void uvm_reg_file::do_pack (uvm_packer packer); endfunction


// do_unpack

function void uvm_reg_file::do_unpack (uvm_packer packer); endfunction
