//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2014 Semifore
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
// Title -- NODOCS -- Virtual Registers
//------------------------------------------------------------------------------
//
// A virtual register is a collection of fields,
// overlaid on top of a memory, usually in an array.
// The semantics and layout of virtual registers comes from
// an agreement between the software and the hardware,
// not any physical structures in the DUT.
//
//------------------------------------------------------------------------------

typedef class uvm_mem_region;
typedef class uvm_mem_mam;

typedef class uvm_vreg_cbs;


//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_vreg
//
// Virtual register abstraction base class
//
// A virtual register represents a set of fields that are
// logically implemented in consecutive memory locations.
//
// All virtual register accesses eventually turn into memory accesses.
//
// A virtual register array may be implemented on top of
// any memory abstraction class and possibly dynamically
// resized and/or relocated.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.9.1
class uvm_vreg extends uvm_object;

   `uvm_register_cb(uvm_vreg, uvm_vreg_cbs)

   local bit locked;
   local uvm_reg_block parent;
   local int unsigned  n_bits;
   local int unsigned  n_used_bits;

   local uvm_vreg_field fields[$];   // Fields in LSB to MSB order

   local uvm_mem          mem;     // Where is it implemented?
   local uvm_reg_addr_t   offset;  // Start of vreg[0]
   local int unsigned     incr;    // From start to start of next
   local longint unsigned size;    //number of vregs
   local bit              is_static;

   local uvm_mem_region   region;    // Not NULL if implemented via MAM
  
   local semaphore atomic;   // Field RMW operations must be atomic
   local string fname;
   local int lineno;
   local bit read_in_progress;
   local bit write_in_progress;

   //
   // Group -- NODOCS -- Initialization
   //


   // @uvm-ieee 1800.2-2017 auto 18.9.1.1.1
   extern function new(string       name,
                       int unsigned n_bits);
                       


   // @uvm-ieee 1800.2-2017 auto 18.9.1.1.2
   extern function void configure(uvm_reg_block     parent,
                                  uvm_mem       mem    = null,
                                  longint unsigned  size   = 0,
                                  uvm_reg_addr_t    offset = 0,
                                  int unsigned      incr   = 0);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.1.3
   extern virtual function bit implement(longint unsigned  n,
                                         uvm_mem       mem    = null,
                                         uvm_reg_addr_t    offset = 0,
                                         int unsigned      incr   = 0);

 
   // @uvm-ieee 1800.2-2017 auto 18.9.1.1.4
   extern virtual function uvm_mem_region allocate(longint unsigned   n,
                                                   uvm_mem_mam        mam,
                                                   uvm_mem_mam_policy alloc = null);

 
   // @uvm-ieee 1800.2-2017 auto 18.9.1.1.5
   extern virtual function uvm_mem_region get_region();


   // @uvm-ieee 1800.2-2017 auto 18.9.1.1.6
   extern virtual function void release_region();


   /*local*/ extern virtual function void set_parent(uvm_reg_block parent);
   /*local*/ extern function void Xlock_modelX();
   
   /*local*/ extern function void add_field(uvm_vreg_field field);
   /*local*/ extern task XatomicX(bit on);

   //
   // Group -- NODOCS -- Introspection
   //

   //
   // Function -- NODOCS -- get_name
   // Get the simple name
   //
   // Return the simple object name of this register.
   //

   //
   // Function -- NODOCS -- get_full_name
   // Get the hierarchical name
   //
   // Return the hierarchal name of this register.
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string        get_full_name();


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.1
   extern virtual function uvm_reg_block get_parent();
   extern virtual function uvm_reg_block get_block();



   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.2
   extern virtual function uvm_mem get_memory();


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.3
   extern virtual function int             get_n_maps      ();


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.4
   extern function         bit             is_in_map       (uvm_reg_map map);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.5
   extern virtual function void            get_maps        (ref uvm_reg_map maps[$]);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.6
   extern virtual function string get_rights(uvm_reg_map map = null);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.7
   extern virtual function string get_access(uvm_reg_map map = null);

   //
   // FUNCTION -- NODOCS -- get_size
   // Returns the size of the virtual register array. 
   //
   extern virtual function int unsigned get_size();

   //
   // FUNCTION -- NODOCS -- get_n_bytes
   // Returns the width, in bytes, of a virtual register.
   //
   // The width of a virtual register is always a multiple of the width
   // of the memory locations used to implement it.
   // For example, a virtual register containing two 1-byte fields
   // implemented in a memory with 4-bytes memory locations is 4-byte wide. 
   //
   extern virtual function int unsigned get_n_bytes();

   //
   // FUNCTION -- NODOCS -- get_n_memlocs
   // Returns the number of memory locations used
   // by a single virtual register. 
   //
   extern virtual function int unsigned get_n_memlocs();

   //
   // FUNCTION -- NODOCS -- get_incr
   // Returns the number of memory locations
   // between two individual virtual registers in the same array. 
   //
   extern virtual function int unsigned get_incr();


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.12
   extern virtual function void get_fields(ref uvm_vreg_field fields[$]);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.13
   extern virtual function uvm_vreg_field get_field_by_name(string name);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.14
   extern virtual function uvm_reg_addr_t  get_offset_in_memory(longint unsigned idx);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.2.15
   extern virtual function uvm_reg_addr_t  get_address(longint unsigned idx,
                                                       uvm_reg_map map = null);

   //
   // Group -- NODOCS -- HDL Access
   //


   // @uvm-ieee 1800.2-2017 auto 18.9.1.3.1
   extern virtual task write(input  longint unsigned   idx,
                             output uvm_status_e  status,
                             input  uvm_reg_data_t     value,
                             input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                             input  uvm_reg_map     map = null,
                             input  uvm_sequence_base  parent = null,
                             input  uvm_object         extension = null,
                             input  string             fname = "",
                             input  int                lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.3.2
   extern virtual task read(input  longint unsigned    idx,
                            output uvm_status_e   status,
                            output uvm_reg_data_t      value,
                            input  uvm_door_e     path = UVM_DEFAULT_DOOR,
                            input  uvm_reg_map      map = null,
                            input  uvm_sequence_base   parent = null,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.3.3
   extern virtual task poke(input  longint unsigned    idx,
                            output uvm_status_e   status,
                            input  uvm_reg_data_t      value,
                            input  uvm_sequence_base   parent = null,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.9.1.3.4
   extern virtual task peek(input  longint unsigned    idx,
                            output uvm_status_e   status,
                            output uvm_reg_data_t      value,
                            input  uvm_sequence_base   parent = null,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);
  

   // @uvm-ieee 1800.2-2017 auto 18.9.1.3.5
   extern function void reset(string kind = "HARD");


   //
   // Group -- NODOCS -- Callbacks
   //


   // @uvm-ieee 1800.2-2017 auto 18.9.1.4.1
   virtual task pre_write(longint unsigned     idx,
                          ref uvm_reg_data_t   wdat,
                          ref uvm_door_e  path,
                          ref uvm_reg_map      map);
   endtask: pre_write


   // @uvm-ieee 1800.2-2017 auto 18.9.1.4.2
   virtual task post_write(longint unsigned       idx,
                           uvm_reg_data_t         wdat,
                           uvm_door_e        path,
                           uvm_reg_map            map,
                           ref uvm_status_e  status);
   endtask: post_write


   // @uvm-ieee 1800.2-2017 auto 18.9.1.4.3
   virtual task pre_read(longint unsigned     idx,
                         ref uvm_door_e  path,
                         ref uvm_reg_map      map);
   endtask: pre_read


   // @uvm-ieee 1800.2-2017 auto 18.9.1.4.4
   virtual task post_read(longint unsigned       idx,
                          ref uvm_reg_data_t     rdat,
                          input uvm_door_e  path,
                          input uvm_reg_map      map,
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

endclass: uvm_vreg



//------------------------------------------------------------------------------
// Class -- NODOCS -- uvm_vreg_cbs
//
// Pre/post read/write callback facade class
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.9.2.1
virtual class uvm_vreg_cbs extends uvm_callback;

   `uvm_object_abstract_utils(uvm_vreg_cbs)

   string fname;
   int    lineno;

   function new(string name = "uvm_reg_cbs"); endfunction
   


   // @uvm-ieee 1800.2-2017 auto 18.9.2.2.1
   virtual task pre_write(uvm_vreg         rg,
                          longint unsigned     idx,
                          ref uvm_reg_data_t   wdat,
                          ref uvm_door_e  path,
                          ref uvm_reg_map   map);
   endtask: pre_write



   // @uvm-ieee 1800.2-2017 auto 18.9.2.2.2
   virtual task post_write(uvm_vreg           rg,
                           longint unsigned       idx,
                           uvm_reg_data_t         wdat,
                           uvm_door_e        path,
                           uvm_reg_map         map,
                           ref uvm_status_e  status);
   endtask: post_write



   // @uvm-ieee 1800.2-2017 auto 18.9.2.2.3
   virtual task pre_read(uvm_vreg         rg,
                         longint unsigned     idx,
                         ref uvm_door_e  path,
                         ref uvm_reg_map   map);
   endtask: pre_read



   // @uvm-ieee 1800.2-2017 auto 18.9.2.2.4
   virtual task post_read(uvm_vreg           rg,
                          longint unsigned       idx,
                          ref uvm_reg_data_t     rdat,
                          input uvm_door_e  path,
                          input uvm_reg_map   map,
                          ref uvm_status_e  status);
   endtask: post_read
endclass: uvm_vreg_cbs


//
// Type -- NODOCS -- uvm_vreg_cb
// Convenience callback type declaration
//
// Use this declaration to register virtual register callbacks rather than
// the more verbose parameterized class
//
typedef uvm_callbacks#(uvm_vreg, uvm_vreg_cbs) uvm_vreg_cb /* @uvm-ieee 1800.2-2017 auto D.4.6.9*/   ;

//
// Type -- NODOCS -- uvm_vreg_cb_iter
// Convenience callback iterator type declaration
//
// Use this declaration to iterate over registered virtual register callbacks
// rather than the more verbose parameterized class
//
typedef uvm_callback_iter#(uvm_vreg, uvm_vreg_cbs) uvm_vreg_cb_iter /* @uvm-ieee 1800.2-2017 auto D.4.6.10*/   ;



//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

function uvm_vreg::new(string       name,
                           int unsigned n_bits); endfunction: new

function void uvm_vreg::configure(uvm_reg_block      parent,
                                      uvm_mem        mem = null,
                                      longint unsigned   size = 0,
                                      uvm_reg_addr_t     offset = 0,
                                      int unsigned       incr = 0); endfunction: configure



function void uvm_vreg::Xlock_modelX(); endfunction: Xlock_modelX


function void uvm_vreg::add_field(uvm_vreg_field field); endfunction: add_field


task uvm_vreg::XatomicX(bit on); endtask: XatomicX


function void uvm_vreg::reset(string kind = "HARD"); endfunction: reset


function string uvm_vreg::get_full_name(); endfunction: get_full_name

function void uvm_vreg::set_parent(uvm_reg_block parent); endfunction: set_parent

function uvm_reg_block uvm_vreg::get_parent(); endfunction: get_parent

function uvm_reg_block uvm_vreg::get_block(); endfunction: get_block


function bit uvm_vreg::implement(longint unsigned n,
                                     uvm_mem      mem = null,
                                     uvm_reg_addr_t   offset = 0,
                                     int unsigned     incr = 0); endfunction: implement


function uvm_mem_region uvm_vreg::allocate(longint unsigned   n,
                                           uvm_mem_mam        mam,
                                           uvm_mem_mam_policy alloc=null); endfunction: allocate


function uvm_mem_region uvm_vreg::get_region(); endfunction: get_region


function void uvm_vreg::release_region(); endfunction: release_region


function uvm_mem uvm_vreg::get_memory(); endfunction: get_memory


function uvm_reg_addr_t  uvm_vreg::get_offset_in_memory(longint unsigned idx); endfunction


function uvm_reg_addr_t  uvm_vreg::get_address(longint unsigned idx,
                                                   uvm_reg_map map = null); endfunction: get_address


function int unsigned uvm_vreg::get_size(); endfunction: get_size


function int unsigned uvm_vreg::get_n_bytes(); endfunction: get_n_bytes


function int unsigned uvm_vreg::get_n_memlocs(); endfunction: get_n_memlocs


function int unsigned uvm_vreg::get_incr(); endfunction: get_incr


function int uvm_vreg::get_n_maps(); endfunction: get_n_maps


function void uvm_vreg::get_maps(ref uvm_reg_map maps[$]); endfunction: get_maps


function bit uvm_vreg::is_in_map(uvm_reg_map map); endfunction


function string uvm_vreg::get_access(uvm_reg_map map = null); endfunction: get_access


function string uvm_vreg::get_rights(uvm_reg_map map = null); endfunction: get_rights


function void uvm_vreg::get_fields(ref uvm_vreg_field fields[$]); endfunction: get_fields


function uvm_vreg_field uvm_vreg::get_field_by_name(string name); endfunction: get_field_by_name


task uvm_vreg::write(input  longint unsigned   idx,
                         output uvm_status_e  status,
                         input  uvm_reg_data_t     value,
                         input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                         input  uvm_reg_map     map = null,
                         input  uvm_sequence_base  parent = null,
                         input  uvm_object         extension = null,
                         input  string             fname = "",
                         input  int                lineno = 0); endtask: write


task uvm_vreg::read(input  longint unsigned   idx,
                        output uvm_status_e  status,
                        output uvm_reg_data_t     value,
                        input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                        input  uvm_reg_map     map = null,
                        input  uvm_sequence_base  parent = null,
                        input  uvm_object         extension = null,
                        input  string             fname = "",
                        input  int                lineno = 0); endtask: read


task uvm_vreg::poke(input longint unsigned   idx,
                        output uvm_status_e status,
                        input  uvm_reg_data_t    value,
                        input  uvm_sequence_base parent = null,
                        input  uvm_object        extension = null,
                        input  string            fname = "",
                        input  int               lineno = 0); endtask: poke


task uvm_vreg::peek(input longint unsigned   idx,
                        output uvm_status_e status,
                        output uvm_reg_data_t    value,
                        input  uvm_sequence_base parent = null,
                        input  uvm_object        extension = null,
                        input  string            fname = "",
                        input  int               lineno = 0); endtask: peek


function void uvm_vreg::do_print (uvm_printer printer); endfunction

function string uvm_vreg::convert2string(); endfunction: convert2string



//TODO - add fatal messages
function uvm_object uvm_vreg::clone(); endfunction

function void uvm_vreg::do_copy   (uvm_object rhs);
endfunction function bit uvm_vreg::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction

function void uvm_vreg::do_pack (uvm_packer packer);
endfunction

function void uvm_vreg::do_unpack (uvm_packer packer);
endfunction
