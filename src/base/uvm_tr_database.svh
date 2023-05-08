//
//-----------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2015 Analog Devices, Inc.
// Copyright 2014 Intel Corporation
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
// File -- NODOCS -- Transaction Recording Databases
//
// The UVM "Transaction Recording Database" classes are an abstract representation
// of the backend tool which is recording information for the user.  Usually this
// tool would be dumping information such that it can be viewed with the ~waves~ 
// of the DUT.
//

typedef class uvm_recorder;
typedef class uvm_tr_stream;
typedef class uvm_link_base;
   
   
//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_tr_database
//
// The ~uvm_tr_database~ class is intended to hide the underlying database implementation
// from the end user, as these details are often vendor or tool-specific.
//
// The ~uvm_tr_database~ class is pure virtual, and must be extended with an
// implementation.  A default text-based implementation is provided via the
// <uvm_text_tr_database> class.
//

// @uvm-ieee 1800.2-2017 auto 7.1.1
virtual class uvm_tr_database extends uvm_object;

   // Variable- m_is_opened
   // Tracks the opened state of the database


   // Variable- m_streams
   // Used for tracking streams which are between the open and closed states

   

   // @uvm-ieee 1800.2-2017 auto 7.1.2
   function new(string name="unnamed-uvm_tr_database"); endfunction : new

   // Group -- NODOCS -- Database API
   

   // @uvm-ieee 1800.2-2017 auto 7.1.3.1
   function bit open_db(); endfunction : open_db


   // @uvm-ieee 1800.2-2017 auto 7.1.3.2
   function bit close_db(); endfunction : close_db


   // @uvm-ieee 1800.2-2017 auto 7.1.3.3
   function bit is_open(); endfunction : is_open

   // Group -- NODOCS -- Stream API
   

   // @uvm-ieee 1800.2-2017 auto 7.1.4.1
   function uvm_tr_stream open_stream(string name,
                                      string scope="",
                                      string type_name=""); endfunction : open_stream

   // Function- m_free_stream
   // Removes stream from the internal array
   function void m_free_stream(uvm_tr_stream stream); endfunction : m_free_stream
   

   // @uvm-ieee 1800.2-2017 auto 7.1.4.2
   function unsigned get_streams(ref uvm_tr_stream q[$]); endfunction : get_streams
   
   // Group -- NODOCS -- Link API
   

   // @uvm-ieee 1800.2-2017 auto 7.1.5
   function void establish_link(uvm_link_base link); endfunction : establish_link
      
   // Group -- NODOCS -- Implementation Agnostic API
   //


   // @uvm-ieee 1800.2-2017 auto 7.1.6.1
   pure virtual protected function bit do_open_db();


   // @uvm-ieee 1800.2-2017 auto 7.1.6.2
   pure virtual protected function bit do_close_db();


   // @uvm-ieee 1800.2-2017 auto 7.1.6.3
   pure virtual protected function uvm_tr_stream do_open_stream(string name,
                                                                string scope,
                                                                string type_name);


   // @uvm-ieee 1800.2-2017 auto 7.1.6.4
   pure virtual protected function void do_establish_link(uvm_link_base link);

endclass : uvm_tr_database

