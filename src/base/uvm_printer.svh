//
//------------------------------------------------------------------------------
// Copyright 2007-2018 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2018 Qualcomm, Inc.
// Copyright 2014 Intel Corporation
// Copyright 2018 Synopsys, Inc.
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
//   the License or the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------------------------


typedef class m_uvm_printer_knobs;
typedef class uvm_printer_element;
typedef class uvm_structure_proxy;

`ifdef UVM_ENABLE_DEPRECATED_API
typedef struct {
  int    level;
  string name;
  string type_name;
  string size;
  string val;
} uvm_printer_row_info;
`endif

// File: uvm_printer
  
// @uvm-ieee 1800.2-2017 auto 16.2.1
virtual class uvm_printer extends uvm_policy;



  extern function new(string name="") ;

  bit m_flushed ; // 0 = needs flush, 1 = flushed since last use

`ifdef UVM_ENABLE_DEPRECATED_API
  // Variable -- NODOCS -- knobs
  //
  // The knob object provides access to the variety of knobs associated with a
  // specific printer instance.
  //
  m_uvm_printer_knobs knobs ;
`else
  //config values from set_* accessors are stored in knobs

`endif

protected function m_uvm_printer_knobs get_knobs() ; endfunction

  // Group -- NODOCS -- Methods for printer usage

  // These functions are called from <uvm_object::print>, or they are called
  // directly on any data to get formatted printing.

  extern static function void set_default(uvm_printer printer) ;

  extern static function uvm_printer get_default() ;

  // Function -- NODOCS -- print_field
  //
  // Prints an integral field (up to 4096 bits).
  //
  // name  - The name of the field.
  // value - The value of the field.
  // size  - The number of bits of the field (maximum is 4096).
  // radix - The radix to use for printing. The printer knob for radix is used
  //           if no radix is specified.
  // scope_separator - is used to find the leaf name since many printers only
  //           print the leaf name of a field.  Typical values for the separator
  //           are . (dot) or [ (open bracket).

  // @uvm-ieee 1800.2-2017 auto 16.2.3.8
  extern virtual function void print_field (string          name,
                                            uvm_bitstream_t value,
                                            int    size,
                                            uvm_radix_enum radix=UVM_NORADIX,
                                            byte   scope_separator=".",
                                            string type_name="");

`ifdef UVM_ENABLE_DEPRECATED_API
  // backward compatibility
  virtual function void print_int (string          name,
                                   uvm_bitstream_t value,
                                   int    size,
                                   uvm_radix_enum radix=UVM_NORADIX,
                                   byte   scope_separator=".",
                                   string type_name=""); endfunction
`endif

  // @uvm-ieee 1800.2-2017 auto 16.2.3.9
  extern virtual function void print_field_int (string name,
                                                uvm_integral_t value,
                                                int    size,
                                                uvm_radix_enum radix=UVM_NORADIX,
                                                byte   scope_separator=".",
                                                string type_name="");

  // Function -- NODOCS -- print_object
  //
  // Prints an object. Whether the object is recursed depends on a variety of
  // knobs, such as the depth knob; if the current depth is at or below the
  // depth setting, then the object is not recursed.
  //
  // By default, the children of <uvm_components> are printed. To turn this
  // behavior off, you must set the <uvm_component::print_enabled> bit to 0 for
  // the specific children you do not want automatically printed.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.1
  extern virtual function void print_object (string     name,
                                             uvm_object value,
                                             byte       scope_separator=".");


  extern virtual function void print_object_header (string name,
                                                    uvm_object value,
                                                    byte scope_separator=".");


  // Function -- NODOCS -- print_string
  //
  // Prints a string field.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.10
  extern virtual function void print_string (string name,
                                             string value,
                                             byte   scope_separator=".");

  uvm_policy::recursion_state_e m_recur_states[uvm_object][uvm_recursion_policy_enum /*recursion*/] ;

  // @uvm-ieee 1800.2-2017 auto 16.2.3.2
  extern virtual function uvm_policy::recursion_state_e object_printed ( uvm_object value,
                                                                         uvm_recursion_policy_enum recursion);

  // Function -- NODOCS -- print_time
  //
  // Prints a time value. name is the name of the field, and value is the
  // value to print.
  //
  // The print is subject to the ~$timeformat~ system task for formatting time
  // values.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.11
  extern virtual function void print_time (string name,
                                           time   value,
                                           byte   scope_separator=".");


  // Function -- NODOCS -- print_real
  //
  // Prints a real field.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.12
  extern virtual function void print_real (string  name,
                                           real    value,
                                           byte    scope_separator=".");

  // Function -- NODOCS -- print_generic
  //
  // Prints a field having the given ~name~, ~type_name~, ~size~, and ~value~.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.3
  extern virtual function void print_generic (string  name,
                                              string  type_name,
                                              int     size,
                                              string  value,
                                              byte    scope_separator=".");

  // @uvm-ieee 1800.2-2017 auto 16.2.3.4
  extern virtual function void print_generic_element (string  name,
                                                      string  type_name,
                                                      string  size,
                                                      string  value);

  // Group -- NODOCS -- Methods for printer subtyping

  // Function -- NODOCS -- emit
  //
  // Emits a string representing the contents of an object
  // in a format defined by an extension of this object.

  extern virtual function string emit ();

  extern virtual function void flush ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.1
  extern virtual function void set_name_enabled (bit enabled);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.1
  extern virtual function bit get_name_enabled ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.2
  extern virtual function void set_type_name_enabled (bit enabled);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.2
  extern virtual function bit get_type_name_enabled ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.3
  extern virtual function void set_size_enabled (bit enabled);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.3
  extern virtual function bit get_size_enabled ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.4
  extern virtual function void set_id_enabled (bit enabled);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.4
  extern virtual function bit get_id_enabled ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.5
  extern virtual function void set_radix_enabled (bit enabled);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.5
  extern virtual function bit get_radix_enabled ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.6
  extern virtual function void set_radix_string (uvm_radix_enum radix, string prefix);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.6
  extern virtual function string get_radix_string (uvm_radix_enum radix);

  // @uvm-ieee 1800.2-2017 auto 16.2.5.7
  extern virtual function void set_default_radix (uvm_radix_enum radix);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.7
  extern virtual function uvm_radix_enum get_default_radix ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.8
  extern virtual function void set_root_enabled (bit enabled);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.8
  extern virtual function bit get_root_enabled ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.9
  extern virtual function void set_recursion_policy (uvm_recursion_policy_enum policy);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.9
  extern virtual function uvm_recursion_policy_enum get_recursion_policy ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.10
  extern virtual function void set_max_depth (int depth);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.10
  extern virtual function int get_max_depth ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.11
  extern virtual function void set_file (UVM_FILE fl);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.11
  extern virtual function UVM_FILE get_file ();

  // @uvm-ieee 1800.2-2017 auto 16.2.5.12
  extern virtual function void set_line_prefix (string prefix);
  // @uvm-ieee 1800.2-2017 auto 16.2.5.12
  extern virtual function string get_line_prefix ();

  // @uvm-ieee 1800.2-2017 auto 16.2.6
  extern virtual function void set_begin_elements (int elements = 5);
  // @uvm-ieee 1800.2-2017 auto 16.2.6
  extern virtual function int get_begin_elements ();
  // @uvm-ieee 1800.2-2017 auto 16.2.6
  extern virtual function void set_end_elements (int elements = 5);
  // @uvm-ieee 1800.2-2017 auto 16.2.6
  extern virtual function int get_end_elements ();



  protected function int m_get_stack_size(); endfunction

  // @uvm-ieee 1800.2-2017 auto 16.2.7.1
  extern protected virtual function uvm_printer_element get_bottom_element ();

  // @uvm-ieee 1800.2-2017 auto 16.2.7.2
  extern protected virtual function uvm_printer_element get_top_element ();

  // @uvm-ieee 1800.2-2017 auto 16.2.7.3
  extern virtual function void push_element ( string name,
                                              string type_name,
                                              string size,
                                              string value=""
  );

  // @uvm-ieee 1800.2-2017 auto 16.2.7.4
  extern virtual function void pop_element ();

  // return an element from the recycled stack if available or a new one otherwise
  extern function uvm_printer_element get_unused_element() ;

  // store element instances that have been created but are not currently on the stack
  uvm_printer_element m_recycled_elements[$];

`ifdef UVM_ENABLE_DEPRECATED_API

  // Function -- NODOCS -- format_row
  //
  // Hook for producing custom output of a single field (row).
  //
  extern virtual function string format_row (uvm_printer_row_info row);


  // Function -- NODOCS -- format_header
  //
  // Hook to override base header with a custom header.
  virtual function string format_header(); endfunction


  // Function -- NODOCS -- format_footer
  //
  // Hook to override base footer with a custom footer.
  virtual function string format_footer(); endfunction


  // Function -- NODOCS -- adjust_name
  //
  // Prints a field's name, or ~id~, which is the full instance name.
  //
  // The intent of the separator is to mark where the leaf name starts if the
  // printer if configured to print only the leaf name of the identifier.

  extern virtual protected function string adjust_name (string id,
                                                   byte scope_separator=".");
`endif

  // Function -- NODOCS -- print_array_header
  //
  // Prints the header of an array. This function is called before each
  // individual element is printed. <print_array_footer> is called to mark the
  // completion of array printing.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.5
  extern virtual  function void print_array_header(string name,
                                                   int    size,
                                                   string arraytype="array",
                                                   byte   scope_separator=".");

  // Function -- NODOCS -- print_array_range
  //
  // Prints a range using ellipses for values. This method is used when honoring
  // the array knobs for partial printing of large arrays,
  // <m_uvm_printer_knobs::begin_elements> and <m_uvm_printer_knobs::end_elements>.
  //
  // This function should be called after begin_elements have been printed
  // and before end_elements have been printed.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.6
  extern virtual function void print_array_range (int min, int max);


  // Function -- NODOCS -- print_array_footer
  //
  // Prints the header of a footer. This function marks the end of an array
  // print. Generally, there is no output associated with the array footer, but
  // this method let's the printer know that the array printing is complete.

  // @uvm-ieee 1800.2-2017 auto 16.2.3.7
  extern virtual  function void print_array_footer (int size = 0);



  // Utility methods
  extern  function bit istop ();
  extern  function string index_string (int index, string name="");

  string m_string;

endclass

// @uvm-ieee 1800.2-2017 auto 16.2.8.1
class uvm_printer_element extends uvm_object;

   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.1
   extern function new (string name="");

   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.2
   extern virtual function void set (string element_name = "",
                                     string element_type_name = "",
                                     string element_size = "",
                                     string element_value = ""
   );

   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.3
   extern virtual function void set_element_name (string element_name);
   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.3
   extern virtual function string get_element_name ();

   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.4
   extern virtual function void set_element_type_name (string element_type_name);
   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.4
   extern virtual function string get_element_type_name ();

   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.5
   extern virtual function void set_element_size (string element_size);
   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.5
   extern virtual function string get_element_size ();

   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.6
   extern virtual function void set_element_value (string element_value);
   // @uvm-ieee 1800.2-2017 auto 16.2.8.2.6
   extern virtual function string get_element_value ();

   extern function void add_child(uvm_printer_element child) ;
   extern function void get_children(ref uvm_printer_element children[$], input bit recurse) ;
   extern function void clear_children() ;






endclass

// @uvm-ieee 1800.2-2017 auto 16.2.9.1
class uvm_printer_element_proxy extends uvm_structure_proxy#(uvm_printer_element);
   // @uvm-ieee 1800.2-2017 auto 16.2.9.2.1
   extern function new (string name="");
   // @uvm-ieee 1800.2-2017 auto 16.2.9.2.2
   extern virtual function void get_immediate_children(uvm_printer_element s, ref uvm_printer_element children[$]);
endclass : uvm_printer_element_proxy


//------------------------------------------------------------------------------
//
// Class: uvm_table_printer
//
// The table printer prints output in a tabular format.
//
// The following shows sample output from the table printer.
//
//|  ---------------------------------------------------
//|  Name        Type            Size        Value
//|  ---------------------------------------------------
//|  c1          container       -           @1013
//|  d1          mydata          -           @1022
//|  v1          integral        32          'hcb8f1c97
//|  e1          enum            32          THREE
//|  str         string          2           hi
//|  value       integral        12          'h2d
//|  ---------------------------------------------------
//
//------------------------------------------------------------------------------
//
// @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2

// @uvm-ieee 1800.2-2017 auto 16.2.10.1
class uvm_table_printer extends uvm_printer;

     // @uvm-ieee 1800.2-2017 auto 16.2.10.2.2



  // @uvm-ieee 1800.2-2017 auto 16.2.10.2.1
  extern function new(string name="");

  // Function -- NODOCS -- emit
  //
  // Formats the collected information from prior calls to ~print_*~
  // into table format.
  //
  extern virtual function string emit();

  extern virtual function string m_emit_element(uvm_printer_element element, int unsigned level);





  // @uvm-ieee 1800.2-2017 auto 16.2.10.2.3
  extern static function void set_default(uvm_table_printer printer) ;

  // Function: get_default
  // Implementation of uvm_table_printer::get_default as defined in
  // section 16.2.10.2.3 of 1800.2-2017.
  //
  // *Note:*
  // The library implements get_default as described in IEEE 1800.2-2017
  // with the exception that this implementation will instance a
  // uvm_table_printer if the most recent call to set_default() used an
  // argument value of null.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 16.2.10.2.4
  extern static function uvm_table_printer get_default() ;

  // @uvm-ieee 1800.2-2017 auto 16.2.10.3
  extern virtual function void set_indent(int indent) ;

  // @uvm-ieee 1800.2-2017 auto 16.2.10.3
  extern virtual function int get_indent() ;

  extern virtual function void flush() ;

  // Variables- m_max_*
  //
  // holds max size of each column, so table columns can be resized dynamically

  protected int m_max_name=4;
  protected int m_max_type=4;
  protected int m_max_size=4;
  protected int m_max_value=5;

  extern virtual function void pop_element();


endclass


//------------------------------------------------------------------------------
//
// Class: uvm_tree_printer
//
// By overriding various methods of the <uvm_printer> super class,
// the tree printer prints output in a tree format.
//
// The following shows sample output from the tree printer.
//
//|  c1: (container@1013) {
//|    d1: (mydata@1022) {
//|         v1: 'hcb8f1c97
//|         e1: THREE
//|         str: hi
//|    }
//|    value: 'h2d
//|  }
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 16.2.11.1
class uvm_tree_printer extends uvm_printer;

  protected string m_newline = "\n";
  protected string m_linefeed ;

     // @uvm-ieee 1800.2-2017 auto 16.2.11.2.2
     `uvm_object_utils(uvm_tree_printer)
  // Variable -- NODOCS -- new
  //
  // Creates a new instance of ~uvm_tree_printer~.

  // @uvm-ieee 1800.2-2017 auto 16.2.11.2.1
  extern function new(string name="");



  // @uvm-ieee 1800.2-2017 auto 16.2.11.2.3
  extern static function void set_default(uvm_tree_printer printer) ;

  // Function: get_default
  // Implementation of uvm_tree_printer::get_default as defined in
  // section 16.2.11.2.4 of 1800.2-2017.
  //
  // *Note:*
  // The library implements get_default as described in IEEE 1800.2-2017
  // with the exception that this implementation will instance a
  // uvm_tree_printer if the most recent call to set_default() used an
  // argument value of null.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 16.2.11.2.4
  extern static function uvm_tree_printer get_default() ;

  // @uvm-ieee 1800.2-2017 auto 16.2.11.3.1
  extern virtual function void set_indent(int indent) ;

  // @uvm-ieee 1800.2-2017 auto 16.2.11.3.1
  extern virtual function int get_indent() ;

  // @uvm-ieee 1800.2-2017 auto 16.2.11.3.2
  extern virtual function void set_separators(string separators) ;

  // @uvm-ieee 1800.2-2017 auto 16.2.11.3.2
  extern virtual function string get_separators() ;

  extern virtual function void flush() ;

  // @uvm-ieee 1800.2-2017 auto 16.2.4.1
  extern virtual function string emit();

  extern virtual function string m_emit_element(uvm_printer_element element, int unsigned level);

endclass



//------------------------------------------------------------------------------
//
// Class: uvm_line_printer
//
// The line printer prints output in a line format.
//
// The following shows sample output from the line printer.
//
//| c1: (container@1013) { d1: (mydata@1022) { v1: 'hcb8f1c97 e1: THREE str: hi } value: 'h2d }
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 16.2.12.1
class uvm_line_printer1;

     // @uvm-ieee 1800.2-2017 auto 16.2.12.2.2
   typedef uvm_object_registry#(uvm_line_printer1) type_id;
endclass

class uvm_line_printer;

     // @uvm-ieee 1800.2-2017 auto 16.2.12.2.2

  // Variable -- NODOCS -- new
  //
  // Creates a new instance of ~uvm_line_printer~. It differs from the
  // <uvm_tree_printer> only in that the output contains no line-feeds
  // and indentation.

  // @uvm-ieee 1800.2-2017 auto 16.2.12.2.1
  // @uvm-ieee 1800.2-2017 auto 16.2.2.1
  extern function new(string name="");



  // @uvm-ieee 1800.2-2017 auto 16.2.12.2.3
  // @uvm-ieee 1800.2-2017 auto 16.2.2.2
  extern static function void set_default(uvm_line_printer printer) ;

  // Function: get_default
  // Implementation of uvm_line_printer::get_default as defined in
  // section 16.2.12.2.3 of 1800.2-2017.
  //
  // *Note:*
  // The library implements get_default as described in IEEE 1800.2-2017
  // with the exception that this implementation will instance a
  // uvm_line_printer if the most recent call to set_default() used an
  // argument value of null.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 16.2.2.3
  extern static function uvm_line_printer get_default() ;

  // @uvm-ieee 1800.2-2017 auto 16.2.12.3
  extern virtual function void set_separators(string separators) ;

  // @uvm-ieee 1800.2-2017 auto 16.2.12.3
  extern virtual function string get_separators() ;

  // @uvm-ieee 1800.2-2017 auto 16.2.4.2
  extern virtual function void flush() ;

endclass



//------------------------------------------------------------------------------
//
// Class -- NODOCS -- m_uvm_printer_knobs
//
// The ~m_uvm_printer_knobs~ class defines the printer settings available to all
// printer subtypes.
//
//------------------------------------------------------------------------------

class m_uvm_printer_knobs;

`ifdef UVM_ENABLE_DEPRECATED_API
  // Variable -- NODOCS -- header
  //
  // Indicates whether the <uvm_printer::format_header> function should be called when
  // printing an object.

  bit header = 1;


  // Variable -- NODOCS -- footer
  //
  // Indicates whether the <uvm_printer::format_footer> function should be called when
  // printing an object.

  bit footer = 1;


  // Variable -- NODOCS -- full_name
  //
  // Indicates whether <uvm_printer::adjust_name> should print the full name of an identifier
  // or just the leaf name.

  bit full_name = 0;
`endif

  // Variable -- NODOCS -- identifier
  //
  // Indicates whether <uvm_printer::adjust_name> should print the identifier. This is useful
  // in cases where you just want the values of an object, but no identifiers.

  bit identifier = 1;


  // Variable -- NODOCS -- type_name
  //
  // Controls whether to print a field's type name.

  bit type_name = 1;


  // Variable -- NODOCS -- size
  //
  // Controls whether to print a field's size.

  bit size = 1;


  // Variable -- NODOCS -- depth
  //
  // Indicates how deep to recurse when printing objects.
  // A depth of -1 means to print everything.

  int depth = -1;


  // Variable -- NODOCS -- reference
  //
  // Controls whether to print a unique reference ID for object handles.
  // The behavior of this knob is simulator-dependent.

  bit reference = 1;


  // Variable -- NODOCS -- begin_elements
  //
  // Defines the number of elements at the head of a list to print.
  // Use -1 for no max.

  int begin_elements = 5;


  // Variable -- NODOCS -- end_elements
  //
  // This defines the number of elements at the end of a list that
  // should be printed.

  int end_elements = 5;


  // Variable -- NODOCS -- prefix
  //
  // Specifies the string prepended to each output line

  string prefix = "";


  // Variable -- NODOCS -- indent
  //
  // This knob specifies the number of spaces to use for level indentation.
  // The default level indentation is two spaces.

  int indent = 2;


  // Variable -- NODOCS -- show_root
  //
  // This setting indicates whether or not the initial object that is printed
  // (when current depth is 0) prints the full path name. By default, the first
  // object is treated like all other objects and only the leaf name is printed.

  bit show_root = 0;


  // Variable -- NODOCS -- mcd
  //
  // This is a file descriptor, or multi-channel descriptor, that specifies
  // where the print output should be directed.
  //
  // By default, the output goes to the standard output of the simulator.

  int mcd = UVM_STDOUT;


  // Variable -- NODOCS -- separator
  //
  // For tree printers only, determines the opening and closing
  // separators used for nested objects.

  string separator = "{}";


  // Variable -- NODOCS -- show_radix
  //
  // Indicates whether the radix string ('h, and so on) should be prepended to
  // an integral value when one is printed.

  bit show_radix = 1;


  // Variable -- NODOCS -- default_radix
  //
  // This knob sets the default radix to use for integral values when no radix
  // enum is explicitly supplied to the <uvm_printer::print_field> or
  // <uvm_printer::print_field_int> methods.

  uvm_radix_enum default_radix = UVM_HEX;


  // Variable -- NODOCS -- dec_radix
  //
  // This string should be prepended to the value of an integral type when a
  // radix of <UVM_DEC> is used for the radix of the integral object.
  //
  // When a negative number is printed, the radix is not printed since only
  // signed decimal values can print as negative.

  string dec_radix = "'d";


  // Variable -- NODOCS -- bin_radix
  //
  // This string should be prepended to the value of an integral type when a
  // radix of <UVM_BIN> is used for the radix of the integral object.

  string bin_radix = "'b";


  // Variable -- NODOCS -- oct_radix
  //
  // This string should be prepended to the value of an integral type when a
  // radix of <UVM_OCT> is used for the radix of the integral object.

  string oct_radix = "'o";


  // Variable -- NODOCS -- unsigned_radix
  //
  // This is the string which should be prepended to the value of an integral
  // type when a radix of <UVM_UNSIGNED> is used for the radix of the integral
  // object.

  string unsigned_radix = "'d";


  // Variable -- NODOCS -- hex_radix
  //
  // This string should be prepended to the value of an integral type when a
  // radix of <UVM_HEX> is used for the radix of the integral object.

  string hex_radix = "'h";

  uvm_recursion_policy_enum recursion_policy ;

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- get_radix_str
  //
  // Converts the radix from an enumerated to a printable radix according to
  // the radix printing knobs (bin_radix, and so on).

  function string get_radix_str(uvm_radix_enum radix); endfunction

  // Deprecated knobs, hereafter ignored
  int max_width = 999;
  string truncation = "+";
  int name_width = -1;
  int type_width = -1;
  int size_width = -1;
  int value_width = -1;
  bit sprint = 1;
`endif
endclass

`ifdef UVM_ENABLE_DEPRECATED_API
typedef m_uvm_printer_knobs uvm_table_printer_knobs;
typedef m_uvm_printer_knobs uvm_tree_printer_knobs;
typedef m_uvm_printer_knobs uvm_printer_knobs;
`endif // UVM_ENABLE_DEPRECATED_API


//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------
function uvm_printer::new(string name=""); endfunction

function void uvm_printer::set_default(uvm_printer printer) ; endfunction

function uvm_printer uvm_printer::get_default() ; endfunction

// print_field
// ---------

function void uvm_printer::print_field (string name,
                                      uvm_bitstream_t value,
                                      int size,
                                      uvm_radix_enum radix=UVM_NORADIX,
                                      byte scope_separator=".",
                                      string type_name=""); endfunction


// print_field_int
// ---------

function void uvm_printer::print_field_int (string name,
                                            uvm_integral_t value,
                                            int          size,
                                            uvm_radix_enum radix=UVM_NORADIX,
                                            byte         scope_separator=".",
                                            string       type_name=""); endfunction


// emit
// ----

function string uvm_printer::emit (); endfunction

function void uvm_printer::flush (); endfunction

function void uvm_printer::set_name_enabled (bit enabled); endfunction
function bit uvm_printer::get_name_enabled (); endfunction

function void uvm_printer::set_type_name_enabled (bit enabled); endfunction
function bit uvm_printer::get_type_name_enabled (); endfunction

function void uvm_printer::set_size_enabled (bit enabled); endfunction
function bit uvm_printer::get_size_enabled (); endfunction

function void uvm_printer::set_id_enabled (bit enabled); endfunction
function bit uvm_printer::get_id_enabled (); endfunction

function void uvm_printer::set_radix_enabled (bit enabled); endfunction
function bit uvm_printer::get_radix_enabled (); endfunction

function void uvm_printer::set_radix_string (uvm_radix_enum radix, string prefix); endfunction
function string uvm_printer::get_radix_string (uvm_radix_enum radix); endfunction

function void uvm_printer::set_default_radix (uvm_radix_enum radix); endfunction
function uvm_radix_enum uvm_printer::get_default_radix (); endfunction

function void uvm_printer::set_root_enabled (bit enabled); endfunction
function bit uvm_printer::get_root_enabled (); endfunction

function void uvm_printer::set_recursion_policy (uvm_recursion_policy_enum policy); endfunction
function uvm_recursion_policy_enum uvm_printer::get_recursion_policy (); endfunction

function void uvm_printer::set_max_depth (int depth); endfunction
function int uvm_printer::get_max_depth (); endfunction

function void uvm_printer::set_file (UVM_FILE fl); endfunction
function UVM_FILE uvm_printer::get_file (); endfunction

function void uvm_printer::set_line_prefix (string prefix); endfunction
function string uvm_printer::get_line_prefix (); endfunction

function void uvm_printer::set_begin_elements (int elements = 5);

endfunction
function int uvm_printer::get_begin_elements ();

endfunction

function void uvm_printer::set_end_elements (int elements = 5);

endfunction
function int uvm_printer::get_end_elements ();

endfunction

function uvm_printer_element uvm_printer::get_bottom_element (); endfunction

function uvm_printer_element uvm_printer::get_top_element (); endfunction

function uvm_printer_element_proxy::new (string name=""); endfunction

function void uvm_printer_element_proxy::get_immediate_children(uvm_printer_element s,
                                                                ref uvm_printer_element children[$]); endfunction



function void uvm_printer::push_element ( string name,
                                          string type_name,
                                          string size,
                                          string value=""); endfunction

function void uvm_printer::pop_element (); endfunction

function uvm_printer_element uvm_printer::get_unused_element() ; endfunction

`ifdef UVM_ENABLE_DEPRECATED_API

// format_row
// ----------

function string uvm_printer::format_row (uvm_printer_row_info row); endfunction
`endif

// print_array_header
// ------------------

function void uvm_printer::print_array_header (string name,
                                               int size,
                                               string arraytype="array",
                                               byte scope_separator="."); endfunction


// print_array_footer
// ------------------

function void  uvm_printer::print_array_footer (int size=0); endfunction


// print_array_range
// -----------------

function void uvm_printer::print_array_range(int min, int max); endfunction


// print_object_header
// -------------------

function void uvm_printer::print_object_header (string name,
                                                uvm_object value,
                                                byte scope_separator="."); endfunction


// print_object
// ------------

function void uvm_printer::print_object (string name, uvm_object value,
                                         byte scope_separator="."); endfunction


// istop
// -----

function bit uvm_printer::istop (); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API

// adjust_name
// -----------

function string uvm_printer::adjust_name(string id, byte scope_separator="."); endfunction

`endif

// print_generic
// -------------

function void uvm_printer::print_generic (string name,
                                          string type_name,
                                          int size,
                                          string value,
                                          byte scope_separator="."); endfunction


function void uvm_printer::print_generic_element (string  name,
                                                  string  type_name,
                                                  string  size,
                                                  string  value); endfunction


// print_time
// ----------

function void uvm_printer::print_time (string name,
                                       time value,
                                       byte scope_separator="."); endfunction


// print_string
// ------------

function void uvm_printer::print_string (string name,
                                         string value,
                                         byte scope_separator="."); endfunction

function uvm_policy::recursion_state_e uvm_printer::object_printed (uvm_object value,
                                                                    uvm_recursion_policy_enum recursion); endfunction

// print_real
// ----------

function void uvm_printer::print_real (string name,
                                       real value,
                                       byte scope_separator="."); endfunction


// index_string
// ------------

function string uvm_printer::index_string(int index, string name=""); endfunction

//------------------------------------------------------------------------------
// Class- uvm_printer_element
//------------------------------------------------------------------------------

function uvm_printer_element::new (string name = ""); endfunction

function void uvm_printer_element::set (string element_name = "",
                                        string element_type_name = "",
                                        string element_size = "",
                                        string element_value = ""
   ); endfunction function void uvm_printer_element::set_element_name (string element_name); endfunction
function string uvm_printer_element::get_element_name (); endfunction

function void uvm_printer_element::set_element_type_name (string element_type_name); endfunction
function string uvm_printer_element::get_element_type_name (); endfunction

function void uvm_printer_element::set_element_size (string element_size); endfunction
function string uvm_printer_element::get_element_size (); endfunction

function void uvm_printer_element::set_element_value (string element_value); endfunction
function string uvm_printer_element::get_element_value (); endfunction

function void uvm_printer_element::add_child(uvm_printer_element child) ; endfunction
function void uvm_printer_element::get_children(ref uvm_printer_element children[$], input bit recurse) ; endfunction function void uvm_printer_element::clear_children() ; endfunction

//------------------------------------------------------------------------------
// Class- uvm_table_printer
//------------------------------------------------------------------------------

// new
// ---

function uvm_table_printer::new(string name=""); endfunction


function void uvm_table_printer::pop_element(); endfunction

// emit
// ----

function string uvm_table_printer::emit(); endfunction

function string uvm_table_printer::m_emit_element(uvm_printer_element element, int unsigned level) ; endfunction


//------------------------------------------------------------------------------
// Class- uvm_tree_printer
//------------------------------------------------------------------------------


// new
// ---

function uvm_tree_printer::new(string name=""); endfunction


function void uvm_tree_printer::set_indent(int indent) ; endfunction
function int uvm_tree_printer::get_indent() ; endfunction

function void uvm_tree_printer::set_separators(string separators) ; endfunction
function string uvm_tree_printer::get_separators() ; endfunction

function void uvm_tree_printer::flush() ; endfunction

// emit
// ----

function string uvm_tree_printer::emit(); endfunction

function string uvm_tree_printer::m_emit_element(uvm_printer_element element, int unsigned level) ; endfunction : m_emit_element

function void uvm_table_printer::set_default(uvm_table_printer printer) ; endfunction

function uvm_table_printer uvm_table_printer::get_default() ; endfunction

function void uvm_table_printer::set_indent(int indent) ; endfunction
function int uvm_table_printer::get_indent() ; endfunction

function void uvm_table_printer::flush() ; endfunction


function void uvm_tree_printer::set_default(uvm_tree_printer printer) ; endfunction

function uvm_tree_printer uvm_tree_printer::get_default() ; endfunction

function uvm_line_printer::new(string name="") ; endfunction

function void uvm_line_printer::set_default(uvm_line_printer printer) ; endfunction

function uvm_line_printer uvm_line_printer::get_default() ; endfunction

function void uvm_line_printer::set_separators(string separators) ; endfunction
function string uvm_line_printer::get_separators() ; endfunction

function void uvm_line_printer::flush() ; endfunction

