//----------------------------------------------------------------------
// Copyright 2018 Synopsys, Inc.
// Copyright 2018 Cadence Design Systems, Inc.
// Copyright 2018 NVIDIA Corporation
// Copyright 2018 Cisco Systems, Inc.
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
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
// Class - uvm_field_op
//
// uvm_field_op is the UVM class for describing all operations supported by the do_execute_op function
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 5.3.13.2.1
class uvm_field_op extends uvm_object;

   // @uvm-ieee 1800.2-2017 auto 5.3.4.5
   // @uvm-ieee 1800.2-2017 auto 5.3.4.6
   // @uvm-ieee 1800.2-2017 auto 5.3.4.7
   // @uvm-ieee 1800.2-2017 auto 5.3.5.1





   // Bit m_is_set is set when the set() method is called and acts 
   // like a state variable. It is cleared when flush is called.




   // Function -- new 
   // 
   // Creates a policy with the specified instance name. If name is not provided, then the policy instance is
   // unnamed.

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.3
   // @uvm-ieee 1800.2-2017 auto 5.3.2
   function new (string name=""); endfunction


   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.4
   virtual function void set( uvm_field_flag_t op_type, uvm_policy policy = null, uvm_object rhs = null); endfunction 

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.5
   virtual function string get_op_name(); endfunction

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.6
   virtual function uvm_field_flag_t get_op_type(); endfunction


   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.7
   virtual function uvm_policy get_policy(); endfunction

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.8
   virtual function uvm_object get_rhs(); endfunction

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.9
   function bit user_hook_enabled(); endfunction

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.10
   function void disable_user_hook(); endfunction

   static uvm_field_op m_recycled_op[$] ; 

   // @uvm-ieee 1800.2-2017 auto 5.3.13.2.11
   virtual function void flush(); endfunction

   // API for reusing uvm_field_op instances.  Implementation
   // artifact, should not be used directly by the user.
   function void m_recycle(); endfunction : m_recycle 
 
   static function uvm_field_op m_get_available_op() ; endfunction
endclass
