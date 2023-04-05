//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2004-2018 Synopsys, Inc.
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
// Title -- NODOCS -- Virtual Register Field Classes
//
// This section defines the virtual field and callback classes.
//
// A virtual field is set of contiguous bits in one or more memory locations.
// The semantics and layout of virtual fields comes from
// an agreement between the software and the hardware,
// not any physical structures in the DUT. 
//
//------------------------------------------------------------------------------

typedef class uvm_vreg_field_cbs;


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_vreg_field
//
// Virtual field abstraction class
//
// A virtual field represents a set of adjacent bits that are
// logically implemented in consecutive memory locations.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.10.1
class uvm_vreg_field extends uvm_object;

   `uvm_object_utils(uvm_vreg_field)
   `uvm_register_cb(uvm_vreg_field, uvm_vreg_field_cbs)
   
   local uvm_vreg parent;
   local int unsigned lsb;
   local int unsigned size;
   local string fname;
   local int lineno;
   local bit read_in_progress;
   local bit write_in_progress;


   //
   // Group -- NODOCS -- initialization
   //


   // @uvm-ieee 1800.2-2017 auto 18.10.2.1
   extern function new(string name = "uvm_vreg_field");


   // @uvm-ieee 1800.2-2017 auto 18.10.2.2
   extern function void configure(uvm_vreg parent,
                                  int unsigned size,
                                  int unsigned lsb_pos);


   //
   // Group -- NODOCS -- Introspection
   //

   //
   // Function -- NODOCS -- get_name
   // Get the simple name
   //
   // Return the simple object name of this virtual field
   //

   //
   // Function -- NODOCS -- get_full_name
   // Get the hierarchical name
   //
   // Return the hierarchal name of this virtual field
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string        get_full_name();


   // @uvm-ieee 1800.2-2017 auto 18.10.3.1
   extern virtual function uvm_vreg get_parent();
   extern virtual function uvm_vreg get_register();

   //
   // FUNCTION -- NODOCS -- get_lsb_pos_in_register
   // Return the position of the virtual field
   ///
   // Returns the index of the least significant bit of the virtual field
   // in the virtual register that instantiates it.
   // An offset of 0 indicates a field that is aligned with the
   // least-significant bit of the register. 
   //
   extern virtual function int unsigned get_lsb_pos_in_register();

   //
   // FUNCTION -- NODOCS -- get_n_bits
   // Returns the width, in bits, of the virtual field. 
   //
   extern virtual function int unsigned get_n_bits();


   // @uvm-ieee 1800.2-2017 auto 18.10.3.4
   extern virtual function string get_access(uvm_reg_map map = null);


   //
   // Group -- NODOCS -- HDL Access
   //


   // @uvm-ieee 1800.2-2017 auto 18.10.4.1
   extern virtual task write(input  longint unsigned   idx,
                             output uvm_status_e  status,
                             input  uvm_reg_data_t     value,
                             input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                             input  uvm_reg_map        map = null,
                             input  uvm_sequence_base  parent = null,
                             input  uvm_object         extension = null,
                             input  string             fname = "",
                             input  int                lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.10.4.2
   extern virtual task read(input  longint unsigned    idx,
                            output uvm_status_e   status,
                            output uvm_reg_data_t      value,
                            input  uvm_door_e     path = UVM_DEFAULT_DOOR,
                            input  uvm_reg_map         map = null,
                            input  uvm_sequence_base   parent = null,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);
               


   // @uvm-ieee 1800.2-2017 auto 18.10.4.3
   extern virtual task poke(input  longint unsigned    idx,
                            output uvm_status_e   status,
                            input  uvm_reg_data_t      value,
                            input  uvm_sequence_base   parent = null,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.10.4.4
   extern virtual task peek(input  longint unsigned    idx,
                            output uvm_status_e   status,
                            output uvm_reg_data_t      value,
                            input  uvm_sequence_base   parent = null,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);

   //
   // Group -- NODOCS -- Callbacks
   //



   // @uvm-ieee 1800.2-2017 auto 18.10.5.1
   virtual task pre_write(longint unsigned     idx,
                          ref uvm_reg_data_t   wdat,
                          ref uvm_door_e  path,
                          ref uvm_reg_map   map);
   endtask: pre_write


   // @uvm-ieee 1800.2-2017 auto 18.10.5.2
   virtual task post_write(longint unsigned       idx,
                           uvm_reg_data_t         wdat,
                           uvm_door_e        path,
                           uvm_reg_map         map,
                           ref uvm_status_e  status);
   endtask: post_write


   // @uvm-ieee 1800.2-2017 auto 18.10.5.3
   virtual task pre_read(longint unsigned      idx,
                         ref uvm_door_e   path,
                         ref uvm_reg_map    map);
   endtask: pre_read


   // @uvm-ieee 1800.2-2017 auto 18.10.5.4
   virtual task post_read(longint unsigned       idx,
                          ref uvm_reg_data_t     rdat,
                          uvm_door_e        path,
                          uvm_reg_map         map,
                          ref uvm_status_e  status);
   endtask: post_read


   extern virtual function void do_print (uvm_printer printer);
   extern virtual function string convert2string;
   extern virtual function uvm_object clone();
   extern virtual function void do_copy   (uvm_object rhs);
   extern virtual function bit do_compare (uvm_object  rhs,
                                          uvm_comparer comparer);
   extern virtual function void do_pack (uvm_packer packer);
   extern virtual function void do_unpack (uvm_packer packer);

endclass: uvm_vreg_field


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_vreg_field_cbs
//
// Pre/post read/write callback facade class
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.10.6.1
virtual class uvm_vreg_field_cbs extends uvm_callback;
   string fname;
   int    lineno;


   `uvm_object_abstract_utils(uvm_vreg_field_cbs)

   function new(string name = "uvm_vreg_field_cbs"); endfunction
   


   // @uvm-ieee 1800.2-2017 auto 18.10.6.2.1
   virtual task pre_write(uvm_vreg_field       field,
                          longint unsigned     idx,
                          ref uvm_reg_data_t   wdat,
                          ref uvm_door_e  path,
                          ref uvm_reg_map   map);
   endtask: pre_write



   // @uvm-ieee 1800.2-2017 auto 18.10.6.2.2
   virtual task post_write(uvm_vreg_field        field,
                           longint unsigned      idx,
                           uvm_reg_data_t        wdat,
                           uvm_door_e       path,
                           uvm_reg_map        map,
                           ref uvm_status_e status);
   endtask: post_write



   // @uvm-ieee 1800.2-2017 auto 18.10.6.2.3
   virtual task pre_read(uvm_vreg_field        field,
                         longint unsigned      idx,
                         ref uvm_door_e   path,
                         ref uvm_reg_map    map);
   endtask: pre_read



   // @uvm-ieee 1800.2-2017 auto 18.10.6.2.4
   virtual task post_read(uvm_vreg_field         field,
                          longint unsigned       idx,
                          ref uvm_reg_data_t     rdat,
                          uvm_door_e        path,
                          uvm_reg_map         map,
                          ref uvm_status_e  status);
   endtask: post_read
endclass: uvm_vreg_field_cbs


//
// Type -- NODOCS -- uvm_vreg_field_cb
// Convenience callback type declaration
//
// Use this declaration to register virtual field callbacks rather than
// the more verbose parameterized class
//
typedef uvm_callbacks#(uvm_vreg_field, uvm_vreg_field_cbs) uvm_vreg_field_cb /* @uvm-ieee 1800.2-2017 auto D.4.6.11*/   ;

//
// Type -- NODOCS -- uvm_vreg_field_cb_iter
// Convenience callback iterator type declaration
//
// Use this declaration to iterate over registered virtual field callbacks
// rather than the more verbose parameterized class
//
typedef uvm_callback_iter#(uvm_vreg_field, uvm_vreg_field_cbs) uvm_vreg_field_cb_iter /* @uvm-ieee 1800.2-2017 auto D.4.6.12*/   ;




function uvm_vreg_field::new(string name="uvm_vreg_field"); endfunction: new

function void uvm_vreg_field::configure(uvm_vreg  parent,
                                   int unsigned  size,
                                   int unsigned  lsb_pos); endfunction: configure



function string uvm_vreg_field::get_full_name(); endfunction: get_full_name


function uvm_vreg uvm_vreg_field::get_register(); endfunction: get_register


function uvm_vreg uvm_vreg_field::get_parent(); endfunction: get_parent



function int unsigned uvm_vreg_field::get_lsb_pos_in_register(); endfunction: get_lsb_pos_in_register


function int unsigned uvm_vreg_field::get_n_bits(); endfunction: get_n_bits


function string uvm_vreg_field::get_access(uvm_reg_map map = null); endfunction: get_access


task uvm_vreg_field::write(input  longint unsigned    idx,
                           output uvm_status_e   status,
                           input  uvm_reg_data_t      value,
                           input  uvm_door_e     path = UVM_DEFAULT_DOOR,
                           input  uvm_reg_map      map = null,
                           input  uvm_sequence_base   parent = null,
                           input  uvm_object          extension = null,
                           input  string              fname = "",
                           input  int                 lineno = 0); endtask: write


task uvm_vreg_field::read(input longint unsigned     idx,
                          output uvm_status_e   status,
                          output uvm_reg_data_t      value,
                          input  uvm_door_e     path = UVM_DEFAULT_DOOR,
                          input  uvm_reg_map      map = null,
                          input  uvm_sequence_base   parent = null,
                          input  uvm_object          extension = null,
                          input  string              fname = "",
                          input  int                 lineno = 0); endtask: read
               

task uvm_vreg_field::poke(input  longint unsigned  idx,
                          output uvm_status_e status,
                          input  uvm_reg_data_t    value,
                          input  uvm_sequence_base parent = null,
                          input  uvm_object        extension = null,
                          input  string            fname = "",
                          input  int               lineno = 0); endtask: poke


task uvm_vreg_field::peek(input  longint unsigned  idx,
                          output uvm_status_e status,
                          output uvm_reg_data_t    value,
                          input  uvm_sequence_base parent = null,
                          input  uvm_object        extension = null,
                          input  string            fname = "",
                          input  int               lineno = 0); endtask: peek
               

function void uvm_vreg_field::do_print (uvm_printer printer); endfunction

function string uvm_vreg_field::convert2string(); endfunction

//TODO - add fatal messages

function uvm_object uvm_vreg_field::clone(); endfunction

function void uvm_vreg_field::do_copy   (uvm_object rhs);
endfunction

function bit uvm_vreg_field::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction

function void uvm_vreg_field::do_pack (uvm_packer packer);
endfunction

function void uvm_vreg_field::do_unpack (uvm_packer packer);
endfunction
