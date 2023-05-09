//-----------------------------------------------------------------------------
// Copyright 2018 Qualcomm, Inc.
// Copyright 2018 Synopsys, Inc.
// Copyright 2018 Cadence Design Systems, Inc.
// Copyright 2018 NVIDIA Corporation
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
// CLASS -- NODOCS -- uvm_copier
//
// The uvm_copier class provides a policy object for doing comparisons. The
// policies determine how miscompares are treated and counted. Results of a
// comparison are stored in the copier object. The <uvm_object::compare>
// and <uvm_object::do_compare> methods are passed a uvm_copier policy
// object.
//
//------------------------------------------------------------------------------

// Class: uvm_copier
// Implementation of the uvm_copier class, as defined in section
// 16.6.1 of 1800.2-2017

// @uvm-ieee 1800.2-2017 auto 16.6.1
class uvm_copier extends uvm_policy;
   // @uvm-ieee 1800.2-2017 auto 16.6.2.2

  // Variable -- NODOCS -- policy
  //
  // Determines whether comparison is UVM_DEEP, UVM_REFERENCE, or UVM_SHALLOW.

    uvm_recursion_policy_enum policy = UVM_DEFAULT_POLICY;


   // @uvm-ieee 1800.2-2017 auto 16.6.2.1
   function new(string name="uvm_copier") ; endfunction
	
   // Implementation only.

  // Implementation only. Not present in the LRM.
 //recursion_state_e m_saved_state[uvm_object /*LHS*/][uvm_object /*RHS*/][uvm_recursion_policy_enum /*recursion*/];

   recursion_state_e m_recur_states[uvm_object /*RHS*/][uvm_object /*LHS*/][uvm_recursion_policy_enum /*recursion*/];

  // Function -- copy_object
  //
  // Copies two class objects using the <policy> knob to determine whether the
  // comparison should be deep, shallow, or reference. 
  //
  // The name input is used for purposes of storing and printing a miscompare. 
  //
  // The ~lhs~ and ~rhs~ objects are the two objects used for comparison. 
  //
  // The ~check_type~ determines whether or not to verify the object
  // types match (the return from ~lhs.get_type_name()~ matches
  // ~rhs.get_type_name()~).

  // @uvm-ieee 1800.2-2017 auto 16.6.4.1
  virtual function void copy_object (
                                       uvm_object lhs,
                                       uvm_object rhs); endfunction
  
   // @uvm-ieee 1800.2-2017 auto 16.6.4.2
   virtual function recursion_state_e object_copied(
	 			uvm_object lhs,
  				uvm_object rhs,
  				uvm_recursion_policy_enum recursion
  ); endfunction


function void flush(); endfunction

// @uvm-ieee 1800.2-2017 auto 16.6.3
virtual function void set_recursion_policy (uvm_recursion_policy_enum policy); endfunction

// @uvm-ieee 1800.2-2017 auto 16.6.3
virtual function uvm_recursion_policy_enum get_recursion_policy(); endfunction

// Function: get_num_copies
//
// Returns the number of times the ~rhs~ has been copied to a unique ~lhs~ 
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
function int unsigned get_num_copies(uvm_object rhs); endfunction : get_num_copies

// Function: get_first_copy
//
//| function int get_first_copy(uvm_object rhs, ref uvm_object lhs)
//
// assigns to the ~lhs~ the value of the first (smallest) object that
// was copied from the ~rhs~. It returns 0 if the ~rhs~ hasn't been copied;
// otherwise, it returns 1.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
`uvm_copier_get_function(first)


// Function: get_next_copy
//
//| function int get_next_copy(uvm_object rhs, ref uvm_object lhs)
//
// finds the smallest object that was copied from the ~rhs~ whose value is 
// greater than the given ~lhs~ object argument. If there is a next entry,
// the ~lhs~ is assigned the value of the next object, and the function returns 1. 
// Otherwise, the ~lhs~ is unchanged, and the function returns 0.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
`uvm_copier_get_function(next)

// Function: get_last_copy
//
//| function int get_last_copy(uvm_object rhs, ref uvm_object lhs)
//
// assigns to the ~lhs~ the value of the last (largest) object that
// was copied from the ~rhs~. It returns 0 if the ~rhs~ hasn't been copied;
// otherwise, it returns 1.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
`uvm_copier_get_function(last)

// Function: get_prev_copy
//
//| function int get_prev_copy(uvm_object rhs, ref uvm_object lhs)
//
// finds the largest object that was copied from the ~rhs~ whose value is 
// smaller than the given ~lhs~ object argument. If there is a previous entry,
// the ~lhs~ is assigned the value of the previous object, and the function returns 1. 
// Otherwise, the ~lhs~ is unchanged, and the function returns 0.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
`uvm_copier_get_function(prev)

// @uvm-ieee 1800.2-2017 auto 16.6.2.3
static function void set_default (uvm_copier copier) ; endfunction

// @uvm-ieee 1800.2-2017 auto 16.6.2.4
static function uvm_copier get_default () ; endfunction
 
endclass
