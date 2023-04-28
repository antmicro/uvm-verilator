//
// -------------------------------------------------------------
// Copyright 2010-2012 Mentor Graphics Corporation
// Copyright 2011-2014 Semifore
// Copyright 2018 Intel Corporation
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
typedef class uvm_reg_frontdoor;


// @uvm-ieee 1800.2-2017 auto 18.4.1
class uvm_reg extends uvm_object;






   protected bit           m_maps[uvm_reg_map];
   protected uvm_reg_field m_fields[$];   // Fields in LSB to MSB order








   protected bit           m_update_in_progress;
   /*local*/ bit           m_is_busy;
   /*local*/ bit           m_is_locked_by_field;




   //----------------------
   // Group -- NODOCS -- Initialization
   //----------------------


   // @uvm-ieee 1800.2-2017 auto 18.4.2.1
   extern function new (string name="",
                        int unsigned n_bits=0,
                        int has_coverage=0);



   // @uvm-ieee 1800.2-2017 auto 18.4.2.2
   extern function void configure (uvm_reg_block blk_parent,
                                   uvm_reg_file regfile_parent = null,
                                   string hdl_path = "");



   // @uvm-ieee 1800.2-2017 auto 18.4.2.3
   extern virtual function void set_offset (uvm_reg_map    map,
                                            uvm_reg_addr_t offset,
                                            bit            unmapped = 0);

   /*local*/ extern virtual function void set_parent (uvm_reg_block blk_parent,
                                                      uvm_reg_file regfile_parent);
   /*local*/ extern virtual function void add_field  (uvm_reg_field field);
   /*local*/ extern virtual function void add_map    (uvm_reg_map map);

   /*local*/ extern function void   Xlock_modelX;

	// remove the knowledge that the register resides in the map from the register instance
	// @uvm-ieee 1800.2-2017 auto 18.4.2.5
	virtual function void unregister(uvm_reg_map map); endfunction


   //---------------------
   // Group -- NODOCS -- Introspection
   //---------------------

   // Function -- NODOCS -- get_name
   //
   // Get the simple name
   //
   // Return the simple object name of this register.
   //

   // Function -- NODOCS -- get_full_name
   //
   // Get the hierarchical name
   //
   // Return the hierarchal name of this register.
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string get_full_name();



   // @uvm-ieee 1800.2-2017 auto 18.4.3.1
   extern virtual function uvm_reg_block get_parent ();
   extern virtual function uvm_reg_block get_block  ();



   // @uvm-ieee 1800.2-2017 auto 18.4.3.2
   extern virtual function uvm_reg_file get_regfile ();



   // @uvm-ieee 1800.2-2017 auto 18.4.3.3
   extern virtual function int get_n_maps ();



   // @uvm-ieee 1800.2-2017 auto 18.4.3.4
   extern function bit is_in_map (uvm_reg_map map);



   // @uvm-ieee 1800.2-2017 auto 18.4.3.5
   extern virtual function void get_maps (ref uvm_reg_map maps[$]);


   /*local*/ extern virtual function uvm_reg_map get_local_map   (uvm_reg_map map);
   /*local*/ extern virtual function uvm_reg_map get_default_map ();



   // @uvm-ieee 1800.2-2017 auto 18.4.3.6
   extern virtual function string get_rights (uvm_reg_map map = null);


   // Function -- NODOCS -- get_n_bits
   //
   // Returns the width, in bits, of this register.
   //
   extern virtual function int unsigned get_n_bits ();


   // Function -- NODOCS -- get_n_bytes
   //
   // Returns the width, in bytes, of this register. Rounds up to
   // next whole byte if register is not a multiple of 8.
   //
   extern virtual function int unsigned get_n_bytes();


   // Function -- NODOCS -- get_max_size
   //
   // Returns the maximum width, in bits, of all registers.
   //
   extern static function int unsigned get_max_size();



   // @uvm-ieee 1800.2-2017 auto 18.4.3.10
   extern virtual function void get_fields (ref uvm_reg_field fields[$]);



   // @uvm-ieee 1800.2-2017 auto 18.4.3.11
   extern virtual function uvm_reg_field get_field_by_name(string name);


   /*local*/ extern function string Xget_fields_accessX(uvm_reg_map map);



   // @uvm-ieee 1800.2-2017 auto 18.4.3.12
   extern virtual function uvm_reg_addr_t get_offset (uvm_reg_map map = null);



   // @uvm-ieee 1800.2-2017 auto 18.4.3.13
   extern virtual function uvm_reg_addr_t get_address (uvm_reg_map map = null);



   // @uvm-ieee 1800.2-2017 auto 18.4.3.14
   extern virtual function int get_addresses (uvm_reg_map map = null,
                                              ref uvm_reg_addr_t addr[]);



   //--------------
   // Group -- NODOCS -- Access
   //--------------



   // @uvm-ieee 1800.2-2017 auto 18.4.4.2
   extern virtual function void set (uvm_reg_data_t  value,
                                     string          fname = "",
                                     int             lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.1
   extern virtual function uvm_reg_data_t  get(string  fname = "",
                                               int     lineno = 0);


   // @uvm-ieee 1800.2-2017 auto 18.4.4.3
   extern virtual function uvm_reg_data_t  get_mirrored_value(string  fname = "",
                                               int     lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.4
   extern virtual function bit needs_update();



   // @uvm-ieee 1800.2-2017 auto 18.4.4.5
   extern virtual function void reset(string kind = "HARD");


   // Function -- NODOCS -- get_reset
   //
   // Get the specified reset value for this register
   //
   // Return the reset value for this register
   // for the specified reset ~kind~.
   //
   extern virtual function uvm_reg_data_t
                             // @uvm-ieee 1800.2-2017 auto 18.4.4.6
                             get_reset(string kind = "HARD");



   // @uvm-ieee 1800.2-2017 auto 18.4.4.7
   extern virtual function bit has_reset(string kind = "HARD",
                                         bit    delete = 0);


   // Function -- NODOCS -- set_reset
   //
   // Specify or modify the reset value for this register
   //
   // Specify or modify the reset value for all the fields in the register
   // corresponding to the cause specified by ~kind~.
   //
   extern virtual function void
                       // @uvm-ieee 1800.2-2017 auto 18.4.4.8
                       set_reset(uvm_reg_data_t value,
                                 string         kind = "HARD");



   // @uvm-ieee 1800.2-2017 auto 18.4.4.9
   // @uvm-ieee 1800.2-2017 auto 18.8.5.3
   extern virtual task write(output uvm_status_e      status,
                             input  uvm_reg_data_t    value,
                             input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                             input  uvm_reg_map       map = null,
                             input  uvm_sequence_base parent = null,
                             input  int               prior = -1,
                             input  uvm_object        extension = null,
                             input  string            fname = "",
                             input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.10
   // @uvm-ieee 1800.2-2017 auto 18.8.5.4
   extern virtual task read(output uvm_status_e      status,
                            output uvm_reg_data_t    value,
                            input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                            input  uvm_reg_map       map = null,
                            input  uvm_sequence_base parent = null,
                            input  int               prior = -1,
                            input  uvm_object        extension = null,
                            input  string            fname = "",
                            input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.11
   // @uvm-ieee 1800.2-2017 auto 18.8.5.5
   // @uvm-ieee 1800.2-2017 auto 18.8.5.6
   extern virtual task poke(output uvm_status_e      status,
                            input  uvm_reg_data_t    value,
                            input  string            kind = "",
                            input  uvm_sequence_base parent = null,
                            input  uvm_object        extension = null,
                            input  string            fname = "",
                            input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.12
   extern virtual task peek(output uvm_status_e      status,
                            output uvm_reg_data_t    value,
                            input  string            kind = "",
                            input  uvm_sequence_base parent = null,
                            input  uvm_object        extension = null,
                            input  string            fname = "",
                            input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.13
   extern virtual task update(output uvm_status_e      status,
                              input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map       map = null,
                              input  uvm_sequence_base parent = null,
                              input  int               prior = -1,
                              input  uvm_object        extension = null,
                              input  string            fname = "",
                              input  int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.14
   // @uvm-ieee 1800.2-2017 auto 18.8.5.8
   extern virtual task mirror(output uvm_status_e      status,
                              input uvm_check_e        check  = UVM_NO_CHECK,
                              input uvm_door_e         path = UVM_DEFAULT_DOOR,
                              input uvm_reg_map        map = null,
                              input uvm_sequence_base  parent = null,
                              input int                prior = -1,
                              input  uvm_object        extension = null,
                              input string             fname = "",
                              input int                lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.15
   // @uvm-ieee 1800.2-2017 auto 18.8.5.9
   extern virtual function bit predict (uvm_reg_data_t    value,
                                        uvm_reg_byte_en_t be = -1,
                                        uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                        uvm_door_e        path = UVM_FRONTDOOR,
                                        uvm_reg_map       map = null,
                                        string            fname = "",
                                        int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.4.16
   extern function bit is_busy();



   /*local*/ extern function void Xset_busyX(bit busy);

   /*local*/ extern task XreadX (output uvm_status_e      status,
                                 output uvm_reg_data_t    value,
                                 input  uvm_door_e        path,
                                 input  uvm_reg_map       map,
                                 input  uvm_sequence_base parent = null,
                                 input  int               prior = -1,
                                 input  uvm_object        extension = null,
                                 input  string            fname = "",
                                 input  int               lineno = 0);

   /*local*/ extern task XatomicX(bit on);

   /*local*/ extern virtual function bit Xcheck_accessX
                                (input uvm_reg_item rw,
                                 output uvm_reg_map_info map_info);

   /*local*/ extern function bit Xis_locked_by_fieldX();


   extern virtual function bit do_check(uvm_reg_data_t expected,
                                        uvm_reg_data_t actual,
                                        uvm_reg_map    map);

   extern virtual task do_write(uvm_reg_item rw);

   extern virtual task do_read(uvm_reg_item rw);

   extern virtual function void do_predict
                                (uvm_reg_item      rw,
                                 uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                 uvm_reg_byte_en_t be = -1);
   //-----------------
   // Group -- NODOCS -- Frontdoor
   //-----------------


   // @uvm-ieee 1800.2-2017 auto 18.4.5.2
   extern function void set_frontdoor(uvm_reg_frontdoor ftdr,
                                      uvm_reg_map       map = null,
                                      string            fname = "",
                                      int               lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.5.1
   extern function uvm_reg_frontdoor get_frontdoor(uvm_reg_map map = null);


   //----------------
   // Group -- NODOCS -- Backdoor
   //----------------



   // @uvm-ieee 1800.2-2017 auto 18.4.6.2
   extern function void set_backdoor(uvm_reg_backdoor bkdr,
                                     string          fname = "",
                                     int             lineno = 0);



   // @uvm-ieee 1800.2-2017 auto 18.4.6.1
   extern function uvm_reg_backdoor get_backdoor(bit inherited = 1);



   // @uvm-ieee 1800.2-2017 auto 18.4.6.3
   extern function void clear_hdl_path (string kind = "RTL");



   // @uvm-ieee 1800.2-2017 auto 18.4.6.4
   extern function void add_hdl_path (uvm_hdl_path_slice slices[],
                                      string kind = "RTL");



   // @uvm-ieee 1800.2-2017 auto 18.4.6.5
   extern function void add_hdl_path_slice(string name,
                                           int offset,
                                           int size,
                                           bit first = 0,
                                           string kind = "RTL");



   // @uvm-ieee 1800.2-2017 auto 18.4.6.6
   extern function bit has_hdl_path (string kind = "");



   // @uvm-ieee 1800.2-2017 auto 18.4.6.7
   extern function void get_hdl_path (ref uvm_hdl_path_concat paths[$],
                                      input string kind = "");



   // @uvm-ieee 1800.2-2017 auto 18.4.6.8
   extern function void get_hdl_path_kinds (ref string kinds[$]);



   // @uvm-ieee 1800.2-2017 auto 18.4.6.9
   extern function void get_full_hdl_path (ref uvm_hdl_path_concat paths[$],
                                           input string kind = "",
                                           input string separator = ".");



   // @uvm-ieee 1800.2-2017 auto 18.4.6.10
   extern virtual task backdoor_read(uvm_reg_item rw);



   // @uvm-ieee 1800.2-2017 auto 18.4.6.11
   extern virtual task backdoor_write(uvm_reg_item rw);



   extern virtual function uvm_status_e backdoor_read_func(uvm_reg_item rw);



   // @uvm-ieee 1800.2-2017 auto 18.4.6.12
   virtual task  backdoor_watch(); endtask


   //----------------
   // Group -- NODOCS -- Coverage
   //----------------


   // @uvm-ieee 1800.2-2017 auto 18.4.7.1
   extern static function void include_coverage(string scope,
                                                uvm_reg_cvr_t models,
                                                uvm_object accessor = null);


   // @uvm-ieee 1800.2-2017 auto 18.4.7.2
   extern protected function uvm_reg_cvr_t build_coverage(uvm_reg_cvr_t models);



   // @uvm-ieee 1800.2-2017 auto 18.4.7.3
   extern virtual protected function void add_coverage(uvm_reg_cvr_t models);



   // @uvm-ieee 1800.2-2017 auto 18.4.7.4
   extern virtual function bit has_coverage(uvm_reg_cvr_t models);



   // @uvm-ieee 1800.2-2017 auto 18.4.7.6
   extern virtual function uvm_reg_cvr_t set_coverage(uvm_reg_cvr_t is_on);



   // @uvm-ieee 1800.2-2017 auto 18.4.7.5
   extern virtual function bit get_coverage(uvm_reg_cvr_t is_on);



   // @uvm-ieee 1800.2-2017 auto 18.4.7.7
   protected virtual function void sample(uvm_reg_data_t  data,
                                          uvm_reg_data_t  byte_en,
                                          bit             is_read,
                                          uvm_reg_map     map);
   endfunction


   // @uvm-ieee 1800.2-2017 auto 18.4.7.8
   virtual function void sample_values();
   endfunction

   /*local*/ function void XsampleX(uvm_reg_data_t  data,
                                    uvm_reg_data_t  byte_en,
                                    bit             is_read,
                                    uvm_reg_map     map);
      sample(data, byte_en, is_read, map);
   endfunction


   //-----------------
   // Group -- NODOCS -- Callbacks
   //-----------------
   `uvm_register_cb(uvm_reg, uvm_reg_cbs)



   // @uvm-ieee 1800.2-2017 auto 18.4.8.1
   virtual task pre_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.4.8.2
   virtual task post_write(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.4.8.3
   virtual task pre_read(uvm_reg_item rw); endtask



   // @uvm-ieee 1800.2-2017 auto 18.4.8.4
   virtual task post_read(uvm_reg_item rw); endtask


   extern virtual function void            do_print (uvm_printer printer);
   extern virtual function string          convert2string();
   extern virtual function uvm_object      clone      ();
   extern virtual function void            do_copy    (uvm_object rhs);
   extern virtual function bit             do_compare (uvm_object  rhs,
                                                       uvm_comparer comparer);
   extern virtual function void            do_pack    (uvm_packer packer);
   extern virtual function void            do_unpack  (uvm_packer packer);

endclass: uvm_reg


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

// new

function uvm_reg::new(string name="", int unsigned n_bits=0, int has_coverage=0); endfunction: new


// configure

function void uvm_reg::configure (uvm_reg_block blk_parent,
                                  uvm_reg_file regfile_parent=null,
                                  string hdl_path = ""); endfunction: configure


// add_field

function void uvm_reg::add_field(uvm_reg_field field); endfunction: add_field


// Xlock_modelX

function void uvm_reg::Xlock_modelX(); endfunction


//----------------------
// Group- User Frontdoor
//----------------------

// set_frontdoor

function void uvm_reg::set_frontdoor(uvm_reg_frontdoor ftdr,
                                     uvm_reg_map       map = null,
                                     string            fname = "",
                                     int               lineno = 0); endfunction: set_frontdoor


// get_frontdoor

function uvm_reg_frontdoor uvm_reg::get_frontdoor(uvm_reg_map map = null); endfunction: get_frontdoor


// set_backdoor

function void uvm_reg::set_backdoor(uvm_reg_backdoor bkdr,
                                    string           fname = "",
                                    int              lineno = 0); endfunction: set_backdoor


// get_backdoor

function uvm_reg_backdoor uvm_reg::get_backdoor(bit inherited = 1); endfunction: get_backdoor



// clear_hdl_path

function void uvm_reg::clear_hdl_path(string kind = "RTL"); endfunction


// add_hdl_path

function void uvm_reg::add_hdl_path(uvm_hdl_path_slice slices[],
                                    string kind = "RTL"); endfunction


// add_hdl_path_slice

function void uvm_reg::add_hdl_path_slice(string name,
                                          int offset,
                                          int size,
                                          bit first = 0,
                                          string kind = "RTL"); endfunction


// has_hdl_path

function bit  uvm_reg::has_hdl_path(string kind = ""); endfunction


// get_hdl_path_kinds

function void uvm_reg::get_hdl_path_kinds (ref string kinds[$]); endfunction


// get_hdl_path

function void uvm_reg::get_hdl_path(ref uvm_hdl_path_concat paths[$],
                                        input string kind = ""); endfunction


// get_full_hdl_path

function void uvm_reg::get_full_hdl_path(ref uvm_hdl_path_concat paths[$],
                                         input string kind = "",
                                         input string separator = "."); endfunction


// set_offset

function void uvm_reg::set_offset (uvm_reg_map    map,
                                   uvm_reg_addr_t offset,
                                   bit unmapped = 0); endfunction


// set_parent

function void uvm_reg::set_parent(uvm_reg_block blk_parent,
                                      uvm_reg_file regfile_parent); endfunction


// get_parent

function uvm_reg_block uvm_reg::get_parent(); endfunction


// get_regfile

function uvm_reg_file uvm_reg::get_regfile(); endfunction


// get_full_name

function string uvm_reg::get_full_name(); endfunction: get_full_name


// add_map

function void uvm_reg::add_map(uvm_reg_map map); endfunction


// get_maps

function void uvm_reg::get_maps(ref uvm_reg_map maps[$]); endfunction


// get_n_maps

function int uvm_reg::get_n_maps(); endfunction


// is_in_map

function bit uvm_reg::is_in_map(uvm_reg_map map); endfunction



// get_local_map

function uvm_reg_map uvm_reg::get_local_map(uvm_reg_map map); endfunction



// get_default_map

function uvm_reg_map uvm_reg::get_default_map(); endfunction


// get_rights

function string uvm_reg::get_rights(uvm_reg_map map = null); endfunction



// get_block

function uvm_reg_block uvm_reg::get_block(); endfunction


// get_offset

function uvm_reg_addr_t uvm_reg::get_offset(uvm_reg_map map = null); endfunction


// get_addresses

function int uvm_reg::get_addresses(uvm_reg_map map=null, ref uvm_reg_addr_t addr[]); endfunction


// get_address

function uvm_reg_addr_t uvm_reg::get_address(uvm_reg_map map = null); endfunction


// get_n_bits

function int unsigned uvm_reg::get_n_bits(); endfunction


// get_n_bytes

function int unsigned uvm_reg::get_n_bytes(); endfunction


// get_max_size

function int unsigned uvm_reg::get_max_size(); endfunction: get_max_size


// get_fields

function void uvm_reg::get_fields(ref uvm_reg_field fields[$]); endfunction


// get_field_by_name

function uvm_reg_field uvm_reg::get_field_by_name(string name); endfunction


// Xget_field_accessX
//
// Returns "WO" if all of the fields in the registers are write-only
// Returns "RO" if all of the fields in the registers are read-only
// Returns "RW" otherwise.

function string uvm_reg::Xget_fields_accessX(uvm_reg_map map); endfunction

      
//---------
// COVERAGE
//---------


// include_coverage

function void uvm_reg::include_coverage(string scope,
                                        uvm_reg_cvr_t models,
                                        uvm_object accessor = null); endfunction


// build_coverage

function uvm_reg_cvr_t uvm_reg::build_coverage(uvm_reg_cvr_t models); endfunction: build_coverage


// add_coverage

function void uvm_reg::add_coverage(uvm_reg_cvr_t models); endfunction: add_coverage


// has_coverage

function bit uvm_reg::has_coverage(uvm_reg_cvr_t models); endfunction: has_coverage


// set_coverage

function uvm_reg_cvr_t uvm_reg::set_coverage(uvm_reg_cvr_t is_on); endfunction: set_coverage


// get_coverage

function bit uvm_reg::get_coverage(uvm_reg_cvr_t is_on); endfunction: get_coverage



//---------
// ACCESS
//---------


// set

function void uvm_reg::set(uvm_reg_data_t  value,
                           string          fname = "",
                           int             lineno = 0); endfunction: set


// predict

function bit uvm_reg::predict (uvm_reg_data_t    value,
                               uvm_reg_byte_en_t be = -1,
                               uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                               uvm_door_e        path = UVM_FRONTDOOR,
                               uvm_reg_map       map = null,
                               string            fname = "",
                               int               lineno = 0); endfunction: predict


// do_predict

function void uvm_reg::do_predict(uvm_reg_item      rw,
                                  uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                  uvm_reg_byte_en_t be = -1); endfunction: do_predict


// get

function uvm_reg_data_t  uvm_reg::get(string  fname = "",
                                      int     lineno = 0); endfunction: get


// get_mirrored_value

function uvm_reg_data_t  uvm_reg::get_mirrored_value(string  fname = "",
                                      int     lineno = 0); endfunction: get_mirrored_value


// reset

function void uvm_reg::reset(string kind = "HARD"); endfunction: reset


// get_reset

function uvm_reg_data_t uvm_reg::get_reset(string kind = "HARD"); endfunction: get_reset


// has_reset

function bit uvm_reg::has_reset(string kind = "HARD",
                                bit    delete = 0); endfunction: has_reset


// set_reset

function void uvm_reg::set_reset(uvm_reg_data_t value,
                                 string         kind = "HARD"); endfunction: set_reset


//-----------
// BUS ACCESS
//-----------

// needs_update

function bit uvm_reg::needs_update(); endfunction: needs_update


// update

task uvm_reg::update(output uvm_status_e      status,
                     input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                     input  uvm_reg_map       map = null,
                     input  uvm_sequence_base parent = null,
                     input  int               prior = -1,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0); endtask: update



// write

task uvm_reg::write(output uvm_status_e      status,
                    input  uvm_reg_data_t    value,
                    input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                    input  uvm_reg_map       map = null,
                    input  uvm_sequence_base parent = null,
                    input  int               prior = -1,
                    input  uvm_object        extension = null,
                    input  string            fname = "",
                    input  int               lineno = 0); endtask


// do_write

task uvm_reg::do_write (uvm_reg_item rw); endtask: do_write

// read

task uvm_reg::read(output uvm_status_e      status,
                   output uvm_reg_data_t    value,
                   input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                   input  uvm_reg_map       map = null,
                   input  uvm_sequence_base parent = null,
                   input  int               prior = -1,
                   input  uvm_object        extension = null,
                   input  string            fname = "",
                   input  int               lineno = 0); endtask: read


// XreadX

task uvm_reg::XreadX(output uvm_status_e      status,
                     output uvm_reg_data_t    value,
                     input  uvm_door_e        path,
                     input  uvm_reg_map       map,
                     input  uvm_sequence_base parent = null,
                     input  int               prior = -1,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0); endtask: XreadX


// do_read

task uvm_reg::do_read(uvm_reg_item rw); endtask: do_read


// Xcheck_accessX

function bit uvm_reg::Xcheck_accessX (input uvm_reg_item rw,
                                      output uvm_reg_map_info map_info); endfunction


// is_busy

function bit uvm_reg::is_busy(); endfunction
    

// Xset_busyX

function void uvm_reg::Xset_busyX(bit busy); endfunction
    

// Xis_loacked_by_fieldX

function bit uvm_reg::Xis_locked_by_fieldX(); endfunction
    

// backdoor_write

task uvm_reg::backdoor_write(uvm_reg_item rw); endtask


// backdoor_read

task uvm_reg::backdoor_read (uvm_reg_item rw); endtask


// backdoor_read_func

function uvm_status_e uvm_reg::backdoor_read_func(uvm_reg_item rw); endfunction


// poke

task uvm_reg::poke(output uvm_status_e      status,
                   input  uvm_reg_data_t    value,
                   input  string            kind = "",
                   input  uvm_sequence_base parent = null,
                   input  uvm_object        extension = null,
                   input  string            fname = "",
                   input  int               lineno = 0); endtask: poke


// peek

task uvm_reg::peek(output uvm_status_e      status,
                   output uvm_reg_data_t    value,
                   input  string            kind = "",
                   input  uvm_sequence_base parent = null,
                   input  uvm_object        extension = null,
                   input  string            fname = "",
                   input  int               lineno = 0); endtask: peek


// do_check
function bit uvm_reg::do_check(input uvm_reg_data_t expected,
                               input uvm_reg_data_t actual,
                               uvm_reg_map          map); endfunction
       

// mirror

task uvm_reg::mirror(output uvm_status_e       status,
                     input  uvm_check_e        check = UVM_NO_CHECK,
                     input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                     input  uvm_reg_map        map = null,
                     input  uvm_sequence_base  parent = null,
                     input  int                prior = -1,
                     input  uvm_object         extension = null,
                     input  string             fname = "",
                     input  int                lineno = 0); endtask: mirror


// XatomicX

task uvm_reg::XatomicX(bit on); endtask: XatomicX


//-------------
// STANDARD OPS
//-------------

// convert2string

function string uvm_reg::convert2string(); endfunction: convert2string


// do_print

function void uvm_reg::do_print (uvm_printer printer); endfunction



// clone

function uvm_object uvm_reg::clone(); endfunction

// do_copy

function void uvm_reg::do_copy(uvm_object rhs); endfunction


// do_compare

function bit uvm_reg::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction


// do_pack

function void uvm_reg::do_pack (uvm_packer packer); endfunction


// do_unpack

function void uvm_reg::do_unpack (uvm_packer packer); endfunction
