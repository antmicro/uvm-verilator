// $Id: uvm_report_catcher.svh,v 1.1.2.10 2010/04/09 15:03:25 janick Exp $
//------------------------------------------------------------------------------
// Copyright 2007-2018 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2018 Intel Corporation
// Copyright 2010-2013 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2014 Cisco Systems, Inc.
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

`ifndef UVM_REPORT_CATCHER_SVH
`define UVM_REPORT_CATCHER_SVH

typedef class uvm_report_object;
typedef class uvm_report_handler;
typedef class uvm_report_server;
typedef class uvm_report_catcher;

typedef uvm_callbacks    #(uvm_report_object, uvm_report_catcher) uvm_report_cb;
typedef uvm_callback_iter#(uvm_report_object, uvm_report_catcher) uvm_report_cb_iter /* @uvm-ieee 1800.2-2017 auto D.4.5*/   ;

class sev_id_struct;
  bit sev_specified ;
  bit id_specified ;
  uvm_severity sev ;
  string  id ;
  bit is_on ;
endclass

// TITLE: Report Catcher
//
// Contains debug methods in the Accellera UVM implementation not documented
// in the IEEE 1800.2-2017 LRM


//------------------------------------------------------------------------------
//
// CLASS: uvm_report_catcher
//

// @uvm-ieee 1800.2-2017 auto 6.6.1
virtual class uvm_report_catcher extends uvm_callback;

  `uvm_register_cb(uvm_report_object,uvm_report_catcher)

  typedef enum { UNKNOWN_ACTION, THROW, CAUGHT} action_e;






  // Counts for the demoteds and caughts







  // Flag counts
  const static int DO_NOT_CATCH      = 1; 
  const static int DO_NOT_MODIFY     = 2; 




  
  // Function -- NODOCS -- new
  //
  // Create a new report catcher. The name argument is optional, but
  // should generally be provided to aid in debugging.

  // @uvm-ieee 1800.2-2017 auto 6.6.2
  function new(string name = "uvm_report_catcher"); endfunction    

  // Group -- NODOCS -- Current Message State

  // Function -- NODOCS -- get_client
  //
  // Returns the <uvm_report_object> that has generated the message that
  // is currently being processed.

  // @uvm-ieee 1800.2-2017 auto 6.6.3.1
  function uvm_report_object get_client(); endfunction

  // Function -- NODOCS -- get_severity
  //
  // Returns the <uvm_severity> of the message that is currently being
  // processed. If the severity was modified by a previously executed
  // catcher object (which re-threw the message), then the returned 
  // severity is the modified value.

  // @uvm-ieee 1800.2-2017 auto 6.6.3.2
  function uvm_severity get_severity(); endfunction
  
  // Function -- NODOCS -- get_context
  //
  // Returns the context name of the message that is currently being
  // processed. This is typically the full hierarchical name of the component
  // that issued the message. However, if user-defined context is set from
  // a uvm_report_message, the user-defined context will be returned.

  // @uvm-ieee 1800.2-2017 auto 6.6.3.3
  function string get_context(); endfunction
  
  // Function -- NODOCS -- get_verbosity
  //
  // Returns the verbosity of the message that is currently being
  // processed. If the verbosity was modified by a previously executed
  // catcher (which re-threw the message), then the returned 
  // verbosity is the modified value.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.3.4
  function int get_verbosity(); endfunction
  
  // Function -- NODOCS -- get_id
  //
  // Returns the string id of the message that is currently being
  // processed. If the id was modified by a previously executed
  // catcher (which re-threw the message), then the returned 
  // id is the modified value.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.3.5
  function string get_id(); endfunction
  
  // Function -- NODOCS -- get_message
  //
  // Returns the string message of the message that is currently being
  // processed. If the message was modified by a previously executed
  // catcher (which re-threw the message), then the returned 
  // message is the modified value.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.3.6
  function string get_message(); endfunction
  
  // Function -- NODOCS -- get_action
  //
  // Returns the <uvm_action> of the message that is currently being
  // processed. If the action was modified by a previously executed
  // catcher (which re-threw the message), then the returned 
  // action is the modified value.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.3.7
  function uvm_action get_action(); endfunction
  
  // Function -- NODOCS -- get_fname
  //
  // Returns the file name of the message.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.3.8
  function string get_fname(); endfunction             

  // Function -- NODOCS -- get_line
  //
  // Returns the line number of the message.

  // @uvm-ieee 1800.2-2017 auto 6.6.3.9
  function int get_line(); endfunction

  // Function -- NODOCS -- get_element_container
  //
  // Returns the element container of the message.

  function uvm_report_message_element_container get_element_container(); endfunction

  
  // Group -- NODOCS -- Change Message State

  // Function -- NODOCS -- set_severity
  //
  // Change the severity of the message to ~severity~. Any other
  // report catchers will see the modified value.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.4.1
  protected function void set_severity(uvm_severity severity); endfunction
  
  // Function -- NODOCS -- set_verbosity
  //
  // Change the verbosity of the message to ~verbosity~. Any other
  // report catchers will see the modified value.

  // @uvm-ieee 1800.2-2017 auto 6.6.4.2
  protected function void set_verbosity(int verbosity); endfunction      

  // Function -- NODOCS -- set_id
  //
  // Change the id of the message to ~id~. Any other
  // report catchers will see the modified value.

  // @uvm-ieee 1800.2-2017 auto 6.6.4.3
  protected function void set_id(string id); endfunction
  
  // Function -- NODOCS -- set_message
  //
  // Change the text of the message to ~message~. Any other
  // report catchers will see the modified value.

  // @uvm-ieee 1800.2-2017 auto 6.6.4.4
  protected function void set_message(string message); endfunction
  
  // Function -- NODOCS -- set_action
  //
  // Change the action of the message to ~action~. Any other
  // report catchers will see the modified value.
  
  // @uvm-ieee 1800.2-2017 auto 6.6.4.5
  protected function void set_action(uvm_action action); endfunction

  // Function -- NODOCS -- set_context
  //
  // Change the context of the message to ~context_str~. Any other
  // report catchers will see the modified value.

  // @uvm-ieee 1800.2-2017 auto 6.6.4.6
  protected function void set_context(string context_str); endfunction

  // Function -- NODOCS -- add_int
  //
  // Add an integral type of the name ~name~ and value ~value~ to
  // the message.  The required ~size~ field indicates the size of ~value~.
  // The required ~radix~ field determines how to display and
  // record the field. Any other report catchers will see the newly
  // added element.
  //

  protected function void add_int(string name,
				  uvm_bitstream_t value,
				  int size,
				  uvm_radix_enum radix,
				  uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction


  // Function -- NODOCS -- add_string
  //
  // Adds a string of the name ~name~ and value ~value~ to the
  // message. Any other report catchers will see the newly
  // added element.
  //

  protected function void add_string(string name,
				     string value,
                                     uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction


  // Function -- NODOCS -- add_object
  //
  // Adds a uvm_object of the name ~name~ and reference ~obj~ to
  // the message. Any other report catchers will see the newly
  // added element.
  //

  protected function void add_object(string name,
				     uvm_object obj,
                                     uvm_action action = (UVM_LOG|UVM_RM_RECORD)); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
  // Group -- NODOCS -- Debug
     
  // Function -- NODOCS -- get_report_catcher
  //
  // Returns the first report catcher that has ~name~. 
  
  static function uvm_report_catcher get_report_catcher(string name); endfunction
`endif 

  // Function: print_catcher
  //
  // Prints debug information about all of the typewide report catchers that are 
  // registered.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
  
  static function void print_catcher(UVM_FILE file = 0); endfunction
  
  // Function: debug_report_catcher
  //
  // Turn on report catching debug information. bits[1:0] of ~what~ enable debug features
  // * bit 0 - when set to 1 -- forces catch to be ignored so that all catchers see the
  //   the reports.
  // * bit 1 - when set to 1 -- forces the message to remain unchanged
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
  
  static function void debug_report_catcher(int what= 0); endfunction        
  
  // Group -- NODOCS -- Callback Interface
 
  // Function -- NODOCS -- catch
  //
  // This is the method that is called for each registered report catcher.
  // There are no arguments to this function. The <Current Message State>
  // interface methods can be used to access information about the 
  // current message being processed.

  // @uvm-ieee 1800.2-2017 auto 6.6.5
  pure virtual function action_e catch();
     

  // Group -- NODOCS -- Reporting

   // Function -- NODOCS -- uvm_report_fatal
   //
   // Issues a fatal message using the current message's report object.
   // This message will bypass any message catching callbacks.
   
   protected function void uvm_report_fatal(string id,
					    string message, 
					    int verbosity,
					    string fname = "",
					    int line = 0,
					    string context_name = "",
					    bit report_enabled_checked = 0); endfunction  


   // Function -- NODOCS -- uvm_report_error
   //
   // Issues an error message using the current message's report object.
   // This message will bypass any message catching callbacks.
   
   protected function void uvm_report_error(string id,
					    string message, 
					    int verbosity,
					    string fname = "",
					    int line = 0,
					    string context_name = "",
					    bit report_enabled_checked = 0); endfunction  
     

   // Function -- NODOCS -- uvm_report_warning
   //
   // Issues a warning message using the current message's report object.
   // This message will bypass any message catching callbacks.
   
   protected function void uvm_report_warning(string id,
					      string message,
					      int verbosity,
					      string fname = "",
					      int line = 0, 
					      string context_name = "",
					      bit report_enabled_checked = 0); endfunction  


   // Function -- NODOCS -- uvm_report_info
   //
   // Issues a info message using the current message's report object.
   // This message will bypass any message catching callbacks.
   
   protected function void uvm_report_info(string id,
					   string message, 
					   int verbosity,
					   string fname = "",
					   int line = 0,
					   string context_name = "",
					   bit report_enabled_checked = 0); endfunction  

   // Function -- NODOCS -- uvm_report
   //
   // Issues a message using the current message's report object.
   // This message will bypass any message catching callbacks.

   protected function void uvm_report(uvm_severity severity,
				      string id,
				      string message,
				      int verbosity,
				      string fname = "",
				      int line = 0,
				      string context_name = "",
				      bit report_enabled_checked = 0); endfunction

   protected function void uvm_process_report_message(uvm_report_message msg); endfunction


  // Function -- NODOCS -- issue
  // Immediately issues the message which is currently being processed. This
  // is useful if the message is being ~CAUGHT~ but should still be emitted.
  //
  // Issuing a message will update the report_server stats, possibly multiple 
  // times if the message is not ~CAUGHT~.

  protected function void issue(); endfunction


  //process_all_report_catchers
  //method called by report_server.report to process catchers
  //

  static function int process_all_report_catchers(uvm_report_message rm); endfunction


  //process_report_catcher
  //internal method to call user <catch()> method
  //

function int process_report_catcher(); endfunction


  // Function -- NODOCS -- summarize
  //
  // This function is called automatically by <uvm_report_server::report_summarize()>.
  // It prints the statistics for the active catchers.


  static function void summarize(); endfunction

endclass

`endif // UVM_REPORT_CATCHER_SVH
