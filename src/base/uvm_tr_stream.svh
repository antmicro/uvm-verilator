//
//-----------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2015 Analog Devices, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2013-2015 NVIDIA Corporation
// Copyright 2017 Cisco Systems, Inc.
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
// File -- NODOCS -- Transaction Recording Streams
//

// class- m_uvm_tr_stream_cfg
// Undocumented helper class for storing stream
// initialization values.
class m_uvm_tr_stream_cfg;
   uvm_tr_database db;
   string scope;
   string stream_type_name;
endclass : m_uvm_tr_stream_cfg


typedef class uvm_text_recorder;
   

// @uvm-ieee 1800.2-2017 auto 7.2.1
virtual class uvm_tr_stream extends uvm_object;
   function new(string name="unnamed-uvm_tr_stream"); endfunction : new
endclass : uvm_tr_stream

