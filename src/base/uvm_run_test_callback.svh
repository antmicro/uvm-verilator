//
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto F.6.1
virtual class uvm_run_test_callback extends uvm_callback;

  // @uvm-ieee 1800.2-2017 auto F.6.2.1
  // @uvm-ieee 1800.2-2017 auto F.7.1.1
  extern function new( string name="uvm_run_test_callback");

  // @uvm-ieee 1800.2-2017 auto F.6.2.2
  virtual function void pre_run_test();
  endfunction

  // @uvm-ieee 1800.2-2017 auto F.6.2.3
  virtual function void post_run_test();
  endfunction

  // @uvm-ieee 1800.2-2017 auto F.6.2.4
  virtual function void pre_abort();
  endfunction

  // @uvm-ieee 1800.2-2017 auto F.6.2.5
  extern static function bit add( uvm_run_test_callback cb );

  // @uvm-ieee 1800.2-2017 auto F.6.2.6
  extern static function bit delete( uvm_run_test_callback cb );


  // 
  // Implementation details.
  // 

  // These functions executes pre_run_test, post_run_test, and pre_abort routines for all registered
  // callbacks.  These are not user functions.  Only uvm_root should call these.
  extern static function void m_do_pre_run_test();
  extern static function void m_do_post_run_test();
  extern static function void m_do_pre_abort();



endclass : uvm_run_test_callback



function uvm_run_test_callback::new( string name="uvm_run_test_callback"); endfunction


// Adds cb to the list of callbacks to be processed. The method returns 1 if cb is not already in the list of
// callbacks; otherwise, a 0 is returned. If cb is null, 0 is returned.
function bit uvm_run_test_callback::add( uvm_run_test_callback cb ); endfunction


// Removes cb from the list of callbacks to be processed. The method returns 1 if cb is in the list of callbacks;
// otherwise, a 0 is returned. If cb is null, 0 is returned.
function bit uvm_run_test_callback::delete( uvm_run_test_callback cb ); endfunction


function void uvm_run_test_callback::m_do_pre_run_test(); endfunction


function void uvm_run_test_callback::m_do_post_run_test(); endfunction


function void uvm_run_test_callback::m_do_pre_abort(); endfunction


