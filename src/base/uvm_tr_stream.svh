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

typedef class uvm_set_before_get_dap;
typedef class uvm_text_recorder;
   

// @uvm-ieee 1800.2-2017 auto 7.2.1
virtual class uvm_tr_stream extends uvm_object;

   // Variable- m_cfg_dap
   // Data access protected reference to the DB
   local uvm_set_before_get_dap#(m_uvm_tr_stream_cfg) m_cfg_dap;

   // Variable- m_records
   // Active records in the stream (active == open or closed)
   local bit m_records[uvm_recorder];
   
   // Variable- m_warn_null_cfg
   // Used to limit the number of warnings
   local bit m_warn_null_cfg;

   // Variable- m_is_opened
   // Used to indicate stream is open
   local bit m_is_opened;

   // Variable- m_is_closed
   // Used to indicate stream is closed
   local bit m_is_closed;
   
   // !m_is_opened && !m_is_closed == m_is_freed
   

   // @uvm-ieee 1800.2-2017 auto 7.2.2
   function new(string name="unnamed-uvm_tr_stream"); endfunction : new

   // Variable- m_ids_by_stream
   // An associative array of int, indexed by uvm_tr_streams.  This
   // provides a unique 'id' or 'handle' for each stream, which can be
   // used to identify the stream.
   //
   // By default, neither ~m_ids_by_stream~ or ~m_streams_by_id~ are
   // used.  Streams are only placed in the arrays when the user
   // attempts to determine the id for a stream.
   local static int m_ids_by_stream[uvm_tr_stream];

   // Group -- NODOCS -- Configuration API
   

   // @uvm-ieee 1800.2-2017 auto 7.2.3.1
   function uvm_tr_database get_db(); endfunction : get_db
      

   // @uvm-ieee 1800.2-2017 auto 7.2.3.2
   function string get_scope(); endfunction : get_scope
      

   // @uvm-ieee 1800.2-2017 auto 7.2.3.3
   function string get_stream_type_name(); endfunction : get_stream_type_name

   // Group -- NODOCS -- Stream API
   //
   // Once a stream has been opened via <uvm_tr_database::open_stream>, the user
   // can ~close~ the stream.
   //
   // Due to the fact that many database implementations will require crossing 
   // a language boundary, an additional step of ~freeing~ the stream is required.
   //
   // A ~link~ can be established within the database any time between "Open" and
   // "Free", however it is illegal to establish a link after "Freeing" the stream.
   //


   // @uvm-ieee 1800.2-2017 auto 7.2.4.1
   function void close(); endfunction : close


   // @uvm-ieee 1800.2-2017 auto 7.2.4.2
   function void free(); endfunction : free
   
   // Function- m_do_open
   // Initializes the state of the stream
   //
   // Parameters-
   // db - Database which the stream belongs to
   // scope - Optional scope
   // stream_type_name - Optional type name for the stream
   //
   // This method will trigger a <do_open> call.
   //
   // An error will be asserted if-
   // - m_do_open is called more than once without the stream
   //   being ~freed~ between.
   // - m_do_open is passed a ~null~ db
   function void m_do_open(uvm_tr_database db,
                           string scope="",
                           string stream_type_name=""); endfunction : m_do_open


   // @uvm-ieee 1800.2-2017 auto 7.2.4.3
   function bit is_open(); endfunction : is_open


   // @uvm-ieee 1800.2-2017 auto 7.2.4.4
   function bit is_closed(); endfunction : is_closed

   // Group -- NODOCS -- Transaction Recorder API
   //
   // New recorders can be opened prior to the stream being ~closed~.
   //
   // Once a stream has been closed, requests to open a new recorder
   // will be ignored (<open_recorder> will return ~null~).
   //
   

   // @uvm-ieee 1800.2-2017 auto 7.2.5.1
   function uvm_recorder open_recorder(string name,
                                      time   open_time = 0,
                                      string type_name=""); endfunction : open_recorder

   // Function- m_free_recorder
   // Removes recorder from the internal array
   function void m_free_recorder(uvm_recorder recorder); endfunction : m_free_recorder


   // @uvm-ieee 1800.2-2017 auto 7.2.5.2
   function unsigned get_recorders(ref uvm_recorder q[$]); endfunction : get_recorders
   
   // Group -- NODOCS -- Handles

   // Variable- m_streams_by_id
   // A corollary to ~m_ids_by_stream~, this indexes the streams by their
   // unique ids.
   local static uvm_tr_stream m_streams_by_id[int];


   // @uvm-ieee 1800.2-2017 auto 7.2.6.1
   function int get_handle(); endfunction : get_handle   
   
   // @uvm-ieee 1800.2-2017 auto 7.2.6.2
   static function uvm_tr_stream get_stream_from_handle(int id); endfunction : get_stream_from_handle
        
   // Function- m_free_id
   // Frees the id/stream link (memory cleanup)
   //
   static function void m_free_id(int id); endfunction : m_free_id

   // Group -- NODOCS -- Implementation Agnostic API
   //


   // @uvm-ieee 1800.2-2017 auto 7.2.7.1
   protected virtual function void do_open(uvm_tr_database db,
                                           string scope,
                                           string stream_type_name);
   endfunction : do_open


   // @uvm-ieee 1800.2-2017 auto 7.2.7.2
   protected virtual function void do_close();
   endfunction : do_close
      

   // @uvm-ieee 1800.2-2017 auto 7.2.7.3
   protected virtual function void do_free();
   endfunction : do_free


   // @uvm-ieee 1800.2-2017 auto 7.2.7.4
   protected virtual function uvm_recorder do_open_recorder(string name,
                                                            time   open_time,
                                                            string type_name); endfunction : do_open_recorder

endclass : uvm_tr_stream

