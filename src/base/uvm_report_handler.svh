//
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017 Cisco Systems, Inc.
// Copyright 2011 Cypress Semiconductor Corp.
// Copyright 2012 Accellera Systems Initiative
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

`ifndef UVM_REPORT_HANDLER_SVH
`define UVM_REPORT_HANDLER_SVH

typedef class uvm_report_object;
typedef class uvm_report_server;
typedef uvm_pool#(string, uvm_action) uvm_id_actions_array;
typedef uvm_pool#(string, UVM_FILE) uvm_id_file_array;
typedef uvm_pool#(string, int) uvm_id_verbosities_array;
typedef uvm_pool#(uvm_severity, uvm_severity) uvm_sev_override_array;

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_report_handler
//
// The uvm_report_handler is the class to which most methods in
// <uvm_report_object> delegate. It stores the maximum verbosity, actions,
// and files that affect the way reports are handled. 
//
// The report handler is not intended for direct use. See <uvm_report_object>
// for information on the UVM reporting mechanism.
//
// The relationship between <uvm_report_object> (a base class for uvm_component)
// and uvm_report_handler is typically one to one, but it can be many to one
// if several uvm_report_objects are configured to use the same
// uvm_report_handler_object. See <uvm_report_object::set_report_handler>.
//
// The relationship between uvm_report_handler and <uvm_report_server> is many
// to one. 
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 6.4.1
class uvm_report_handler extends uvm_object;

  // internal variables

  int m_max_verbosity_level;

  // id verbosity settings : default and severity
  uvm_id_verbosities_array id_verbosities;
  uvm_id_verbosities_array severity_id_verbosities[uvm_severity];

  // actions
  uvm_id_actions_array id_actions;
  uvm_action severity_actions[uvm_severity];
  uvm_id_actions_array severity_id_actions[uvm_severity];

  // severity overrides
  uvm_sev_override_array sev_overrides;
  uvm_sev_override_array sev_id_overrides [string];

  // file handles : default, severity, action, (severity,id)
  UVM_FILE default_file_handle;
  uvm_id_file_array id_file_handles;
  UVM_FILE severity_file_handles[uvm_severity];
  uvm_id_file_array severity_id_file_handles[uvm_severity];


  `uvm_object_utils(uvm_report_handler)


  // Function -- NODOCS -- new
  // 
  // Creates and initializes a new uvm_report_handler object.

  // @uvm-ieee 1800.2-2017 auto 6.4.2.1
  function new(string name = "uvm_report_handler"); endfunction


  // Function -- NODOCS -- print
  //
  // The uvm_report_handler implements the <uvm_object::do_print()> such that
  // ~print~ method provides UVM printer formatted output
  // of the current configuration.  A snippet of example output is shown here:
  //
  // |uvm_test_top                uvm_report_handler  -     @555                    
  // |  max_verbosity_level       uvm_verbosity       32    UVM_FULL                
  // |  id_verbosities            uvm_pool            3     -                       
  // |    [ID1]                   uvm_verbosity       32    UVM_LOW                 
  // |  severity_id_verbosities   array               4     -                       
  // |    [UVM_INFO:ID4]          int                 32    501                     
  // |  id_actions                uvm_pool            2     -                       
  // |    [ACT_ID]                uvm_action          32    DISPLAY LOG COUNT       
  // |  severity_actions          array               4     -                       
  // |    [UVM_INFO]              uvm_action          32    DISPLAY                 
  // |    [UVM_WARNING]           uvm_action          32    DISPLAY RM_RECORD COUNT 
  // |    [UVM_ERROR]             uvm_action          32    DISPLAY COUNT           
  // |    [UVM_FATAL]             uvm_action          32    DISPLAY EXIT            
  // |  default_file_handle       int                 32    'h1                     

  // @uvm-ieee 1800.2-2017 auto 6.4.2.2
  virtual function void do_print (uvm_printer printer); endfunction

  
  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Message Processing
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- process_report_message
  //
  // This is the common handler method used by the four core reporting methods
  // (e.g. <uvm_report_error>) in <uvm_report_object>.

  // @uvm-ieee 1800.2-2017 auto 6.4.7
  virtual function void process_report_message(uvm_report_message report_message); endfunction


  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Convenience Methods
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- format_action
  //
  // Returns a string representation of the ~action~, e.g., "DISPLAY".

  static function string format_action(uvm_action action); endfunction


  // Function- initialize
  //
  // Internal method for initializing report handler.

  function void initialize(); endfunction

  
  // Function- get_severity_id_file
  //
  // Return the file id based on the severity and the id

function UVM_FILE get_severity_id_file(uvm_severity severity, string id); endfunction


  // Function- set_verbosity_level
  //
  // Internal method called by uvm_report_object.

  // @uvm-ieee 1800.2-2017 auto 6.4.3.2
  function void set_verbosity_level(int verbosity_level); endfunction


  // Function- get_verbosity_level
  //
  // Returns the verbosity associated with the given ~severity~ and ~id~.
  // 
  // First, if there is a verbosity associated with the ~(severity,id)~ pair,
  // return that.  Else, if there is a verbosity associated with the ~id~, return
  // that.  Else, return the max verbosity setting.

  // @uvm-ieee 1800.2-2017 auto 6.4.3.1
  function int get_verbosity_level(uvm_severity severity=UVM_INFO, string id="" ); endfunction


  // Function- get_action
  //
  // Returns the action associated with the given ~severity~ and ~id~.
  // 
  // First, if there is an action associated with the ~(severity,id)~ pair,
  // return that.  Else, if there is an action associated with the ~id~, return
  // that.  Else, if there is an action associated with the ~severity~, return
  // that. Else, return the default action associated with the ~severity~.

  // @uvm-ieee 1800.2-2017 auto 6.4.4.1
  function uvm_action get_action(uvm_severity severity, string id); endfunction


  // Function- get_file_handle
  //
  // Returns the file descriptor associated with the given ~severity~ and ~id~.
  //
  // First, if there is a file handle associated with the ~(severity,id)~ pair,
  // return that. Else, if there is a file handle associated with the ~id~, return
  // that. Else, if there is an file handle associated with the ~severity~, return
  // that. Else, return the default file handle.

  // @uvm-ieee 1800.2-2017 auto 6.4.5.1
  function UVM_FILE get_file_handle(uvm_severity severity, string id); endfunction


  // Function- set_severity_action
  // Function- set_id_action
  // Function- set_severity_id_action
  // Function- set_id_verbosity
  // Function- set_severity_id_verbosity
  //
  // Internal methods called by uvm_report_object.

  // @uvm-ieee 1800.2-2017 auto 6.4.4.2
  function void set_severity_action(input uvm_severity severity,
                                    input uvm_action action); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.4.2
  function void set_id_action(input string id, input uvm_action action); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.4.2
  function void set_severity_id_action(uvm_severity severity,
                                       string id,
                                       uvm_action action); endfunction
  
  // @uvm-ieee 1800.2-2017 auto 6.4.3.3
  function void set_id_verbosity(input string id, input int verbosity); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.3.3
  function void set_severity_id_verbosity(uvm_severity severity,
                                       string id,
                                       int verbosity); endfunction

  // Function- set_default_file
  // Function- set_severity_file
  // Function- set_id_file
  // Function- set_severity_id_file
  //
  // Internal methods called by uvm_report_object.

  // @uvm-ieee 1800.2-2017 auto 6.4.5.2
  function void set_default_file (UVM_FILE file); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.5.2
  function void set_severity_file (uvm_severity severity, UVM_FILE file); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.5.2
  function void set_id_file (string id, UVM_FILE file); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.5.2
  function void set_severity_id_file(uvm_severity severity,
                                     string id, UVM_FILE file); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.6
  function void set_severity_override(uvm_severity cur_severity,
                                      uvm_severity new_severity); endfunction

  // @uvm-ieee 1800.2-2017 auto 6.4.6
  function void set_severity_id_override(uvm_severity cur_severity,
                                         string id,
                                         uvm_severity new_severity); endfunction

  

  // Function- report
  //
  // This is the common handler method used by the four core reporting methods
  // (e.g., uvm_report_error) in <uvm_report_object>.

  virtual function void report(
      uvm_severity severity,
      string name,
      string id,
      string message,
      int verbosity_level=UVM_MEDIUM,
      string filename="",
      int line=0,
      uvm_report_object client=null
      ); endfunction

endclass : uvm_report_handler

`endif //UVM_REPORT_HANDLER_SVH
