//----------------------------------------------------------------------
// Copyright 2010-2012 Mentor Graphics Corporation
// Copyright 2010-2018 Cadence Design Systems, Inc.
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



`ifndef UVM_REGEX_NO_DPI
import "DPI-C" context function int uvm_re_match(string re, string str);
import "DPI-C" context function string uvm_glob_to_re(string glob);

`else

// The Verilog only version does not match regular expressions,
// it only does glob style matching.
function int uvm_re_match(string re, string str); endfunction

function string uvm_glob_to_re(string glob); endfunction

`endif
