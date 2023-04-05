//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2012-2014 Semifore
// Copyright 2018 Qualcomm, Inc.
// Copyright 2004-2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2014-2018 NVIDIA Corporation
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
//

typedef class uvm_reg_cbs;



// @uvm-ieee 1800.2-2017 auto 18.5.1
class uvm_reg_field extends uvm_object;

   // Variable -- NODOCS -- value
   // Mirrored field value.
   // This value can be sampled in a functional coverage model
   // or constrained when randomized.
   rand  uvm_reg_data_t  value; // Mirrored after randomize()

   local uvm_reg_data_t  m_mirrored; // What we think is in the HW
   local uvm_reg_data_t  m_desired;  // Mirrored after set()
   local string          m_access;
   local uvm_reg         m_parent;
   local int unsigned    m_lsb;
   local int unsigned    m_size;
   local bit             m_volatile;
   local uvm_reg_data_t  m_reset[string];
   local bit             m_written;
   local bit             m_read_in_progress;
   local bit             m_write_in_progress;
   local string          m_fname;
   local int             m_lineno;
   local int             m_cover_on;
   local bit             m_individually_accessible;
   local uvm_check_e     m_check;

   local static int m_max_size;
   local static bit m_policy_names[string];

   constraint uvm_reg_field_valid {
      if (`UVM_REG_DATA_WIDTH > m_size) {
         value < (`UVM_REG_DATA_WIDTH'h1 << m_size);
      }
   }

   `uvm_object_utils(uvm_reg_field)

   //----------------------
   // Group -- NODOCS -- Initialization
   //----------------------


   // @uvm-ieee 1800.2-2017 auto 18.5.3.1
   extern function new(string name = "uvm_reg_field");



   // @uvm-ieee 1800.2-2017 auto 18.5.3.2
   extern function void configure(uvm_reg        parent,
                                  int unsigned   size,
                                  int unsigned   lsb_pos,
                                  string         access,
                                  bit            volatile,
                                  uvm_reg_data_t reset,
                                  bit            has_reset,
                                  bit            is_rand,
                                  bit            individually_accessible); 


   //---------------------
   // Group -- NODOCS -- Introspection
   //---------------------

   // Function -- NODOCS -- get_name
   //
   // Get the simple name
   //
   // Return the simple object name of this field
   //


   // Function -- NODOCS -- get_full_name
   //
   // Get the hierarchical name
   //
   // Return the hierarchal name of this field
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string get_full_name();



   // @uvm-ieee 1800.2-2017 auto 18.5.4.1
   extern virtual function uvm_reg get_parent();
   extern virtual function uvm_reg get_register();


   // Function -- NODOCS -- get_lsb_pos
   //
   // Return the position of the field
   //
   // Returns the index of the least significant bit of the field
   // in the register that instantiates it.
   // An offset of 0 indicates a field that is aligned with the
   // least-significant bit of the register. 
   //
   extern virtual function int unsigned get_lsb_pos();


   // Function -- NODOCS -- get_n_bits
   //
   // Returns the width, in number of bits, of the field. 
   //
   extern virtual function int unsigned get_n_bits();

   //
   // FUNCTION -- NODOCS -- get_max_size
   // Returns the width, in number of bits, of the largest field. 
   //
   extern static function int unsigned get_max_size();



   // @uvm-ieee 1800.2-2017 auto 18.5.4.6
   extern virtual function string set_access(string mode);



   // @uvm-ieee 1800.2-2017 auto 18.5.4.7
   extern static function bit define_access(string name);
   local static bit m_predefined = m_predefine_policies();
   extern local static function bit m_predefine_policies();
 
   // Function -- NODOCS -- get_access
   //
   // Get the access policy of the field
   //
   // Returns the current access policy of the field
   // when written and read through the specified address ~map~.
   // If the register containing the field is mapped in multiple
   // address map, an address map must be specified.
   // The access policy of a field from a specific
   // address map may be restricted by the register's access policy in that
   // address map.
   // For example, a RW field may only be writable through one of
   // the address maps and read-only through all of the other maps.
   // If the field access contradicts the map's access value
   // (field access of WO, and map access value of RO, etc), the
   // method's return value is NOACCESS.

   // @uvm-ieee 1800.2-2017 auto 18.5.4.5
   extern virtual function string get_access(uvm_reg_map map = null);



   // @uvm-ieee 1800.2-2017 auto 18.5.4.8
   extern virtual function bit is_known_access(uvm_reg_map map = null);


   // @uvm-ieee 1800.2-2017 auto 18.5.4.9
   extern virtual function void set_volatility(bit volatile);


   // @uvm-ieee 1800.2-2017 auto 18.5.4.10
   extern virtual function bit is_volatile();


   //--------------
   // Group -- NODOCS -- Access
   //--------------



   // @uvm-ieee 1800.2-2017 auto 18.5.5.2
   extern virtual function void set(uvm_reg_data_t  value,
                                    string          fname = "",
                                    int             lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.5.5.1
   extern virtual function uvm_reg_data_t get(string fname = "",
                                              int    lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.3
   extern virtual function uvm_reg_data_t get_mirrored_value(string fname = "",
                                              int    lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.5.5.4
   extern virtual function void reset(string kind = "HARD");



   // @uvm-ieee 1800.2-2017 auto 18.5.5.6
   extern virtual function uvm_reg_data_t get_reset(string kind = "HARD");



   // @uvm-ieee 1800.2-2017 auto 18.5.5.5
   extern virtual function bit has_reset(string kind = "HARD",
                                         bit    delete = 0);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.7
   extern virtual function void set_reset(uvm_reg_data_t value,
                                          string kind = "HARD");



   // @uvm-ieee 1800.2-2017 auto 18.5.5.8
   extern virtual function bit needs_update();



   // @uvm-ieee 1800.2-2017 auto 18.5.5.9
   extern virtual task write (output uvm_status_e       status,
                              input  uvm_reg_data_t     value,
                              input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map        map = null,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.10
   extern virtual task read  (output uvm_status_e       status,
                              output uvm_reg_data_t     value,
                              input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map        map = null,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);
               


   // @uvm-ieee 1800.2-2017 auto 18.5.5.11
   extern virtual task poke  (output uvm_status_e       status,
                              input  uvm_reg_data_t     value,
                              input  string             kind = "",
                              input  uvm_sequence_base  parent = null,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.12
   extern virtual task peek  (output uvm_status_e       status,
                              output uvm_reg_data_t     value,
                              input  string             kind = "",
                              input  uvm_sequence_base  parent = null,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);
               


   // @uvm-ieee 1800.2-2017 auto 18.5.5.13
   extern virtual task mirror(output uvm_status_e      status,
                              input  uvm_check_e       check = UVM_NO_CHECK,
                              input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map       map = null,
                              input  uvm_sequence_base parent = null,
                              input  int               prior = -1,
                              input  uvm_object        extension = null,
                              input  string            fname = "",
                              input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.15
   extern function void set_compare(uvm_check_e check=UVM_CHECK);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.14
   extern function uvm_check_e get_compare();

   

   // @uvm-ieee 1800.2-2017 auto 18.5.5.16
   extern function bit is_indv_accessible (uvm_door_e  path,
                                           uvm_reg_map local_map);



   // @uvm-ieee 1800.2-2017 auto 18.5.5.17
   extern function bit predict (uvm_reg_data_t    value,
                                uvm_reg_byte_en_t be = -1,
                                uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                uvm_door_e        path = UVM_FRONTDOOR,
                                uvm_reg_map       map = null,
                                string            fname = "",
                                int               lineno = 0);



   /*local*/
   extern virtual function uvm_reg_data_t XpredictX (uvm_reg_data_t cur_val,
                                                     uvm_reg_data_t wr_val,
                                                     uvm_reg_map    map);

   /*local*/
   extern virtual function uvm_reg_data_t XupdateX();
  
   /*local*/
   extern function bit Xcheck_accessX (input uvm_reg_item rw,
                                       output uvm_reg_map_info map_info);

   extern virtual task do_write(uvm_reg_item rw);
   extern virtual task do_read(uvm_reg_item rw);
   extern virtual function void do_predict 
                                  (uvm_reg_item rw,
                                   uvm_predict_e kind=UVM_PREDICT_DIRECT,
                                   uvm_reg_byte_en_t be = -1);


   extern function void pre_randomize();
   extern function void post_randomize();


   //-----------------
   // Group -- NODOCS -- Callbacks
   //-----------------

   `uvm_register_cb(uvm_reg_field, uvm_reg_cbs)



   // @uvm-ieee 1800.2-2017 auto 18.5.6.1
   virtual task pre_write  (uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.5.6.2
   virtual task post_write (uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.5.6.3
   virtual task pre_read (uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.5.6.4
   virtual task post_read  (uvm_reg_item rw); endtask


   extern virtual function void do_print (uvm_printer printer);
   extern virtual function string convert2string;
   extern virtual function uvm_object clone();
   extern virtual function void do_copy   (uvm_object rhs);
   extern virtual function bit  do_compare (uvm_object  rhs,
                                            uvm_comparer comparer);
   extern virtual function void do_pack (uvm_packer packer);
   extern virtual function void do_unpack (uvm_packer packer);

endclass: uvm_reg_field


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

// new

function uvm_reg_field::new(string name = "uvm_reg_field"); endfunction: new


// configure

function void uvm_reg_field::configure(uvm_reg        parent,
                                       int unsigned   size,
                                       int unsigned   lsb_pos,
                                       string         access,
                                       bit            volatile,
                                       uvm_reg_data_t reset,
                                       bit            has_reset,
                                       bit            is_rand,
                                       bit            individually_accessible); endfunction: configure


// get_parent

function uvm_reg uvm_reg_field::get_parent(); endfunction: get_parent


// get_full_name

function string uvm_reg_field::get_full_name(); endfunction: get_full_name


// get_register

function uvm_reg uvm_reg_field::get_register(); endfunction: get_register


// get_lsb_pos

function int unsigned uvm_reg_field::get_lsb_pos(); endfunction: get_lsb_pos


// get_n_bits

function int unsigned uvm_reg_field::get_n_bits(); endfunction: get_n_bits


// get_max_size

function int unsigned uvm_reg_field::get_max_size(); endfunction: get_max_size


// is_known_access

function bit uvm_reg_field::is_known_access(uvm_reg_map map = null); endfunction


// get_access

function string uvm_reg_field::get_access(uvm_reg_map map = null); endfunction: get_access


// set_access

function string uvm_reg_field::set_access(string mode); endfunction: set_access


// define_access

function bit uvm_reg_field::define_access(string name); endfunction


// m_predefined_policies

function bit uvm_reg_field::m_predefine_policies(); endfunction


// set_volatility

function void uvm_reg_field::set_volatility(bit volatile); endfunction


// is_volatile

function bit uvm_reg_field::is_volatile(); endfunction


// XpredictX

function uvm_reg_data_t uvm_reg_field::XpredictX (uvm_reg_data_t cur_val,
                                                  uvm_reg_data_t wr_val,
                                                  uvm_reg_map    map); endfunction: XpredictX



// predict

function bit uvm_reg_field::predict (uvm_reg_data_t    value,
                                     uvm_reg_byte_en_t be = -1,
                                     uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                     uvm_door_e        path = UVM_FRONTDOOR,
                                     uvm_reg_map       map = null,
                                     string            fname = "",
                                     int               lineno = 0); endfunction: predict


// do_predict

function void uvm_reg_field::do_predict(uvm_reg_item      rw,
                                        uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                        uvm_reg_byte_en_t be = -1); endfunction: do_predict


// XupdateX

function uvm_reg_data_t  uvm_reg_field::XupdateX(); endfunction: XupdateX


// set

function void uvm_reg_field::set(uvm_reg_data_t  value,
                                 string          fname = "",
                                 int             lineno = 0); endfunction: set

 
// get

function uvm_reg_data_t  uvm_reg_field::get(string  fname = "",
                                            int     lineno = 0); endfunction: get

 
// get_mirrored_value

function uvm_reg_data_t  uvm_reg_field::get_mirrored_value(string  fname = "",
                                            int     lineno = 0); endfunction: get_mirrored_value


// reset

function void uvm_reg_field::reset(string kind = "HARD"); endfunction: reset


// has_reset

function bit uvm_reg_field::has_reset(string kind = "HARD",
                                      bit    delete = 0); endfunction: has_reset


// get_reset

function uvm_reg_data_t
   uvm_reg_field::get_reset(string kind = "HARD"); endfunction: get_reset


// set_reset

function void uvm_reg_field::set_reset(uvm_reg_data_t value,
                                       string kind = "HARD"); endfunction: set_reset


// needs_update

function bit uvm_reg_field::needs_update(); endfunction: needs_update


typedef class uvm_reg_map_info;


// Xcheck_accessX

function bit uvm_reg_field::Xcheck_accessX(input uvm_reg_item rw,
                                           output uvm_reg_map_info map_info); endfunction


// write

task uvm_reg_field::write(output uvm_status_e       status,
                          input  uvm_reg_data_t     value,
                          input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                          input  uvm_reg_map        map = null,
                          input  uvm_sequence_base  parent = null,
                          input  int                prior = -1,
                          input  uvm_object         extension = null,
                          input  string             fname = "",
                          input  int                lineno = 0); endtask


// do_write

task uvm_reg_field::do_write(uvm_reg_item rw); endtask: do_write


// read

task uvm_reg_field::read(output uvm_status_e       status,
                         output uvm_reg_data_t     value,
                         input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                         input  uvm_reg_map        map = null,
                         input  uvm_sequence_base  parent = null,
                         input  int                prior = -1,
                         input  uvm_object         extension = null,
                         input  string             fname = "",
                         input  int                lineno = 0); endtask: read


// do_read

task uvm_reg_field::do_read(uvm_reg_item rw); endtask: do_read
               

// is_indv_accessible

function bit uvm_reg_field::is_indv_accessible(uvm_door_e  path,
                                               uvm_reg_map local_map); endfunction


// poke

task uvm_reg_field::poke(output uvm_status_e      status,
                         input  uvm_reg_data_t    value,
                         input  string            kind = "",
                         input  uvm_sequence_base parent = null,
                         input  uvm_object        extension = null,
                         input  string            fname = "",
                         input  int               lineno = 0); endtask: poke


// peek

task uvm_reg_field::peek(output uvm_status_e      status,
                         output uvm_reg_data_t    value,
                         input  string            kind = "",
                         input  uvm_sequence_base parent = null,
                         input  uvm_object        extension = null,
                         input  string            fname = "",
                         input  int               lineno = 0); endtask: peek
               

// mirror

task uvm_reg_field::mirror(output uvm_status_e      status,
                           input  uvm_check_e       check = UVM_NO_CHECK,
                           input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                           input  uvm_reg_map       map = null,
                           input  uvm_sequence_base parent = null,
                           input  int               prior = -1,
                           input  uvm_object        extension = null,
                           input  string            fname = "",
                           input  int               lineno = 0); endtask: mirror


// set_compare

function void uvm_reg_field::set_compare(uvm_check_e check=UVM_CHECK); endfunction


// get_compare

function uvm_check_e uvm_reg_field::get_compare(); endfunction

// pre_randomize

function void uvm_reg_field::pre_randomize(); endfunction: pre_randomize


// post_randomize

function void uvm_reg_field::post_randomize(); endfunction: post_randomize


// do_print

function void uvm_reg_field::do_print (uvm_printer printer); endfunction


// convert2string

function string uvm_reg_field::convert2string(); endfunction: convert2string


// clone

function uvm_object uvm_reg_field::clone(); endfunction

// do_copy

function void uvm_reg_field::do_copy(uvm_object rhs); endfunction


// do_compare

function bit uvm_reg_field::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction


// do_pack

function void uvm_reg_field::do_pack (uvm_packer packer); endfunction


// do_unpack

function void uvm_reg_field::do_unpack (uvm_packer packer); endfunction
