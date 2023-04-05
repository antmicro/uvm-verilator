//
//-----------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2015 Analog Devices, Inc.
// Copyright 2011-2018 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017-2018 Cisco Systems, Inc.
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

typedef class uvm_report_message;

// File -- NODOCS -- UVM Recorders
//
// The uvm_recorder class serves two purposes:
//  - Firstly, it is an abstract representation of a record within a
//    <uvm_tr_stream>.
//  - Secondly, it is a policy object for recording fields ~into~ that
//    record within the ~stream~.
//

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_recorder
//
// Abstract class which defines the ~recorder~ API.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 16.4.1
virtual class uvm_recorder extends uvm_policy;

   `uvm_object_abstract_utils(uvm_recorder)

  // Variable- m_stream_dap
  // Data access protected reference to the stream
  local uvm_set_before_get_dap#(uvm_tr_stream) m_stream_dap;

  // Variable- m_warn_null_stream
  // Used to limit the number of warnings 
  local bit m_warn_null_stream;

  // Variable- m_is_opened
  // Used to indicate recorder is open
  local bit m_is_opened;
   
  // Variable- m_is_closed
  // Used to indicate recorder is closed
  local bit m_is_closed;

  // !m_is_opened && !m_is_closed == m_is_freed

  // Variable- m_open_time
  // Used to store the open_time
  local time m_open_time;

  // Variable- m_close_time
  // Used to store the close_time
  local time m_close_time;
   
  // Variable- recording_depth
  int recording_depth;

  // Variable -- NODOCS -- default_radix
  //
  // This is the default radix setting if <record_field> is called without
  // a radix.

  uvm_radix_enum default_radix = UVM_HEX;

`ifdef UVM_ENABLE_DEPRECATED_API
   
  // Variable -- NODOCS -- physical
  //
  // This bit provides a filtering mechanism for fields. 
  //
  // The <abstract> and physical settings allow an object to distinguish between
  // two different classes of fields. 
  //
  // It is up to you, in the <uvm_object::do_record> method, to test the
  // setting of this field if you want to use the physical trait as a filter.

  bit physical = 1;


  // Variable -- NODOCS -- abstract
  //
  // This bit provides a filtering mechanism for fields. 
  //
  // The abstract and physical settings allow an object to distinguish between
  // two different classes of fields. 
  //
  // It is up to you, in the <uvm_object::do_record> method, to test the
  // setting of this field if you want to use the abstract trait as a filter.

  bit abstract = 1;

`endif //  `ifdef UVM_ENABLE_DEPRECATED_API
   
  // Variable -- NODOCS -- identifier
  //
  // This bit is used to specify whether or not an object's reference should be
  // recorded when the object is recorded. 

  bit identifier = 1;


  // Variable -- NODOCS -- recursion_policy
  //
  // Sets the recursion policy for recording objects. 
  //
  // The default policy is deep (which means to recurse an object).

`ifndef UVM_ENABLE_DEPRECATED_API
  local
`endif
  uvm_recursion_policy_enum policy = UVM_DEFAULT_POLICY;

  // @uvm-ieee 1800.2-2017 auto 16.4.2.1
  virtual function void set_recursion_policy(uvm_recursion_policy_enum policy); endfunction : set_recursion_policy

  // @uvm-ieee 1800.2-2017 auto 16.4.2.1
  virtual function uvm_recursion_policy_enum get_recursion_policy(); endfunction : get_recursion_policy

  // @uvm-ieee 1800.2-2017 auto 16.4.4.1
  virtual function void flush(); endfunction : flush
  
   // Variable- m_ids_by_recorder
   // An associative array of int, indexed by uvm_recorders.  This
   // provides a unique 'id' or 'handle' for each recorder, which can be
   // used to identify the recorder.
   //
   // By default, neither ~m_ids_by_recorder~ or ~m_recorders_by_id~ are
   // used.  Recorders are only placed in the arrays when the user
   // attempts to determine the id for a recorder.
   local static int m_ids_by_recorder[uvm_recorder];


  function new(string name = "uvm_recorder"); endfunction

   // Group -- NODOCS -- Configuration API
   

   // @uvm-ieee 1800.2-2017 auto 16.4.3
   function uvm_tr_stream get_stream(); endfunction : get_stream

   // Group -- NODOCS -- Transaction Recorder API
   //
   // Once a recorder has been opened via <uvm_tr_stream::open_recorder>, the user
   // can ~close~ the recorder.
   //
   // Due to the fact that many database implementations will require crossing
   // a language boundary, an additional step of ~freeing~ the recorder is required.
   //
   // A ~link~ can be established within the database any time between ~open~ and
   // ~free~, however it is illegal to establish a link after ~freeing~ the recorder.
   //


   // @uvm-ieee 1800.2-2017 auto 16.4.4.2
   function void close(time close_time = 0); endfunction : close


   // @uvm-ieee 1800.2-2017 auto 16.4.4.3
   function void free(time close_time = 0); endfunction : free
      

   // @uvm-ieee 1800.2-2017 auto 16.4.4.4
   function bit is_open(); endfunction : is_open


   // @uvm-ieee 1800.2-2017 auto 16.4.4.5
   function time get_open_time(); endfunction : get_open_time


   // @uvm-ieee 1800.2-2017 auto 16.4.4.6
   function bit is_closed(); endfunction : is_closed
    

   // @uvm-ieee 1800.2-2017 auto 16.4.4.7
   function time get_close_time(); endfunction : get_close_time

  // Function- m_do_open
  // Initializes the internal state of the recorder.
  //
  // Parameters -- NODOCS --
  // stream - The stream which spawned this recorder
  //
  // This method will trigger a <do_open> call.
  //
  // An error will be asserted if:
  // - ~m_do_open~ is called more than once without the
  //  recorder being ~freed~ in between.
  // - ~stream~ is ~null~
  function void m_do_open(uvm_tr_stream stream, time open_time, string type_name); endfunction : m_do_open

   // Group -- NODOCS -- Handles


   // Variable- m_recorders_by_id
   // A corollary to ~m_ids_by_recorder~, this indexes the recorders by their
   // unique ids.
   local static uvm_recorder m_recorders_by_id[int];

   // Variable- m_id
   // Static int marking the last assigned id.
   local static int m_id;

   // Function- m_free_id
   // Frees the id/recorder link (memory cleanup)
   //
   static function void m_free_id(int id); endfunction : m_free_id
            

   // @uvm-ieee 1800.2-2017 auto 16.4.5.1
   function int get_handle(); endfunction : get_handle


   // @uvm-ieee 1800.2-2017 auto 16.4.5.2
   static function uvm_recorder get_recorder_from_handle(int id); endfunction : get_recorder_from_handle

   // Group -- NODOCS -- Attribute Recording
   

   // @uvm-ieee 1800.2-2017 auto 16.4.6.1
   function void record_field(string name,
                              uvm_bitstream_t value,
                              int size,
                              uvm_radix_enum radix=UVM_NORADIX); endfunction : record_field


   // @uvm-ieee 1800.2-2017 auto 16.4.6.2
   function void record_field_int(string name,
                                  uvm_integral_t value,
                                  int size,
                                  uvm_radix_enum radix=UVM_NORADIX); endfunction : record_field_int


   // @uvm-ieee 1800.2-2017 auto 16.4.6.3
   function void record_field_real(string name,
                                   real value); endfunction : record_field_real

   // @uvm-ieee 1800.2-2017 auto 16.4.6.4
   function void record_object(string name,
                               uvm_object value); endfunction : record_object


   // @uvm-ieee 1800.2-2017 auto 16.4.6.5
   function void record_string(string name,
                               string value); endfunction : record_string
   

   // @uvm-ieee 1800.2-2017 auto 16.4.6.6
   function void record_time(string name,
                             time value); endfunction : record_time
   

   // @uvm-ieee 1800.2-2017 auto 16.4.6.7
   function void record_generic(string name,
                                string value,
                                string type_name=""); endfunction : record_generic


  // @uvm-ieee 1800.2-2017 auto 16.4.6.8
  virtual function bit use_record_attribute(); endfunction : use_record_attribute


   // @uvm-ieee 1800.2-2017 auto 16.4.6.9
   virtual function int get_record_attribute_handle(); endfunction : get_record_attribute_handle
   
   // Group -- NODOCS -- Implementation Agnostic API


   // @uvm-ieee 1800.2-2017 auto 16.4.7.1
   protected virtual function void do_open(uvm_tr_stream stream,
                                             time open_time,
                                             string type_name);
   endfunction : do_open


   // @uvm-ieee 1800.2-2017 auto 16.4.7.2
   protected virtual function void do_close(time close_time);
   endfunction : do_close


   // @uvm-ieee 1800.2-2017 auto 16.4.7.3
   protected virtual function void do_free();
   endfunction : do_free
   

   // @uvm-ieee 1800.2-2017 auto 16.4.7.4
   pure virtual protected function void do_record_field(string name,
                                                        uvm_bitstream_t value,
                                                        int size,
                                                        uvm_radix_enum radix);


   // @uvm-ieee 1800.2-2017 auto 16.4.7.5
   pure virtual protected function void do_record_field_int(string name,
                                                            uvm_integral_t value,
                                                            int          size,
                                                            uvm_radix_enum radix);
   

   // @uvm-ieee 1800.2-2017 auto 16.4.7.6
   pure virtual protected function void do_record_field_real(string name,
                                                             real value);


   // Function : do_record_object
   // The library implements do_record_object as virtual even though the LRM
   // calls for pure virtual. Mantis 6591 calls for the LRM to move to
   // virtual.  The implemented signature is:
   // virtual protected function void do_record_object(string name, uvm_object value);
  
   // @uvm-ieee 1800.2-2017 auto 16.4.7.7
   virtual protected function void do_record_object(string name,
                                                    uvm_object value); endfunction : do_record_object


   // @uvm-ieee 1800.2-2017 auto 16.4.7.9
   pure virtual protected function void do_record_string(string name,
                                                         string value);


   // @uvm-ieee 1800.2-2017 auto 16.4.7.10
   pure virtual protected function void do_record_time(string name,
                                                       time value);


   // @uvm-ieee 1800.2-2017 auto 16.4.7.11
   pure virtual protected function void do_record_generic(string name,
                                                          string value,
                                                          string type_name);


   // The following code is primarily for backwards compat. purposes.  "Transaction
   // Handles" are useful when connecting to a backend, but when passing the information
   // back and forth within simulation, it is safer to user the ~recorder~ itself
   // as a reference to the transaction within the database.

   //------------------------------
   // Group- Vendor-Independent API
   //------------------------------


  // UVM provides only a text-based default implementation.
  // Vendors provide subtype implementations and overwrite the
  // <uvm_default_recorder> handle.


  // Function- open_file
  //
  // Opens the file in the <filename> property and assigns to the
  // file descriptor <file>.
  //
  virtual function bit open_file(); endfunction

  // Function- create_stream
  //
  //
  virtual function int create_stream (string name,
                                          string t,
                                          string scope); endfunction

   
  // Function- m_set_attribute
  //
  //
  virtual function void m_set_attribute (int txh,
                                 string nm,
                                 string value);
  endfunction
  
  
  // Function- set_attribute
  //
  virtual function void set_attribute (int txh,
                               string nm,
                               logic [1023:0] value,
                               uvm_radix_enum radix,
                               int numbits=1024);
  endfunction
  
  
  // Function- check_handle_kind
  //
  //
  virtual function int check_handle_kind (string htype, int handle); endfunction
  
  
  // Function- begin_tr
  //
  //
  virtual function int begin_tr(string txtype,
                                     int stream,
                                     string nm,
                                     string label="",
                                     string desc="",
                                     time begin_time=0);
    return -1;
  endfunction
  
  
  // Function- end_tr
  //
  //
  virtual function void end_tr (int handle, time end_time=0);
  endfunction
  
  
  // Function- link_tr
  //
  //
  virtual function void link_tr(int h1,
                                 int h2,
                                 string relation="");
  endfunction
  
  
  
  // Function- free_tr
  //
  //
  virtual function void free_tr(int handle);
  endfunction
  
endclass // uvm_recorder

//------------------------------------------------------------------------------
//
// CLASS: uvm_text_recorder
//
// The ~uvm_text_recorder~ is the default recorder implementation for the
// <uvm_text_tr_database>.
//
// @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
  
class uvm_text_recorder extends uvm_recorder;

   `uvm_object_utils(uvm_text_recorder)

   // Variable- m_text_db
   //
   // Reference to the text database backend
   uvm_text_tr_database m_text_db;

   // Function --NODOCS-- new
   // Constructor
   //
   // Parameters --NODOCS--
   // name - Instance name
   function new(string name="unnamed-uvm_text_recorder"); endfunction : new

   // Group --NODOCS-- Implementation Agnostic API

   // Function --NODOCS-- do_open
   // Callback triggered via <uvm_tr_stream::open_recorder>.
   //
   // Text-backend specific implementation.
   protected virtual function void do_open(uvm_tr_stream stream,
                                             time open_time,
                                             string type_name); endfunction : do_open

   // Function --NODOCS-- do_close
   // Callback triggered via <uvm_recorder::close>.
   //
   // Text-backend specific implementation.
   protected virtual function void do_close(time close_time); endfunction : do_close

   // Function --NODOCS-- do_free
   // Callback triggered via <uvm_recorder::free>.
   //
   // Text-backend specific implementation.
   protected virtual function void do_free(); endfunction : do_free
   
   // Function --NODOCS-- do_record_field
   // Records an integral field (less than or equal to 4096 bits).
   //
   // Text-backend specific implementation.
   protected virtual function void do_record_field(string name,
                                                   uvm_bitstream_t value,
                                                   int size,
                                                   uvm_radix_enum radix); endfunction : do_record_field
  
   
   // Function --NODOCS-- do_record_field_int
   // Records an integral field (less than or equal to 64 bits).
   //
   // Text-backend specific implementation.
   protected virtual function void do_record_field_int(string name,
                                                       uvm_integral_t value,
                                                       int          size,
                                                       uvm_radix_enum radix); endfunction : do_record_field_int


   // Function --NODOCS-- do_record_field_real
   // Record a real field.
   //
   // Text-backened specific implementation.
   protected virtual function void do_record_field_real(string name,
                                                        real value); endfunction : do_record_field_real

  // Stores the passed-in names of the objects in the hierarchy
  local string m_object_names[$];
  local function string m_current_context(string name=""); endfunction : m_current_context

  
   // Function --NODOCS-- do_record_object
   // Record an object field.
   //
   // Text-backend specific implementation.
   //
   // The method uses ~identifier~ to determine whether or not to
   // record the object instance id, and ~recursion_policy~ to
   // determine whether or not to recurse into the object.
   protected virtual function void do_record_object(string name,
                                                    uvm_object value); endfunction : do_record_object

   // Function --NODOCS-- do_record_string
   // Records a string field.
   //
   // Text-backend specific implementation.
   protected virtual function void do_record_string(string name,
                                                    string value); endfunction : do_record_string

   // Function --NODOCS-- do_record_time
   // Records a time field.
   //
   // Text-backend specific implementation.
   protected virtual function void do_record_time(string name,
                                                    time value); endfunction : do_record_time

   // Function --NODOCS-- do_record_generic
   // Records a name/value pair, where ~value~ has been converted to a string.
   //
   // Text-backend specific implementation.
   protected virtual function void do_record_generic(string name,
                                                     string value,
                                                     string type_name); endfunction : do_record_generic

   // Group: Implementation Specific API
   
   // Function: write_attribute
   // Outputs a <uvm_bitstream_t> attribute to the textual log.
   //
   // Parameters:
   // nm - Name of the attribute
   // value - Value 
   // radix - Radix of the output
   // numbits - number of valid bits
   //
   // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
   function void write_attribute(string nm,
                                 uvm_bitstream_t value,
                                 uvm_radix_enum radix,
                                 int numbits=$bits(uvm_bitstream_t)); endfunction : write_attribute

   // Function: write_attribute_int
   // Outputs an <uvm_integral_t> attribute to the textual log
   //
   // Parameters:
   // nm - Name of the attribute
   // value - Value
   // radix - Radix of the output
   // numbits - number of valid bits
   //
   // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
   function void write_attribute_int(string  nm,
                                     uvm_integral_t value,
                                     uvm_radix_enum radix,
                                     int numbits=$bits(uvm_bitstream_t)); endfunction : write_attribute_int

   /// LEFT FOR BACKWARDS COMPAT ONLY!!!!!!!!

   //------------------------------
   // Group- Vendor-Independent API
   //------------------------------


  // UVM provides only a text-based default implementation.
  // Vendors provide subtype implementations and overwrite the
  // <uvm_default_recorder> handle.

   string                                                   filename;
   bit                                                      filename_set;

  // Function- open_file
  //
  // Opens the file in the <filename> property and assigns to the
  // file descriptor <file>.
  //
  virtual function bit open_file(); endfunction


  // Function- create_stream
  //
  //
  virtual function int create_stream (string name,
                                          string t,
                                          string scope); endfunction

   
  // Function- m_set_attribute
  //
  //
  virtual function void m_set_attribute (int txh,
                                 string nm,
                                 string value); endfunction
  
  
  // Function- set_attribute
  //
  //
  virtual function void set_attribute (int txh,
                               string nm,
                               logic [1023:0] value,
                               uvm_radix_enum radix,
                               int numbits=1024); endfunction
  
  
  // Function- check_handle_kind
  //
  //
  virtual function int check_handle_kind (string htype, int handle); endfunction
  
  
  // Function- begin_tr
  //
  //
  virtual function int begin_tr(string txtype,
                                     int stream,
                                     string nm,
                                     string label="",
                                     string desc="",
                                     time begin_time=0);
     if (open_file()) begin
        uvm_tr_stream stream_obj = uvm_tr_stream::get_stream_from_handle(stream);
        uvm_recorder recorder;
  
        if (stream_obj == null)
          return -1;

        recorder = stream_obj.open_recorder(nm, begin_time, txtype);

        return recorder.get_handle();
     end
     return -1;
  endfunction
  
  
  // Function- end_tr
  //
  //
  virtual function void end_tr (int handle, time end_time=0);
     if (open_file()) begin
        uvm_recorder record = uvm_recorder::get_recorder_from_handle(handle);
        if (record != null) begin
           record.close(end_time);
        end
     end
  endfunction
  
  
  // Function- link_tr
  //
  //
  virtual function void link_tr(int h1,
                                 int h2,
                                 string relation=""); endfunction
  
  
  
  // Function- free_tr
  //
  //
  virtual function void free_tr(int handle); endfunction // free_tr

endclass : uvm_text_recorder

  
   
