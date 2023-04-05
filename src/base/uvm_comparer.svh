//-----------------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017-2018 Cisco Systems, Inc.
// Copyright 2018 Qualcomm, Inc.
// Copyright 2014 Intel Corporation
// Copyright 2013-2018 Synopsys, Inc.
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
//-----------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_comparer
//
// The uvm_comparer class provides a policy object for doing comparisons. The
// policies determine how miscompares are treated and counted. Results of a
// comparison are stored in the comparer object. The <uvm_object::compare>
// and <uvm_object::do_compare> methods are passed a uvm_comparer policy
// object.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 16.3.1
class uvm_comparer extends uvm_policy;
	
   // @uvm-ieee 1800.2-2017 auto 16.3.2.3
   `uvm_object_utils(uvm_comparer)

  // @uvm-ieee 1800.2-2017 auto 16.3.2.2
  extern virtual function void flush();

  // @uvm-ieee 1800.2-2017 auto 16.3.3.5
  extern virtual function uvm_policy::recursion_state_e object_compared(
     uvm_object lhs,
     uvm_object rhs,
     uvm_recursion_policy_enum recursion,
     output bit ret_val
  );

  // @uvm-ieee 1800.2-2017 auto 16.3.3.8
  extern virtual function string get_miscompares();

  extern virtual function int unsigned get_result();

  extern virtual function void set_result(int unsigned result) ;

  // @uvm-ieee 1800.2-2017 auto 16.3.4.1
  extern virtual function void set_recursion_policy( uvm_recursion_policy_enum policy);

  // @uvm-ieee 1800.2-2017 auto 16.3.4.1
  extern virtual function uvm_recursion_policy_enum get_recursion_policy();

  // @uvm-ieee 1800.2-2017 auto 16.3.4.2
  extern virtual function void set_check_type( bit enabled );

  // @uvm-ieee 1800.2-2017 auto 16.3.4.2
  extern virtual function bit get_check_type();

  // @uvm-ieee 1800.2-2017 auto 16.3.5.1
  extern virtual function void set_show_max (int unsigned show_max);

  extern virtual function int unsigned get_show_max ();

  // @uvm-ieee 1800.2-2017 auto 16.3.5.2
  extern virtual function void set_verbosity (int unsigned verbosity);

  extern virtual function int unsigned get_verbosity ();

  // @uvm-ieee 1800.2-2017 auto 16.3.5.3
  extern virtual function void set_severity (uvm_severity severity);

  // @uvm-ieee 1800.2-2017 auto 16.3.5.3
  extern virtual function uvm_severity get_severity ();

  // @uvm-ieee 1800.2-2017 auto 16.3.6
  extern virtual function void set_threshold (int unsigned threshold);

  extern virtual function int unsigned get_threshold ();

  typedef struct {
     recursion_state_e state;
     bit ret_val;
  } state_info_t ;
  state_info_t m_recur_states[uvm_object /*LHS*/][uvm_object /*RHS*/][uvm_recursion_policy_enum /*recursion*/];

  // Variable -- NODOCS -- policy
  //
  // Determines whether comparison is UVM_DEEP, UVM_REFERENCE, or UVM_SHALLOW.

`ifdef UVM_ENABLE_DEPRECATED_API
  uvm_recursion_policy_enum policy = UVM_DEFAULT_POLICY;
`else
  local uvm_recursion_policy_enum policy = UVM_DEFAULT_POLICY;
`endif

  // Variable -- NODOCS -- show_max
  //
  // Sets the maximum number of messages to send to the printer for miscompares
  // of an object. 

`ifdef UVM_ENABLE_DEPRECATED_API
  int unsigned show_max = 1;
`else
  local int unsigned show_max = 1;
`endif

  // Variable -- NODOCS -- verbosity
  //
  // Sets the verbosity for printed messages. 
  //
  // The verbosity setting is used by the messaging mechanism to determine
  // whether messages should be suppressed or shown.

`ifdef UVM_ENABLE_DEPRECATED_API
  int unsigned verbosity = UVM_LOW;
`else
  local int unsigned verbosity = UVM_LOW;
`endif


  // Variable -- NODOCS -- sev
  //
  // Sets the severity for printed messages. 
  //
  // The severity setting is used by the messaging mechanism for printing and
  // filtering messages.

`ifdef UVM_ENABLE_DEPRECATED_API
  uvm_severity sev = UVM_INFO;
`else
  local uvm_severity sev = UVM_INFO;
`endif


  // Variable -- NODOCS -- miscompares
  //
  // This string is reset to an empty string when a comparison is started. 
  //
  // The string holds the last set of miscompares that occurred during a
  // comparison.

`ifdef UVM_ENABLE_DEPRECATED_API
  string miscompares = "";
`else
  local string miscompares = "";
`endif

   
`ifdef UVM_ENABLE_DEPRECATED_API
  // Variable -- NODOCS -- physical
  //
  // This bit provides a filtering mechanism for fields. 
  //
  // The abstract and physical settings allow an object to distinguish between
  // two different classes of fields.
  //
  // It is up to you, in the <uvm_object::do_compare> method, to test the
  // setting of this field if you want to use the physical trait as a filter.

  bit physical = 1;
`endif


`ifdef UVM_ENABLE_DEPRECATED_API
  // Variable -- NODOCS -- abstract
  //
  // This bit provides a filtering mechanism for fields. 
  //
  // The abstract and physical settings allow an object to distinguish between
  // two different classes of fields.
  //
  // It is up to you, in the <uvm_object::do_compare> method, to test the
  // setting of this field if you want to use the abstract trait as a filter.

  bit abstract = 1;
`endif

  // Variable -- NODOCS -- check_type
  //
  // This bit determines whether the type, given by <uvm_object::get_type_name>,
  // is used to verify that the types of two objects are the same. 
  //
  // This bit is used by the <compare_object> method. In some cases it is useful
  // to set this to 0 when the two operands are related by inheritance but are
  // different types.

`ifdef UVM_ENABLE_DEPRECATED_API
  bit check_type = 1;
`else
  local bit check_type = 1;
`endif


  // Variable -- NODOCS -- result
  // 
  // This bit stores the number of miscompares for a given compare operation.
  // You can use the result to determine the number of miscompares that
  // were found.

`ifdef UVM_ENABLE_DEPRECATED_API
  int unsigned result = 0;
`else
  local int unsigned result = 0;
`endif

  local int unsigned m_threshold;

	// @uvm-ieee 1800.2-2017 auto 16.3.2.1
	function new(string name=""); endfunction


  // @uvm-ieee 1800.2-2017 auto 16.3.2.4
  static function void set_default (uvm_comparer comparer) ; endfunction

  // @uvm-ieee 1800.2-2017 auto 16.3.2.5
  static function uvm_comparer get_default () ; endfunction

   
  // Function -- NODOCS -- compare_field
  //
  // Compares two integral values. 
  //
  // The ~name~ input is used for purposes of storing and printing a miscompare.
  //
  // The left-hand-side ~lhs~ and right-hand-side ~rhs~ objects are the two
  // objects used for comparison. 
  //
  // The size variable indicates the number of bits to compare; size must be
  // less than or equal to 4096. 
  //
  // The radix is used for reporting purposes, the default radix is hex.

  // @uvm-ieee 1800.2-2017 auto 16.3.3.1
  virtual function bit compare_field (string name, 
                                      uvm_bitstream_t lhs, 
                                      uvm_bitstream_t rhs, 
                                      int size,
                                      uvm_radix_enum radix=UVM_NORADIX); endfunction

  
  
  // Function -- NODOCS -- compare_field_int
  //
  // This method is the same as <compare_field> except that the arguments are
  // small integers, less than or equal to 64 bits. It is automatically called
  // by <compare_field> if the operand size is less than or equal to 64.

  // @uvm-ieee 1800.2-2017 auto 16.3.3.2
  virtual function bit compare_field_int (string name, 
                                          uvm_integral_t lhs, 
                                          uvm_integral_t rhs, 
                                          int size,
                                          uvm_radix_enum radix=UVM_NORADIX); endfunction


  // Function -- NODOCS -- compare_field_real
  //
  // This method is the same as <compare_field> except that the arguments are
  // real numbers.

  // @uvm-ieee 1800.2-2017 auto 16.3.3.3
  virtual function bit compare_field_real (string name, 
                                          real lhs, 
                                          real rhs); endfunction

  // Stores the passed-in names of the objects in the hierarchy
  local string m_object_names[$];
  local function string m_current_context(string name=""); endfunction : m_current_context
  
  // Function -- NODOCS -- compare_object
  //
  // Compares two class objects using the <policy> knob to determine whether the
  // comparison should be deep, shallow, or reference. 
  //
  // The name input is used for purposes of storing and printing a miscompare. 
  //
  // The ~lhs~ and ~rhs~ objects are the two objects used for comparison. 
  //
  // The ~check_type~ determines whether or not to verify the object
  // types match (the return from ~lhs.get_type_name()~ matches
  // ~rhs.get_type_name()~).

  // @uvm-ieee 1800.2-2017 auto 16.3.3.4
  virtual function bit compare_object (string name,
                                       uvm_object lhs,
                                       uvm_object rhs); endfunction
  
  
  // Function -- NODOCS -- compare_string
  //
  // Compares two string variables. 
  //
  // The ~name~ input is used for purposes of storing and printing a miscompare. 
  //
  // The ~lhs~ and ~rhs~ objects are the two objects used for comparison.

  // @uvm-ieee 1800.2-2017 auto 16.3.3.6
  virtual function bit compare_string (string name,
                                       string lhs,
                                       string rhs); endfunction


  // Function -- NODOCS -- print_msg
  //
  // Causes the error count to be incremented and the message, ~msg~, to be
  // appended to the <miscompares> string (a newline is used to separate
  // messages). 
  //
  // If the message count is less than the <show_max> setting, then the message
  // is printed to standard-out using the current verbosity and severity
  // settings. See the <verbosity> and <sev> variables for more information.

  // @uvm-ieee 1800.2-2017 auto 16.3.3.7
  function void print_msg (string msg); endfunction



  // Internal methods - do not call directly

  // print_msg_object
  // ----------------

  function void print_msg_object(uvm_object lhs, uvm_object rhs); endfunction

  int depth;                      //current depth of objects
  bit compare_map[uvm_object][uvm_object];

endclass

function void uvm_comparer::flush(); endfunction

function uvm_policy::recursion_state_e uvm_comparer::object_compared(
  uvm_object lhs,
  uvm_object rhs,
  uvm_recursion_policy_enum recursion,
  output bit ret_val
); endfunction

function string uvm_comparer::get_miscompares(); endfunction

function int unsigned uvm_comparer::get_result(); endfunction

function void uvm_comparer::set_result(int unsigned result); endfunction

function void uvm_comparer::set_recursion_policy( uvm_recursion_policy_enum policy); endfunction

function uvm_recursion_policy_enum uvm_comparer::get_recursion_policy(); endfunction

function void uvm_comparer::set_check_type( bit enabled ); endfunction

function bit uvm_comparer::get_check_type(); endfunction

function void uvm_comparer::set_show_max (int unsigned show_max); endfunction

function int unsigned uvm_comparer::get_show_max(); endfunction

function void uvm_comparer::set_verbosity (int unsigned verbosity); endfunction

function int unsigned uvm_comparer::get_verbosity(); endfunction

function void uvm_comparer::set_severity (uvm_severity severity); endfunction

function uvm_severity uvm_comparer::get_severity(); endfunction

function void uvm_comparer::set_threshold (int unsigned threshold); endfunction

function int unsigned uvm_comparer::get_threshold(); endfunction

