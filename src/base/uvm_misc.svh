//
//------------------------------------------------------------------------------
// Copyright 2007-2018 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2017 Intel Corporation
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2013 Verilab
// Copyright 2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2014-2018 Cisco Systems, Inc.
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

// File -- NODOCS -- Miscellaneous Structures

//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_void
//
// The ~uvm_void~ class is the base class for all UVM classes. It is an abstract
// class with no data members or functions. It allows for generic containers of
// objects to be created, similar to a void pointer in the C programming
// language. User classes derived directly from ~uvm_void~ inherit none of the
// UVM functionality, but such classes may be placed in ~uvm_void~-typed
// containers along with other UVM objects.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 5.2
virtual class uvm_void;
endclass

// Append/prepend symbolic values for order-dependent APIs
typedef enum {UVM_APPEND, UVM_PREPEND} uvm_apprepend;

// Forward declaration since scope stack uses uvm_objects now
typedef class uvm_object;

typedef class uvm_coreservice_t;
typedef class uvm_factory;


// m_uvm_config_obj_misc is an internal typedef for the uvm_misc.svh file
// to use. UVM users should use the uvm_config_object typedef



typedef class uvm_comparer ;
typedef class uvm_packer ;
typedef class uvm_recorder ;
typedef class uvm_printer ;

// Variable- uvm_global_random_seed
//
// Create a seed which is based off of the global seed which can be used to seed
// srandom processes but will change if the command line seed setting is 
// changed.
//
int unsigned uvm_global_random_seed = $urandom;


// Class- uvm_seed_map
//
// This map is a seed map that can be used to update seeds. The update
// is done automatically by the seed hashing routine. The seed_table_lookup
// uses an instance name lookup and the seed_table inside a given map
// uses a type name for the lookup.
//
class uvm_seed_map;
  int unsigned seed_table [string];
  int unsigned count [string];
endclass

uvm_seed_map uvm_random_seed_table_lookup [string];


//------------------------------------------------------------------------------
// Internal utility functions
//------------------------------------------------------------------------------

// Function- uvm_instance_scope
//
// A function that returns the scope that the UVM library lives in, either
// an instance, a module, or a package.
//
function string uvm_instance_scope(); endfunction


// Function- uvm_oneway_hash
//
// A one-way hash function that is useful for creating srandom seeds. An
// unsigned int value is generated from the string input. An initial seed can
// be used to seed the hash, if not supplied the uvm_global_random_seed 
// value is used. Uses a CRC like functionality to minimize collisions.
//
parameter UVM_STR_CRC_POLYNOMIAL = 32'h04c11db6;
function int unsigned uvm_oneway_hash ( string string_in, int unsigned seed=0 ); endfunction


// Function- uvm_create_random_seed
//
// Creates a random seed and updates the seed map so that if the same string
// is used again, a new value will be generated. The inst_id is used to hash
// by instance name and get a map of type name hashes which the type_id uses
// for its lookup.

function int unsigned uvm_create_random_seed ( string type_id, string inst_id="" ); endfunction


// Function- uvm_object_value_str 
//
//
function string uvm_object_value_str(uvm_object v); endfunction


// Function- uvm_leaf_scope
//
//
function string uvm_leaf_scope (string full_name, byte scope_separator = "."); endfunction


// Function- uvm_bitstream_to_string
//
//
function string uvm_bitstream_to_string (uvm_bitstream_t value, int size,
                                         uvm_radix_enum radix=UVM_NORADIX,
                                         string radix_str=""); endfunction

// Function- uvm_integral_to_string
//
//
function string uvm_integral_to_string (uvm_integral_t value, int size,
                                         uvm_radix_enum radix=UVM_NORADIX,
                                         string radix_str=""); endfunction
   
// Function- uvm_get_array_index_int
//
// The following functions check to see if a string is representing an array
// index, and if so, what the index is.

function int uvm_get_array_index_int(string arg, output bit is_wildcard); endfunction 
  

// Function- uvm_get_array_index_string
//
//
function string uvm_get_array_index_string(string arg, output bit is_wildcard); endfunction


// Function- uvm_is_array
//
//
function bit uvm_is_array(string arg); endfunction


// Function- uvm_has_wildcard
//
//
function automatic bit uvm_has_wildcard (string arg); endfunction


typedef class uvm_component;
typedef class uvm_root;


`ifdef UVM_ENABLE_DEPRECATED_API 
//------------------------------------------------------------------------------
// CLASS -- NODOCS -- uvm_utils #(TYPE,FIELD)
//
// This class contains useful template functions.
//
//------------------------------------------------------------------------------
        
class uvm_utils #(type TYPE=int, string FIELD="config");

  typedef TYPE types_t[$];

  // Function -- NODOCS -- find_all
  //
  // Recursively finds all component instances of the parameter type ~TYPE~,
  // starting with the component given by ~start~. Uses <uvm_root::find_all>.

  static function types_t find_all(uvm_component start); endfunction

  static function TYPE find(uvm_component start); endfunction

  static function TYPE create_type_by_name(string type_name, string contxt); endfunction


  // Function -- NODOCS -- get_config
  //
  // This method gets the object config of type ~TYPE~
  // associated with component ~comp~.
  // We check for the two kinds of error which may occur with this kind of 
  // operation.

  static function TYPE get_config(uvm_component comp, bit is_fatal); endfunction
endclass
`endif

`ifdef UVM_USE_PROCESS_CONTAINER
class process_container_c;
   process p;
   function new(process p_); endfunction
endclass
`endif


// this is an internal function and provides a string join independent of a streaming pack
function automatic string m_uvm_string_queue_join(ref string i[$]); endfunction


			
