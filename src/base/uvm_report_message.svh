//
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2013 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
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

`ifndef UVM_REPORT_MESSAGE_SVH
`define UVM_REPORT_MESSAGE_SVH


typedef class uvm_report_server;
typedef class uvm_report_handler;

 

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_message_element_base
//
// Base class for report message element. Defines common interface.
//
//------------------------------------------------------------------------------

virtual class uvm_report_message_element_base;
   protected uvm_action _action;
   protected string          _name;


   // Function -- NODOCS -- get_name
   // 

   virtual function string get_name(); endfunction

   // Function -- NODOCS -- set_name
   // 
   // Get or set the name of the element
   //

   virtual function void set_name(string name); endfunction
     

   // Function -- NODOCS -- get_action
   // 

   virtual function uvm_action get_action(); endfunction

   // Function -- NODOCS -- set_action
   // 
   // Get or set the authorized action for the element
   //

   virtual function void set_action(uvm_action action); endfunction
     
     
   function void print(uvm_printer printer); endfunction : print
   function void record(uvm_recorder recorder); endfunction : record
   function void copy(uvm_report_message_element_base rhs); endfunction : copy
   function uvm_report_message_element_base clone(); endfunction : clone

   pure virtual function void do_print(uvm_printer printer);
   pure virtual function void do_record(uvm_recorder recorder);
   pure virtual function void do_copy(uvm_report_message_element_base rhs);
   pure virtual function uvm_report_message_element_base do_clone();
   
endclass : uvm_report_message_element_base


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_message_int_element
//
// Message element class for integral type
//
//------------------------------------------------------------------------------

class uvm_report_message_int_element extends uvm_report_message_element_base;
   typedef uvm_report_message_int_element this_type;
   
   protected uvm_bitstream_t _val;
   protected int             _size;
   protected uvm_radix_enum  _radix;

   // Function -- NODOCS -- get_value
   //

   virtual function uvm_bitstream_t get_value(output int size, 
                                              output uvm_radix_enum radix); endfunction


   // Function -- NODOCS -- set_value
   //
   // Get or set the value (integral type) of the element, with size and radix
   //

   virtual function void set_value(uvm_bitstream_t value,
                              int size, 
                              uvm_radix_enum radix); endfunction virtual function void do_print(uvm_printer printer); endfunction : do_print

   virtual function void do_record(uvm_recorder recorder); endfunction : do_record

   virtual function void do_copy(uvm_report_message_element_base rhs); endfunction : do_copy

   virtual function uvm_report_message_element_base do_clone(); endfunction : do_clone
endclass : uvm_report_message_int_element


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_message_string_element
//
// Message element class for string type
//
//------------------------------------------------------------------------------

class uvm_report_message_string_element extends uvm_report_message_element_base;
   typedef uvm_report_message_string_element this_type;
   protected string  _val;


   // Function -- NODOCS -- get_value
   //

   virtual function string get_value(); endfunction

   // Function -- NODOCS -- set_value
   //
   // Get or set the value (string type) of the element
   //

   virtual function void set_value(string value); endfunction


   virtual function void do_print(uvm_printer printer); endfunction : do_print

   virtual function void do_record(uvm_recorder recorder); endfunction : do_record

   virtual function void do_copy(uvm_report_message_element_base rhs); endfunction : do_copy
   
   virtual function uvm_report_message_element_base do_clone(); endfunction : do_clone
endclass : uvm_report_message_string_element


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_message_object_element
//
// Message element class for object type
//
//------------------------------------------------------------------------------

class uvm_report_message_object_element extends uvm_report_message_element_base;
   typedef uvm_report_message_object_element this_type;
   protected uvm_object _val;


   // Function -- NODOCS -- get_value
   //
   // Get the value (object reference) of the element
   //

   virtual function uvm_object get_value(); endfunction

   // Function -- NODOCS -- set_value
   //
   // Get or set the value (object reference) of the element
   //

   virtual function void set_value(uvm_object value); endfunction


   virtual function void do_print(uvm_printer printer); endfunction : do_print

   virtual function void do_record(uvm_recorder recorder); endfunction : do_record

   virtual function void do_copy(uvm_report_message_element_base rhs); endfunction : do_copy
   
   virtual function uvm_report_message_element_base do_clone(); endfunction : do_clone
endclass : uvm_report_message_object_element

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_message_element_container
//
// A container used by report message to contain the dynamically added elements,
// with APIs to add and delete the elements.
//
//------------------------------------------------------------------------------

class uvm_report_message_element_container extends uvm_object;

  protected uvm_report_message_element_base elements[$];

  `uvm_object_utils(uvm_report_message_element_container)

  // Function -- NODOCS -- new
  //
  // Create a new uvm_report_message_element_container object
  //

  function new(string name = "element_container"); endfunction


  // Function -- NODOCS -- size
  //
  // Returns the size of the container, i.e. the number of elements
  //

  virtual function int size(); endfunction


  // Function -- NODOCS -- delete
  //
  // Delete the ~index~-th element in the container
  //

  virtual function void delete(int index); endfunction


  // Function -- NODOCS -- delete_elements
  //
  // Delete all the elements in the container
  //

  virtual function void delete_elements(); endfunction


  // Function -- NODOCS -- get_elements
  //
  // Get all the elements from the container and put them in a queue
  //

  typedef uvm_report_message_element_base queue_of_element[$];
  virtual function queue_of_element get_elements(); endfunction


  // Function -- NODOCS -- add_int
  // 
  // This method adds an integral type of the name ~name~ and value ~value~ to
  // the container.  The required ~size~ field indicates the size of ~value~. 
  // The required ~radix~ field determines how to display and 
  // record the field. The optional print/record bit is to specify whether 
  // the element will be printed/recorded.
  //

  virtual function void add_int(string name, uvm_bitstream_t value, 
                                int size, uvm_radix_enum radix,
			        uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction


  // Function -- NODOCS -- add_string
  // 
  // This method adds a string of the name ~name~ and value ~value~ to the 
  // message. The optional print/record bit is to specify whether 
  // the element will be printed/recorded.
  //

  virtual function void add_string(string name, string value, 
                                   uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction


  // Function -- NODOCS -- add_object
  // 
  // This method adds a uvm_object of the name ~name~ and reference ~obj~ to
  // the message. The optional print/record bit is to specify whether 
  // the element will be printed/recorded. 
  //

  virtual function void add_object(string name, uvm_object obj, 
                                   uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction

  virtual function void do_print(uvm_printer printer); endfunction

  virtual function void do_record(uvm_recorder recorder); endfunction

  virtual function void do_copy(uvm_object rhs); endfunction

endclass



//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_message
//
// The uvm_report_message is the basic UVM object message class.  It provides 
// the fields that are common to all messages.  It also has a message element 
// container and provides the APIs necessary to add integral types, strings and
// uvm_objects to the container. The report message object can be initialized
// with the common fields, and passes through the whole reporting system (i.e. 
// report object, report handler, report server, report catcher, etc) as an
// object. The additional elements can be added/deleted to/from the message 
// object anywhere in the reporting system, and can be printed or recorded
// along with the common fields.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 6.2.1
class uvm_report_message extends uvm_object;

  protected uvm_report_object _report_object;
  protected uvm_report_handler _report_handler;
  protected uvm_report_server _report_server;

  protected uvm_severity _severity; 
  protected string _id;
  protected string _message;
  protected int _verbosity;
  protected string _filename;
  protected int _line;
  protected string _context_name;
  protected uvm_action _action; 
  protected UVM_FILE _file;

  // Not documented.
  protected uvm_report_message_element_container _report_message_element_container;


  // Function -- NODOCS -- new
  // 
  // Creates a new uvm_report_message object.
  //

  // @uvm-ieee 1800.2-2017 auto 6.2.2.1
  function new(string name = "uvm_report_message"); endfunction


  // Function -- NODOCS -- new_report_message
  // 
  // Creates a new uvm_report_message object.
  // This function is the same as new(), but keeps the random stability.
  //

  // @uvm-ieee 1800.2-2017 auto 6.2.2.2
  static function uvm_report_message new_report_message(string name = "uvm_report_message"); endfunction


  // Function -- NODOCS -- print
  //
  // The uvm_report_message implements <uvm_object::do_print()> such that
  // ~print~ method provides UVM printer formatted output
  // of the message.  A snippet of example output is shown here:
  //
  //| --------------------------------------------------------
  //| Name                Type               Size  Value
  //| --------------------------------------------------------
  //| uvm_report_message  uvm_report_message  -     @532
  //|   severity          uvm_severity        2     UVM_INFO
  //|   id                string              10    TEST_ID
  //|   message           string              12    A message...
  //|   verbosity         uvm_verbosity       32    UVM_LOW
  //|   filename          string              7     test.sv
  //|   line              integral            32    'd58
  //|   context_name      string              0     ""
  //|   color             string              3     red
  //|   my_int            integral            32    'd5
  //|   my_string         string              3     foo
  //|   my_obj            my_class            -     @531
  //|     foo             integral            32    'd3
  //|     bar             string              8     hi there


  // @uvm-ieee 1800.2-2017 auto 6.2.2.3
  virtual function void do_print(uvm_printer printer); endfunction


  `uvm_object_utils(uvm_report_message)



  // do_pack() not needed
  // do_unpack() not needed
  // do_compare() not needed


  // Not documented.
  virtual function void do_copy (uvm_object rhs); endfunction


  //----------------------------------------------------------------------------
  // Group -- NODOCS --  Infrastructure References
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- get_report_object

  // @uvm-ieee 1800.2-2017 auto 6.2.3.1
  virtual function uvm_report_object get_report_object(); endfunction

  // Function -- NODOCS -- set_report_object
  //
  // Get or set the uvm_report_object that originated the message.

  // @uvm-ieee 1800.2-2017 auto 6.2.3.1
  virtual function void set_report_object(uvm_report_object ro); endfunction


  // Function -- NODOCS -- get_report_handler

  // @uvm-ieee 1800.2-2017 auto 6.2.3.2
  virtual function uvm_report_handler get_report_handler(); endfunction

  // Function -- NODOCS -- set_report_handler
  //
  // Get or set the uvm_report_handler that is responsible for checking
  // whether the message is enabled, should be upgraded/downgraded, etc.

  // @uvm-ieee 1800.2-2017 auto 6.2.3.2
  virtual function void set_report_handler(uvm_report_handler rh); endfunction

  
  // Function -- NODOCS -- get_report_server

  // @uvm-ieee 1800.2-2017 auto 6.2.3.3
  virtual function uvm_report_server get_report_server(); endfunction

  // Function -- NODOCS -- set_report_server
  //
  // Get or set the uvm_report_server that is responsible for servicing
  // the message's actions.  

  // @uvm-ieee 1800.2-2017 auto 6.2.3.3
  virtual function void set_report_server(uvm_report_server rs); endfunction


  //----------------------------------------------------------------------------
  // Group -- NODOCS --  Message Fields
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- get_severity

  // @uvm-ieee 1800.2-2017 auto 6.2.4.1
  virtual function uvm_severity get_severity(); endfunction

  // Function -- NODOCS -- set_severity
  //
  // Get or set the severity (UVM_INFO, UVM_WARNING, UVM_ERROR or 
  // UVM_FATAL) of the message.  The value of this field is determined via
  // the API used (`uvm_info(), `uvm_waring(), etc.) and populated for the user.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.1
  virtual function void set_severity(uvm_severity sev); endfunction


  // Function -- NODOCS -- get_id

  // @uvm-ieee 1800.2-2017 auto 6.2.4.2
  virtual function string get_id(); endfunction

  // Function -- NODOCS -- set_id
  //
  // Get or set the id of the message.  The value of this field is 
  // completely under user discretion.  Users are recommended to follow a
  // consistent convention.  Settings in the uvm_report_handler allow various
  // messaging controls based on this field.  See <uvm_report_handler>.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.2
  virtual function void set_id(string id); endfunction


  // Function -- NODOCS -- get_message

  // @uvm-ieee 1800.2-2017 auto 6.2.4.3
  virtual function string get_message(); endfunction

  // Function -- NODOCS -- set_message
  //
  // Get or set the user message content string.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.3
  virtual function void set_message(string msg); endfunction


  // Function -- NODOCS -- get_verbosity

  // @uvm-ieee 1800.2-2017 auto 6.2.4.4
  virtual function int get_verbosity(); endfunction

  // Function -- NODOCS -- set_verbosity
  //
  // Get or set the message threshold value.  This value is compared
  // against settings in the <uvm_report_handler> to determine whether this
  // message should be executed.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.4
  virtual function void set_verbosity(int ver); endfunction


  // Function -- NODOCS -- get_filename

  // @uvm-ieee 1800.2-2017 auto 6.2.4.5
  virtual function string get_filename(); endfunction

  // Function -- NODOCS -- set_filename
  //
  // Get or set the file from which the message originates.  This value
  // is automatically populated by the messaging macros.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.5
  virtual function void set_filename(string fname); endfunction


  // Function -- NODOCS -- get_line

  // @uvm-ieee 1800.2-2017 auto 6.2.4.6
  virtual function int get_line(); endfunction

  // Function -- NODOCS -- set_line
  //
  // Get or set the line in the ~file~ from which the message originates.
  // This value is automatically populate by the messaging macros.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.6
  virtual function void set_line(int ln); endfunction


  // Function -- NODOCS -- get_context

  // @uvm-ieee 1800.2-2017 auto 6.2.4.7
  virtual function string get_context(); endfunction

  // Function -- NODOCS -- set_context
  //
  // Get or set the optional user-supplied string that is meant to convey
  // the context of the message.  It can be useful in scopes that are not
  // inherently UVM like modules, interfaces, etc.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.7
  virtual function void set_context(string cn); endfunction
 

  // Function -- NODOCS -- get_action

  // @uvm-ieee 1800.2-2017 auto 6.2.4.8
  virtual function uvm_action get_action(); endfunction

  // Function -- NODOCS -- set_action
  //
  // Get or set the action(s) that the uvm_report_server should perform
  // for this message.  This field is populated by the uvm_report_handler during
  // message execution flow.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.8
  virtual function void set_action(uvm_action act); endfunction


  // Function -- NODOCS -- get_file

  // @uvm-ieee 1800.2-2017 auto 6.2.4.9
  virtual function UVM_FILE get_file(); endfunction

  // Function -- NODOCS -- set_file
  //
  // Get or set the file that the message is to be written to when the 
  // message's action is UVM_LOG.  This field is populated by the 
  // uvm_report_handler during message execution flow.

  // @uvm-ieee 1800.2-2017 auto 6.2.4.9
  virtual function void set_file(UVM_FILE fl); endfunction


  // Function -- NODOCS -- get_element_container
  //
  // Get the element_container of the message

  virtual function uvm_report_message_element_container get_element_container(); endfunction


  // Function -- NODOCS -- set_report_message
  //
  // Set all the common fields of the report message in one shot.
  //

  // @uvm-ieee 1800.2-2017 auto 6.2.4.10
  virtual function void set_report_message(uvm_severity severity, 
    					   string id,
					   string message,
					   int verbosity, 
    					   string filename,
					   int line,
					   string context_name); endfunction


  //----------------------------------------------------------------------------
  // Group-  Message Recording
  //----------------------------------------------------------------------------

  // Not documented.
  virtual function void m_record_message(uvm_recorder recorder); endfunction


  // Not documented.
  virtual function void m_record_core_properties(uvm_recorder recorder); endfunction

  // Not documented.
  virtual function void do_record(uvm_recorder recorder); endfunction


  //----------------------------------------------------------------------------
  // Group -- NODOCS --  Message Element APIs
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- add_int
  // 
  // This method adds an integral type of the name ~name~ and value ~value~ to
  // the message.  The required ~size~ field indicates the size of ~value~. 
  // The required ~radix~ field determines how to display and 
  // record the field. The optional print/record bit is to specify whether 
  // the element will be printed/recorded.
  //

  virtual function void add_int(string name, uvm_bitstream_t value, 
                                int size, uvm_radix_enum radix, 
                                uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction


  // Function -- NODOCS -- add_string
  // 
  // This method adds a string of the name ~name~ and value ~value~ to the 
  // message. The optional print/record bit is to specify whether 
  // the element will be printed/recorded.
  //

  virtual function void add_string(string name, string value,
                                   uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction


  // Function -- NODOCS -- add_object
  // 
  // This method adds a uvm_object of the name ~name~ and reference ~obj~ to
  // the message. The optional print/record bit is to specify whether 
  // the element will be printed/recorded. 
  //

  virtual function void add_object(string name, uvm_object obj,
                                   uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction

endclass


`endif
