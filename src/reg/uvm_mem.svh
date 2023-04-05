//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2018 Intel Corporation
// Copyright 2004-2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2012 Accellera Systems Initiative
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


//------------------------------------------------------------------------------
// CLASS -- NODOCS -- uvm_mem
//------------------------------------------------------------------------------
// Memory abstraction base class
//
// A memory is a collection of contiguous locations.
// A memory may be accessible via more than one address map.
//
// Unlike registers, memories are not mirrored because of the potentially
// large data space: tests that walk the entire memory space would negate
// any benefit from sparse memory modelling techniques.
// Rather than relying on a mirror, it is recommended that
// backdoor access be used instead.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.6.1
class uvm_mem extends uvm_object;
// See Mantis 6040. I did NOT make this class virtual because it 
// seems to break a lot of existing tests and code. 
// Sought LRM clarification

   typedef enum {UNKNOWNS, ZEROES, ONES, ADDRESS, VALUE, INCR, DECR} init_e;

   local bit               m_locked;
   local bit               m_read_in_progress;
   local bit               m_write_in_progress;
   local string            m_access;
   local longint unsigned  m_size;
   local uvm_reg_block     m_parent;
   local bit               m_maps[uvm_reg_map];
   local int unsigned      m_n_bits;
   local uvm_reg_backdoor  m_backdoor;
   local bit               m_is_powered_down;
   local int               m_has_cover;
   local int               m_cover_on;
   local string            m_fname;
   local int               m_lineno;
   local bit               m_vregs[uvm_vreg];
   local uvm_object_string_pool
               #(uvm_queue #(uvm_hdl_path_concat)) m_hdl_paths_pool;

   local static int unsigned  m_max_size;

   //----------------------
   // Group -- NODOCS -- Initialization
   //----------------------


   // @uvm-ieee 1800.2-2017 auto 18.6.3.1
   extern function new (string           name,
                        longint unsigned size,
                        int unsigned     n_bits,
                        string           access = "RW",
                        int              has_coverage = UVM_NO_COVERAGE);

   

   // @uvm-ieee 1800.2-2017 auto 18.6.3.2
   extern function void configure (uvm_reg_block parent,
                                   string        hdl_path = "");

   

   // @uvm-ieee 1800.2-2017 auto 18.6.3.3
   extern virtual function void set_offset (uvm_reg_map    map,
                                            uvm_reg_addr_t offset,
                                            bit            unmapped = 0);


   /*local*/ extern virtual function void set_parent(uvm_reg_block parent);
   /*local*/ extern function void add_map(uvm_reg_map map);
   /*local*/ extern function void Xlock_modelX();
   /*local*/ extern function void Xadd_vregX(uvm_vreg vreg);
   /*local*/ extern function void Xdelete_vregX(uvm_vreg vreg);


   // variable -- NODOCS -- mam
   //
   // Memory allocation manager
   //
   // Memory allocation manager for the memory corresponding to this
   // abstraction class instance.
   // Can be used to allocate regions of consecutive addresses of
   // specific sizes, such as DMA buffers,
   // or to locate virtual register array.
   //
   uvm_mem_mam mam;


   //---------------------
   // Group -- NODOCS -- Introspection
   //---------------------

   // Function -- NODOCS -- get_name
   //
   // Get the simple name
   //
   // Return the simple object name of this memory.
   //

   // Function -- NODOCS -- get_full_name
   //
   // Get the hierarchical name
   //
   // Return the hierarchal name of this memory.
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string get_full_name();



   // @uvm-ieee 1800.2-2017 auto 18.6.4.1
   extern virtual function uvm_reg_block get_parent ();
   extern virtual function uvm_reg_block get_block  ();



   // @uvm-ieee 1800.2-2017 auto 18.6.4.2
   extern virtual function int get_n_maps ();



   // @uvm-ieee 1800.2-2017 auto 18.6.4.3
   extern function bit is_in_map (uvm_reg_map map);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.4
   extern virtual function void get_maps (ref uvm_reg_map maps[$]);


   /*local*/ extern function uvm_reg_map get_local_map   (uvm_reg_map map);

   /*local*/ extern function uvm_reg_map get_default_map ();



   // @uvm-ieee 1800.2-2017 auto 18.6.4.5
   extern virtual function string get_rights (uvm_reg_map map = null);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.6
   extern virtual function string get_access(uvm_reg_map map = null);


   // Function -- NODOCS -- get_size
   //
   // Returns the number of unique memory locations in this memory. 
   // this is in units of the memory declaration: full memory is get_size()*get_n_bits() (bits)
   extern function longint unsigned get_size();


   // Function -- NODOCS -- get_n_bytes
   //
   // Return the width, in number of bytes, of each memory location
   //
   extern function int unsigned get_n_bytes();


   // Function -- NODOCS -- get_n_bits
   //
   // Returns the width, in number of bits, of each memory location
   //
   extern function int unsigned get_n_bits();


   // Function -- NODOCS -- get_max_size
   //
   // Returns the maximum width, in number of bits, of all memories
   //
   extern static function int unsigned    get_max_size();



   // @uvm-ieee 1800.2-2017 auto 18.6.4.11
   extern virtual function void get_virtual_registers(ref uvm_vreg regs[$]);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.12
   extern virtual function void get_virtual_fields(ref uvm_vreg_field fields[$]);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.13
   extern virtual function uvm_vreg get_vreg_by_name(string name);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.14
   extern virtual function uvm_vreg_field  get_vfield_by_name(string name);


   // Function -- NODOCS -- get_vreg_by_offset
   //
   // Find the virtual register implemented at the specified offset
   //
   // Finds the virtual register implemented in this memory
   // at the specified ~offset~ in the specified address ~map~
   // and returns its abstraction class instance.
   // If no virtual register at the offset is found, returns ~null~. 
   //
   extern virtual function uvm_vreg get_vreg_by_offset(uvm_reg_addr_t offset,
                                                       uvm_reg_map    map = null);

   

   // @uvm-ieee 1800.2-2017 auto 18.6.4.15
   extern virtual function uvm_reg_addr_t  get_offset (uvm_reg_addr_t offset = 0,
                                                       uvm_reg_map    map = null);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.16
   extern virtual function uvm_reg_addr_t  get_address(uvm_reg_addr_t  offset = 0,
                                                       uvm_reg_map   map = null);



   // @uvm-ieee 1800.2-2017 auto 18.6.4.17
   extern virtual function int get_addresses(uvm_reg_addr_t     offset = 0,
                                             uvm_reg_map        map=null,
                                             ref uvm_reg_addr_t addr[]);


   //------------------
   // Group -- NODOCS -- HDL Access
   //------------------


   // @uvm-ieee 1800.2-2017 auto 18.6.5.1
   extern virtual task write(output uvm_status_e       status,
                             input  uvm_reg_addr_t     offset,
                             input  uvm_reg_data_t     value,
                             input  uvm_door_e         path   = UVM_DEFAULT_DOOR,
                             input  uvm_reg_map        map = null,
                             input  uvm_sequence_base  parent = null,
                             input  int                prior = -1,
                             input  uvm_object         extension = null,
                             input  string             fname = "",
                             input  int                lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.6.5.2
   extern virtual task read(output uvm_status_e        status,
                            input  uvm_reg_addr_t      offset,
                            output uvm_reg_data_t      value,
                            input  uvm_door_e          path   = UVM_DEFAULT_DOOR,
                            input  uvm_reg_map         map = null,
                            input  uvm_sequence_base   parent = null,
                            input  int                 prior = -1,
                            input  uvm_object          extension = null,
                            input  string              fname = "",
                            input  int                 lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.6.5.3
   extern virtual task burst_write(output uvm_status_e      status,
                                   input  uvm_reg_addr_t    offset,
                                   input  uvm_reg_data_t    value[],
                                   input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                                   input  uvm_reg_map       map = null,
                                   input  uvm_sequence_base parent = null,
                                   input  int               prior = -1,
                                   input  uvm_object        extension = null,
                                   input  string            fname = "",
                                   input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.6.5.4
   extern virtual task burst_read(output uvm_status_e      status,
                                  input  uvm_reg_addr_t    offset,
                                  ref    uvm_reg_data_t    value[],
                                  input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                                  input  uvm_reg_map       map = null,
                                  input  uvm_sequence_base parent = null,
                                  input  int               prior = -1,
                                  input  uvm_object        extension = null,
                                  input  string            fname = "",
                                  input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.6.5.5
   extern virtual task poke(output uvm_status_e       status,
                            input  uvm_reg_addr_t     offset,
                            input  uvm_reg_data_t     value,
                            input  string             kind = "",
                            input  uvm_sequence_base  parent = null,
                            input  uvm_object         extension = null,
                            input  string             fname = "",
                            input  int                lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.6.5.6
   extern virtual task peek(output uvm_status_e       status,
                            input  uvm_reg_addr_t     offset,
                            output uvm_reg_data_t     value,
                            input  string             kind = "",
                            input  uvm_sequence_base  parent = null,
                            input  uvm_object         extension = null,
                            input  string             fname = "",
                            input  int                lineno = 0);



   extern protected function bit Xcheck_accessX (input uvm_reg_item rw,
                                                 output uvm_reg_map_info map_info);
   

   extern virtual task do_write (uvm_reg_item rw);
   extern virtual task do_read  (uvm_reg_item rw);


   //-----------------
   // Group -- NODOCS -- Frontdoor
   //-----------------


   // @uvm-ieee 1800.2-2017 auto 18.6.6.2
   extern function void set_frontdoor(uvm_reg_frontdoor ftdr,
                                      uvm_reg_map map = null,
                                      string fname = "",
                                      int lineno = 0);
   


   // @uvm-ieee 1800.2-2017 auto 18.6.6.1
   extern function uvm_reg_frontdoor get_frontdoor(uvm_reg_map map = null);


   //----------------
   // Group -- NODOCS -- Backdoor
   //----------------


   // @uvm-ieee 1800.2-2017 auto 18.6.7.2
   extern function void set_backdoor (uvm_reg_backdoor bkdr,
                                      string fname = "",
                                      int lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.6.7.1
   extern function uvm_reg_backdoor get_backdoor(bit inherited = 1);



   // @uvm-ieee 1800.2-2017 auto 18.6.7.3
   extern function void clear_hdl_path (string kind = "RTL");

   

   // @uvm-ieee 1800.2-2017 auto 18.6.7.4
   extern function void add_hdl_path (uvm_hdl_path_slice slices[],
                                      string kind = "RTL");
   


   // @uvm-ieee 1800.2-2017 auto 18.6.7.5
   extern function void add_hdl_path_slice(string name,
                                           int offset,
                                           int size,
                                           bit first = 0,
                                           string kind = "RTL");



   // @uvm-ieee 1800.2-2017 auto 18.6.7.6
   extern function bit  has_hdl_path (string kind = "");



   // @uvm-ieee 1800.2-2017 auto 18.6.7.7
   extern function void get_hdl_path (ref uvm_hdl_path_concat paths[$],
                                      input string kind = "");



   // @uvm-ieee 1800.2-2017 auto 18.6.7.9
   extern function void get_full_hdl_path (ref uvm_hdl_path_concat paths[$],
                                           input string kind = "",
                                           input string separator = ".");


   // @uvm-ieee 1800.2-2017 auto 18.6.7.8
   extern function void get_hdl_path_kinds (ref string kinds[$]);


   // @uvm-ieee 1800.2-2017 auto 18.6.7.10
   extern virtual protected task backdoor_read(uvm_reg_item rw);



   // @uvm-ieee 1800.2-2017 auto 18.6.7.11
   extern virtual task backdoor_write(uvm_reg_item rw);

   

   extern virtual function uvm_status_e backdoor_read_func(uvm_reg_item rw);


   //-----------------
   // Group -- NODOCS -- Callbacks
   //-----------------
   `uvm_register_cb(uvm_mem, uvm_reg_cbs)



   // @uvm-ieee 1800.2-2017 auto 18.6.9.1
   virtual task pre_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.6.9.2
   virtual task post_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.6.9.3
   virtual task pre_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.6.9.4
   virtual task post_read(uvm_reg_item rw); endtask


   //----------------
   // Group -- NODOCS -- Coverage
   //----------------


   // @uvm-ieee 1800.2-2017 auto 18.6.8.1
   extern protected function uvm_reg_cvr_t build_coverage(uvm_reg_cvr_t models);



   // @uvm-ieee 1800.2-2017 auto 18.6.8.2
   extern virtual protected function void add_coverage(uvm_reg_cvr_t models);



   // @uvm-ieee 1800.2-2017 auto 18.6.8.3
   extern virtual function bit has_coverage(uvm_reg_cvr_t models);



   // @uvm-ieee 1800.2-2017 auto 18.6.8.5
   extern virtual function uvm_reg_cvr_t set_coverage(uvm_reg_cvr_t is_on);



   // @uvm-ieee 1800.2-2017 auto 18.6.8.4
   extern virtual function bit get_coverage(uvm_reg_cvr_t is_on);



   // @uvm-ieee 1800.2-2017 auto 18.6.8.6
   protected virtual function void  sample(uvm_reg_addr_t offset,
                                           bit            is_read,
                                           uvm_reg_map    map);
   endfunction

   /*local*/ function void XsampleX(uvm_reg_addr_t addr,
                                    bit            is_read,
                                    uvm_reg_map    map); endfunction

   // Core ovm_object operations

   extern virtual function void do_print (uvm_printer printer);
   extern virtual function string convert2string();
   extern virtual function uvm_object clone();
   extern virtual function void do_copy   (uvm_object rhs);
   extern virtual function bit do_compare (uvm_object  rhs,
                                          uvm_comparer comparer);
   extern virtual function void do_pack (uvm_packer packer);
   extern virtual function void do_unpack (uvm_packer packer);


endclass: uvm_mem



//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------


// new

function uvm_mem::new (string           name,
                       longint unsigned size,
                       int unsigned     n_bits,
                       string           access = "RW",
                       int              has_coverage = UVM_NO_COVERAGE); endfunction: new


// configure

function void uvm_mem::configure(uvm_reg_block  parent,
                                 string         hdl_path="");
endfunction: configure


// set_offset

function void uvm_mem::set_offset (uvm_reg_map    map,
                                   uvm_reg_addr_t offset,
                                   bit unmapped = 0); endfunction


// add_map

function void uvm_mem::add_map(uvm_reg_map map); endfunction


// Xlock_modelX

function void uvm_mem::Xlock_modelX(); endfunction: Xlock_modelX


// get_full_name

function string uvm_mem::get_full_name(); endfunction: get_full_name


// get_block

function uvm_reg_block uvm_mem::get_block(); endfunction: get_block


// get_n_maps

function int uvm_mem::get_n_maps(); endfunction: get_n_maps


// get_maps

function void uvm_mem::get_maps(ref uvm_reg_map maps[$]); endfunction


// is_in_map

function bit uvm_mem::is_in_map(uvm_reg_map map); endfunction


// get_local_map

function uvm_reg_map uvm_mem::get_local_map(uvm_reg_map map); endfunction


// get_default_map

function uvm_reg_map uvm_mem::get_default_map(); endfunction


// get_access

function string uvm_mem::get_access(uvm_reg_map map = null); endfunction: get_access


// get_rights

function string uvm_mem::get_rights(uvm_reg_map map = null); endfunction: get_rights


// get_offset

function uvm_reg_addr_t uvm_mem::get_offset(uvm_reg_addr_t offset = 0,
                                            uvm_reg_map map = null); endfunction: get_offset



// get_virtual_registers

function void uvm_mem::get_virtual_registers(ref uvm_vreg regs[$]); endfunction


// get_virtual_fields

function void uvm_mem::get_virtual_fields(ref uvm_vreg_field fields[$]); endfunction: get_virtual_fields


// get_vfield_by_name

function uvm_vreg_field uvm_mem::get_vfield_by_name(string name); endfunction: get_vfield_by_name


// get_vreg_by_name

function uvm_vreg uvm_mem::get_vreg_by_name(string name); endfunction: get_vreg_by_name


// get_vreg_by_offset

function uvm_vreg uvm_mem::get_vreg_by_offset(uvm_reg_addr_t offset,
                                              uvm_reg_map map = null); endfunction: get_vreg_by_offset



// get_addresses

function int uvm_mem::get_addresses(uvm_reg_addr_t offset = 0,
                                    uvm_reg_map map=null,
                                    ref uvm_reg_addr_t addr[]); endfunction


// get_address

function uvm_reg_addr_t uvm_mem::get_address(uvm_reg_addr_t offset = 0,
                                             uvm_reg_map map = null); endfunction


// get_size

function longint unsigned uvm_mem::get_size(); endfunction: get_size


// get_n_bits

function int unsigned uvm_mem::get_n_bits(); endfunction: get_n_bits


// get_max_size

function int unsigned uvm_mem::get_max_size(); endfunction: get_max_size


// get_n_bytes

function int unsigned uvm_mem::get_n_bytes(); endfunction: get_n_bytes




//---------
// COVERAGE
//---------


function uvm_reg_cvr_t uvm_mem::build_coverage(uvm_reg_cvr_t models); endfunction: build_coverage


// add_coverage

function void uvm_mem::add_coverage(uvm_reg_cvr_t models); endfunction: add_coverage


// has_coverage

function bit uvm_mem::has_coverage(uvm_reg_cvr_t models); endfunction: has_coverage


// set_coverage

function uvm_reg_cvr_t uvm_mem::set_coverage(uvm_reg_cvr_t is_on); endfunction: set_coverage


// get_coverage

function bit uvm_mem::get_coverage(uvm_reg_cvr_t is_on); endfunction: get_coverage




//-----------
// HDL ACCESS
//-----------

// write
//------

task uvm_mem::write(output uvm_status_e      status,
                    input  uvm_reg_addr_t    offset,
                    input  uvm_reg_data_t    value,
                    input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                    input  uvm_reg_map       map = null,
                    input  uvm_sequence_base parent = null,
                    input  int               prior = -1,
                    input  uvm_object        extension = null,
                    input  string            fname = "",
                    input  int               lineno = 0); endtask: write


// read

task uvm_mem::read(output uvm_status_e       status,
                   input  uvm_reg_addr_t     offset,
                   output uvm_reg_data_t     value,
                   input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                   input  uvm_reg_map        map = null,
                   input  uvm_sequence_base  parent = null,
                   input  int                prior = -1,
                   input  uvm_object         extension = null,
                   input  string             fname = "",
                   input  int                lineno = 0); endtask: read


// burst_write

task uvm_mem::burst_write(output uvm_status_e       status,
                          input  uvm_reg_addr_t     offset,
                          input  uvm_reg_data_t     value[],
                          input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                          input  uvm_reg_map        map = null,
                          input  uvm_sequence_base  parent = null,
                          input  int                prior = -1,
                          input  uvm_object         extension = null,
                          input  string             fname = "",
                          input  int                lineno = 0); endtask: burst_write


// burst_read

task uvm_mem::burst_read(output uvm_status_e       status,
                         input  uvm_reg_addr_t     offset,
                         ref    uvm_reg_data_t     value[],
                         input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                         input  uvm_reg_map        map = null,
                         input  uvm_sequence_base  parent = null,
                         input  int                prior = -1,
                         input  uvm_object         extension = null,
                         input  string             fname = "",
                         input  int                lineno = 0); endtask: burst_read


// do_write

task uvm_mem::do_write(uvm_reg_item rw); endtask: do_write


// do_read

task uvm_mem::do_read(uvm_reg_item rw); endtask: do_read


// Xcheck_accessX

function bit uvm_mem::Xcheck_accessX(input uvm_reg_item rw,
                                     output uvm_reg_map_info map_info); endfunction


//-------
// ACCESS
//-------

// poke

task uvm_mem::poke(output uvm_status_e      status,
                   input  uvm_reg_addr_t    offset,
                   input  uvm_reg_data_t    value,
                   input  string            kind = "",
                   input  uvm_sequence_base parent = null,
                   input  uvm_object        extension = null,
                   input  string            fname = "",
                   input  int               lineno = 0); endtask: poke


// peek

task uvm_mem::peek(output uvm_status_e      status,
                   input  uvm_reg_addr_t    offset,
                   output uvm_reg_data_t    value,
                   input  string            kind = "",
                   input  uvm_sequence_base parent = null,
                   input  uvm_object        extension = null,
                   input  string            fname = "",
                   input  int               lineno = 0); endtask: peek


//-----------------
// Group- Frontdoor
//-----------------

// set_frontdoor

function void uvm_mem::set_frontdoor(uvm_reg_frontdoor ftdr,
                                     uvm_reg_map       map = null,
                                     string            fname = "",
                                     int               lineno = 0); endfunction: set_frontdoor


// get_frontdoor

function uvm_reg_frontdoor uvm_mem::get_frontdoor(uvm_reg_map map = null); endfunction: get_frontdoor


//----------------
// Group- Backdoor
//----------------

// set_backdoor

function void uvm_mem::set_backdoor(uvm_reg_backdoor bkdr,
                                    string fname = "",
                                    int lineno = 0); endfunction: set_backdoor


// get_backdoor

function uvm_reg_backdoor uvm_mem::get_backdoor(bit inherited = 1); endfunction: get_backdoor


// backdoor_read_func

function uvm_status_e uvm_mem::backdoor_read_func(uvm_reg_item rw); endfunction


// backdoor_read

task uvm_mem::backdoor_read(uvm_reg_item rw); endtask


// backdoor_write

task uvm_mem::backdoor_write(uvm_reg_item rw); endtask




// clear_hdl_path

function void uvm_mem::clear_hdl_path(string kind = "RTL"); endfunction


// add_hdl_path

function void uvm_mem::add_hdl_path(uvm_hdl_path_slice slices[], string kind = "RTL"); endfunction


// add_hdl_path_slice

function void uvm_mem::add_hdl_path_slice(string name,
                                          int offset,
                                          int size,
                                          bit first = 0,
                                          string kind = "RTL"); endfunction


// has_hdl_path

function bit  uvm_mem::has_hdl_path(string kind = ""); endfunction


// get_hdl_path

function void uvm_mem::get_hdl_path(ref uvm_hdl_path_concat paths[$],
                                    input string kind = ""); endfunction


// get_hdl_path_kinds

function void uvm_mem::get_hdl_path_kinds (ref string kinds[$]); endfunction

// get_full_hdl_path

function void uvm_mem::get_full_hdl_path(ref uvm_hdl_path_concat paths[$],
                                         input string kind = "",
                                         input string separator = "."); endfunction


// set_parent

function void uvm_mem::set_parent(uvm_reg_block parent); endfunction


// get_parent

function uvm_reg_block uvm_mem::get_parent(); endfunction


// convert2string

function string uvm_mem::convert2string(); endfunction


// do_print

function void uvm_mem::do_print (uvm_printer printer); endfunction


// clone

function uvm_object uvm_mem::clone(); endfunction

// do_copy

function void uvm_mem::do_copy(uvm_object rhs); endfunction


// do_compare

function bit uvm_mem::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction


// do_pack

function void uvm_mem::do_pack (uvm_packer packer); endfunction


// do_unpack

function void uvm_mem::do_unpack (uvm_packer packer); endfunction


// Xadd_vregX

function void uvm_mem::Xadd_vregX(uvm_vreg vreg); endfunction


// Xdelete_vregX

function void uvm_mem::Xdelete_vregX(uvm_vreg vreg); endfunction
